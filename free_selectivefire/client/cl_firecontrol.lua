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
        -- Only one mode available, can't cycle
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

-- Play mode change sound
local function PlayModeChangeSound()
    if not Config.PlaySound then return end
    PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
end

-- ============================================================================
-- FIRE CONTROL LOGIC
-- ============================================================================

-- Handle semi-automatic fire
local function HandleSemiAuto(ped, weaponHash)
    local currentTime = GetGameTimer()

    -- Check if trigger is being held
    if IsControlPressed(0, 24) then -- INPUT_ATTACK
        if not isTriggerHeld then
            -- First press - allow shot
            isTriggerHeld = true
            shotsFiredThisTrigger = 0
        end

        -- Only allow one shot per trigger pull
        if shotsFiredThisTrigger > 0 then
            -- Block additional shots
            DisableControlAction(0, 24, true)  -- Disable attack
            DisableControlAction(0, 257, true) -- Disable attack 2
        end
    else
        -- Trigger released
        isTriggerHeld = false
        shotsFiredThisTrigger = 0
    end
end

-- Handle burst fire
local function HandleBurstFire(ped, weaponHash)
    local currentTime = GetGameTimer()
    local burstCount = GetBurstCount(weaponHash)

    if IsControlPressed(0, 24) then -- INPUT_ATTACK
        if not isTriggerHeld then
            -- First press - start new burst
            isTriggerHeld = true
            isInBurst = true
            burstShotsRemaining = burstCount
            shotsFiredThisTrigger = 0
        end

        if isInBurst then
            if burstShotsRemaining > 0 then
                -- Allow shots within burst
                if shotsFiredThisTrigger >= burstCount then
                    -- Burst complete, block firing
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 257, true)
                    isInBurst = false

                    -- Start burst delay
                    lastShotTime = currentTime
                end
            else
                -- Burst complete, check delay
                if currentTime - lastShotTime < Config.BurstDelay then
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 257, true)
                end
            end
        else
            -- Check if burst delay has passed
            if currentTime - lastShotTime < Config.BurstDelay then
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 257, true)
            else
                -- Allow new burst
                isInBurst = true
                burstShotsRemaining = burstCount
                shotsFiredThisTrigger = 0
            end
        end
    else
        -- Trigger released
        isTriggerHeld = false
        isInBurst = false
        burstShotsRemaining = 0
    end
end

-- Handle full-automatic fire (no restrictions)
local function HandleFullAuto(ped, weaponHash)
    -- Full auto has no fire control restrictions
    -- Weapon fires at its natural rate
    isTriggerHeld = IsControlPressed(0, 24)
end

-- Track shots fired
local lastAmmoCount = 0
local function TrackShotsFired(ped, weaponHash)
    local _, currentAmmo = GetAmmoInClip(ped, weaponHash)

    if currentAmmo < lastAmmoCount then
        -- Shot was fired
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

        -- Check if this weapon has fire control
        local config = Config.Weapons[weaponHash]
        if config then
            -- Track shots for burst/semi modes
            TrackShotsFired(ped, weaponHash)

            -- Apply fire mode control
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

        -- Check for toggle key press
        if IsControlJustPressed(0, Config.ToggleKeyCode) then
            local currentTime = GetGameTimer()

            -- Debounce
            if currentTime - lastToggleTime > 200 then
                lastToggleTime = currentTime

                local config = Config.Weapons[weaponHash]
                if config then
                    local modes = GetEffectiveModes(ped, weaponHash)

                    if #modes > 1 then
                        if CycleFireMode(ped, weaponHash) then
                            PlayModeChangeSound()

                            -- Reset fire control state
                            isTriggerHeld = false
                            isInBurst = false
                            burstShotsRemaining = 0
                            shotsFiredThisTrigger = 0

                            -- Trigger HUD update event
                            TriggerEvent('selectivefire:modeChanged', currentMode, weaponHash)
                        end
                    else
                        -- Notify player weapon doesn't have select fire
                        TriggerEvent('selectivefire:noSelectFire', weaponHash)
                    end
                end
            end
        end
    end
end)

-- ============================================================================
-- EXPORTS
-- ============================================================================

-- Export current fire mode
exports('GetCurrentFireMode', function()
    return currentMode
end)

-- Export current weapon
exports('GetCurrentWeapon', function()
    return currentWeapon
end)

-- Export to check if weapon has select fire
exports('HasSelectFire', function(weaponHash)
    weaponHash = weaponHash or currentWeapon
    local config = Config.Weapons[weaponHash]
    if not config then return false end

    local modes = GetEffectiveModes(PlayerPedId(), weaponHash)
    return #modes > 1
end)

-- Export to set fire mode programmatically
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
            TriggerEvent('selectivefire:modeChanged', currentMode, weaponHash)
            return true
        end
    end

    return false
end)

-- Export available modes for current weapon
exports('GetAvailableModes', function()
    local ped = PlayerPedId()
    return GetEffectiveModes(ped, currentWeapon)
end)

-- ============================================================================
-- EVENTS
-- ============================================================================

-- Event when mode changes (for HUD and other systems)
RegisterNetEvent('selectivefire:modeChanged')
AddEventHandler('selectivefire:modeChanged', function(mode, weaponHash)
    -- Other scripts can listen to this event
end)

-- Event when player tries to toggle on non-select-fire weapon
RegisterNetEvent('selectivefire:noSelectFire')
AddEventHandler('selectivefire:noSelectFire', function(weaponHash)
    -- Could show notification here
    -- For now, just a subtle audio cue
    if Config.PlaySound then
        PlaySoundFrontend(-1, 'ERROR', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
    end
end)
