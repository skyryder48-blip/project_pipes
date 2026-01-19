--[[
    Client-Side Ammunition System
    Handles weapon component swapping and ammo state management
]]

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
-- COMPONENT HELPERS
-- ============================================

-- Get component hash from weapon and ammo type
local function GetComponentHash(weaponHash, ammoType)
    local componentName = GetComponentName(weaponHash, ammoType)
    if componentName then
        return joaat(componentName)
    end
    return nil
end

-- Remove all ammo type clips from a weapon
local function RemoveAllAmmoClips(ped, weaponHash)
    local allComponents = GetAllComponentNames(weaponHash)

    for ammoType, componentName in pairs(allComponents) do
        local componentHash = joaat(componentName)
        if HasPedGotWeaponComponent(ped, weaponHash, componentHash) then
            RemoveWeaponComponentFromPed(ped, weaponHash, componentHash)
            if Config.Debug then
                print(('[AMMO] Removed component %s (%s)'):format(componentName, ammoType))
            end
        end
    end
end

-- Add a specific ammo clip to a weapon
local function AddAmmoClip(ped, weaponHash, ammoType)
    local componentName = GetComponentName(weaponHash, ammoType)
    if not componentName then
        if Config.Debug then
            print(('[AMMO] ERROR: No component found for %s, type %s'):format(weaponHash, ammoType))
        end
        return false
    end

    local componentHash = joaat(componentName)
    GiveWeaponComponentToPed(ped, weaponHash, componentHash)
    SetCurrentAmmoType(weaponHash, ammoType)

    if Config.Debug then
        print(('[AMMO] Added component %s (%s)'):format(componentName, ammoType))
    end
    return true
end

-- ============================================
-- AMMO LOADING LOGIC
-- ============================================

-- Load ammo into currently equipped weapon
-- Returns: success (bool), oldAmmoType (string|nil), oldAmmoCount (int), error (string|nil), loadedCount (int)
function LoadAmmoIntoWeapon(caliber, ammoType, ammoCount)
    local ped = PlayerPedId()
    local weaponHash = GetEquippedWeapon()

    -- Check if holding a valid weapon
    if weaponHash == `weapon_unarmed` then
        return false, nil, 0, 'no_weapon', 0
    end

    -- Check if weapon is in our system
    local weaponInfo = GetWeaponInfo(weaponHash)
    if not weaponInfo then
        return false, nil, 0, 'unknown_weapon', 0
    end

    -- Check if ammo caliber matches weapon
    if weaponInfo.caliber ~= caliber then
        return false, nil, 0, 'wrong_caliber', 0
    end

    -- Check if ammo type exists for this caliber
    if not Config.AmmoTypes[caliber] or not Config.AmmoTypes[caliber][ammoType] then
        return false, nil, 0, 'invalid_ammo_type', 0
    end

    -- Get current ammo state
    local currentType = GetCurrentAmmoType(weaponHash)
    local currentAmmoInWeapon = GetAmmoInPedWeapon(ped, weaponHash)

    -- Calculate how much ammo to load (capped at magazine capacity)
    local capacity = weaponInfo.clipSize
    local ammoToLoad = math.min(ammoCount, capacity)

    -- Store old ammo info for return to inventory
    local oldAmmoType = currentType
    local oldAmmoCount = currentAmmoInWeapon

    -- Play reload animation (optional)
    if Config.ReloadDelay and Config.ReloadDelay > 0 then
        -- Could trigger reload animation here
        Wait(Config.ReloadDelay)
    end

    -- Remove current ammo and clips
    if currentAmmoInWeapon > 0 then
        SetPedAmmo(ped, weaponHash, 0)
    end
    RemoveAllAmmoClips(ped, weaponHash)

    -- Add new clip component
    local componentAdded = AddAmmoClip(ped, weaponHash, ammoType)
    if not componentAdded then
        return false, oldAmmoType, oldAmmoCount, 'component_failed', 0
    end

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
    local success, oldType, oldCount, error, loadedCount = LoadAmmoIntoWeapon(caliber, ammoType, ammoCount)

    -- Report back to server
    TriggerServerEvent('ammo_system:server:loadAmmoResult', {
        success = success,
        error = error,
        oldAmmoType = oldType,
        oldAmmoCount = oldCount,
        loadedCount = loadedCount,
        caliber = caliber,
        newAmmoType = ammoType,
        weaponHash = GetEquippedWeapon()
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

-- Sync state from server
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

    Wait(1000)
    TriggerServerEvent('ammo_system:server:requestStateSync')
end)

-- ============================================
-- DEBUG COMMANDS
-- ============================================

if Config.Debug then
    RegisterCommand('ammostate', function()
        local weaponHash = GetEquippedWeapon()
        local weaponInfo = GetWeaponInfo(weaponHash)
        local ped = PlayerPedId()

        print('=== Current Ammo State ===')
        print(('Weapon Hash: %s'):format(weaponHash))

        if weaponInfo then
            print(('Caliber: %s'):format(weaponInfo.caliber))
            print(('Capacity: %d'):format(weaponInfo.clipSize))
            print(('Loaded Type: %s'):format(GetCurrentAmmoType(weaponHash) or 'none'))
            print(('Ammo Count: %d'):format(GetAmmoInPedWeapon(ped, weaponHash)))

            print('Components:')
            local allComponents = GetAllComponentNames(weaponHash)
            for ammoType, componentName in pairs(allComponents) do
                local hasIt = HasPedGotWeaponComponent(ped, weaponHash, joaat(componentName))
                print(('  %s: %s [%s]'):format(ammoType, componentName, hasIt and 'EQUIPPED' or 'not equipped'))
            end
        else
            print('Weapon not in ammo system')
        end
    end, false)

    RegisterCommand('testammo', function(source, args)
        local ammoType = args[1] or 'fmj'
        local success, oldType, oldCount, err, loaded = LoadAmmoIntoWeapon('9mm', ammoType, 50)
        print(('Test load result: success=%s, error=%s, loaded=%d'):format(tostring(success), err or 'none', loaded or 0))
    end, false)
end

-- ============================================
-- EXPORTS
-- ============================================

exports('GetEquippedWeapon', GetEquippedWeapon)
exports('GetCurrentAmmoType', GetCurrentAmmoType)
exports('LoadAmmoIntoWeapon', LoadAmmoIntoWeapon)
exports('IsWeaponSupported', IsWeaponSupported)
