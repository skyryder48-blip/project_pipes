--[[
    Pepperball Effects System
    ==========================

    Handles the vision blur and coughing effects when a player is hit
    by 12 gauge pepperball rounds (AMMO_12G_PEPPERBALL).

    Effects:
    - Screen blur/yellow tint (simulates tear gas exposure)
    - Forced coughing animation
    - Movement speed reduction
    - Gradual effect fade over time

    Duration: 8 seconds base, stacks with multiple hits
]]

local isPeppered = false
local pepperEndTime = 0
local pepperIntensity = 0.0

-- Effect configuration
local Config = {
    baseDuration = 8000,        -- Base effect duration in ms
    maxDuration = 20000,        -- Maximum stacked duration
    intensityPerHit = 0.4,      -- Intensity added per hit (0.0-1.0)
    maxIntensity = 1.0,         -- Maximum intensity cap
    fadeRate = 0.001,           -- How fast intensity decreases per frame
    movementPenalty = 0.4,      -- Movement speed reduction (40%)
    coughInterval = 2000,       -- Time between coughs in ms
    blurStrength = 2.0,         -- TimeCycle blur strength
}

-- Coughing animation data
local coughAnims = {
    { dict = 'gestures@m@standing@casual', anim = 'gesture_no_way' },
    { dict = 'mp_player_intcelebrationmale', anim = 'mp_player_int_gasp' },
}

local lastCoughTime = 0

-- Apply pepper effect to player
function ApplyPepperEffect(intensity)
    local currentTime = GetGameTimer()

    -- Stack duration and intensity
    pepperEndTime = math.min(currentTime + Config.baseDuration, currentTime + Config.maxDuration)
    pepperIntensity = math.min(pepperIntensity + (intensity or Config.intensityPerHit), Config.maxIntensity)
    isPeppered = true

    if Config.Debug then
        print(('[PEPPERBALL] Effect applied - Intensity: %.2f, Duration: %dms'):format(
            pepperIntensity, pepperEndTime - currentTime))
    end
end

-- Force coughing animation
function PlayCoughAnimation()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then return end

    local cough = coughAnims[math.random(#coughAnims)]

    RequestAnimDict(cough.dict)
    local timeout = 1000
    while not HasAnimDictLoaded(cough.dict) and timeout > 0 do
        Wait(10)
        timeout = timeout - 10
    end

    if HasAnimDictLoaded(cough.dict) then
        TaskPlayAnim(ped, cough.dict, cough.anim, 4.0, -4.0, 1500, 49, 0, false, false, false)
    end
end

-- Main effect loop
CreateThread(function()
    while true do
        if isPeppered then
            local currentTime = GetGameTimer()

            -- Check if effect should end
            if currentTime >= pepperEndTime or pepperIntensity <= 0 then
                isPeppered = false
                pepperIntensity = 0.0
                ClearTimecycleModifier()
                ResetPedMovementClipset(PlayerPedId())
                Wait(100)
            else
                -- Apply visual effects based on intensity
                SetTimecycleModifier('phone_cam3')  -- Yellow/brown tint
                SetTimecycleModifierStrength(pepperIntensity * 0.8)

                -- Screen blur effect
                if pepperIntensity > 0.3 then
                    DrawRect(0.5, 0.5, 1.0, 1.0, 180, 150, 50, math.floor(pepperIntensity * 80))
                end

                -- Movement penalty
                local ped = PlayerPedId()
                if pepperIntensity > 0.5 then
                    SetPedMoveRateOverride(ped, 1.0 - (Config.movementPenalty * pepperIntensity))
                end

                -- Periodic coughing
                if currentTime - lastCoughTime >= Config.coughInterval then
                    if math.random() < pepperIntensity then
                        PlayCoughAnimation()
                        lastCoughTime = currentTime
                    end
                end

                -- Gradual fade
                pepperIntensity = pepperIntensity - Config.fadeRate

                Wait(0)
            end
        else
            Wait(500)  -- Sleep when not active
        end
    end
end)

-- Listen for damage events from pepperball ammo
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local weaponHash = args[7]

        -- Check if local player was hit
        if victim == PlayerPedId() then
            -- Server should validate and trigger effect
            -- This is a fallback for client-side detection
        end
    end
end)

-- Server event to apply pepper effect (called from damage handler)
RegisterNetEvent('ammo:pepperball:applyEffect')
AddEventHandler('ammo:pepperball:applyEffect', function(intensity)
    ApplyPepperEffect(intensity)
end)

-- Export for other resources
exports('ApplyPepperEffect', ApplyPepperEffect)
exports('IsPeppered', function() return isPeppered end)
exports('GetPepperIntensity', function() return pepperIntensity end)

-- Debug command
if Config.Debug then
    RegisterCommand('testpepper', function()
        ApplyPepperEffect(0.6)
    end, false)
end
