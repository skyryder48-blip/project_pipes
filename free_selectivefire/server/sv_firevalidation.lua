--[[
    SELECTIVE FIRE SYSTEM - SERVER VALIDATION (Optimized)

    Lightweight server-side fire rate validation.
    Uses event-driven architecture with minimal memory footprint.

    Performance characteristics:
    - No polling/ticks - purely event-driven
    - O(1) lookups using hash tables
    - Limited memory: only tracks active players with weapons
    - Automatic cleanup on player disconnect
]]

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local ValidationConfig = {
    -- Minimum time between shots for semi-auto (ms)
    SemiAutoMinInterval = 180,      -- Slightly lower than client (200ms) for latency

    -- Burst validation
    BurstMaxShots = 4,              -- Allow 4 to account for timing variance
    BurstWindow = 400,              -- Window to count burst shots (ms)

    -- Anomaly thresholds
    ViolationThreshold = 5,         -- Violations before logging
    ViolationDecay = 15000,         -- Reset violations after this time (ms)

    -- Feature toggles
    EnableValidation = true,
    EnableLogging = true,
    EnableKick = false,             -- Set true only for strict enforcement
    KickThreshold = 15,
}

-- ============================================================================
-- PLAYER STATE (Minimal Memory)
-- ============================================================================

local playerStates = {}

-- Lightweight state structure
local function GetState(source)
    if not playerStates[source] then
        playerStates[source] = {
            mode = 'SEMI',
            weapon = nil,
            lastShot = 0,
            recentShots = {},       -- Circular buffer of last 5 shot times
            shotIndex = 1,
            violations = 0,
            lastViolation = 0,
        }
    end
    return playerStates[source]
end

-- Cleanup on disconnect
AddEventHandler('playerDropped', function()
    playerStates[source] = nil
end)

-- ============================================================================
-- VALIDATION LOGIC (Optimized)
-- ============================================================================

local function ValidateShot(source, mode)
    if not ValidationConfig.EnableValidation then return true end

    local state = GetState(source)
    local now = GetGameTimer()

    -- Decay violations over time
    if (now - state.lastViolation) > ValidationConfig.ViolationDecay then
        state.violations = 0
    end

    -- Record shot time in circular buffer
    state.recentShots[state.shotIndex] = now
    state.shotIndex = (state.shotIndex % 5) + 1

    local isValid = true

    if mode == 'SEMI' then
        -- Check interval from previous shot
        local prevIndex = state.shotIndex - 2
        if prevIndex < 1 then prevIndex = prevIndex + 5 end
        local prevShot = state.recentShots[prevIndex]

        if prevShot and (now - prevShot) < ValidationConfig.SemiAutoMinInterval then
            isValid = false
        end

    elseif mode == 'BURST' then
        -- Count shots in burst window
        local count = 0
        for i = 1, 5 do
            local t = state.recentShots[i]
            if t and (now - t) < ValidationConfig.BurstWindow then
                count = count + 1
            end
        end
        if count > ValidationConfig.BurstMaxShots then
            isValid = false
        end
    end
    -- FULL mode: no restrictions

    -- Handle violation
    if not isValid then
        state.violations = state.violations + 1
        state.lastViolation = now

        if state.violations >= ValidationConfig.ViolationThreshold then
            if ValidationConfig.EnableLogging then
                local name = GetPlayerName(source) or 'Unknown'
                print(('[SelectiveFire] WARN: %s (%d) - Rapid fire detected (mode: %s, violations: %d)'):format(
                    name, source, mode, state.violations
                ))
            end

            if ValidationConfig.EnableKick and state.violations >= ValidationConfig.KickThreshold then
                DropPlayer(source, 'Fire rate anomaly')
            end
        end
    end

    state.lastShot = now
    return isValid
end

-- ============================================================================
-- EVENT HANDLERS
-- ============================================================================

RegisterNetEvent('selectivefire:modeChanged', function(weaponHash, mode)
    local state = GetState(source)
    state.mode = mode
    state.weapon = weaponHash
    -- Clear shot history on mode change
    state.recentShots = {}
    state.shotIndex = 1
end)

RegisterNetEvent('selectivefire:shotFired', function(weaponHash, mode)
    ValidateShot(source, mode)
end)

-- ============================================================================
-- ADMIN COMMANDS (Console only)
-- ============================================================================

RegisterCommand('sf_check', function(src, args)
    if src ~= 0 then return end

    local target = tonumber(args[1])
    if not target then
        print('Usage: sf_check <playerId>')
        return
    end

    local state = playerStates[target]
    if not state then
        print('No state for player ' .. target)
        return
    end

    print(('[SelectiveFire] Player %d: mode=%s, violations=%d'):format(
        target, state.mode, state.violations
    ))
end, true)

RegisterCommand('sf_reset', function(src, args)
    if src ~= 0 then return end

    local target = tonumber(args[1])
    if target and playerStates[target] then
        playerStates[target].violations = 0
        playerStates[target].recentShots = {}
        print('Reset state for player ' .. target)
    end
end, true)

-- ============================================================================
-- EXPORTS
-- ============================================================================

exports('GetViolations', function(playerId)
    local state = playerStates[playerId]
    return state and state.violations or 0
end)

exports('ResetViolations', function(playerId)
    if playerStates[playerId] then
        playerStates[playerId].violations = 0
        return true
    end
    return false
end)

-- ============================================================================
-- INIT
-- ============================================================================

if ValidationConfig.EnableValidation then
    print('[SelectiveFire] Server validation active (logging: ' ..
        (ValidationConfig.EnableLogging and 'on' or 'off') .. ')')
end
