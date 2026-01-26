--[[
    Server-Side Ammunition Damage Handler
    ======================================

    Intercepts weaponDamageEvent and applies ammo-type specific modifiers.

    Flow:
    1. Player fires weapon → weaponDamageEvent triggered
    2. Get player's current ammo type from state
    3. Apply damage multiplier based on ammo type
    4. Apply armor modifier if target is armored
    5. Trigger special effects (fire, ragdoll, etc.)

    Dependencies:
    - shared/modifiers.lua (Config.AmmoModifiers)
    - shared/config.lua (Config.Weapons)
]]

-- =============================================================================
-- CONFIGURATION
-- =============================================================================

local DamageConfig = {
    -- Enable/disable the damage modification system
    Enabled = true,

    -- Debug mode (prints damage calculations to console)
    Debug = false,

    -- Enable armor detection and modification
    ArmorSystemEnabled = true,

    -- Minimum armor value to be considered "armored"
    ArmorThreshold = 10,

    -- Enable special effects (fire, ragdoll, blind)
    EffectsEnabled = true,

    -- Log suspicious damage patterns
    LogSuspicious = true,
    SuspiciousThreshold = 200,  -- Damage over this value is logged
}

-- =============================================================================
-- PLAYER AMMO STATE
-- =============================================================================

-- Tracks current ammo type per player per weapon
-- { [source] = { [weaponHash] = ammoType } }
local playerAmmoState = {}

--- Get the current ammo type for a player's weapon
-- @param source number Player server ID
-- @param weaponHash number Weapon hash
-- @return string Ammo type (defaults to caliber's default)
local function GetPlayerAmmoType(source, weaponHash)
    if playerAmmoState[source] and playerAmmoState[source][weaponHash] then
        return playerAmmoState[source][weaponHash]
    end

    -- Fallback to default for this weapon's caliber
    local weaponInfo = Config.Weapons and Config.Weapons[weaponHash]
    if weaponInfo and weaponInfo.caliber then
        return GetDefaultAmmoType(weaponInfo.caliber)
    end

    return 'fmj'
end

--- Set the current ammo type for a player's weapon
-- @param source number Player server ID
-- @param weaponHash number Weapon hash
-- @param ammoType string The ammo type
local function SetPlayerAmmoType(source, weaponHash, ammoType)
    if not playerAmmoState[source] then
        playerAmmoState[source] = {}
    end
    playerAmmoState[source][weaponHash] = ammoType

    -- Sync to client via StateBag for other systems
    local stateKey = ('ammo_%s'):format(weaponHash)
    Player(source).state:set(stateKey, ammoType, true)

    if DamageConfig.Debug then
        print(('[AMMO DAMAGE] Player %d weapon %d set to %s'):format(source, weaponHash, ammoType))
    end
end

--- Clear all ammo state for a player
-- @param source number Player server ID
local function ClearPlayerState(source)
    playerAmmoState[source] = nil
end

-- =============================================================================
-- DAMAGE CALCULATION
-- =============================================================================

--- Check if a ped has armor
-- @param pedNetId number Network ID of the ped
-- @return boolean, number Whether armored and armor amount
local function CheckPedArmor(pedNetId)
    if not DamageConfig.ArmorSystemEnabled then
        return false, 0
    end

    local ped = NetworkGetEntityFromNetworkId(pedNetId)
    if not DoesEntityExist(ped) then
        return false, 0
    end

    -- Can't get armor directly on server, check via player state or assume based on entity type
    -- For NPC peds, we check if they're wearing armor via model or assume no armor
    -- For player peds, we use StateBag or callback

    local pedOwner = NetworkGetEntityOwner(ped)
    if pedOwner and pedOwner > 0 then
        -- This is a player - check their armor StateBag
        local armor = Player(pedOwner).state.armor or 0
        return armor >= DamageConfig.ArmorThreshold, armor
    end

    -- NPC - assume no armor unless configured
    return false, 0
end

--- Calculate final damage with modifiers applied
-- @param baseDamage number Original damage value
-- @param ammoType string The ammo type used
-- @param caliber string The weapon's caliber
-- @param hasArmor boolean Whether target has armor
-- @param armorAmount number Amount of armor (0-100)
-- @return number Modified damage value
local function CalculateDamage(baseDamage, ammoType, caliber, hasArmor, armorAmount)
    local modifier = GetAmmoModifier(ammoType, caliber)

    -- Start with base damage × ammo damage multiplier
    local damage = baseDamage * modifier.damageMult

    -- Apply armor modifier if target is armored
    if hasArmor and armorAmount > 0 then
        if modifier.armorBypass then
            -- AP rounds bypass armor entirely
            -- Damage goes through at full modified value
            if DamageConfig.Debug then
                print(('[AMMO DAMAGE] Armor BYPASSED by %s'):format(ammoType))
            end
        else
            -- Apply armor multiplier (reduces damage vs armor)
            damage = damage * modifier.armorMult

            if DamageConfig.Debug then
                print(('[AMMO DAMAGE] Armor reduced damage: %.1f × %.2f = %.1f'):format(
                    baseDamage * modifier.damageMult, modifier.armorMult, damage
                ))
            end
        end
    end

    return math.floor(damage + 0.5)  -- Round to nearest integer
end

-- =============================================================================
-- SPECIAL EFFECTS
-- =============================================================================

--- Trigger special effects based on ammo type
-- @param attackerSource number Attacker's server ID
-- @param victimNetId number Victim's network ID
-- @param effects table Effects configuration from modifier
-- @param weaponHash number Weapon hash (for context)
local function TriggerSpecialEffects(attackerSource, victimNetId, effects, weaponHash)
    if not DamageConfig.EffectsEnabled or not effects then return end
    if not victimNetId or victimNetId == 0 then return end

    local victim = NetworkGetEntityFromNetworkId(victimNetId)
    if not DoesEntityExist(victim) then return end

    -- Get victim's owner (for player effects)
    local victimSource = NetworkGetEntityOwner(victim)
    if not victimSource or victimSource <= 0 then return end

    -- Fire Effect (Incendiary, Dragon's Breath, API)
    if effects.fire then
        TriggerClientEvent('ammo:applyFireEffect', victimSource, {
            duration = effects.fireDuration or 3000,
            damage = effects.fireDamage or 3,
            trail = effects.fireTrail or false,
        })

        if DamageConfig.Debug then
            print(('[AMMO EFFECTS] Fire applied to player %d'):format(victimSource))
        end
    end

    -- Vehicle Fire (API rounds)
    if effects.vehicleFire and IsEntityAVehicle(victim) then
        -- Trigger fire on vehicle
        TriggerClientEvent('ammo:applyVehicleFire', victimSource, {
            vehicleNetId = victimNetId,
            duration = effects.fireDuration or 5000,
        })
    end

    -- Ragdoll Effect (Beanbag)
    if effects.ragdoll then
        TriggerClientEvent('ammo:applyRagdoll', victimSource, {
            force = effects.ragdollForce or 300,
            duration = effects.ragdollDuration or 2000,
        })

        if DamageConfig.Debug then
            print(('[AMMO EFFECTS] Ragdoll applied to player %d'):format(victimSource))
        end
    end

    -- Blind Effect (Pepperball)
    if effects.blind then
        TriggerClientEvent('ammo:applyBlindEffect', victimSource, {
            duration = effects.blindDuration or 5000,
            cough = effects.cough or false,
            coughInterval = effects.coughInterval or 2000,
        })

        if DamageConfig.Debug then
            print(('[AMMO EFFECTS] Blind applied to player %d'):format(victimSource))
        end
    end

    -- Incapacitation Effect (Tranquilizer)
    if effects.incapacitate then
        TriggerClientEvent('ammo:applyIncapacitation', victimSource, {
            duration = effects.incapDuration or 30000,
            phase1 = effects.phase1Duration or 5000,
            phase2 = effects.phase2Duration or 5000,
            phase3 = effects.phase3Duration or 20000,
        })

        if DamageConfig.Debug then
            print(('[AMMO EFFECTS] Incapacitation applied to player %d'):format(victimSource))
        end
    end

    -- Explosion Effect (BOOM rounds)
    if effects.explosive then
        local coords = GetEntityCoords(victim)
        if coords then
            -- Create explosion at impact point
            -- Note: This requires careful balancing to not be OP
            TriggerClientEvent('ammo:createExplosion', -1, {
                coords = coords,
                radius = effects.explosionRadius or 1.5,
                damage = effects.explosionDamage or 30,
                isVehicle = IsEntityAVehicle(victim),
            })

            if DamageConfig.Debug then
                print(('[AMMO EFFECTS] Explosion at %.1f, %.1f, %.1f'):format(coords.x, coords.y, coords.z))
            end
        end
    end

    -- Vehicle Explosion (BOOM on vehicles)
    if effects.vehicleExplosion and IsEntityAVehicle(victim) then
        -- Add significant damage to vehicle, may trigger explosion
        local vehicleHealth = GetEntityHealth(victim)
        if vehicleHealth < 300 then
            -- Vehicle is low health, trigger explosion
            TriggerClientEvent('ammo:explodeVehicle', -1, {
                vehicleNetId = victimNetId,
            })
        end
    end
end

-- =============================================================================
-- WEAPON DAMAGE EVENT HANDLER
-- =============================================================================

AddEventHandler('weaponDamageEvent', function(attackerSource, data)
    if not DamageConfig.Enabled then return end

    -- Validate data
    if not data or not data.weaponType then return end

    local weaponHash = data.weaponType
    local baseDamage = data.weaponDamage or 0
    local victimNetId = data.hitGlobalId

    -- Check if this weapon is in our system
    local weaponInfo = Config.Weapons and Config.Weapons[weaponHash]
    if not weaponInfo then
        -- Weapon not in ammo system, let default damage through
        return
    end

    local caliber = weaponInfo.caliber
    local ammoType = GetPlayerAmmoType(attackerSource, weaponHash)
    local modifier = GetAmmoModifier(ammoType, caliber)

    -- Debug output
    if DamageConfig.Debug then
        print(('=== WEAPON DAMAGE EVENT ==='):format())
        print(('  Attacker: %d'):format(attackerSource))
        print(('  Weapon: %d (%s)'):format(weaponHash, caliber))
        print(('  Ammo Type: %s'):format(ammoType))
        print(('  Base Damage: %.1f'):format(baseDamage))
    end

    -- Check for blanks (no damage ammo)
    if modifier.effects and modifier.effects.noDamage then
        CancelEvent()
        if DamageConfig.Debug then
            print('  CANCELLED: Blank ammunition')
        end
        return
    end

    -- Check target armor status
    local hasArmor, armorAmount = CheckPedArmor(victimNetId)

    -- Calculate modified damage
    local newDamage = CalculateDamage(baseDamage, ammoType, caliber, hasArmor, armorAmount)

    -- Apply the modified damage
    data.weaponDamage = newDamage

    -- Log suspicious damage
    if DamageConfig.LogSuspicious and newDamage > DamageConfig.SuspiciousThreshold then
        local attackerName = GetPlayerName(attackerSource) or 'Unknown'
        print(('[AMMO DAMAGE WARNING] High damage: %s (%d) dealt %d damage with %s %s'):format(
            attackerName, attackerSource, newDamage, caliber, ammoType
        ))
    end

    if DamageConfig.Debug then
        print(('  Modified Damage: %.1f'):format(newDamage))
        print(('  Armor: %s (%d)'):format(hasArmor and 'YES' or 'NO', armorAmount))
    end

    -- Trigger special effects
    if modifier.effects and next(modifier.effects) then
        TriggerSpecialEffects(attackerSource, victimNetId, modifier.effects, weaponHash)
    end

    -- Check for bullet penetration (overpenetration through target)
    if Config.Penetration and Config.Penetration.enabled then
        local effectivePen = GetEffectivePenetration(caliber, modifier)

        -- Only check overpenetration if penetration value is high enough
        if effectivePen >= 0.50 then
            -- Get impact coordinates from client via callback or estimate
            TriggerClientEvent('ammo:requestImpactCoords', attackerSource, {
                victimNetId = victimNetId,
                caliber = caliber,
                ammoType = ammoType,
                baseDamage = newDamage,
            })
        end

        if DamageConfig.Debug then
            print(('  Penetration Value: %.2f'):format(effectivePen))
        end
    end
end)

-- =============================================================================
-- AMMO TYPE SYNC EVENTS
-- =============================================================================

-- Called when player equips magazine with specific ammo type
RegisterNetEvent('ammo:setAmmoType', function(weaponHash, ammoType)
    local src = source
    if type(weaponHash) ~= 'number' or type(ammoType) ~= 'string' then return end

    -- Validate ammo type exists
    if not Config.AmmoModifiers[ammoType] then
        print(('[AMMO DAMAGE] Invalid ammo type from player %d: %s'):format(src, ammoType))
        return
    end

    SetPlayerAmmoType(src, weaponHash, ammoType)
end)

-- Called when magazine is equipped via magazine system
RegisterNetEvent('ammo:magazineEquipped', function(data)
    local src = source
    if not data or not data.weaponHash or not data.ammoType then return end

    SetPlayerAmmoType(src, data.weaponHash, data.ammoType)
end)

-- =============================================================================
-- PLAYER STATE MANAGEMENT
-- =============================================================================

-- Clean up on player disconnect
AddEventHandler('playerDropped', function()
    ClearPlayerState(source)
end)

-- Clean up on character unload (framework integration)
RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(src)
    ClearPlayerState(src)
end)

RegisterNetEvent('ox:playerLogout', function(src)
    ClearPlayerState(src)
end)

-- =============================================================================
-- ARMOR SYNC (from client)
-- =============================================================================

-- Client should periodically sync their armor value
RegisterNetEvent('ammo:syncArmor', function(armorAmount)
    local src = source
    if type(armorAmount) ~= 'number' then return end

    Player(src).state:set('armor', armorAmount, false)
end)

-- =============================================================================
-- ADMIN/DEBUG COMMANDS
-- =============================================================================

-- Check player's current ammo state
RegisterCommand('ammo_check', function(src, args)
    if src ~= 0 then return end  -- Console only

    local targetId = tonumber(args[1])
    if not targetId then
        print('Usage: ammo_check <playerId>')
        return
    end

    local state = playerAmmoState[targetId]
    if not state then
        print(('Player %d has no ammo state'):format(targetId))
        return
    end

    print(('=== Ammo State for Player %d ==='):format(targetId))
    for weaponHash, ammoType in pairs(state) do
        print(('  Weapon %d: %s'):format(weaponHash, ammoType))
    end
end, true)

-- Toggle debug mode
RegisterCommand('ammo_debug', function(src, args)
    if src ~= 0 then return end  -- Console only

    DamageConfig.Debug = not DamageConfig.Debug
    print(('[AMMO DAMAGE] Debug mode: %s'):format(DamageConfig.Debug and 'ON' or 'OFF'))
end, true)

-- =============================================================================
-- EXPORTS
-- =============================================================================

exports('GetPlayerAmmoType', GetPlayerAmmoType)
exports('SetPlayerAmmoType', SetPlayerAmmoType)
exports('ClearPlayerState', ClearPlayerState)
exports('CalculateDamage', CalculateDamage)

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

CreateThread(function()
    if DamageConfig.Enabled then
        print('[AMMO DAMAGE] Server damage handler initialized')
        print(('[AMMO DAMAGE] Armor system: %s'):format(DamageConfig.ArmorSystemEnabled and 'ENABLED' or 'DISABLED'))
        print(('[AMMO DAMAGE] Effects: %s'):format(DamageConfig.EffectsEnabled and 'ENABLED' or 'DISABLED'))
    else
        print('[AMMO DAMAGE] Server damage handler DISABLED')
    end
end)
