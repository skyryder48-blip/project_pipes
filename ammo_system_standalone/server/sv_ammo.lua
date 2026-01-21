--[[
    Server-Side Ammunition System (Unified)
    =========================================

    MERGED SYSTEM: Works with magazine_server.lua

    This file provides:
    - Ammo type configuration reference (Config.AmmoTypes)
    - Helper functions for caliber/item lookups
    - State management exports for other resources

    IMPORTANT: Direct ammo loading is DISABLED.
    All ammunition must be loaded into magazines first.
    See magazine_server.lua for inventory operations.
]]

-- ============================================
-- HELPER FUNCTIONS (Used by magazine system)
-- ============================================

-- Parse ammo item name to get caliber and type
-- e.g., 'ammo_9mm_fmj' -> '9mm', 'fmj'
function ParseAmmoItem(itemName)
    local caliber, ammoType = itemName:match('ammo_(.+)_(.+)')
    return caliber, ammoType
end

-- Get the ammo item name from caliber and type
function GetAmmoItemName(caliber, ammoType)
    local ammoConfig = Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][ammoType]
    if ammoConfig then
        return ammoConfig.item
    end
    return ('ammo_%s_%s'):format(caliber, ammoType)
end

-- Get ammo config by caliber and type
function GetAmmoConfig(caliber, ammoType)
    if Config.AmmoTypes[caliber] then
        return Config.AmmoTypes[caliber][ammoType]
    end
    return nil
end

-- Get all ammo types for a caliber
function GetAmmoTypesForCaliber(caliber)
    return Config.AmmoTypes[caliber] or {}
end

-- Send notification to player
function NotifyPlayer(source, message, msgType)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Ammunition',
        description = message,
        type = msgType or 'info'
    })
end

-- ============================================
-- PLAYER EVENTS
-- ============================================

AddEventHandler('playerDropped', function()
    local source = source
    if Config.Debug then
        print(('[AMMO] Player %s disconnected'):format(source))
    end
end)

-- ============================================
-- INITIALIZATION
-- ============================================

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    -- Count calibers and ammo types for logging
    local caliberCount = 0
    local itemCount = 0
    for caliber, types in pairs(Config.AmmoTypes) do
        caliberCount = caliberCount + 1
        for _ in pairs(types) do
            itemCount = itemCount + 1
        end
    end

    print('[AMMO SYSTEM] Server initialized (Magazine System Mode)')
    print(('[AMMO SYSTEM] Available: %d calibers, %d ammo types'):format(caliberCount, itemCount))
    print('[AMMO SYSTEM] Direct ammo loading DISABLED - use magazines')
end)

-- ============================================
-- EXPORTS (For use by magazine system and other resources)
-- ============================================

exports('ParseAmmoItem', ParseAmmoItem)
exports('GetAmmoItemName', GetAmmoItemName)
exports('GetAmmoConfig', GetAmmoConfig)
exports('GetAmmoTypesForCaliber', GetAmmoTypesForCaliber)
exports('NotifyPlayer', NotifyPlayer)
