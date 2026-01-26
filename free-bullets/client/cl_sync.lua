--[[
    StateBag Synchronization Handler
    =================================
    Syncs ammo type state between client and server
    Ensures other players see correct visual effects
]]

local cachedAmmoTypes = {}  -- { [weaponHash] = ammoType }

-- =============================================================================
-- LOCAL STATE MANAGEMENT
-- =============================================================================

--- Set the current ammo type for a weapon locally and sync to server
-- @param weaponHash number The weapon hash
-- @param ammoType string The ammo type (fmj, hp, ap, etc.)
local function SetAmmoType(weaponHash, ammoType)
    if not weaponHash or not ammoType then return end

    cachedAmmoTypes[weaponHash] = ammoType

    -- Update local StateBag
    local key = ('ammo_%s'):format(weaponHash)
    LocalPlayer.state:set(key, ammoType, true)  -- Replicated to server

    -- Notify server
    TriggerServerEvent('ammo:setAmmoType', weaponHash, ammoType)
end

--- Get the current ammo type for a weapon
-- @param weaponHash number The weapon hash
-- @return string The ammo type
local function GetAmmoType(weaponHash)
    if not weaponHash then return 'fmj' end

    -- Check cache first
    if cachedAmmoTypes[weaponHash] then
        return cachedAmmoTypes[weaponHash]
    end

    -- Check StateBag
    local key = ('ammo_%s'):format(weaponHash)
    local ammoType = LocalPlayer.state[key]

    if ammoType then
        cachedAmmoTypes[weaponHash] = ammoType
        return ammoType
    end

    -- Get default from weapon info
    local weaponInfo = Config.Weapons and Config.Weapons[weaponHash]
    if weaponInfo and weaponInfo.caliber then
        return GetDefaultAmmoType(weaponInfo.caliber)
    end

    return 'fmj'
end

-- =============================================================================
-- STATEBAG CHANGE HANDLERS
-- =============================================================================

-- Listen for ammo type changes from server
AddStateBagChangeHandler(nil, 'player', function(bagName, key, value, reserved, replicated)
    -- Only handle ammo_ prefixed keys
    if not key:match('^ammo_') then return end

    local playerId = GetPlayerFromStateBagName(bagName)
    if playerId == 0 then return end

    local weaponHash = tonumber(key:gsub('ammo_', ''))
    if not weaponHash then return end

    -- Update local cache if this is our state
    if playerId == PlayerId() then
        cachedAmmoTypes[weaponHash] = value
    end

    -- Other players can now see our ammo type for visual effect sync
    -- This is used by cl_effects.lua to render correct tracers/effects
end)

-- =============================================================================
-- MAGAZINE EQUIP INTEGRATION
-- =============================================================================

-- When a magazine is equipped, sync the ammo type
RegisterNetEvent('ammo:magazineEquipped', function(data)
    if data.weaponHash and data.ammoType then
        SetAmmoType(data.weaponHash, data.ammoType)
    end
end)

-- When ammo is changed via inventory or other means
RegisterNetEvent('ammo:ammoTypeChanged', function(weaponHash, ammoType)
    SetAmmoType(weaponHash, ammoType)
end)

-- =============================================================================
-- WEAPON CHANGE MONITORING
-- =============================================================================

local lastEquippedWeapon = nil

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` and weapon ~= lastEquippedWeapon then
            lastEquippedWeapon = weapon

            -- Check if we have a cached ammo type
            local ammoType = GetAmmoType(weapon)

            -- Ensure state is synced
            local key = ('ammo_%s'):format(weapon)
            if LocalPlayer.state[key] ~= ammoType then
                LocalPlayer.state:set(key, ammoType, true)
            end
        elseif weapon == `WEAPON_UNARMED` then
            lastEquippedWeapon = nil
        end

        Wait(500)
    end
end)

-- =============================================================================
-- OTHER PLAYER EFFECT RENDERING
-- =============================================================================

-- Get ammo type for another player (for rendering their tracers)
local function GetOtherPlayerAmmoType(playerId, weaponHash)
    local stateBagName = ('player:%d'):format(GetPlayerServerId(playerId))
    local key = ('ammo_%s'):format(weaponHash)

    return Player(GetPlayerServerId(playerId)).state[key] or 'fmj'
end

-- Watch other players for tracer effects
CreateThread(function()
    while true do
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)

        for _, playerId in ipairs(GetActivePlayers()) do
            if playerId ~= PlayerId() then
                local ped = GetPlayerPed(playerId)

                if DoesEntityExist(ped) then
                    local pedCoords = GetEntityCoords(ped)
                    local distance = #(myCoords - pedCoords)

                    -- Only process nearby players (within 100m)
                    if distance < 100.0 and IsPedShooting(ped) then
                        local weapon = GetSelectedPedWeapon(ped)
                        local ammoType = GetOtherPlayerAmmoType(playerId, weapon)

                        -- Check if they're using AP (tracer) ammo
                        local weaponInfo = Config.Weapons and Config.Weapons[weapon]
                        local caliber = weaponInfo and weaponInfo.caliber

                        if caliber then
                            local modifier = GetAmmoModifier(ammoType, caliber)

                            if modifier and modifier.effects and modifier.effects.tracer then
                                -- Render their tracer effect (handled by their client sync)
                                -- We just observe their state, they render their own tracers
                            end
                        end
                    end
                end
            end
        end

        Wait(100)
    end
end)

-- =============================================================================
-- CLEANUP
-- =============================================================================

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    -- Clear all state bags
    for weaponHash, _ in pairs(cachedAmmoTypes) do
        local key = ('ammo_%s'):format(weaponHash)
        LocalPlayer.state:set(key, nil, true)
    end

    cachedAmmoTypes = {}
end)

-- =============================================================================
-- ADMIN COMMAND HANDLERS
-- =============================================================================

-- Handle status request from admin
RegisterNetEvent('ammo:requestStatus', function(requesterId)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)

    local data = {
        playerId = GetPlayerServerId(PlayerId()),
        weaponName = 'None',
        caliber = nil,
        ammoType = nil,
        ammoCount = 0,
        magazineInfo = nil,
        hasSuppressor = false,
    }

    if weapon ~= `WEAPON_UNARMED` then
        local weaponInfo = Config.Weapons and Config.Weapons[weapon]

        data.weaponName = GetLabelText(GetWeapontypeSlot(weapon)) or tostring(weapon)
        data.ammoCount = GetAmmoInPedWeapon(ped, weapon)

        if weaponInfo then
            data.caliber = weaponInfo.caliber
            data.ammoType = GetAmmoType(weapon)
        end

        -- Check suppressor
        data.hasSuppressor = HasPedGotWeaponComponent(ped, weapon, `COMPONENT_AT_PI_SUPP`) or
                             HasPedGotWeaponComponent(ped, weapon, `COMPONENT_AT_AR_SUPP`) or
                             HasPedGotWeaponComponent(ped, weapon, `COMPONENT_AT_AR_SUPP_02`) or
                             HasPedGotWeaponComponent(ped, weapon, `COMPONENT_AT_SR_SUPP`)

        -- Get equipped magazine info
        local equippedMag = exports['free-bullets']:GetEquippedMagazine(weapon)
        if equippedMag then
            data.magazineInfo = equippedMag
        end
    end

    TriggerServerEvent('ammo:sendStatus', data, requesterId)
end)

-- Handle force ammo type change from admin
RegisterNetEvent('ammo:forceSetAmmoType', function(ammoType)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)

    if weapon ~= `WEAPON_UNARMED` then
        SetAmmoType(weapon, ammoType)

        if lib and lib.notify then
            lib.notify({
                title = 'Ammo Changed',
                description = 'Ammo type set to ' .. string.upper(ammoType),
                type = 'inform'
            })
        end
    end
end)

-- Update current caliber state for effects system
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` then
            local weaponInfo = Config.Weapons and Config.Weapons[weapon]
            if weaponInfo then
                LocalPlayer.state:set('currentCaliber', weaponInfo.caliber, false)
                LocalPlayer.state:set('currentAmmoType', GetAmmoType(weapon), false)
            end
        else
            LocalPlayer.state:set('currentCaliber', nil, false)
            LocalPlayer.state:set('currentAmmoType', nil, false)
        end

        Wait(250)
    end
end)

-- =============================================================================
-- EXPORTS
-- =============================================================================

exports('SetAmmoType', SetAmmoType)
exports('GetAmmoType', GetAmmoType)
exports('GetOtherPlayerAmmoType', GetOtherPlayerAmmoType)
