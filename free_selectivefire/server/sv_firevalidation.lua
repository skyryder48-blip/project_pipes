--[[
    SELECTIVE FIRE SYSTEM - SERVER VALIDATION

    Server-side fire rate validation to detect anomalous fire patterns.
    This provides anti-cheat protection while respecting client authority
    for immediate fire control feedback.

    Features:
    - Tracks player fire modes and shot timing
    - Detects suspicious fire rates for semi-auto weapons
    - Logs anomalies for admin review
    - Configurable thresholds to avoid false positives
]]

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local ValidationConfig = {
    -- Minimum time between shots for semi-auto (ms)
    -- Slightly lower than client to account for latency
    SemiAutoMinInterval = 200,

    -- Burst validation: max shots in burst period
    BurstMaxShots = 4,              -- Allow 4 to account for timing variance
    BurstPeriod = 400,              -- Window to count burst shots (ms)

    -- Anomaly detection thresholds
    MaxViolationsBeforeLog = 3,     -- Violations before logging
    ViolationResetTime = 10000,     -- Reset violations after this time (ms)

    -- Enable/disable validation features
    EnableValidation = true,
    EnableLogging = true,
    EnableKick = false,             -- DANGER: Set true only for strict servers
    KickThreshold = 10,             -- Violations before kick (if enabled)
}

-- ============================================================================
-- PLAYER STATE TRACKING
-- ============================================================================

local playerStates = {}

-- Initialize player state
local function InitPlayerState(source)
    playerStates[source] = {
        currentMode = 'SEMI',
        currentWeapon = nil,
        lastShotTime = 0,
        shotTimes = {},             -- Ring buffer of recent shot times
        violations = 0,
        lastViolationTime = 0,
    }
end

-- Clean up player state on disconnect
AddEventHandler('playerDropped', function(reason)
    local source = source
    playerStates[source] = nil
end)

-- ============================================================================
-- VALIDATION LOGIC
-- ============================================================================

-- Check if fire rate is valid for current mode
local function ValidateFireRate(source, weaponHash, mode)
    local state = playerStates[source]
    if not state then
        InitPlayerState(source)
        state = playerStates[source]
    end

    local currentTime = GetGameTimer()

    -- Reset violations if enough time has passed
    if (currentTime - state.lastViolationTime) > ValidationConfig.ViolationResetTime then
        state.violations = 0
    end

    -- Add current shot time to buffer
    table.insert(state.shotTimes, currentTime)

    -- Keep only recent shots (last second)
    local recentShots = {}
    for _, shotTime in ipairs(state.shotTimes) do
        if (currentTime - shotTime) < 1000 then
            table.insert(recentShots, shotTime)
        end
    end
    state.shotTimes = recentShots

    -- Validate based on mode
    local isValid = true
    local violationType = nil

    if mode == 'SEMI' then
        -- Check interval between last two shots
        if #state.shotTimes >= 2 then
            local interval = state.shotTimes[#state.shotTimes] - state.shotTimes[#state.shotTimes - 1]
            if interval < ValidationConfig.SemiAutoMinInterval then
                isValid = false
                violationType = 'SEMI_RAPID_FIRE'
            end
        end
    elseif mode == 'BURST' then
        -- Count shots in burst window
        local burstShots = 0
        for _, shotTime in ipairs(state.shotTimes) do
            if (currentTime - shotTime) < ValidationConfig.BurstPeriod then
                burstShots = burstShots + 1
            end
        end
        if burstShots > ValidationConfig.BurstMaxShots then
            isValid = false
            violationType = 'BURST_OVERFLOW'
        end
    end
    -- FULL mode has no restrictions

    -- Handle violations
    if not isValid then
        state.violations = state.violations + 1
        state.lastViolationTime = currentTime

        if state.violations >= ValidationConfig.MaxViolationsBeforeLog then
            if ValidationConfig.EnableLogging then
                local playerName = GetPlayerName(source) or 'Unknown'
                print(string.format(
                    '[SelectiveFire] WARNING: Player %s (%d) - %s violation #%d (mode: %s, weapon: %s)',
                    playerName,
                    source,
                    violationType,
                    state.violations,
                    mode,
                    weaponHash
                ))
            end
        end

        -- Kick if enabled and threshold reached
        if ValidationConfig.EnableKick and state.violations >= ValidationConfig.KickThreshold then
            DropPlayer(source, 'Fire rate anomaly detected')
        end
    end

    state.lastShotTime = currentTime
    return isValid
end

-- ============================================================================
-- EVENT HANDLERS
-- ============================================================================

-- Player changed fire mode
RegisterNetEvent('selectivefire:modeChanged')
AddEventHandler('selectivefire:modeChanged', function(weaponHash, mode)
    local source = source
    if not playerStates[source] then
        InitPlayerState(source)
    end

    playerStates[source].currentMode = mode
    playerStates[source].currentWeapon = weaponHash
    -- Reset shot tracking on mode change
    playerStates[source].shotTimes = {}
end)

-- Player fired a shot
RegisterNetEvent('selectivefire:shotFired')
AddEventHandler('selectivefire:shotFired', function(weaponHash, mode)
    local source = source

    if not ValidationConfig.EnableValidation then
        return
    end

    if not playerStates[source] then
        InitPlayerState(source)
    end

    -- Update current state
    playerStates[source].currentWeapon = weaponHash
    playerStates[source].currentMode = mode

    -- Validate fire rate
    ValidateFireRate(source, weaponHash, mode)
end)

-- ============================================================================
-- ADMIN COMMANDS
-- ============================================================================

-- Command to check player fire state (admin only)
RegisterCommand('checkfirestate', function(source, args, rawCommand)
    -- Server console or admin check
    if source ~= 0 then
        -- Add your admin permission check here
        -- For now, only server console can use this
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        print('Usage: checkfirestate <playerId>')
        return
    end

    local state = playerStates[targetId]
    if not state then
        print('No state found for player ' .. targetId)
        return
    end

    local playerName = GetPlayerName(targetId) or 'Unknown'
    print(string.format(
        '[SelectiveFire] Player %s (%d):\n  Mode: %s\n  Weapon: %s\n  Violations: %d\n  Recent Shots: %d',
        playerName,
        targetId,
        state.currentMode or 'N/A',
        state.currentWeapon or 'N/A',
        state.violations or 0,
        #state.shotTimes
    ))
end, true)

-- Command to reset player violations (admin only)
RegisterCommand('resetfireviolations', function(source, args, rawCommand)
    if source ~= 0 then
        return
    end

    local targetId = tonumber(args[1])
    if not targetId then
        print('Usage: resetfireviolations <playerId>')
        return
    end

    if playerStates[targetId] then
        playerStates[targetId].violations = 0
        playerStates[targetId].shotTimes = {}
        print('Reset fire violations for player ' .. targetId)
    else
        print('No state found for player ' .. targetId)
    end
end, true)

-- ============================================================================
-- EXPORTS
-- ============================================================================

exports('GetPlayerFireState', function(playerId)
    return playerStates[playerId]
end)

exports('GetPlayerViolations', function(playerId)
    local state = playerStates[playerId]
    if state then
        return state.violations
    end
    return 0
end)

exports('ResetPlayerViolations', function(playerId)
    if playerStates[playerId] then
        playerStates[playerId].violations = 0
        return true
    end
    return false
end)

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

print('[SelectiveFire] Server validation loaded - Validation: ' ..
    (ValidationConfig.EnableValidation and 'ENABLED' or 'DISABLED') ..
    ', Logging: ' .. (ValidationConfig.EnableLogging and 'ENABLED' or 'DISABLED'))
