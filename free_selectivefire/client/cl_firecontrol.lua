--[[
    SELECTIVE FIRE SYSTEM - FIRE CONTROL (Optimized)

    Core logic for managing weapon fire modes.
    Handles semi-auto, burst, and full-auto fire control.

    Performance optimizations:
    - Cached PlayerPedId() with timed refresh
    - Conditional waiting based on weapon state
    - Event-driven weapon detection where possible
    - Minimal native calls per frame

    Target: <0.1ms idle resource usage
]]

-- ============================================================================
-- LOCAL VARIABLES
-- ============================================================================

local currentWeapon = nil
local currentMode = 'SEMI'
local weaponModes = {}               -- Stores selected mode per weapon
local isInBurst = false
local burstShotsRemaining = 0
local lastShotTime = 0
local lastToggleTime = 0
local isTriggerHeld = false
local shotsFiredThisTrigger = 0

-- Performance: Cached values
local cachedPed = nil
local pedCacheTime = 0
local PED_CACHE_INTERVAL = 1000      -- Refresh ped every 1000ms (was 500ms)

-- Vehicle state
local isInVehicle = false
local vehicleCheckTime = 0
local VEHICLE_CHECK_INTERVAL = 500   -- Check vehicle every 500ms (was 250ms)

-- Control state - avoid repeated native calls
local isArmed = false                -- Has a configured weapon
local lastWeaponCheck = 0
local WEAPON_CHECK_INTERVAL = 100    -- Check weapon change every 100ms

-- Mode display names
local modeNames = {
    SEMI = 'Semi-Auto',
    BURST = 'Burst',
    FULL = 'Full-Auto',
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- Get cached player ped (refreshed periodically)
local function GetCachedPed()
    local currentTime = GetGameTimer()
    if not cachedPed or (currentTime - pedCacheTime) > PED_CACHE_INTERVAL then
        cachedPed = PlayerPedId()
        pedCacheTime = currentTime
    end
    return cachedPed
end

-- Check if player is in vehicle (cached)
local function CheckIsInVehicle(ped)
    local currentTime = GetGameTimer()
    if (currentTime - vehicleCheckTime) > VEHICLE_CHECK_INTERVAL then
        isInVehicle = IsPedInAnyVehicle(ped, false)
        vehicleCheckTime = currentTime
    end
    return isInVehicle
end

-- Check if weapon has modification component attached
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

-- Get the effective modes for current weapon state
local function GetEffectiveModes(ped, weaponHash)
    local config = Config.Weapons[weaponHash]
    if not config then
        return {'SEMI'}
    end

    -- Check for modification
    if config.modifiable and HasModificationAttached(ped, weaponHash) then
        return config.modesWhenModified or config.modes or {'SEMI'}
    end

    return config.modes or {'SEMI'}
end

-- Cycle to next fire mode
local function CycleFireMode(ped, weaponHash)
    local modes = GetEffectiveModes(ped, weaponHash)
    if #modes <= 1 then
        return false
    end

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
        weaponModes[weaponHash] = currentMode
    end

    -- Send to server for validation tracking
    TriggerServerEvent('selectivefire:modeChanged', weaponHash, currentMode)

    return true
end

-- Play mode change sound (subtle click)
local function PlayModeChangeSound()
    if not Config.PlaySound then return end
    PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', true)
end

-- Show brief notification
local function ShowModeNotification(weaponHash)
    local modeName = modeNames[currentMode] or currentMode

    -- Brief, subtle notification
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(modeName)
    EndTextCommandThefeedPostTicker(false, false)
end

-- ============================================================================
-- FIRE CONTROL LOGIC
-- ============================================================================

-- Handle semi-automatic fire
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

-- Handle burst fire
local function HandleBurstFire(weaponHash)
    local currentTime = GetGameTimer()
    local burstCount = GetBurstCount(weaponHash)

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

-- Handle full-automatic fire (no restrictions)
local function HandleFullAuto()
    isTriggerHeld = IsControlPressed(0, 24)
end

-- Track shots fired
local lastAmmoCount = 0
local function TrackShotsFired(ped, weaponHash)
    local _, currentAmmo = GetAmmoInClip(ped, weaponHash)

    if currentAmmo < lastAmmoCount then
        local shotsFired = lastAmmoCount - currentAmmo
        shotsFiredThisTrigger = shotsFiredThisTrigger + shotsFired
        if isInBurst then
            burstShotsRemaining = burstShotsRemaining - shotsFired
        end
        -- Notify server of shot for validation (batch if multiple)
        TriggerServerEvent('selectivefire:shotFired', weaponHash, currentMode)
    end

    lastAmmoCount = currentAmmo
end

-- ============================================================================
-- MAIN CONTROL THREAD
-- ============================================================================

Citizen.CreateThread(function()
    -- Initial cache
    cachedPed = PlayerPedId()
    pedCacheTime = GetGameTimer()

    while true do
        local currentTime = GetGameTimer()
        local ped = GetCachedPed()

        -- Check weapon at reduced frequency when idle
        local weaponHash = nil
        local config = nil

        if (currentTime - lastWeaponCheck) > WEAPON_CHECK_INTERVAL or isArmed then
            weaponHash = GetSelectedPedWeapon(ped)
            config = Config.Weapons[weaponHash]
            lastWeaponCheck = currentTime

            -- Check if weapon changed
            if weaponHash ~= currentWeapon then
                currentWeapon = weaponHash
                lastAmmoCount = 0
                shotsFiredThisTrigger = 0
                isTriggerHeld = false
                isInBurst = false
                isArmed = (config ~= nil)

                -- Restore remembered mode or use default
                if Config.RememberMode and weaponModes[weaponHash] then
                    currentMode = weaponModes[weaponHash]
                else
                    currentMode = GetDefaultMode(weaponHash)
                end

                -- Validate mode is available
                if config then
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
            end
        else
            -- Use cached values
            weaponHash = currentWeapon
            config = Config.Weapons[weaponHash]
        end

        -- Only process fire control if we have a configured weapon
        if config and isArmed then
            -- Check vehicle state
            local inVehicle = CheckIsInVehicle(ped)

            -- Track shots for both on-foot and vehicle
            TrackShotsFired(ped, weaponHash)

            -- Apply fire control based on current mode
            -- Note: Fire control works in vehicles but may have reduced effectiveness
            -- due to GTA's vehicle weapon control scheme
            if currentMode == 'SEMI' then
                HandleSemiAuto()
            elseif currentMode == 'BURST' then
                HandleBurstFire(weaponHash)
            elseif currentMode == 'FULL' then
                HandleFullAuto()
            end

            Citizen.Wait(0)  -- Full speed for fire control
        else
            -- No configured weapon - sleep longer to save resources
            Citizen.Wait(250)
        end
    end
end)

-- ============================================================================
-- TOGGLE KEY HANDLER (Separate thread for responsiveness)
-- ============================================================================

Citizen.CreateThread(function()
    while true do
        -- Only process if armed
        if isArmed and currentWeapon then
            local config = Config.Weapons[currentWeapon]

            if config and IsControlJustPressed(0, Config.ToggleKeyCode) then
                local currentTime = GetGameTimer()

                if currentTime - lastToggleTime > 200 then
                    lastToggleTime = currentTime

                    local ped = GetCachedPed()
                    local modes = GetEffectiveModes(ped, currentWeapon)

                    if #modes > 1 then
                        if CycleFireMode(ped, currentWeapon) then
                            PlayModeChangeSound()
                            ShowModeNotification(currentWeapon)

                            -- Reset fire control state
                            isTriggerHeld = false
                            isInBurst = false
                            burstShotsRemaining = 0
                            shotsFiredThisTrigger = 0
                        end
                    end
                end
            end
            Citizen.Wait(0)  -- Fast response for toggle key when armed
        else
            Citizen.Wait(250)  -- Slow tick when unarmed
        end
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

exports('HasSelectFire', function(weaponHash)
    weaponHash = weaponHash or currentWeapon
    local config = Config.Weapons[weaponHash]
    if not config then return false end
    return #GetEffectiveModes(GetCachedPed(), weaponHash) > 1
end)

exports('SetFireMode', function(mode)
    local ped = GetCachedPed()
    local weaponHash = GetSelectedPedWeapon(ped)
    local modes = GetEffectiveModes(ped, weaponHash)

    for _, availableMode in ipairs(modes) do
        if availableMode == mode then
            currentMode = mode
            if Config.RememberMode then
                weaponModes[weaponHash] = currentMode
            end
            TriggerServerEvent('selectivefire:modeChanged', weaponHash, currentMode)
            return true
        end
    end
    return false
end)

exports('GetAvailableModes', function()
    return GetEffectiveModes(GetCachedPed(), currentWeapon)
end)

exports('IsArmed', function()
    return isArmed
end)

exports('IsInVehicle', function()
    return isInVehicle
end)
