--[[
    Client-Side Limb Damage Effects
    ================================

    Handles visual/gameplay effects for limb-based damage:
    - Arm wounds: Aim penalty, weapon drop
    - Leg wounds: Movement penalty, falling
    - Head wounds: Vision impairment, knockout
    - Torso wounds: (Handled by med script)

    Integrates with medical scripts via events.
]]

-- =============================================================================
-- STATE TRACKING
-- =============================================================================

local limbWounds = {
    arm_left = false,
    arm_right = false,
    leg_left = false,
    leg_right = false,
    head = false,
    torso = false,
}

local movementPenalty = 0
local aimPenalty = 0
local isLimping = false

-- =============================================================================
-- LIMB DAMAGE EVENT HANDLER
-- =============================================================================

RegisterNetEvent('ammo:limbDamage', function(data)
    if not data or not data.region then return end

    local ped = PlayerPedId()
    local region = data.region

    -- Mark region as wounded
    limbWounds[region] = true

    -- Apply region-specific effects
    if region == 'arm_left' or region == 'arm_right' then
        ApplyArmWoundEffects(data)
    elseif region == 'leg_left' or region == 'leg_right' then
        ApplyLegWoundEffects(data)
    elseif region == 'head' then
        ApplyHeadWoundEffects(data)
    end

    -- Notify for med script integration
    -- The server already triggers the specific medical event
end)

-- =============================================================================
-- ARM WOUND EFFECTS
-- =============================================================================

function ApplyArmWoundEffects(data)
    local ped = PlayerPedId()

    -- Apply aim penalty
    if data.aimPenalty and data.aimPenalty > 0 then
        aimPenalty = math.min(0.60, aimPenalty + data.aimPenalty)

        -- Visual feedback
        if lib and lib.notify then
            local armSide = data.limbSide == 'right' and 'right' or 'left'
            lib.notify({
                title = 'Arm Wound',
                description = ('Your %s arm is injured - aiming impaired'):format(armSide),
                type = 'error',
                duration = 3000,
            })
        end
    end
end

-- =============================================================================
-- LEG WOUND EFFECTS
-- =============================================================================

function ApplyLegWoundEffects(data)
    local ped = PlayerPedId()

    -- Apply movement penalty
    if data.movementPenalty and data.movementPenalty > 0 then
        movementPenalty = math.min(0.70, movementPenalty + data.movementPenalty)
        UpdateMovementSpeed()

        -- Visual feedback
        if lib and lib.notify then
            local legSide = data.limbSide == 'right' and 'right' or 'left'
            lib.notify({
                title = 'Leg Wound',
                description = ('Your %s leg is injured - movement impaired'):format(legSide),
                type = 'error',
                duration = 3000,
            })
        end
    end

    -- Start limping if not already
    if data.canCauseLimp and not isLimping then
        StartLimping()
    end
end

function StartLimping()
    isLimping = true

    -- Request limp animation
    local clipset = 'move_m@injured'
    RequestAnimSet(clipset)

    local timeout = 1000
    while not HasAnimSetLoaded(clipset) and timeout > 0 do
        Wait(10)
        timeout = timeout - 10
    end

    if HasAnimSetLoaded(clipset) then
        SetPedMovementClipset(PlayerPedId(), clipset, 0.5)
    end
end

function StopLimping()
    isLimping = false
    ResetPedMovementClipset(PlayerPedId(), 0.5)
end

function UpdateMovementSpeed()
    local ped = PlayerPedId()
    local speedMult = 1.0 - movementPenalty
    SetPedMoveRateOverride(ped, speedMult)
end

-- =============================================================================
-- HEAD WOUND EFFECTS
-- =============================================================================

function ApplyHeadWoundEffects(data)
    local ped = PlayerPedId()

    -- Vision impairment
    if data.visionImpairment then
        -- Slight blur/shake
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.2)

        -- Brief screen effect
        AnimpostfxPlay('FocusOut', 0, false)
        SetTimeout(500, function()
            AnimpostfxStop('FocusOut')
        end)
    end

    -- Notification
    if lib and lib.notify then
        lib.notify({
            title = 'Head Wound',
            description = 'Your head is ringing...',
            type = 'error',
            duration = 3000,
        })
    end
end

-- =============================================================================
-- SPECIAL EFFECT HANDLERS
-- =============================================================================

-- Force drop weapon (arm wound)
RegisterNetEvent('ammo:forceDropWeapon', function()
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)

    if weapon ~= `WEAPON_UNARMED` then
        SetPedDropsWeapon(ped)

        if lib and lib.notify then
            lib.notify({
                title = 'Weapon Dropped',
                description = 'The impact made you drop your weapon!',
                type = 'warning',
                duration = 3000,
            })
        end
    end
end)

-- Cause fall (leg wound)
RegisterNetEvent('ammo:causeFall', function()
    local ped = PlayerPedId()

    SetPedToRagdoll(ped, 2000, 2000, 0, true, true, false)

    if lib and lib.notify then
        lib.notify({
            title = 'Lost Balance',
            description = 'Your leg gave out!',
            type = 'error',
            duration = 2000,
        })
    end
end)

-- Knockout (head wound)
RegisterNetEvent('ammo:knockout', function(data)
    local ped = PlayerPedId()
    local duration = data.duration or 5000

    -- Ragdoll
    SetPedToRagdoll(ped, duration, duration, 0, true, true, false)

    -- Screen effect
    AnimpostfxPlay('DeathFailOut', 0, true)
    DoScreenFadeOut(500)

    -- Notify
    if lib and lib.notify then
        lib.notify({
            title = 'Knocked Out',
            description = 'You\'ve been knocked unconscious...',
            type = 'error',
            duration = duration,
        })
    end

    -- Wake up
    SetTimeout(duration, function()
        AnimpostfxStop('DeathFailOut')
        DoScreenFadeIn(1000)

        if lib and lib.notify then
            lib.notify({
                title = 'Waking Up',
                description = 'You\'re regaining consciousness...',
                type = 'inform',
                duration = 3000,
            })
        end
    end)
end)

-- =============================================================================
-- ARMOR DAMAGE FEEDBACK
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
-- AIM PENALTY APPLICATION
-- =============================================================================

CreateThread(function()
    while true do
        if aimPenalty > 0 then
            local ped = PlayerPedId()

            if IsPedShooting(ped) or IsPlayerFreeAiming(PlayerId()) then
                -- Apply aim shake based on penalty
                local shakeIntensity = aimPenalty * 0.5
                ShakeGameplayCam('HAND_SHAKE', shakeIntensity)
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- =============================================================================
-- WOUND RECOVERY (Called by med script or timeout)
-- =============================================================================

RegisterNetEvent('ammo:healLimb', function(region)
    if not region then return end

    limbWounds[region] = false

    -- Reset effects for that limb
    if region == 'arm_left' or region == 'arm_right' then
        aimPenalty = math.max(0, aimPenalty - 0.30)
    elseif region == 'leg_left' or region == 'leg_right' then
        movementPenalty = math.max(0, movementPenalty - 0.35)
        UpdateMovementSpeed()

        -- Stop limping if both legs healed
        if not limbWounds.leg_left and not limbWounds.leg_right then
            StopLimping()
        end
    end
end)

-- Full healing (all limbs)
RegisterNetEvent('ammo:healAllLimbs', function()
    for region, _ in pairs(limbWounds) do
        limbWounds[region] = false
    end

    aimPenalty = 0
    movementPenalty = 0
    StopLimping()
    UpdateMovementSpeed()
end)

-- =============================================================================
-- CLEANUP
-- =============================================================================

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    -- Reset all effects
    local ped = PlayerPedId()
    ResetPedMovementClipset(ped, 1.0)
    SetPedMoveRateOverride(ped, 1.0)
    StopGameplayCamShaking(true)
    AnimpostfxStop('DeathFailOut')
    AnimpostfxStop('FocusOut')
end)

-- =============================================================================
-- EXPORTS
-- =============================================================================

exports('GetLimbWounds', function() return limbWounds end)
exports('GetAimPenalty', function() return aimPenalty end)
exports('GetMovementPenalty', function() return movementPenalty end)
exports('IsLimping', function() return isLimping end)
