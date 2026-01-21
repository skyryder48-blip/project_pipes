--[[
    SELECTIVE FIRE SYSTEM - FIRE CONTROL
    Integrated with ox_inventory and ox_lib

    Features:
    - ox_inventory currentWeapon event for weapon detection
    - ox_lib keybind for fire mode toggle
    - Death/respawn state reset
    - Character switch cleanup
    - Weapon removal detection

    Performance: <0.1ms idle, event-driven where possible
]]

-- ============================================================================
-- LOCAL VARIABLES
-- ============================================================================

local currentWeapon = nil
local currentWeaponHash = nil
local currentMode = 'SEMI'
local weaponModes = {}               -- Stores selected mode per weapon
local isInBurst = false
local burstShotsRemaining = 0
local lastShotTime = 0
local isTriggerHeld = false
local shotsFiredThisTrigger = 0

-- Performance: Cached values
local cachedPed = nil
local pedCacheTime = 0
local PED_CACHE_INTERVAL = 1000

-- State flags
local isArmed = false
local isAlive = true
local isLoggedIn = false

-- Mode display names
local modeNames = {
    SEMI = 'Semi-Auto',
    BURST = 'Burst',
    FULL = 'Full-Auto',
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function GetCachedPed()
    local currentTime = GetGameTimer()
    if not cachedPed or (currentTime - pedCacheTime) > PED_CACHE_INTERVAL then
        cachedPed = PlayerPedId()
        pedCacheTime = currentTime
    end
    return cachedPed
end

local function HasModificationAttached(ped, weaponHash)
    local config = Config.Weapons[weaponHash]
    if not config or not config.modifiable then
        return false
    end

    local componentName = config.modificationComponent
    if not componentName then
        return false
    end

    local componentHash = GetHashKey(componentName)
    return HasPedGotWeaponComponent(ped, weaponHash, componentHash)
end

local function GetEffectiveModes(ped, weaponHash)
    local config = Config.Weapons[weaponHash]
    if not config then
        return {'SEMI'}
    end

    if config.modifiable and HasModificationAttached(ped, weaponHash) then
        return config.modesWhenModified or config.modes or {'SEMI'}
    end

    return config.modes or {'SEMI'}
end

local function ResetFireState()
    isTriggerHeld = false
    isInBurst = false
    burstShotsRemaining = 0
    shotsFiredThisTrigger = 0
    lastShotTime = 0
end

local function ClearWeaponState()
    currentWeapon = nil
    currentWeaponHash = nil
    currentMode = 'SEMI'
    isArmed = false
    ResetFireState()
end

local function ClearAllState()
    ClearWeaponState()
    weaponModes = {}
    isAlive = true
end

-- ============================================================================
-- FIRE MODE TOGGLE (ox_lib keybind)
-- ============================================================================

local function CycleFireMode()
    if not isArmed or not currentWeaponHash then return end

    local ped = GetCachedPed()
    local modes = GetEffectiveModes(ped, currentWeaponHash)

    if #modes <= 1 then return end

    local currentIndex = 1
    for i, mode in ipairs(modes) do
        if mode == currentMode then
            currentIndex = i
            break
        end
    end

    local nextIndex = (currentIndex % #modes) + 1
    currentMode = modes[nextIndex]

    -- Store mode for this weapon
    if Config.RememberMode then
        weaponModes[currentWeaponHash] = currentMode
    end

    -- Notify server
    TriggerServerEvent('selectivefire:modeChanged', currentWeaponHash, currentMode)

    -- Play sound
    if Config.PlaySound then
        PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', true)
    end

    -- Show notification
    local modeName = modeNames[currentMode] or currentMode
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(modeName)
    EndTextCommandThefeedPostTicker(false, false)

    -- Reset fire state
    ResetFireState()
end

-- Register keybind with ox_lib
lib.addKeybind({
    name = 'selectivefire_toggle',
    description = 'Toggle Fire Mode',
    defaultKey = Config.ToggleKey or 'B',
    onPressed = function()
        if isArmed and isAlive then
            CycleFireMode()
        end
    end
})

-- ============================================================================
-- OX_INVENTORY WEAPON DETECTION
-- ============================================================================

AddEventHandler('ox_inventory:currentWeapon', function(weapon)
    if weapon then
        -- Weapon equipped
        local weaponHash = weapon.hash
        local config = Config.Weapons[weaponHash]

        currentWeapon = weapon
        currentWeaponHash = weaponHash
        isArmed = (config ~= nil)

        if config then
            -- Restore remembered mode or use default
            if Config.RememberMode and weaponModes[weaponHash] then
                currentMode = weaponModes[weaponHash]
            else
                currentMode = GetDefaultMode(weaponHash)
            end

            -- Validate mode is available
            local ped = GetCachedPed()
            local modes = GetEffectiveModes(ped, weaponHash)
            local modeValid = false
            for _, mode in ipairs(modes) do
                if mode == currentMode then
                    modeValid = true
                    break
                end
            end
            if not modeValid then
                currentMode = modes[1] or 'SEMI'
            end
        end

        ResetFireState()
    else
        -- Weapon holstered/removed
        ClearWeaponState()
    end
end)

-- ============================================================================
-- FIRE CONTROL LOGIC
-- ============================================================================

local function HandleSemiAuto()
    if IsControlPressed(0, 24) then
        if not isTriggerHeld then
            isTriggerHeld = true
            shotsFiredThisTrigger = 0
        end

        if shotsFiredThisTrigger > 0 then
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 257, true)
        end
    else
        isTriggerHeld = false
        shotsFiredThisTrigger = 0
    end
end

local function HandleBurstFire()
    local currentTime = GetGameTimer()
    local burstCount = GetBurstCount(currentWeaponHash)

    if IsControlPressed(0, 24) then
        if not isTriggerHeld then
            isTriggerHeld = true
            isInBurst = true
            burstShotsRemaining = burstCount
            shotsFiredThisTrigger = 0
        end

        if isInBurst then
            if burstShotsRemaining > 0 then
                if shotsFiredThisTrigger >= burstCount then
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 257, true)
                    isInBurst = false
                    lastShotTime = currentTime
                end
            else
                if currentTime - lastShotTime < Config.BurstDelay then
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 257, true)
                end
            end
        else
            if currentTime - lastShotTime < Config.BurstDelay then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 257, true)
            else
                isInBurst = true
                burstShotsRemaining = burstCount
                shotsFiredThisTrigger = 0
            end
        end
    else
        isTriggerHeld = false
        isInBurst = false
        burstShotsRemaining = 0
    end
end

local function HandleFullAuto()
    isTriggerHeld = IsControlPressed(0, 24)
end

-- Track shots fired
local lastAmmoCount = 0
local function TrackShotsFired()
    if not currentWeaponHash then return end

    local ped = GetCachedPed()
    local _, currentAmmo = GetAmmoInClip(ped, currentWeaponHash)

    if currentAmmo < lastAmmoCount then
        local shotsFired = lastAmmoCount - currentAmmo
        shotsFiredThisTrigger = shotsFiredThisTrigger + shotsFired
        if isInBurst then
            burstShotsRemaining = burstShotsRemaining - shotsFired
        end
        TriggerServerEvent('selectivefire:shotFired', currentWeaponHash, currentMode)
    end

    lastAmmoCount = currentAmmo
end

-- ============================================================================
-- MAIN FIRE CONTROL THREAD
-- ============================================================================

CreateThread(function()
    cachedPed = PlayerPedId()
    pedCacheTime = GetGameTimer()

    while true do
        if isArmed and isAlive and currentWeaponHash then
            TrackShotsFired()

            if currentMode == 'SEMI' then
                HandleSemiAuto()
            elseif currentMode == 'BURST' then
                HandleBurstFire()
            elseif currentMode == 'FULL' then
                HandleFullAuto()
            end

            Wait(0)
        else
            Wait(250)
        end
    end
end)

-- ============================================================================
-- DEATH / RESPAWN HANDLING
-- ============================================================================

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local isDead = args[4] == 1

        if victim == GetCachedPed() and isDead then
            isAlive = false
            ResetFireState()
            TriggerServerEvent('selectivefire:playerDied')
        end
    end
end)

-- Respawn detection
CreateThread(function()
    while true do
        Wait(1000)
        local ped = GetCachedPed()

        if not isAlive and not IsEntityDead(ped) then
            isAlive = true
            ResetFireState()
            TriggerServerEvent('selectivefire:playerRespawned')
        end
    end
end)

-- ============================================================================
-- CHARACTER SWITCH / LOGOUT CLEANUP
-- ============================================================================

-- Qbox
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    ClearAllState()
    isLoggedIn = false
    TriggerServerEvent('selectivefire:characterUnloaded')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    ClearAllState()
    isLoggedIn = true
end)

-- ox_core (if used)
RegisterNetEvent('ox:playerLoaded', function()
    ClearAllState()
    isLoggedIn = true
end)

RegisterNetEvent('ox:playerLogout', function()
    ClearAllState()
    isLoggedIn = false
    TriggerServerEvent('selectivefire:characterUnloaded')
end)

-- ============================================================================
-- RESOURCE CLEANUP
-- ============================================================================

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        ClearAllState()
    end
end)

-- ============================================================================
-- EXPORTS
-- ============================================================================

exports('GetCurrentFireMode', function()
    return currentMode
end)

exports('GetCurrentWeapon', function()
    return currentWeapon
end)

exports('GetCurrentWeaponHash', function()
    return currentWeaponHash
end)

exports('HasSelectFire', function(weaponHash)
    weaponHash = weaponHash or currentWeaponHash
    local config = Config.Weapons[weaponHash]
    if not config then return false end
    return #GetEffectiveModes(GetCachedPed(), weaponHash) > 1
end)

exports('SetFireMode', function(mode)
    if not currentWeaponHash then return false end

    local ped = GetCachedPed()
    local modes = GetEffectiveModes(ped, currentWeaponHash)

    for _, availableMode in ipairs(modes) do
        if availableMode == mode then
            currentMode = mode
            if Config.RememberMode then
                weaponModes[currentWeaponHash] = currentMode
            end
            TriggerServerEvent('selectivefire:modeChanged', currentWeaponHash, currentMode)
            return true
        end
    end
    return false
end)

exports('GetAvailableModes', function()
    return GetEffectiveModes(GetCachedPed(), currentWeaponHash)
end)

exports('IsArmed', function()
    return isArmed
end)

exports('IsAlive', function()
    return isAlive
end)
