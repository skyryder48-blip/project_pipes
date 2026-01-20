--[[
    SELECTIVE FIRE SYSTEM - HUD INDICATOR

    Displays the current fire mode on screen when wielding
    a weapon with selective fire capability.
]]

-- ============================================================================
-- LOCAL VARIABLES
-- ============================================================================

local showHUD = false
local currentDisplayMode = 'SEMI'
local hudAlpha = 0
local targetAlpha = 0
local lastModeChangeTime = 0
local flashTimer = 0
local isFlashing = false

-- Mode display configuration
local modeDisplay = {
    SEMI = {
        text = 'SEMI',
        color = {r = 255, g = 255, b = 255},  -- White
        icon = '|',                            -- Single line
    },
    BURST = {
        text = 'BURST',
        color = {r = 255, g = 200, b = 50},   -- Orange/Yellow
        icon = '|||',                          -- Triple lines
    },
    FULL = {
        text = 'AUTO',
        color = {r = 255, g = 80, b = 80},    -- Red
        icon = '~',                            -- Wave (continuous)
    },
}

-- ============================================================================
-- DRAWING FUNCTIONS
-- ============================================================================

-- Draw text on screen
local function DrawText2D(x, y, text, scale, r, g, b, a, font, outline)
    SetTextFont(font or 4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Draw rectangle
local function DrawRect2D(x, y, width, height, r, g, b, a)
    DrawRect(x, y, width, height, r, g, b, a)
end

-- Draw the fire mode indicator
local function DrawFireModeIndicator()
    if not Config.ShowHUD then return end
    if hudAlpha <= 0 then return end

    local mode = modeDisplay[currentDisplayMode]
    if not mode then return end

    local x = Config.HUDPosition.x
    local y = Config.HUDPosition.y
    local alpha = math.floor(hudAlpha)

    -- Flash effect on mode change
    local flashAlpha = alpha
    if isFlashing and flashTimer > 0 then
        local flashIntensity = math.sin(flashTimer * 15) * 0.5 + 0.5
        flashAlpha = math.floor(alpha * (0.5 + flashIntensity * 0.5))
    end

    -- Background box
    local bgWidth = 0.045
    local bgHeight = 0.045
    local bgAlpha = math.floor(flashAlpha * 0.6)
    DrawRect2D(x, y, bgWidth, bgHeight, 0, 0, 0, bgAlpha)

    -- Border (subtle)
    local borderAlpha = math.floor(flashAlpha * 0.3)
    DrawRect2D(x, y - bgHeight/2 - 0.001, bgWidth + 0.002, 0.002, mode.color.r, mode.color.g, mode.color.b, borderAlpha)

    -- Mode text
    local textScale = 0.35
    DrawText2D(x, y - 0.012, mode.text, textScale, mode.color.r, mode.color.g, mode.color.b, flashAlpha, 4, true)

    -- Mode icon (visual indicator)
    local iconScale = 0.25
    DrawText2D(x, y + 0.005, mode.icon, iconScale, mode.color.r, mode.color.g, mode.color.b, math.floor(flashAlpha * 0.7), 4, true)
end

-- Draw extended info (weapon name, available modes)
local function DrawExtendedInfo()
    if not Config.ShowHUD then return end
    if hudAlpha <= 0 then return end

    -- Only show extended info briefly after mode change
    local timeSinceChange = GetGameTimer() - lastModeChangeTime
    if timeSinceChange > 2000 then return end

    local fadeAlpha = 1.0
    if timeSinceChange > 1500 then
        fadeAlpha = 1.0 - ((timeSinceChange - 1500) / 500)
    end

    local x = Config.HUDPosition.x
    local y = Config.HUDPosition.y + 0.035
    local alpha = math.floor(hudAlpha * fadeAlpha * 0.8)

    -- Get weapon info
    local weaponHash = exports['free_selectivefire']:GetCurrentWeapon()
    local config = Config.Weapons[weaponHash]
    if config and config.name then
        DrawText2D(x, y, config.name, 0.25, 200, 200, 200, alpha, 4, true)
    end
end

-- ============================================================================
-- HUD UPDATE THREAD
-- ============================================================================

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = PlayerPedId()
        local weaponHash = GetSelectedPedWeapon(ped)

        -- Check if current weapon has select fire
        local hasSelectFire = exports['free_selectivefire']:HasSelectFire(weaponHash)

        if hasSelectFire then
            showHUD = true
            targetAlpha = 255

            -- Get current mode from fire control
            currentDisplayMode = exports['free_selectivefire']:GetCurrentFireMode()
        else
            showHUD = false
            targetAlpha = 0
        end

        -- Smooth alpha transition
        if hudAlpha < targetAlpha then
            hudAlpha = math.min(hudAlpha + 15, targetAlpha)
        elseif hudAlpha > targetAlpha then
            hudAlpha = math.max(hudAlpha - 15, targetAlpha)
        end

        -- Update flash timer
        if isFlashing then
            flashTimer = flashTimer - 0.016  -- Approximate frame time
            if flashTimer <= 0 then
                isFlashing = false
                flashTimer = 0
            end
        end

        -- Draw HUD elements
        if hudAlpha > 0 then
            DrawFireModeIndicator()
            DrawExtendedInfo()
        end
    end
end)

-- ============================================================================
-- EVENT HANDLERS
-- ============================================================================

-- Listen for mode changes
AddEventHandler('selectivefire:modeChanged', function(mode, weaponHash)
    currentDisplayMode = mode
    lastModeChangeTime = GetGameTimer()

    -- Start flash effect
    isFlashing = true
    flashTimer = 0.5  -- Flash duration in seconds

    -- Show notification
    local modeName = modeDisplay[mode] and modeDisplay[mode].text or mode
    local config = Config.Weapons[weaponHash]
    local weaponName = config and config.name or 'Weapon'

    -- Subtle notification (can be disabled)
    -- BeginTextCommandThefeedPost('STRING')
    -- AddTextComponentSubstringPlayerName(weaponName .. ': ' .. modeName)
    -- EndTextCommandThefeedPostTicker(false, false)
end)

-- Listen for no select fire attempts
AddEventHandler('selectivefire:noSelectFire', function(weaponHash)
    -- Could flash a "no select fire" indicator here
    -- For now handled by sound in fire control
end)

-- ============================================================================
-- NUI ALTERNATIVE (Optional - for custom UI)
-- ============================================================================

--[[
    If you prefer a custom NUI-based HUD, you can use these events
    to communicate with your UI framework:

    TriggerEvent('selectivefire:updateUI', {
        mode = currentDisplayMode,
        weaponName = weaponName,
        availableModes = modes,
    })
]]

-- Export for custom UI integration
exports('GetHUDData', function()
    local weaponHash = exports['free_selectivefire']:GetCurrentWeapon()
    local config = Config.Weapons[weaponHash]

    return {
        mode = currentDisplayMode,
        weaponName = config and config.name or nil,
        availableModes = exports['free_selectivefire']:GetAvailableModes(),
        hasSelectFire = exports['free_selectivefire']:HasSelectFire(),
        isVisible = showHUD and hudAlpha > 0,
    }
end)
