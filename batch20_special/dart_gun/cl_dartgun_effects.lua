-- ================================================================
-- TRANQUILIZER DART GUN - SPECIAL EFFECTS HANDLER
-- ================================================================
-- Effects: Freeze + Ragdoll + Stumble
-- Duration: 30 seconds
-- 
-- This script handles the special tranquilizer effects when
-- a target is hit by the dart gun. The target will:
-- 1. Stumble on initial hit
-- 2. Fall into ragdoll state
-- 3. Remain frozen/incapacitated for 30 seconds
-- ================================================================

local DART_GUN_HASH = GetHashKey('WEAPON_DARTGUN')
local EFFECT_DURATION = 30000 -- 30 seconds in milliseconds
local STUMBLE_DELAY = 500 -- Delay before ragdoll kicks in (ms)

-- Track affected peds to prevent stacking
local affectedPeds = {}

-- Clean up expired effects
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local currentTime = GetGameTimer()
        for ped, expireTime in pairs(affectedPeds) do
            if currentTime > expireTime then
                -- Release ped from frozen state
                if DoesEntityExist(ped) then
                    FreezeEntityPosition(ped, false)
                    SetEntityInvincible(ped, false)
                    ClearPedTasksImmediately(ped)
                    SetBlockingOfNonTemporaryEvents(ped, false)
                end
                affectedPeds[ped] = nil
            end
        end
    end
end)

-- Main damage detection thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local playerPed = PlayerPedId()
        local weapon = GetSelectedPedWeapon(playerPed)
        
        -- Only process if player has dart gun equipped
        if weapon == DART_GUN_HASH then
            -- Check if player just fired
            if IsPedShooting(playerPed) then
                -- Get the entity the player is aiming at
                local targetPed = GetPedTargetedByPlayer(PlayerId())
                
                if targetPed and DoesEntityExist(targetPed) and IsPedAPlayer(targetPed) == false then
                    -- Check if not already affected
                    if not affectedPeds[targetPed] then
                        ApplyDartEffect(targetPed)
                    end
                end
            end
        end
    end
end)

-- Apply the tranquilizer dart effects
function ApplyDartEffect(ped)
    if not DoesEntityExist(ped) then return end
    
    -- Mark ped as affected
    local expireTime = GetGameTimer() + EFFECT_DURATION
    affectedPeds[ped] = expireTime
    
    -- Phase 1: Initial stumble
    SetPedToRagdoll(ped, STUMBLE_DELAY, STUMBLE_DELAY, 0, false, false, false)
    
    -- Phase 2: Full ragdoll and freeze after stumble
    Citizen.SetTimeout(STUMBLE_DELAY, function()
        if DoesEntityExist(ped) and affectedPeds[ped] then
            -- Apply ragdoll
            SetPedToRagdoll(ped, EFFECT_DURATION, EFFECT_DURATION, 0, false, false, false)
            
            -- Freeze position after ragdoll settles
            Citizen.SetTimeout(1000, function()
                if DoesEntityExist(ped) and affectedPeds[ped] then
                    FreezeEntityPosition(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    -- Make invincible while tranquilized (optional - remove if you want them vulnerable)
                    -- SetEntityInvincible(ped, true)
                end
            end)
        end
    end)
    
    -- Visual/audio feedback (optional)
    -- PlaySoundFromEntity(-1, "DART_HIT", ped, "DART_GUN_SOUNDS", false, 0)
end

-- Event handler for networked/synced damage (for multiplayer)
RegisterNetEvent('dartgun:applyEffect')
AddEventHandler('dartgun:applyEffect', function(targetNetId)
    local ped = NetworkGetEntityFromNetworkId(targetNetId)
    if DoesEntityExist(ped) and not affectedPeds[ped] then
        ApplyDartEffect(ped)
    end
end)

-- Server trigger for synced effects (call from server when dart hits)
-- TriggerServerEvent('dartgun:hitTarget', NetworkGetNetworkIdFromEntity(targetPed))

-- Export function for other resources to check if ped is tranquilized
exports('IsPedTranquilized', function(ped)
    return affectedPeds[ped] ~= nil
end)

-- Export function to manually clear tranquilizer effect
exports('ClearTranquilizerEffect', function(ped)
    if affectedPeds[ped] then
        if DoesEntityExist(ped) then
            FreezeEntityPosition(ped, false)
            SetEntityInvincible(ped, false)
            ClearPedTasksImmediately(ped)
            SetBlockingOfNonTemporaryEvents(ped, false)
        end
        affectedPeds[ped] = nil
        return true
    end
    return false
end)

-- Export function to get remaining tranquilizer time
exports('GetTranquilizerTimeRemaining', function(ped)
    if affectedPeds[ped] then
        local remaining = affectedPeds[ped] - GetGameTimer()
        return remaining > 0 and remaining or 0
    end
    return 0
end)
