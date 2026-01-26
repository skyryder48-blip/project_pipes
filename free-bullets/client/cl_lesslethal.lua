--[[
    Less-Lethal Ammunition Effects
    ==============================
    - Beanbag: Ragdoll knockback
    - Pepperball: Vision blur + coughing
    - Tranquilizer: Progressive incapacitation
]]

local isPeppered = false
local isTranqed = false

-- =============================================================================
-- BEANBAG - RAGDOLL KNOCKBACK
-- =============================================================================

RegisterNetEvent('ammo:applyRagdoll', function(data)
    local ped = PlayerPedId()
    if IsEntityDead(ped) then return end

    local force = data.force or 550
    local duration = data.duration or 2200

    -- Apply ragdoll
    SetPedToRagdoll(ped, duration, duration, 0, true, true, false)

    -- Apply knockback force
    local coords = GetEntityCoords(ped)

    -- Get direction from shooter (if available) or use random
    local forceDir = data.direction or vector3(
        math.random() * 2 - 1,
        math.random() * 2 - 1,
        0.3
    )

    ApplyForceToEntity(
        ped,
        1,                          -- Force type
        forceDir.x * force * 0.01,
        forceDir.y * force * 0.01,
        forceDir.z * force * 0.01,
        0.0, 0.0, 0.0,              -- Offset
        0,                          -- Bone index
        false,                      -- Is direction relative
        true,                       -- Ignore up vector
        true,                       -- Is force relative
        false,                      -- P13
        true                        -- P14
    )

    -- Notification
    if lib and lib.notify then
        lib.notify({
            title = 'Impact',
            description = 'You\'ve been hit by a beanbag round!',
            type = 'warning',
            duration = 3000,
        })
    end
end)

-- =============================================================================
-- PEPPERBALL - VISION BLUR + COUGHING
-- =============================================================================

RegisterNetEvent('ammo:applyBlindEffect', function(data)
    if isPeppered then
        -- Refresh duration if already peppered
        return
    end

    isPeppered = true

    local ped = PlayerPedId()
    local duration = data.duration or 8500
    local coughInterval = data.coughInterval or 1800
    local endTime = GetGameTimer() + duration

    -- Notification
    if lib and lib.notify then
        lib.notify({
            title = 'Pepperball Impact',
            description = 'Your eyes are burning!',
            type = 'error',
            duration = 5000,
        })
    end

    -- Start visual effects
    AnimpostfxPlay('DrugsMichaelAliensFight', 0, true)
    ShakeGameplayCam('DRUNK_SHAKE', 1.0)

    -- Reduce player speed
    SetPedMoveRateOverride(ped, 0.4)

    -- Coughing animation loop
    CreateThread(function()
        -- Request animation dictionary
        RequestAnimDict('timetable@gardener@smoking_joint')
        while not HasAnimDictLoaded('timetable@gardener@smoking_joint') do
            Wait(10)
        end

        while GetGameTimer() < endTime and not IsEntityDead(ped) do
            -- Play cough animation
            TaskPlayAnim(
                ped,
                'timetable@gardener@smoking_joint',
                'idle_cough',
                8.0, -8.0,
                1500,
                49,
                0,
                false, false, false
            )

            -- Random cough sound
            PlayPain(ped, 7, 0)

            Wait(coughInterval + math.random(-200, 400))
        end

        -- Clear effects
        AnimpostfxStop('DrugsMichaelAliensFight')
        StopGameplayCamShaking(true)
        SetPedMoveRateOverride(ped, 1.0)
        ClearPedTasks(ped)

        if lib and lib.notify then
            lib.notify({
                title = 'Recovering',
                description = 'Your vision is clearing...',
                type = 'inform',
                duration = 3000,
            })
        end

        isPeppered = false
    end)
end)

-- =============================================================================
-- TRANQUILIZER - PROGRESSIVE INCAPACITATION
-- =============================================================================

RegisterNetEvent('ammo:applyIncapacitation', function(data)
    if isTranqed then return end
    isTranqed = true

    local ped = PlayerPedId()
    local totalDuration = data.duration or 32000
    local phase1 = data.phase1Duration or 5500    -- Stumbling
    local phase2 = data.phase2Duration or 5500    -- Falling
    local phase3 = totalDuration - phase1 - phase2 -- Unconscious

    -- Request animation dictionaries
    RequestAnimDict('move_m@drunk@verydrunk')
    while not HasAnimDictLoaded('move_m@drunk@verydrunk') do Wait(10) end

    -- =========================================================================
    -- PHASE 1: STUMBLING (Dizzy, impaired movement)
    -- =========================================================================

    if lib and lib.notify then
        lib.notify({
            title = 'Tranquilized',
            description = 'You feel a sharp sting... something\'s wrong...',
            type = 'warning',
            duration = 4000,
        })
    end

    -- Apply drunk movement
    SetPedMovementClipset(ped, 'move_m@drunk@verydrunk', 1.0)
    ShakeGameplayCam('DRUNK_SHAKE', 0.5)
    SetPedMoveRateOverride(ped, 0.6)

    -- Gradual screen effect
    AnimpostfxPlay('DrugsDrivingIn', 0, false)

    Wait(phase1)

    if IsEntityDead(ped) then
        CleanupTranqEffects(ped)
        return
    end

    -- =========================================================================
    -- PHASE 2: FALLING (Legs give out, ragdoll)
    -- =========================================================================

    if lib and lib.notify then
        lib.notify({
            title = 'Tranquilized',
            description = 'Your legs are giving out...',
            type = 'error',
            duration = 4000,
        })
    end

    -- Intensify effects
    ShakeGameplayCam('DRUNK_SHAKE', 1.0)
    AnimpostfxPlay('DrugsDrivingOut', 0, false)

    -- Force to ground
    SetPedToRagdoll(ped, phase2, phase2, 0, true, true, false)

    Wait(phase2)

    if IsEntityDead(ped) then
        CleanupTranqEffects(ped)
        return
    end

    -- =========================================================================
    -- PHASE 3: UNCONSCIOUS (Frozen, blackout)
    -- =========================================================================

    if lib and lib.notify then
        lib.notify({
            title = 'Unconscious',
            description = 'Everything goes dark...',
            type = 'error',
            duration = 5000,
        })
    end

    -- Complete incapacitation
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)  -- Prevent death while unconscious
    AnimpostfxPlay('DeathFailOut', 0, true)
    StopGameplayCamShaking(true)

    -- Force prone position
    SetPedToRagdoll(ped, 1000, 1000, 0, true, true, false)

    Wait(phase3)

    -- =========================================================================
    -- WAKE UP
    -- =========================================================================

    CleanupTranqEffects(ped)

    if lib and lib.notify then
        lib.notify({
            title = 'Waking Up',
            description = 'The sedative is wearing off... you feel groggy.',
            type = 'inform',
            duration = 5000,
        })
    end

    -- Gradual recovery (still impaired for a bit)
    SetPedMovementClipset(ped, 'move_m@drunk@moderatedrunk', 0.5)
    SetPedMoveRateOverride(ped, 0.7)

    Wait(5000)

    -- Full recovery
    ResetPedMovementClipset(ped, 1.0)
    SetPedMoveRateOverride(ped, 1.0)

    isTranqed = false
end)

-- Cleanup function for tranq effects
function CleanupTranqEffects(ped)
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    AnimpostfxStop('DeathFailOut')
    AnimpostfxStop('DrugsDrivingIn')
    AnimpostfxStop('DrugsDrivingOut')
    StopGameplayCamShaking(true)
    ResetPedMovementClipset(ped, 1.0)
    SetPedMoveRateOverride(ped, 1.0)
    ClearPedTasks(ped)
end

-- =============================================================================
-- CLEANUP ON RESOURCE STOP
-- =============================================================================

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    local ped = PlayerPedId()

    -- Clear all effects
    if isPeppered then
        AnimpostfxStop('DrugsMichaelAliensFight')
        StopGameplayCamShaking(true)
        SetPedMoveRateOverride(ped, 1.0)
    end

    if isTranqed then
        CleanupTranqEffects(ped)
    end
end)

-- =============================================================================
-- EXPORTS
-- =============================================================================

exports('IsPeppered', function() return isPeppered end)
exports('IsTranqed', function() return isTranqed end)
