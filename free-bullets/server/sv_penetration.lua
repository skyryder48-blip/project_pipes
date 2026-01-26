--[[
    Server-Side Bullet Penetration System
    ======================================

    Handles:
    1. Overpenetration (bullets passing through targets)
    2. Material penetration (bullets through cover)
    3. Damage falloff after penetration

    Works in conjunction with sv_damage.lua and client cl_penetration.lua
]]

-- =============================================================================
-- CONFIGURATION
-- =============================================================================

local PenetrationConfig = {
    -- Enable/disable penetration system
    Enabled = true,

    -- Debug output
    Debug = false,

    -- Maximum secondary targets from overpenetration
    MaxSecondaryTargets = 3,

    -- Cooldown between penetration damage (prevents spam)
    DamageCooldown = 100,  -- ms

    -- Maximum range for secondary target detection (meters)
    MaxPenetrationRange = 50.0,
}

-- Track recent penetration damage to prevent duplicates
local recentPenetrationDamage = {}  -- { [victimNetId] = timestamp }

-- =============================================================================
-- OVERPENETRATION MECHANICS
-- =============================================================================

--- Check if a round should overpenetrate a target
-- @param caliber string The weapon caliber
-- @param ammoType string The ammo type
-- @return boolean, number, number Whether it overpenetrates, damage retention %, max targets
local function ShouldOverpenetrate(caliber, ammoType)
    if not Config.Penetration or not Config.Penetration.enabled then
        return false, 0, 1
    end

    local modifier = GetAmmoModifier(ammoType, caliber)
    if not modifier then
        return false, 0, 1
    end

    -- Get effective penetration value
    local effectivePen = GetEffectivePenetration(caliber, modifier)

    -- Get overpenetration stats
    local stats = GetOverpenetrationStats(effectivePen)

    -- Roll for overpenetration chance
    local roll = math.random()
    local willOverpenetrate = roll <= stats.chance

    if PenetrationConfig.Debug then
        print(('[PENETRATION] %s %s | Pen: %.2f | Chance: %.0f%% | Roll: %.2f | Result: %s'):format(
            caliber, ammoType, effectivePen, stats.chance * 100, roll,
            willOverpenetrate and 'OVERPENETRATE' or 'STOPPED'
        ))
    end

    return willOverpenetrate, stats.damageRetained, stats.maxTargets
end

--- Apply penetration damage to secondary target
-- @param attackerSource number Attacker's server ID
-- @param victimNetId number Secondary victim's network ID
-- @param damage number Damage amount
-- @param ammoType string Ammo type for effects
-- @param caliber string Caliber for context
local function ApplyPenetrationDamage(attackerSource, victimNetId, damage, ammoType, caliber)
    if not victimNetId or victimNetId == 0 then return end

    -- Check cooldown to prevent duplicate damage
    local now = GetGameTimer()
    if recentPenetrationDamage[victimNetId] and
       now - recentPenetrationDamage[victimNetId] < PenetrationConfig.DamageCooldown then
        return
    end
    recentPenetrationDamage[victimNetId] = now

    local victim = NetworkGetEntityFromNetworkId(victimNetId)
    if not DoesEntityExist(victim) then return end

    local victimSource = NetworkGetEntityOwner(victim)
    if not victimSource or victimSource <= 0 then return end

    -- Apply damage via client event
    TriggerClientEvent('ammo:applyPenetrationDamage', victimSource, {
        damage = damage,
        attackerSource = attackerSource,
        ammoType = ammoType,
        caliber = caliber,
        isPenetration = true,
    })

    if PenetrationConfig.Debug then
        print(('[PENETRATION] Secondary damage: %d to player %d (NetID %d)'):format(
            damage, victimSource, victimNetId
        ))
    end
end

-- =============================================================================
-- MATERIAL PENETRATION
-- =============================================================================

--- Process material penetration from client raycast result
-- @param source number Player who fired
-- @param data table Raycast result data
local function ProcessMaterialPenetration(source, data)
    if not Config.Penetration or not Config.Penetration.enabled then return end

    local caliber = data.caliber
    local ammoType = data.ammoType
    local materialHash = data.materialHash
    local baseDamage = data.baseDamage

    local modifier = GetAmmoModifier(ammoType, caliber)
    if not modifier then return end

    local effectivePen = GetEffectivePenetration(caliber, modifier)
    local materialType = GetMaterialFromHash(materialHash)

    local canPenetrate, damageRetention = CanPenetrateMaterial(effectivePen, materialType)

    if PenetrationConfig.Debug then
        print(('[PENETRATION] Material: %s | Pen: %.2f | Can Penetrate: %s | Retention: %.0f%%'):format(
            materialType, effectivePen, canPenetrate and 'YES' or 'NO', damageRetention * 100
        ))
    end

    if canPenetrate and data.secondaryVictimNetId then
        -- Bullet penetrated cover and hit someone behind it
        local penetratedDamage = math.floor(baseDamage * damageRetention)
        ApplyPenetrationDamage(source, data.secondaryVictimNetId, penetratedDamage, ammoType, caliber)
    end

    -- Notify client of result for visual effects
    TriggerClientEvent('ammo:penetrationResult', source, {
        penetrated = canPenetrate,
        material = materialType,
        impactCoords = data.impactCoords,
        exitCoords = data.exitCoords,
    })
end

-- =============================================================================
-- EVENT HANDLERS
-- =============================================================================

-- Called from sv_damage.lua after primary damage is applied
-- Checks if bullet should continue through target
RegisterNetEvent('ammo:checkOverpenetration', function(data)
    local src = source
    if not PenetrationConfig.Enabled then return end

    if not data or not data.caliber or not data.ammoType then return end

    local shouldPenetrate, damageRetained, maxTargets = ShouldOverpenetrate(
        data.caliber,
        data.ammoType
    )

    if shouldPenetrate then
        -- Tell client to do raycast for secondary targets
        TriggerClientEvent('ammo:findSecondaryTargets', src, {
            caliber = data.caliber,
            ammoType = data.ammoType,
            baseDamage = data.baseDamage,
            damageRetained = damageRetained,
            maxTargets = maxTargets,
            primaryVictimNetId = data.victimNetId,
            impactCoords = data.impactCoords,
            direction = data.direction,
        })
    end
end)

-- Called from client with secondary target results
RegisterNetEvent('ammo:secondaryTargetsFound', function(data)
    local src = source
    if not PenetrationConfig.Enabled then return end

    if not data or not data.targets then return end

    local damageRetained = data.damageRetained or 0.5
    local baseDamage = data.baseDamage or 0

    -- Process each secondary target
    local targetsHit = 0
    for _, target in ipairs(data.targets) do
        if targetsHit >= PenetrationConfig.MaxSecondaryTargets then break end

        -- Calculate damage with falloff per target
        local falloffMultiplier = 1.0 - (targetsHit * 0.15)  -- 15% less per target
        local penetrationDamage = math.floor(baseDamage * damageRetained * falloffMultiplier)

        if penetrationDamage > 0 then
            ApplyPenetrationDamage(src, target.netId, penetrationDamage, data.ammoType, data.caliber)
            targetsHit = targetsHit + 1

            if PenetrationConfig.Debug then
                print(('[PENETRATION] Target %d: NetID %d | Damage: %d (%.0f%% retained, %.0f%% falloff)'):format(
                    targetsHit, target.netId, penetrationDamage,
                    damageRetained * 100, falloffMultiplier * 100
                ))
            end
        end
    end
end)

-- Called from client after material raycast
RegisterNetEvent('ammo:materialPenetrationResult', function(data)
    local src = source
    ProcessMaterialPenetration(src, data)
end)

-- =============================================================================
-- CLEANUP
-- =============================================================================

-- Periodically clean old penetration damage records
CreateThread(function()
    while true do
        Wait(5000)  -- Every 5 seconds

        local now = GetGameTimer()
        local cleanupThreshold = 1000  -- 1 second old

        for netId, timestamp in pairs(recentPenetrationDamage) do
            if now - timestamp > cleanupThreshold then
                recentPenetrationDamage[netId] = nil
            end
        end
    end
end)

-- =============================================================================
-- DEBUG COMMANDS
-- =============================================================================

RegisterCommand('pen_debug', function(src, args)
    if src ~= 0 then return end  -- Console only

    PenetrationConfig.Debug = not PenetrationConfig.Debug
    print(('[PENETRATION] Debug mode: %s'):format(PenetrationConfig.Debug and 'ON' or 'OFF'))
end, true)

RegisterCommand('pen_test', function(src, args)
    if src ~= 0 then return end  -- Console only

    local caliber = args[1] or '.50bmg'
    local ammoType = args[2] or 'ball'

    local shouldPen, retained, maxTargets = ShouldOverpenetrate(caliber, ammoType)

    print(('=== Penetration Test: %s %s ==='):format(caliber, ammoType))
    print(('  Overpenetrates: %s'):format(shouldPen and 'YES' or 'NO'))
    print(('  Damage Retained: %.0f%%'):format(retained * 100))
    print(('  Max Targets: %d'):format(maxTargets))
end, true)

-- =============================================================================
-- EXPORTS
-- =============================================================================

exports('ShouldOverpenetrate', ShouldOverpenetrate)
exports('ApplyPenetrationDamage', ApplyPenetrationDamage)
exports('ProcessMaterialPenetration', ProcessMaterialPenetration)

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

CreateThread(function()
    if PenetrationConfig.Enabled then
        print('[PENETRATION] Server penetration handler initialized')
        print(('[PENETRATION] Max secondary targets: %d'):format(PenetrationConfig.MaxSecondaryTargets))
        print(('[PENETRATION] Max range: %.1fm'):format(PenetrationConfig.MaxPenetrationRange))
    else
        print('[PENETRATION] Server penetration handler DISABLED')
    end
end)
