--[[
    Server-Side Ammunition System
    Handles item usage, inventory management, and state persistence
]]

-- Player ammo states: playerAmmoState[source][weaponHash] = ammoType
local playerAmmoState = {}

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

-- Parse ammo item name to get caliber and type
-- e.g., 'ammo_9mm_fmj' -> '9mm', 'fmj'
local function ParseAmmoItem(itemName)
    local caliber, ammoType = itemName:match('ammo_(.+)_(.+)')
    return caliber, ammoType
end

-- Get the ammo item name from caliber and type
local function GetAmmoItemName(caliber, ammoType)
    local ammoConfig = Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][ammoType]
    if ammoConfig then
        return ammoConfig.item
    end
    return ('ammo_%s_%s'):format(caliber, ammoType)
end

-- Send notification to player
local function Notify(source, message, msgType)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Ammunition',
        description = message,
        type = msgType or 'info'
    })
end

-- ============================================
-- STATE MANAGEMENT
-- ============================================

local function InitPlayerState(source)
    if not playerAmmoState[source] then
        playerAmmoState[source] = {}
    end
end

local function SetPlayerWeaponAmmo(source, weaponHash, ammoType)
    InitPlayerState(source)
    playerAmmoState[source][weaponHash] = ammoType
end

local function GetPlayerWeaponAmmo(source, weaponHash)
    if playerAmmoState[source] then
        return playerAmmoState[source][weaponHash]
    end
    return nil
end

local function ClearPlayerWeaponAmmo(source, weaponHash)
    if playerAmmoState[source] then
        playerAmmoState[source][weaponHash] = nil
    end
end

local function ClearPlayerState(source)
    playerAmmoState[source] = nil
end

-- ============================================
-- ITEM USAGE HANDLER
-- ============================================

local function RegisterAmmoItems()
    for caliber, ammoTypes in pairs(Config.AmmoTypes) do
        for ammoType, ammoData in pairs(ammoTypes) do
            local itemName = ammoData.item

            exports.ox_inventory:RegisterUsableItem(itemName, function(playerData, slot)
                local source = playerData.source
                local item = playerData.inventory[slot]

                if not item or item.count <= 0 then
                    Notify(source, 'You don\'t have any ammo', 'error')
                    return
                end

                -- Tell client to load ammo
                TriggerClientEvent('ammo_system:client:loadAmmo', source, caliber, ammoType, item.count)

                if Config.Debug then
                    print(('[AMMO] Player %s using %s (%d rounds)'):format(source, itemName, item.count))
                end
            end)

            if Config.Debug then
                print(('[AMMO] Registered usable item: %s'):format(itemName))
            end
        end
    end
end

-- ============================================
-- LOAD AMMO RESULT HANDLER
-- ============================================

RegisterNetEvent('ammo_system:server:loadAmmoResult', function(result)
    local source = source

    if not result.success then
        local errorMessages = {
            no_weapon = 'You need to equip a weapon first',
            unknown_weapon = 'This weapon doesn\'t use this ammo system',
            wrong_caliber = 'This ammo doesn\'t fit your weapon',
            invalid_ammo_type = 'Invalid ammo type',
            component_failed = 'Failed to load magazine component'
        }

        local message = errorMessages[result.error] or 'Failed to load ammo'
        Notify(source, message, 'error')
        return
    end

    local caliber = result.caliber
    local newAmmoType = result.newAmmoType
    local loadedCount = result.loadedCount
    local oldAmmoType = result.oldAmmoType
    local oldAmmoCount = result.oldAmmoCount
    local weaponHash = result.weaponHash

    -- Get item names
    local newItemName = GetAmmoItemName(caliber, newAmmoType)
    local oldItemName = oldAmmoType and GetAmmoItemName(caliber, oldAmmoType) or nil

    -- Remove used ammo from inventory
    local removed = exports.ox_inventory:RemoveItem(source, newItemName, loadedCount)

    if not removed then
        Notify(source, 'Failed to remove ammo from inventory', 'error')
        return
    end

    -- Return old ammo to inventory if configured
    if Config.ReturnOldAmmo and oldAmmoType and oldAmmoCount and oldAmmoCount > 0 then
        local added = exports.ox_inventory:AddItem(source, oldItemName, oldAmmoCount)

        if added and Config.Notifications.ammoReturned then
            local ammoConfig = Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][oldAmmoType]
            local label = ammoConfig and ammoConfig.label or oldAmmoType
            Notify(source, ('Returned %d rounds of %s'):format(oldAmmoCount, label), 'info')
        end
    end

    -- Update server state
    if weaponHash then
        SetPlayerWeaponAmmo(source, weaponHash, newAmmoType)
    end

    -- Notify success
    if Config.Notifications.ammoLoaded then
        local ammoConfig = Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][newAmmoType]
        local label = ammoConfig and ammoConfig.label or newAmmoType
        Notify(source, ('Loaded %d rounds of %s'):format(loadedCount, label), 'success')
    end

    if Config.Debug then
        print(('[AMMO] Player %s loaded %d rounds of %s (returned %d rounds of %s)'):format(
            source, loadedCount, newAmmoType, oldAmmoCount or 0, oldAmmoType or 'none'
        ))
    end
end)

-- ============================================
-- STATE SYNC HANDLER
-- ============================================

RegisterNetEvent('ammo_system:server:requestStateSync', function()
    local source = source
    InitPlayerState(source)
    TriggerClientEvent('ammo_system:client:syncState', source, playerAmmoState[source])
end)

-- ============================================
-- PLAYER EVENTS
-- ============================================

AddEventHandler('playerDropped', function()
    local source = source
    ClearPlayerState(source)

    if Config.Debug then
        print(('[AMMO] Cleared state for disconnected player %s'):format(source))
    end
end)

-- ============================================
-- WEAPON EVENTS
-- ============================================

RegisterNetEvent('ammo_system:server:weaponRemoved', function(weaponHash)
    local source = source
    ClearPlayerWeaponAmmo(source, weaponHash)
    TriggerClientEvent('ammo_system:client:weaponRemoved', source, weaponHash)
end)

-- ============================================
-- INITIALIZATION
-- ============================================

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    RegisterAmmoItems()

    local caliberCount = 0
    local itemCount = 0
    for caliber, types in pairs(Config.AmmoTypes) do
        caliberCount = caliberCount + 1
        for _ in pairs(types) do
            itemCount = itemCount + 1
        end
    end

    print('[AMMO SYSTEM] Server initialized')
    print(('[AMMO SYSTEM] Registered %d calibers, %d ammo types'):format(caliberCount, itemCount))
end)

-- ============================================
-- EXPORTS
-- ============================================

exports('GetPlayerWeaponAmmo', GetPlayerWeaponAmmo)
exports('SetPlayerWeaponAmmo', SetPlayerWeaponAmmo)
exports('ClearPlayerWeaponAmmo', ClearPlayerWeaponAmmo)
