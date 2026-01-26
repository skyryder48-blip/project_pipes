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

-- =============================================================================
-- ARMOR INTEGRITY TRACKING
-- =============================================================================

local playerArmorIntegrity = {}  -- { [source] = integrity (0-100) }

local function GetArmorIntegrity(source)
    return playerArmorIntegrity[source] or 100
end

local function SetArmorIntegrity(source, integrity)
    playerArmorIntegrity[source] = math.max(0, math.min(100, integrity))
    Player(source).state:set('armorIntegrity', playerArmorIntegrity[source], true)
end

local function DegradeArmor(source, caliber, ammoType)
    if not Config.ArmorDegradation or not Config.ArmorDegradation.enabled then
        return
    end

    local degradation = CalculateArmorDegradation(caliber, ammoType)
    local currentIntegrity = GetArmorIntegrity(source)
    local newIntegrity = currentIntegrity - degradation

    SetArmorIntegrity(source, newIntegrity)

    if DamageConfig.Debug then
        print(('[ARMOR] Player %d: %d%% → %d%% (-%d from %s %s)'):format(
            source, currentIntegrity, newIntegrity, degradation, caliber, ammoType
        ))
    end

    -- Notify client of armor damage
    TriggerClientEvent('ammo:armorDamaged', source, {
        integrity = newIntegrity,
        degradation = degradation,
    })
end

-- =============================================================================
-- DAMAGE CALCULATION (ENHANCED)
-- =============================================================================

--- Calculate final damage with all modifiers applied
-- @param baseDamage number Original damage value
-- @param ammoType string The ammo type used
-- @param caliber string The weapon's caliber
-- @param hasArmor boolean Whether target has armor
-- @param armorAmount number Amount of armor (0-100)
-- @param distance number Distance from attacker to target (meters)
-- @param boneIndex number Hit bone for limb damage
-- @param hasSuppressor boolean Whether weapon has suppressor
-- @param victimSource number Victim's server ID (for armor degradation)
-- @return number, table Modified damage value and limb effect data
local function CalculateDamage(baseDamage, ammoType, caliber, hasArmor, armorAmount, distance, boneIndex, hasSuppressor, victimSource)
    local modifier = GetAmmoModifier(ammoType, caliber)
    local limbEffects = nil

    -- Start with base damage × ammo damage multiplier
    local damage = baseDamage * modifier.damageMult

    if DamageConfig.Debug then
        print(('[DAMAGE CALC] Base: %.1f × %.2f = %.1f'):format(baseDamage, modifier.damageMult, damage))
    end

    -- ==========================================================================
    -- 1. RANGE FALLOFF
    -- ==========================================================================
    if distance and distance > 0 then
        local rangeMult = CalculateRangeFalloff(caliber, distance, ammoType)
        damage = damage * rangeMult

        if DamageConfig.Debug and rangeMult < 1.0 then
            print(('[DAMAGE CALC] Range falloff: %.0fm → %.0f%% damage'):format(distance, rangeMult * 100))
        end
    end

    -- ==========================================================================
    -- 2. LIMB DAMAGE
    -- ==========================================================================
    if boneIndex and boneIndex > 0 then
        local limbMult, effects = CalculateLimbDamage(boneIndex, caliber, ammoType)
        damage = damage * limbMult
        limbEffects = effects

        if DamageConfig.Debug then
            local region = GetBodyRegion(boneIndex)
            print(('[DAMAGE CALC] Limb hit: %s → %.0f%% damage'):format(region, limbMult * 100))
        end
    end

    -- ==========================================================================
    -- 3. SUPPRESSOR EFFECTS
    -- ==========================================================================
    if hasSuppressor then
        local suppressorMods = GetSuppressorModifiers(caliber, ammoType, true)
        damage = damage * suppressorMods.damageModifier

        if DamageConfig.Debug and suppressorMods.damageModifier ~= 1.0 then
            print(('[DAMAGE CALC] Suppressor: %.0f%% damage'):format(suppressorMods.damageModifier * 100))
        end
    end

    -- ==========================================================================
    -- 4. ARMOR INTERACTION
    -- ==========================================================================
    if hasArmor and armorAmount > 0 then
        -- Get armor effectiveness based on integrity
        local armorIntegrity = victimSource and GetArmorIntegrity(victimSource) or 100
        local armorEffectiveness = GetArmorEffectiveness(armorIntegrity)

        if modifier.armorBypass then
            -- AP rounds bypass armor entirely
            if DamageConfig.Debug then
                print(('[DAMAGE CALC] Armor BYPASSED by %s'):format(ammoType))
            end
        else
            -- Apply armor multiplier × effectiveness
            local effectiveArmorMult = 1.0 - ((1.0 - modifier.armorMult) * armorEffectiveness)
            damage = damage * effectiveArmorMult

            if DamageConfig.Debug then
                print(('[DAMAGE CALC] Armor: %.0f%% integrity, %.0f%% effective → %.0f%% damage through'):format(
                    armorIntegrity, armorEffectiveness * 100, effectiveArmorMult * 100
                ))
            end
        end

        -- Degrade armor on hit
        if victimSource then
            DegradeArmor(victimSource, caliber, ammoType)
        end
    end

    return math.floor(damage + 0.5), limbEffects  -- Round to nearest integer
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

    -- Get additional data for enhanced damage calculation
    local boneIndex = data.hitComponent or 0
    local hasSuppressor = Player(attackerSource).state.hasSuppressor or false

    -- Calculate distance between attacker and victim
    local distance = 0
    local attackerPed = GetPlayerPed(attackerSource)
    if attackerPed and victimNetId then
        local victim = NetworkGetEntityFromNetworkId(victimNetId)
        if DoesEntityExist(attackerPed) and DoesEntityExist(victim) then
            local attackerCoords = GetEntityCoords(attackerPed)
            local victimCoords = GetEntityCoords(victim)
            distance = #(attackerCoords - victimCoords)
        end
    end

    -- Get victim source for armor tracking
    local victimSource = nil
    if victimNetId then
        local victim = NetworkGetEntityFromNetworkId(victimNetId)
        if DoesEntityExist(victim) then
            victimSource = NetworkGetEntityOwner(victim)
        end
    end

    -- Debug output
    if DamageConfig.Debug then
        print(('=== WEAPON DAMAGE EVENT ==='):format())
        print(('  Attacker: %d'):format(attackerSource))
        print(('  Weapon: %d (%s)'):format(weaponHash, caliber))
        print(('  Ammo Type: %s'):format(ammoType))
        print(('  Base Damage: %.1f'):format(baseDamage))
        print(('  Distance: %.1fm'):format(distance))
        print(('  Bone: %d'):format(boneIndex))
        print(('  Suppressor: %s'):format(hasSuppressor and 'YES' or 'NO'))
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

    -- Calculate modified damage with all systems
    local newDamage, limbEffects = CalculateDamage(
        baseDamage,
        ammoType,
        caliber,
        hasArmor,
        armorAmount,
        distance,
        boneIndex,
        hasSuppressor,
        victimSource
    )

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
        if limbEffects then
            print(('  Limb: %s (bleed mult: %.2f)'):format(limbEffects.region, limbEffects.bleedMultiplier))
        end
    end

    -- Trigger limb damage effects for medical script integration
    if limbEffects and victimSource and victimSource > 0 then
        -- Send limb damage event to victim for med script
        TriggerClientEvent('ammo:limbDamage', victimSource, limbEffects)

        -- Also trigger the specific medical event if defined
        if limbEffects.event then
            TriggerClientEvent(limbEffects.event, victimSource, limbEffects)
        end

        -- Handle special limb effects
        if limbEffects.canDropWeapon and math.random() < (limbEffects.dropChance or 0) then
            TriggerClientEvent('ammo:forceDropWeapon', victimSource)
        end

        if limbEffects.canCauseFall and math.random() < (limbEffects.fallChance or 0) then
            TriggerClientEvent('ammo:causeFall', victimSource)
        end

        if limbEffects.canKnockout and math.random() < (limbEffects.knockoutChance or 0) then
            TriggerClientEvent('ammo:knockout', victimSource, {
                duration = 5000 + math.random(0, 5000),
            })
        end
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
-- SUPPRESSOR SYNC
-- =============================================================================

-- Called when player equips/unequips suppressor
RegisterNetEvent('ammo:setSuppressor', function(hasSuppressor)
    local src = source
    Player(src).state:set('hasSuppressor', hasSuppressor == true, true)

    if DamageConfig.Debug then
        print(('[AMMO] Player %d suppressor: %s'):format(src, hasSuppressor and 'EQUIPPED' or 'REMOVED'))
    end
end)

-- =============================================================================
-- ARMOR MANAGEMENT
-- =============================================================================

-- Reset armor integrity (when armor is replaced/repaired)
RegisterNetEvent('ammo:resetArmorIntegrity', function()
    local src = source
    SetArmorIntegrity(src, 100)

    if DamageConfig.Debug then
        print(('[ARMOR] Player %d armor integrity reset to 100%%'):format(src))
    end
end)

-- Repair armor (partial restoration)
RegisterNetEvent('ammo:repairArmor', function(repairAmount)
    local src = source
    local currentIntegrity = GetArmorIntegrity(src)
    local newIntegrity = math.min(100, currentIntegrity + (repairAmount or 25))
    SetArmorIntegrity(src, newIntegrity)

    if DamageConfig.Debug then
        print(('[ARMOR] Player %d armor repaired: %d%% → %d%%'):format(src, currentIntegrity, newIntegrity))
    end
end)

-- =============================================================================
-- PLAYER STATE MANAGEMENT
-- =============================================================================

-- Clean up on player disconnect
AddEventHandler('playerDropped', function()
    ClearPlayerState(source)
    playerArmorIntegrity[source] = nil
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
