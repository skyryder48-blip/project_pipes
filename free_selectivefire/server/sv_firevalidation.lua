--[[
    SELECTIVE FIRE SYSTEM - SERVER VALIDATION
    Integrated with ox_inventory and ox_lib

    Features:
    - Lightweight fire rate validation
    - Death/respawn state reset
    - Character switch cleanup
    - Event-driven architecture

    Performance: Purely event-driven, no ticks
]]

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local ValidationConfig = {
    -- Fire rate thresholds (ms)
    SemiAutoMinInterval = 180,
    BurstMaxShots = 4,
    BurstWindow = 400,

    -- Violation handling
    ViolationThreshold = 5,
    ViolationDecay = 15000,

    -- Features
    EnableValidation = true,
    EnableLogging = true,
    EnableKick = false,
    KickThreshold = 15,

    -- Cleanup
    ResetOnDeath = true,             -- Reset violations on death
    ResetOnCharacterSwitch = true,   -- Full wipe on character switch
}

-- ============================================================================
-- PLAYER STATE
-- ============================================================================

local playerStates = {}

local function GetState(source)
    if not playerStates[source] then
        playerStates[source] = {
            mode = 'SEMI',
            weapon = nil,
            lastShot = 0,
            recentShots = {},
            shotIndex = 1,
            violations = 0,
            lastViolation = 0,
        }
    end
    return playerStates[source]
end

local function ClearState(source)
    playerStates[source] = nil
end

local function ResetViolations(source)
    local state = playerStates[source]
    if state then
        state.violations = 0
        state.recentShots = {}
        state.shotIndex = 1
    end
end

-- ============================================================================
-- VALIDATION LOGIC
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
        local prevIndex = state.shotIndex - 2
        if prevIndex < 1 then prevIndex = prevIndex + 5 end
        local prevShot = state.recentShots[prevIndex]

        if prevShot and (now - prevShot) < ValidationConfig.SemiAutoMinInterval then
            isValid = false
        end

    elseif mode == 'BURST' then
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

    if not isValid then
        state.violations = state.violations + 1
        state.lastViolation = now

        if state.violations >= ValidationConfig.ViolationThreshold then
            if ValidationConfig.EnableLogging then
                local name = GetPlayerName(source) or 'Unknown'
                print(('[SelectiveFire] WARN: %s (%d) - Rapid fire (mode: %s, violations: %d)'):format(
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
-- FIRE MODE EVENTS
-- ============================================================================

RegisterNetEvent('selectivefire:modeChanged', function(weaponHash, mode)
    local state = GetState(source)
    state.mode = mode
    state.weapon = weaponHash
    state.recentShots = {}
    state.shotIndex = 1
end)

RegisterNetEvent('selectivefire:shotFired', function(weaponHash, mode)
    ValidateShot(source, mode)
end)

-- ============================================================================
-- DEATH / RESPAWN CLEANUP
-- ============================================================================

RegisterNetEvent('selectivefire:playerDied', function()
    if ValidationConfig.ResetOnDeath then
        ResetViolations(source)
    end
end)

RegisterNetEvent('selectivefire:playerRespawned', function()
    -- State already reset on death, just log if needed
end)

-- ============================================================================
-- CHARACTER SWITCH / LOGOUT CLEANUP
-- ============================================================================

RegisterNetEvent('selectivefire:characterUnloaded', function()
    if ValidationConfig.ResetOnCharacterSwitch then
        ClearState(source)
    end
end)

-- Qbox/QBCore server-side events
RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(source)
    if ValidationConfig.ResetOnCharacterSwitch then
        ClearState(source)
    end
end)

-- ox_core server-side events
RegisterNetEvent('ox:playerLogout', function(source)
    if ValidationConfig.ResetOnCharacterSwitch then
        ClearState(source)
    end
end)

-- ============================================================================
-- PLAYER DISCONNECT
-- ============================================================================

AddEventHandler('playerDropped', function()
    ClearState(source)
end)

-- ============================================================================
-- ADMIN COMMANDS
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
    if target then
        ResetViolations(target)
        print('Reset violations for player ' .. target)
    end
end, true)

RegisterCommand('sf_clear', function(src, args)
    if src ~= 0 then return end

    local target = tonumber(args[1])
    if target then
        ClearState(target)
        print('Cleared all state for player ' .. target)
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
    ResetViolations(playerId)
    return true
end)

exports('ClearState', function(playerId)
    ClearState(playerId)
    return true
end)

exports('GetPlayerFireMode', function(playerId)
    local state = playerStates[playerId]
    return state and state.mode or nil
end)

-- ============================================================================
-- INIT
-- ============================================================================

if ValidationConfig.EnableValidation then
    print('[SelectiveFire] Server validation active')
end
