--[[
    Server-Side Ammunition System
    Handles item usage, inventory management, and state persistence
]]

local QBX = exports['qbx_core']:GetCoreObject()

-- Player ammo states: playerAmmoState[source][weaponHash] = ammoType
local playerAmmoState = {}

-- ============================================
-- HELPER FUNCTIONS
-- ============================================

-- Get caliber from ammo item name
-- e.g., 'ammo_9mm_fmj' -> '9mm', 'fmj'
local function ParseAmmoItem(itemName)
    -- Pattern: ammo_CALIBER_TYPE
    local caliber, ammoType = itemName:match('ammo_(.+)_(.+)')
    return caliber, ammoType
end

-- Get the ammo item name from caliber and type
local function GetAmmoItemName(caliber, ammoType)
    return ('ammo_%s_%s'):format(caliber, ammoType)
end

-- Send notification to player
local function Notify(source, message, type)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Ammunition',
        description = message,
        type = type or 'info'
    })
end

-- ============================================
-- STATE MANAGEMENT
-- ============================================

-- Initialize player state
local function InitPlayerState(source)
    if not playerAmmoState[source] then
        playerAmmoState[source] = {}
    end
end

-- Set ammo type for a weapon
local function SetPlayerWeaponAmmo(source, weaponHash, ammoType)
    InitPlayerState(source)
    playerAmmoState[source][weaponHash] = ammoType
end

-- Get ammo type for a weapon
local function GetPlayerWeaponAmmo(source, weaponHash)
    if playerAmmoState[source] then
        return playerAmmoState[source][weaponHash]
    end
    return nil
end

-- Clear weapon ammo state
local function ClearPlayerWeaponAmmo(source, weaponHash)
    if playerAmmoState[source] then
        playerAmmoState[source][weaponHash] = nil
    end
end

-- Clear all state for a player
local function ClearPlayerState(source)
    playerAmmoState[source] = nil
end

-- ============================================
-- ITEM USAGE HANDLER
-- ============================================

-- Register usable items for all ammo types
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
        -- Handle errors
        local errorMessages = {
            no_weapon = 'You need to equip a weapon first',
            unknown_weapon = 'This weapon doesn\'t use this ammo system',
            wrong_caliber = 'This ammo doesn\'t fit your weapon'
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
    if Config.ReturnOldAmmo and oldAmmoType and oldAmmoCount > 0 then
        local added = exports.ox_inventory:AddItem(source, oldItemName, oldAmmoCount)
        
        if added and Config.Notifications.ammoReturned then
            Notify(source, ('Returned %d rounds of %s to inventory'):format(
                oldAmmoCount, 
                Config.AmmoTypes[caliber][oldAmmoType].label
            ), 'info')
        end
    end
    
    -- Update server state
    -- We need to get the weapon hash from client
    -- For now, just notify success
    if Config.Notifications.ammoLoaded then
        Notify(source, ('Loaded %d rounds of %s'):format(
            loadedCount,
            Config.AmmoTypes[caliber][newAmmoType].label
        ), 'success')
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

-- Clean up state when player drops
AddEventHandler('playerDropped', function()
    local source = source
    ClearPlayerState(source)
    
    if Config.Debug then
        print(('[AMMO] Cleared state for disconnected player %s'):format(source))
    end
end)

-- ============================================
-- WEAPON EVENTS (Integration with weapon give/remove systems)
-- ============================================

-- Hook into weapon removal to track state
-- This should be called by your weapon management system
RegisterNetEvent('ammo_system:server:weaponRemoved', function(weaponHash)
    local source = source
    ClearPlayerWeaponAmmo(source, weaponHash)
    TriggerClientEvent('ammo_system:client:weaponRemoved', source, weaponHash)
end)

-- Hook into weapon addition
RegisterNetEvent('ammo_system:server:weaponAdded', function(weaponHash)
    local source = source
    TriggerClientEvent('ammo_system:client:weaponAdded', source, weaponHash)
end)

-- ============================================
-- INITIALIZATION
-- ============================================

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Register all ammo items
    RegisterAmmoItems()
    
    print('[AMMO SYSTEM] Server initialized')
    print(('[AMMO SYSTEM] Registered %d calibers'):format(CountTable(Config.AmmoTypes)))
end)

-- Helper to count table entries
function CountTable(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
end

-- ============================================
-- EXPORTS
-- ============================================

exports('GetPlayerWeaponAmmo', GetPlayerWeaponAmmo)
exports('SetPlayerWeaponAmmo', SetPlayerWeaponAmmo)
exports('ClearPlayerWeaponAmmo', ClearPlayerWeaponAmmo)
