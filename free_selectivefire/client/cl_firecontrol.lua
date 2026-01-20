--[[
    SELECTIVE FIRE SYSTEM - FIRE CONTROL

    Core logic for managing weapon fire modes.
    Handles semi-auto, burst, and full-auto fire control.
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

-- Mode display names
local modeNames = {
    SEMI = 'Semi-Auto',
    BURST = 'Burst',
    FULL = 'Full-Auto',
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- Check if player has a specific weapon component
local function HasWeaponComponent(ped, weaponHash, componentHash)
    return HasPedGotWeaponComponent(ped, weaponHash, componentHash)
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
    return HasWeaponComponent(ped, weaponHash, componentHash)
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

    return true
end

-- Play mode change sound (subtle click)
local function PlayModeChangeSound()
    if not Config.PlaySound then return end
    PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', true)
end

-- Show brief notification
local function ShowModeNotification(weaponHash)
    local config = Config.Weapons[weaponHash]
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
local function HandleSemiAuto(ped, weaponHash)
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
local function HandleBurstFire(ped, weaponHash)
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

-- Handle full-automatic fire
local function HandleFullAuto(ped, weaponHash)
    isTriggerHeld = IsControlPressed(0, 24)
end

-- Track shots fired
local lastAmmoCount = 0
local function TrackShotsFired(ped, weaponHash)
    local _, currentAmmo = GetAmmoInClip(ped, weaponHash)

    if currentAmmo < lastAmmoCount then
        shotsFiredThisTrigger = shotsFiredThisTrigger + 1
        if isInBurst then
            burstShotsRemaining = burstShotsRemaining - 1
        end
    end

    lastAmmoCount = currentAmmo
end

-- ============================================================================
-- MAIN CONTROL THREAD
-- ============================================================================

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = PlayerPedId()
        local weaponHash = GetSelectedPedWeapon(ped)

        -- Check if weapon changed
        if weaponHash ~= currentWeapon then
            currentWeapon = weaponHash
            lastAmmoCount = 0
            shotsFiredThisTrigger = 0
            isTriggerHeld = false
            isInBurst = false

            -- Restore remembered mode or use default
            if Config.RememberMode and weaponModes[weaponHash] then
                currentMode = weaponModes[weaponHash]
            else
                currentMode = GetDefaultMode(weaponHash)
            end

            -- Validate mode is available
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

        -- Apply fire control if weapon is configured
        local config = Config.Weapons[weaponHash]
        if config then
            TrackShotsFired(ped, weaponHash)

            if currentMode == 'SEMI' then
                HandleSemiAuto(ped, weaponHash)
            elseif currentMode == 'BURST' then
                HandleBurstFire(ped, weaponHash)
            elseif currentMode == 'FULL' then
                HandleFullAuto(ped, weaponHash)
            end
        end
    end
end)

-- ============================================================================
-- TOGGLE KEY HANDLER
-- ============================================================================

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = PlayerPedId()
        local weaponHash = GetSelectedPedWeapon(ped)

        if IsControlJustPressed(0, Config.ToggleKeyCode) then
            local currentTime = GetGameTimer()

            if currentTime - lastToggleTime > 200 then
                lastToggleTime = currentTime

                local config = Config.Weapons[weaponHash]
                if config then
                    local modes = GetEffectiveModes(ped, weaponHash)

                    if #modes > 1 then
                        if CycleFireMode(ped, weaponHash) then
                            PlayModeChangeSound()
                            ShowModeNotification(weaponHash)

                            -- Reset fire control state
                            isTriggerHeld = false
                            isInBurst = false
                            burstShotsRemaining = 0
                            shotsFiredThisTrigger = 0
                        end
                    end
                end
            end
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
    return #GetEffectiveModes(PlayerPedId(), weaponHash) > 1
end)

exports('SetFireMode', function(mode)
    local ped = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(ped)
    local modes = GetEffectiveModes(ped, weaponHash)

    for _, availableMode in ipairs(modes) do
        if availableMode == mode then
            currentMode = mode
            if Config.RememberMode then
                weaponModes[weaponHash] = currentMode
            end
            return true
        end
    end
    return false
end)

exports('GetAvailableModes', function()
    return GetEffectiveModes(PlayerPedId(), currentWeapon)
end)
