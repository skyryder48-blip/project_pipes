--[[
    Client-Side Ammunition System (Unified)
    ========================================

    MERGED SYSTEM: Works with magazine_client.lua

    This file provides:
    - Helper functions for component name generation
    - Weapon info lookups
    - joaat hash function

    IMPORTANT: Direct ammo loading is DISABLED.
    All ammunition must be loaded via the magazine system.
    See magazine_client.lua for weapon loading operations.
]]

-- ============================================
-- JOAAT HASH FUNCTION
-- ============================================

-- Standard joaat hash (matches GTA's GetHashKey)
function joaat(s)
    local hash = 0
    s = string.lower(s)
    for i = 1, #s do
        hash = hash + string.byte(s, i)
        hash = hash + (hash << 10)
        hash = hash ~ (hash >> 6)
    end
    hash = hash + (hash << 3)
    hash = hash ~ (hash >> 11)
    hash = hash + (hash << 15)

    -- Convert to signed 32-bit integer
    if hash >= 2147483648 then
        hash = hash - 4294967296
    end

    return hash
end

-- ============================================
-- WEAPON INFO HELPERS
-- ============================================

-- Get weapon info from Config.Weapons
function GetWeaponInfo(weaponHash)
    return Config.Weapons[weaponHash]
end

-- Check if weapon is supported by the ammo system
function IsWeaponSupported(weaponHash)
    return Config.Weapons[weaponHash] ~= nil
end

-- Get the currently equipped weapon hash
function GetEquippedWeapon()
    local ped = PlayerPedId()
    return GetSelectedPedWeapon(ped)
end

-- ============================================
-- COMPONENT NAME HELPERS
-- ============================================

--[[
    Get component name for a weapon + ammo type combination
    Uses STANDARD clip suffix (_CLIP_)

    @param weaponHash - The weapon hash
    @param ammoType - The ammo type (e.g., 'fmj', 'hp', 'ap')
    @return string - Component name (e.g., 'COMPONENT_G17_CLIP_FMJ')
]]
function GetComponentName(weaponHash, ammoType)
    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo then return nil end

    local caliber = weaponInfo.caliber
    local ammoConfig = Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][ammoType]
    if not ammoConfig then return nil end

    -- Standard clip component: COMPONENT_G17_CLIP_FMJ
    return weaponInfo.componentBase .. ammoConfig.componentSuffix
end

--[[
    Get ALL component names for a weapon (all ammo types)
    Returns standard clip variants only

    @param weaponHash - The weapon hash
    @return table - { ammoType = componentName, ... }
]]
function GetAllComponentNames(weaponHash)
    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo then return {} end

    local caliber = weaponInfo.caliber
    local ammoTypes = Config.AmmoTypes[caliber]
    if not ammoTypes then return {} end

    local components = {}
    for ammoType, ammoConfig in pairs(ammoTypes) do
        components[ammoType] = weaponInfo.componentBase .. ammoConfig.componentSuffix
    end

    return components
end

--[[
    Build a component name from parts
    Supports standard (_CLIP_), extended (_EXTCLIP_), and drum (_DRUM_)

    @param weaponHash - The weapon hash
    @param magazineSuffix - Magazine suffix (e.g., '_CLIP_', '_EXTCLIP_', '_DRUM_')
    @param ammoType - The ammo type (e.g., 'fmj', 'hp')
    @return string - Component name (e.g., 'COMPONENT_G17_DRUM_HP')

    NOTE: For magazine-based lookups, use GetMagazineComponentName() from magazines.lua
]]
function BuildComponentName(weaponHash, magazineSuffix, ammoType)
    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo then return nil end

    -- Build: COMPONENT_G17 + _DRUM_ + HP = COMPONENT_G17_DRUM_HP
    return weaponInfo.componentBase .. magazineSuffix .. string.upper(ammoType)
end

--[[
    Remove ALL clip components from a weapon
    Handles standard, extended, and drum variants for all ammo types

    @param weaponHash - The weapon hash
]]
function RemoveAllClipComponents(weaponHash)
    local ped = PlayerPedId()
    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo then return end

    local caliber = weaponInfo.caliber
    local ammoTypes = Config.AmmoTypes[caliber]
    if not ammoTypes then return end

    -- Remove all possible clip components for this weapon
    for ammoType, _ in pairs(ammoTypes) do
        -- Try standard, extended, drum, stick, and clip2 variants
        for _, suffix in ipairs({ '_CLIP_', '_EXTCLIP_', '_DRUM_', '_STICK_', '_CLIP2_' }) do
            local componentName = weaponInfo.componentBase .. suffix .. string.upper(ammoType)
            local componentHash = GetHashKey(componentName)
            if HasPedGotWeaponComponent(ped, weaponHash, componentHash) then
                RemoveWeaponComponentFromPed(ped, weaponHash, componentHash)
                if Config.Debug then
                    print(('[AMMO] Removed component: %s'):format(componentName))
                end
            end
        end
    end
end

--[[
    Apply a clip component to a weapon

    @param weaponHash - The weapon hash
    @param componentName - Full component name (e.g., 'COMPONENT_G17_DRUM_HP')
    @param ammoCount - Number of rounds to set
]]
function ApplyClipComponent(weaponHash, componentName, ammoCount)
    local ped = PlayerPedId()

    -- Remove existing clips first
    RemoveAllClipComponents(weaponHash)

    -- Apply new component
    local componentHash = GetHashKey(componentName)
    GiveWeaponComponentToPed(ped, weaponHash, componentHash)

    -- Set ammo count
    if ammoCount and ammoCount > 0 then
        SetPedAmmo(ped, weaponHash, ammoCount)
    end

    if Config.Debug then
        print(('[AMMO] Applied component: %s with %d rounds'):format(componentName, ammoCount or 0))
    end
end

-- ============================================
-- DEBUG COMMANDS
-- ============================================

if Config.Debug then
    RegisterCommand('ammostate', function()
        local weaponHash = GetEquippedWeapon()
        local weaponInfo = GetWeaponInfo(weaponHash)
        local ped = PlayerPedId()

        print('=== Current Weapon State ===')
        print(('Weapon Hash: %s'):format(weaponHash))

        if weaponInfo then
            print(('Caliber: %s'):format(weaponInfo.caliber))
            print(('Base Capacity: %d'):format(weaponInfo.clipSize))
            print(('Component Base: %s'):format(weaponInfo.componentBase))
            print(('Current Ammo: %d'):format(GetAmmoInPedWeapon(ped, weaponHash)))

            print('Checking components:')
            local ammoTypes = Config.AmmoTypes[weaponInfo.caliber] or {}
            for ammoType, _ in pairs(ammoTypes) do
                for _, suffix in ipairs({ '_CLIP_', '_EXTCLIP_', '_DRUM_', '_STICK_', '_CLIP2_' }) do
                    local componentName = weaponInfo.componentBase .. suffix .. string.upper(ammoType)
                    local hasIt = HasPedGotWeaponComponent(ped, weaponHash, GetHashKey(componentName))
                    if hasIt then
                        print(('  [EQUIPPED] %s'):format(componentName))
                    end
                end
            end
        else
            print('Weapon not in ammo system')
        end
    end, false)
end

-- ============================================
-- EXPORTS
-- ============================================

exports('joaat', joaat)
exports('GetWeaponInfo', GetWeaponInfo)
exports('IsWeaponSupported', IsWeaponSupported)
exports('GetEquippedWeapon', GetEquippedWeapon)
exports('GetComponentName', GetComponentName)
exports('GetAllComponentNames', GetAllComponentNames)
exports('BuildComponentName', BuildComponentName)
exports('RemoveAllClipComponents', RemoveAllClipComponents)
exports('ApplyClipComponent', ApplyClipComponent)
