--[[
    Admin Commands - Free Bullets System
    =====================================

    Commands for testing and administration:
    - /giveammo [player] [caliber] [type] [amount]
    - /givemag [player] [magazine] [ammoType] [count]
    - /ammostatus [player]
    - /setammo [player] [type]
    - /listavailableammo
    - /listmags
]]

local ox_inventory = exports.ox_inventory

-- =============================================================================
-- PERMISSION CHECK
-- =============================================================================

local function HasAdminPermission(source)
    -- Check for ace permission
    if IsPlayerAceAllowed(source, 'command.ammo_admin') then
        return true
    end

    -- Check for admin group (QBCore/ESX compatibility)
    if QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            local group = Player.PlayerData.permission
            return group == 'admin' or group == 'god' or group == 'superadmin'
        end
    end

    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            local group = xPlayer.getGroup()
            return group == 'admin' or group == 'superadmin'
        end
    end

    -- Console always has permission
    if source == 0 then
        return true
    end

    return false
end

local function NotifyPlayer(source, title, message, type)
    if source == 0 then
        print(('[%s] %s'):format(title, message))
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = title,
            description = message,
            type = type or 'inform'
        })
    end
end

-- =============================================================================
-- /giveammo - Give loose ammunition
-- =============================================================================

RegisterCommand('giveammo', function(source, args)
    if not HasAdminPermission(source) then
        NotifyPlayer(source, 'Error', 'No permission', 'error')
        return
    end

    local targetId = tonumber(args[1])
    local caliber = args[2]
    local ammoType = args[3]
    local amount = tonumber(args[4]) or 30

    if not targetId or not caliber or not ammoType then
        NotifyPlayer(source, 'Usage', '/giveammo [playerID] [caliber] [ammoType] [amount]', 'inform')
        NotifyPlayer(source, 'Example', '/giveammo 1 9mm hp 60', 'inform')
        return
    end

    -- Validate caliber exists
    local caliberMap = Config.CaliberAmmoMap[caliber]
    if not caliberMap then
        NotifyPlayer(source, 'Error', 'Invalid caliber: ' .. caliber, 'error')
        return
    end

    -- Validate ammo type exists for caliber
    if not caliberMap[ammoType] then
        local validTypes = {}
        for t, _ in pairs(caliberMap) do
            table.insert(validTypes, t)
        end
        NotifyPlayer(source, 'Error', 'Invalid ammo type. Valid: ' .. table.concat(validTypes, ', '), 'error')
        return
    end

    -- Get ammo item name
    local ammoConfig = Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][ammoType]
    if not ammoConfig or not ammoConfig.item then
        NotifyPlayer(source, 'Error', 'Ammo item not configured for this type', 'error')
        return
    end

    -- Give the ammo
    local success = ox_inventory:AddItem(targetId, ammoConfig.item, amount)
    if success then
        NotifyPlayer(source, 'Success', ('Gave %dx %s %s to player %d'):format(amount, caliber, ammoType:upper(), targetId), 'success')
        NotifyPlayer(targetId, 'Admin', ('Received %dx %s %s'):format(amount, caliber, ammoType:upper()), 'success')
    else
        NotifyPlayer(source, 'Error', 'Failed to give ammo - inventory full?', 'error')
    end
end, false)

-- =============================================================================
-- /givemag - Give magazine (empty or loaded)
-- =============================================================================

RegisterCommand('givemag', function(source, args)
    if not HasAdminPermission(source) then
        NotifyPlayer(source, 'Error', 'No permission', 'error')
        return
    end

    local targetId = tonumber(args[1])
    local magName = args[2]
    local ammoType = args[3]  -- Optional: if provided, gives loaded mag
    local count = tonumber(args[4])  -- Optional: round count

    if not targetId or not magName then
        NotifyPlayer(source, 'Usage', '/givemag [playerID] [magazine] [ammoType?] [count?]', 'inform')
        NotifyPlayer(source, 'Example', '/givemag 1 mag_g17_std hp 17', 'inform')
        return
    end

    -- Validate magazine exists
    local magInfo = Config.Magazines[magName]
    if not magInfo then
        NotifyPlayer(source, 'Error', 'Invalid magazine: ' .. magName, 'error')
        return
    end

    local metadata = nil
    if ammoType then
        -- Loaded magazine
        local capacity = count or magInfo.capacity
        capacity = math.min(capacity, magInfo.capacity)

        metadata = {
            ammoType = ammoType,
            count = capacity,
            maxCount = magInfo.capacity,
            label = ('%s (%d/%d %s)'):format(magInfo.label, capacity, magInfo.capacity, ammoType:upper())
        }
    end

    local success = ox_inventory:AddItem(targetId, magName, 1, metadata)
    if success then
        local desc = metadata and ('loaded with %d %s'):format(metadata.count, ammoType:upper()) or 'empty'
        NotifyPlayer(source, 'Success', ('Gave %s (%s) to player %d'):format(magInfo.label, desc, targetId), 'success')
        NotifyPlayer(targetId, 'Admin', ('Received %s (%s)'):format(magInfo.label, desc), 'success')
    else
        NotifyPlayer(source, 'Error', 'Failed to give magazine - inventory full?', 'error')
    end
end, false)

-- =============================================================================
-- /ammostatus - Check player's current ammo state
-- =============================================================================

RegisterCommand('ammostatus', function(source, args)
    if not HasAdminPermission(source) then
        NotifyPlayer(source, 'Error', 'No permission', 'error')
        return
    end

    local targetId = tonumber(args[1]) or source

    if targetId == 0 then
        print('Cannot check ammo status for console')
        return
    end

    -- Request client to send status
    TriggerClientEvent('ammo:requestStatus', targetId, source)
end, false)

RegisterNetEvent('ammo:sendStatus', function(data, requesterId)
    local source = source

    -- Verify this came from the right player
    if data.playerId ~= source then return end

    local output = {
        ('=== Ammo Status for Player %d ==='):format(source),
        ('Current Weapon: %s'):format(data.weaponName or 'None'),
        ('Caliber: %s'):format(data.caliber or 'N/A'),
        ('Ammo Type: %s'):format(data.ammoType or 'N/A'),
        ('Rounds in Weapon: %d'):format(data.ammoCount or 0),
    }

    if data.magazineInfo then
        table.insert(output, ('Magazine: %s (%d/%d)'):format(
            data.magazineInfo.item or 'Unknown',
            data.magazineInfo.count or 0,
            data.magazineInfo.maxCount or 0
        ))
    end

    if data.hasSuppressor then
        table.insert(output, 'Suppressor: Equipped')
    end

    for _, line in ipairs(output) do
        if requesterId == 0 then
            print(line)
        else
            TriggerClientEvent('chat:addMessage', requesterId, { args = { 'Ammo', line } })
        end
    end
end)

-- =============================================================================
-- /setammo - Force set player's current ammo type
-- =============================================================================

RegisterCommand('setammo', function(source, args)
    if not HasAdminPermission(source) then
        NotifyPlayer(source, 'Error', 'No permission', 'error')
        return
    end

    local targetId = tonumber(args[1])
    local ammoType = args[2]

    if not targetId or not ammoType then
        NotifyPlayer(source, 'Usage', '/setammo [playerID] [ammoType]', 'inform')
        NotifyPlayer(source, 'Example', '/setammo 1 ap', 'inform')
        return
    end

    TriggerClientEvent('ammo:forceSetAmmoType', targetId, ammoType)
    NotifyPlayer(source, 'Success', ('Set player %d ammo type to %s'):format(targetId, ammoType:upper()), 'success')
    NotifyPlayer(targetId, 'Admin', ('Ammo type changed to %s'):format(ammoType:upper()), 'inform')
end, false)

-- =============================================================================
-- /listavailableammo - List all ammo types and calibers
-- =============================================================================

RegisterCommand('listavailableammo', function(source, args)
    if not HasAdminPermission(source) then
        NotifyPlayer(source, 'Error', 'No permission', 'error')
        return
    end

    local output = { '=== Available Ammunition ===' }

    for caliber, ammoTypes in pairs(Config.CaliberAmmoMap) do
        local types = {}
        for ammoType, _ in pairs(ammoTypes) do
            table.insert(types, ammoType)
        end
        table.insert(output, ('%s: %s'):format(caliber, table.concat(types, ', ')))
    end

    for _, line in ipairs(output) do
        if source == 0 then
            print(line)
        else
            TriggerClientEvent('chat:addMessage', source, { args = { 'Ammo', line } })
        end
    end
end, false)

-- =============================================================================
-- /listmags - List all magazines
-- =============================================================================

RegisterCommand('listmags', function(source, args)
    if not HasAdminPermission(source) then
        NotifyPlayer(source, 'Error', 'No permission', 'error')
        return
    end

    local filterCaliber = args[1]
    local output = { '=== Available Magazines ===' }

    for magName, magInfo in pairs(Config.Magazines) do
        -- Get caliber from first compatible weapon
        local caliber = nil
        for _, weaponName in ipairs(magInfo.weapons or {}) do
            local weaponHash = joaat(weaponName)
            local weaponInfo = Config.Weapons[weaponHash]
            if weaponInfo then
                caliber = weaponInfo.caliber
                break
            end
        end

        -- Apply filter if specified
        if not filterCaliber or caliber == filterCaliber then
            table.insert(output, ('%s | %s | Cap: %d | Type: %s'):format(
                magName,
                magInfo.label or 'Unknown',
                magInfo.capacity or 0,
                magInfo.type or 'standard'
            ))
        end
    end

    if #output == 1 then
        table.insert(output, 'No magazines found' .. (filterCaliber and (' for caliber ' .. filterCaliber) or ''))
    end

    for _, line in ipairs(output) do
        if source == 0 then
            print(line)
        else
            TriggerClientEvent('chat:addMessage', source, { args = { 'Mags', line } })
        end
    end
end, false)

-- =============================================================================
-- /giveweaponkit - Give weapon with loaded magazine and spare ammo
-- =============================================================================

RegisterCommand('giveweaponkit', function(source, args)
    if not HasAdminPermission(source) then
        NotifyPlayer(source, 'Error', 'No permission', 'error')
        return
    end

    local targetId = tonumber(args[1])
    local weaponName = args[2]
    local ammoType = args[3] or 'fmj'
    local spareMags = tonumber(args[4]) or 2

    if not targetId or not weaponName then
        NotifyPlayer(source, 'Usage', '/giveweaponkit [playerID] [weaponName] [ammoType?] [spareMags?]', 'inform')
        NotifyPlayer(source, 'Example', '/giveweaponkit 1 WEAPON_G17 hp 3', 'inform')
        return
    end

    local weaponHash = joaat(weaponName:upper())
    local weaponInfo = Config.Weapons[weaponHash]

    if not weaponInfo then
        NotifyPlayer(source, 'Error', 'Weapon not found in ammo system: ' .. weaponName, 'error')
        return
    end

    -- Find compatible magazine
    local compatMag = nil
    for magName, magInfo in pairs(Config.Magazines) do
        if magInfo.weapons then
            for _, wep in ipairs(magInfo.weapons) do
                if joaat(wep) == weaponHash and magInfo.type == 'standard' then
                    compatMag = { name = magName, info = magInfo }
                    break
                end
            end
        end
        if compatMag then break end
    end

    if not compatMag then
        NotifyPlayer(source, 'Error', 'No compatible magazine found for this weapon', 'error')
        return
    end

    -- Give weapon
    ox_inventory:AddItem(targetId, weaponName:lower(), 1)

    -- Give loaded magazines
    for i = 1, spareMags + 1 do  -- +1 for the one in the gun
        local metadata = {
            ammoType = ammoType,
            count = compatMag.info.capacity,
            maxCount = compatMag.info.capacity,
            label = ('%s (%d/%d %s)'):format(compatMag.info.label, compatMag.info.capacity, compatMag.info.capacity, ammoType:upper())
        }
        ox_inventory:AddItem(targetId, compatMag.name, 1, metadata)
    end

    NotifyPlayer(source, 'Success', ('Gave %s kit with %d loaded %s mags to player %d'):format(
        weaponName, spareMags + 1, ammoType:upper(), targetId
    ), 'success')
    NotifyPlayer(targetId, 'Admin', ('Received %s with %d loaded magazines'):format(weaponName, spareMags + 1), 'success')
end, false)

-- =============================================================================
-- /reloadconfig - Reload ammo configuration (dev only)
-- =============================================================================

RegisterCommand('ammoreload', function(source, args)
    if source ~= 0 then
        NotifyPlayer(source, 'Error', 'Console only command', 'error')
        return
    end

    -- This would require resource restart in FiveM
    print('[Ammo] Configuration reload requires resource restart: ensure free-bullets')
end, false)

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

-- Use FiveM's built-in joaat (available server-side).
-- Custom Lua joaat implementations produce incorrect hashes under
-- lua54's 64-bit integer arithmetic (no 32-bit wrapping per step).
function joaat(s)
    if type(s) ~= 'string' then return 0 end
    return GetHashKey(s)
end

-- =============================================================================
-- COMMAND SUGGESTIONS (for chat autocomplete)
-- =============================================================================

TriggerEvent('chat:addSuggestion', '/giveammo', 'Give loose ammunition to player', {
    { name = 'playerID', help = 'Target player ID' },
    { name = 'caliber', help = '9mm, .45acp, 5.56, etc.' },
    { name = 'ammoType', help = 'fmj, hp, ap, jhp, etc.' },
    { name = 'amount', help = 'Number of rounds (default: 30)' },
})

TriggerEvent('chat:addSuggestion', '/givemag', 'Give magazine to player', {
    { name = 'playerID', help = 'Target player ID' },
    { name = 'magazine', help = 'Magazine item name (e.g., mag_g17_std)' },
    { name = 'ammoType', help = 'Optional: load with this ammo type' },
    { name = 'count', help = 'Optional: round count' },
})

TriggerEvent('chat:addSuggestion', '/ammostatus', 'Check player ammo status', {
    { name = 'playerID', help = 'Target player ID (default: self)' },
})

TriggerEvent('chat:addSuggestion', '/setammo', 'Force set player ammo type', {
    { name = 'playerID', help = 'Target player ID' },
    { name = 'ammoType', help = 'fmj, hp, ap, etc.' },
})

TriggerEvent('chat:addSuggestion', '/giveweaponkit', 'Give weapon with loaded magazines', {
    { name = 'playerID', help = 'Target player ID' },
    { name = 'weaponName', help = 'WEAPON_G17, WEAPON_M9, etc.' },
    { name = 'ammoType', help = 'fmj, hp, ap (default: fmj)' },
    { name = 'spareMags', help = 'Number of spare mags (default: 2)' },
})

TriggerEvent('chat:addSuggestion', '/listavailableammo', 'List all available ammo types', {})
TriggerEvent('chat:addSuggestion', '/listmags', 'List all magazines', {
    { name = 'caliber', help = 'Optional: filter by caliber' },
})

print('[free-bullets] Admin commands loaded')
