--[[
    Client-Side Limb Damage - Medical Script Integration
    =====================================================

    Simplified to ONLY pass bleed/wound data to external medical scripts.
    All gameplay effects (aim penalty, movement, limping) are handled
    by the server's medical system.

    Events triggered to med script:
    - ammo:limbDamage (generic wound data)
    - medical:headTrauma
    - medical:torsoWound
    - medical:armWound
    - medical:legWound
]]

-- =============================================================================
-- LIMB DAMAGE EVENT HANDLER (Pass-through to Med Script)
-- =============================================================================

RegisterNetEvent('ammo:limbDamage', function(data)
    if not data or not data.region then return end

    -- Build enhanced bleed data for medical script
    local bleedData = {
        -- Location information
        region = data.region,
        limbSide = data.limbSide,

        -- Bleed severity (from ammo system calculations)
        bleedRate = data.bleedRate,           -- 'light', 'moderate', 'severe'
        bleedMultiplier = data.bleedMultiplier or 1.0,

        -- Caliber/ammo context for med script
        caliber = data.caliber,
        ammoType = data.ammoType,

        -- Additional flags med script can use
        organDamageChance = data.organDamageChance,
        canCauseInternalBleeding = data.canCauseInternalBleeding,

        -- Timestamp for tracking
        timestamp = GetGameTimer(),
    }

    -- Trigger the specific medical event if defined
    if data.event then
        TriggerEvent(data.event, bleedData)
    end

    -- Also trigger generic wound event for any listening systems
    TriggerEvent('medical:woundReceived', bleedData)
end)

-- =============================================================================
-- ARMOR DAMAGE FEEDBACK (Visual only)
-- =============================================================================

RegisterNetEvent('ammo:armorDamaged', function(data)
    if not data then return end

    local integrity = data.integrity or 100
    local degradation = data.degradation or 0

    -- Visual/audio feedback for armor taking damage
    if degradation > 10 then
        -- Significant armor damage
        PlaySoundFrontend(-1, 'Armour_Warning', 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', true)
    end

    -- Warning when armor is compromised
    if integrity <= 40 and integrity > 20 then
        if lib and lib.notify then
            lib.notify({
                title = 'Armor Damaged',
                description = 'Your armor is compromised!',
                type = 'warning',
                duration = 3000,
            })
        end
    elseif integrity <= 20 then
        if lib and lib.notify then
            lib.notify({
                title = 'Armor Critical',
                description = 'Your armor is nearly destroyed!',
                type = 'error',
                duration = 3000,
            })
        end
    end
end)

-- =============================================================================
-- SUPPRESSOR SYNC
-- =============================================================================

-- Monitor weapon components for suppressor
CreateThread(function()
    local lastSuppressorState = false

    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` then
            -- Check for suppressor component
            local hasSuppressor = HasPedGotWeaponComponent(ped, weapon, `COMPONENT_AT_PI_SUPP`) or
                                  HasPedGotWeaponComponent(ped, weapon, `COMPONENT_AT_AR_SUPP`) or
                                  HasPedGotWeaponComponent(ped, weapon, `COMPONENT_AT_AR_SUPP_02`) or
                                  HasPedGotWeaponComponent(ped, weapon, `COMPONENT_AT_SR_SUPP`) or
                                  HasPedGotWeaponComponent(ped, weapon, `COMPONENT_AT_PI_SUPP_02`)

            if hasSuppressor ~= lastSuppressorState then
                lastSuppressorState = hasSuppressor
                TriggerServerEvent('ammo:setSuppressor', hasSuppressor)
            end

            Wait(500)
        else
            if lastSuppressorState then
                lastSuppressorState = false
                TriggerServerEvent('ammo:setSuppressor', false)
            end
            Wait(1000)
        end
    end
end)

-- =============================================================================
-- EXPORTS (For med script queries)
-- =============================================================================

-- Export bleed multiplier calculation for external med scripts
exports('GetBleedMultiplier', function(caliber, ammoType)
    local ammoBleedMod = Config.LimbDamage and Config.LimbDamage.ammoBleedModifiers[ammoType] or 1.0
    local caliberBleedMod = Config.LimbDamage and Config.LimbDamage.caliberBleedMultiplier[caliber] or 1.0
    return ammoBleedMod * caliberBleedMod
end)
