--[[
    Client-Side Ammunition System
    Handles weapon component swapping and ammo state display
]]

local QBX = exports['qbx_core']:GetCoreObject()
local currentAmmoType = {}  -- Tracks loaded ammo type per weapon hash

-- ============================================
-- STATE MANAGEMENT
-- ============================================

-- Get the currently equipped weapon hash
function GetEquippedWeapon()
    local ped = PlayerPedId()
    return GetSelectedPedWeapon(ped)
end

-- Get current ammo type for a weapon
function GetCurrentAmmoType(weaponHash)
    return currentAmmoType[weaponHash] or nil
end

-- Set current ammo type for a weapon
function SetCurrentAmmoType(weaponHash, ammoType)
    currentAmmoType[weaponHash] = ammoType
    if Config.Debug then
        print(('[AMMO] Set ammo type for %s to %s'):format(weaponHash, ammoType))
    end
end

-- ============================================
-- COMPONENT MANAGEMENT
-- ============================================

-- Remove all ammo type clips from a weapon
function RemoveAllAmmoClips(ped, weaponHash, weaponConfig)
    local caliber = weaponConfig.caliber
    local ammoTypes = Config.AmmoTypes[caliber]
    
    for ammoType, ammoData in pairs(ammoTypes) do
        local componentHash = GetComponentHash(weaponConfig, ammoType)
        if HasPedGotWeaponComponent(ped, weaponHash, componentHash) then
            RemoveWeaponComponentFromPed(ped, weaponHash, componentHash)
            if Config.Debug then
                print(('[AMMO] Removed component %s from weapon'):format(ammoType))
            end
        end
    end
end

-- Add a specific ammo clip to a weapon
function AddAmmoClip(ped, weaponHash, weaponConfig, ammoType)
    local componentHash = GetComponentHash(weaponConfig, ammoType)
    GiveWeaponComponentToPed(ped, weaponHash, componentHash)
    SetCurrentAmmoType(weaponHash, ammoType)
    
    if Config.Debug then
        print(('[AMMO] Added %s clip to weapon'):format(ammoType))
    end
end

-- ============================================
-- AMMO LOADING LOGIC
-- ============================================

-- Load ammo into currently equipped weapon
-- Returns: success (bool), oldAmmoType (string|nil), oldAmmoCount (int)
function LoadAmmoIntoWeapon(ammoType, ammoCount)
    local ped = PlayerPedId()
    local weaponHash = GetEquippedWeapon()
    
    -- Check if holding a valid weapon
    if weaponHash == `weapon_unarmed` then
        return false, nil, 0, 'no_weapon'
    end
    
    -- Check if weapon is in our system
    local weaponConfig = GetWeaponConfig(weaponHash)
    if not weaponConfig then
        return false, nil, 0, 'unknown_weapon'
    end
    
    -- Check if ammo type matches weapon caliber
    local caliber = weaponConfig.caliber
    if not Config.AmmoTypes[caliber] or not Config.AmmoTypes[caliber][ammoType] then
        return false, nil, 0, 'wrong_caliber'
    end
    
    -- Get current ammo state
    local currentType = GetCurrentAmmoType(weaponHash)
    local currentAmmoInWeapon = GetAmmoInPedWeapon(ped, weaponHash)
    
    -- Calculate how much ammo to load (capped at magazine capacity)
    local capacity = weaponConfig.capacity
    local ammoToLoad = math.min(ammoCount, capacity)
    
    -- Store old ammo info for return to inventory
    local oldAmmoType = currentType
    local oldAmmoCount = currentAmmoInWeapon
    
    -- Remove current ammo and clips
    if currentAmmoInWeapon > 0 then
        SetPedAmmo(ped, weaponHash, 0)
    end
    RemoveAllAmmoClips(ped, weaponHash, weaponConfig)
    
    -- Add new clip component
    AddAmmoClip(ped, weaponHash, weaponConfig, ammoType)
    
    -- Set new ammo count
    SetPedAmmo(ped, weaponHash, ammoToLoad)
    
    if Config.Debug then
        print(('[AMMO] Loaded %d rounds of %s (was: %d rounds of %s)'):format(
            ammoToLoad, ammoType, oldAmmoCount or 0, oldAmmoType or 'none'
        ))
    end
    
    return true, oldAmmoType, oldAmmoCount, nil, ammoToLoad
end

-- ============================================
-- SERVER COMMUNICATION
-- ============================================

-- Called by server when player uses ammo item
RegisterNetEvent('ammo_system:client:loadAmmo', function(caliber, ammoType, ammoCount)
    local success, oldType, oldCount, error, loadedCount = LoadAmmoIntoWeapon(ammoType, ammoCount)
    
    -- Report back to server
    TriggerServerEvent('ammo_system:server:loadAmmoResult', {
        success = success,
        error = error,
        oldAmmoType = oldType,
        oldAmmoCount = oldCount,
        loadedCount = loadedCount,
        caliber = caliber,
        newAmmoType = ammoType
    })
end)

-- ============================================
-- WEAPON PICKUP/DROP HANDLING
-- ============================================

-- When weapon is removed, clear its ammo state
RegisterNetEvent('ammo_system:client:weaponRemoved', function(weaponHash)
    currentAmmoType[weaponHash] = nil
    if Config.Debug then
        print(('[AMMO] Cleared ammo state for weapon %s'):format(weaponHash))
    end
end)

-- When player receives a weapon, ensure it starts empty
RegisterNetEvent('ammo_system:client:weaponAdded', function(weaponHash)
    if Config.WeaponsSpawnEmpty then
        local ped = PlayerPedId()
        SetPedAmmo(ped, weaponHash, 0)
        currentAmmoType[weaponHash] = nil
        
        if Config.Debug then
            print(('[AMMO] Weapon %s added with empty magazine'):format(weaponHash))
        end
    end
end)

-- ============================================
-- SYNC STATE ON RESOURCE START
-- ============================================

-- Sync ammo state from server on resource start
RegisterNetEvent('ammo_system:client:syncState', function(ammoState)
    currentAmmoType = ammoState or {}
    if Config.Debug then
        print('[AMMO] Synced ammo state from server')
        for hash, ammoType in pairs(currentAmmoType) do
            print(('  - Weapon %s: %s'):format(hash, ammoType))
        end
    end
end)

-- Request state sync on resource start
AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Small delay to ensure server is ready
    Wait(1000)
    TriggerServerEvent('ammo_system:server:requestStateSync')
end)

-- ============================================
-- DEBUG COMMANDS (remove in production)
-- ============================================

if Config.Debug then
    RegisterCommand('ammostate', function()
        local weaponHash = GetEquippedWeapon()
        local weaponConfig = GetWeaponConfig(weaponHash)
        local ped = PlayerPedId()
        
        print('=== Current Ammo State ===')
        print(('Weapon Hash: %s'):format(weaponHash))
        
        if weaponConfig then
            print(('Weapon: %s'):format(weaponConfig.label))
            print(('Caliber: %s'):format(weaponConfig.caliber))
            print(('Capacity: %d'):format(weaponConfig.capacity))
            print(('Loaded Type: %s'):format(GetCurrentAmmoType(weaponHash) or 'none'))
            print(('Ammo Count: %d'):format(GetAmmoInPedWeapon(ped, weaponHash)))
        else
            print('Weapon not in ammo system')
        end
    end, false)
end

-- ============================================
-- EXPORTS
-- ============================================

exports('GetEquippedWeapon', GetEquippedWeapon)
exports('GetCurrentAmmoType', GetCurrentAmmoType)
exports('GetWeaponConfig', GetWeaponConfig)
exports('LoadAmmoIntoWeapon', LoadAmmoIntoWeapon)
