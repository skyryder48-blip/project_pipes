--[[
    Magazine System - Server
    =========================

    Handles all inventory operations for the magazine system:
    - Loading magazines with ammo
    - Unloading magazines
    - Equipping/swapping magazines
    - Combat reload management
    - Empty magazine return
]]

local ox_inventory = exports.ox_inventory

-- ============================================================================
-- MAGAZINE LOADING
-- ============================================================================

--[[
    Load ammo into an empty magazine
]]
RegisterNetEvent('ammo:loadMagazine', function(data)
    local source = source
    local xPlayer = ESX and ESX.GetPlayerFromId(source) or nil

    -- Validate data
    if not data.magazineItem or not data.ammoItem or not data.amount then
        return
    end

    local magInfo = Config.Magazines[data.magazineItem]
    if not magInfo then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Invalid magazine type',
            type = 'error'
        })
        return
    end

    -- Check player has the magazine
    local magazineCount = ox_inventory:Search(source, 'count', data.magazineItem)
    if magazineCount <= 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Magazine not found in inventory',
            type = 'error'
        })
        return
    end

    -- Check player has enough ammo
    local ammoCount = ox_inventory:Search(source, 'count', data.ammoItem)
    if ammoCount < data.amount then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Not enough ammunition',
            type = 'error'
        })
        return
    end

    -- Validate amount doesn't exceed capacity
    local loadAmount = math.min(data.amount, data.maxCapacity, ammoCount)

    -- Remove the empty magazine from inventory
    local removed = ox_inventory:RemoveItem(source, data.magazineItem, 1, nil, data.magazineSlot)
    if not removed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to access magazine',
            type = 'error'
        })
        return
    end

    -- Remove the ammo from inventory
    local ammoRemoved = ox_inventory:RemoveItem(source, data.ammoItem, loadAmount)
    if not ammoRemoved then
        -- Refund the magazine
        ox_inventory:AddItem(source, data.magazineItem, 1)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to access ammunition',
            type = 'error'
        })
        return
    end

    -- Add loaded magazine with metadata
    local metadata = {
        ammoType = data.ammoType,
        count = loadAmount,
        maxCount = data.maxCapacity,
        label = string.format('%s (%d/%d %s)', magInfo.label, loadAmount, data.maxCapacity, string.upper(data.ammoType)),
    }

    local added = ox_inventory:AddItem(source, data.magazineItem, 1, metadata)
    if added then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Magazine Loaded',
            description = string.format('Loaded %d %s rounds', loadAmount, string.upper(data.ammoType)),
            type = 'success'
        })
    else
        -- Refund everything if add fails
        ox_inventory:AddItem(source, data.magazineItem, 1)
        ox_inventory:AddItem(source, data.ammoItem, loadAmount)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to create loaded magazine',
            type = 'error'
        })
    end
end)

-- ============================================================================
-- MAGAZINE UNLOADING
-- ============================================================================

--[[
    Unload ammo from a loaded magazine back to loose rounds
]]
RegisterNetEvent('ammo:unloadMagazine', function(data)
    local source = source

    if not data.magazineItem or not data.ammoType or not data.count then
        return
    end

    local magInfo = Config.Magazines[data.magazineItem]
    if not magInfo then return end

    -- Get the ammo item name for this caliber/type
    local weaponInfo = nil
    for _, weaponName in ipairs(magInfo.weapons) do
        weaponInfo = Config.Weapons[GetHashKey(weaponName)]
        if weaponInfo then break end
    end

    if not weaponInfo then return end

    local ammoConfig = Config.AmmoTypes[weaponInfo.caliber] and Config.AmmoTypes[weaponInfo.caliber][data.ammoType]
    if not ammoConfig then return end

    -- Remove the loaded magazine
    local removed = ox_inventory:RemoveItem(source, data.magazineItem, 1, nil, data.magazineSlot)
    if not removed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to access magazine',
            type = 'error'
        })
        return
    end

    -- Add empty magazine back
    ox_inventory:AddItem(source, data.magazineItem, 1)

    -- Add loose ammo
    ox_inventory:AddItem(source, ammoConfig.item, data.count)

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Magazine Unloaded',
        description = string.format('Recovered %d %s rounds', data.count, string.upper(data.ammoType)),
        type = 'success'
    })
end)

-- ============================================================================
-- MAGAZINE EQUIPPING
-- ============================================================================

--[[
    Equip a magazine to weapon (swap if one already equipped)

    Supports shared magazine compatibility with per-weapon capacity limits:
    - If magazine has more rounds than weapon can physically hold (weaponClipSize),
      only loads what the weapon can accept
    - Excess rounds returned as LOOSE AMMO (not partial magazine) to prevent exploits
    - Empty magazine returned to inventory
    - Example: 17rd G17 mag in G26 (10rd capacity) → G26 loads 10, empty mag + 7 loose rounds returned
]]
RegisterNetEvent('ammo:equipMagazine', function(data)
    local source = source

    if not data.newMagazine or not data.weaponHash then
        return
    end

    local newMag = data.newMagazine
    local currentMag = data.currentMagazine
    local weaponClipSize = data.weaponClipSize or 999  -- Fallback if not provided

    local magInfo = Config.Magazines[newMag.item]
    local magazineRounds = newMag.metadata.count or 0

    -- Calculate how many rounds the weapon can actually accept
    local actualLoad = math.min(magazineRounds, weaponClipSize)
    local excessRounds = magazineRounds - actualLoad

    -- Remove the new magazine from inventory
    local removed = ox_inventory:RemoveItem(source, newMag.item, 1, nil, newMag.slot)
    if not removed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to access magazine',
            type = 'error'
        })
        return
    end

    -- If there was a magazine already equipped, return it to inventory
    if currentMag and currentMag.item then
        local currentMagInfo = Config.Magazines[currentMag.item]
        local metadata = nil

        if currentMag.count and currentMag.count > 0 then
            -- Return with remaining ammo
            metadata = {
                ammoType = currentMag.ammoType,
                count = currentMag.count,
                maxCount = currentMagInfo and currentMagInfo.capacity or currentMag.count,
                label = string.format('%s (%d/%d %s)',
                    currentMagInfo and currentMagInfo.label or currentMag.item,
                    currentMag.count,
                    currentMagInfo and currentMagInfo.capacity or currentMag.count,
                    string.upper(currentMag.ammoType)
                ),
            }
        end
        -- Empty mags have no metadata (stackable)

        ox_inventory:AddItem(source, currentMag.item, 1, metadata)
    end

    -- If there are excess rounds that couldn't fit in the weapon,
    -- return them as LOOSE AMMO (not a partial magazine)
    if excessRounds > 0 then
        -- Get the caliber from the magazine's compatible weapons
        local caliber = nil
        if magInfo and magInfo.weapons then
            for _, weaponName in ipairs(magInfo.weapons) do
                local weaponInfo = Config.Weapons[GetHashKey(weaponName)]
                if weaponInfo and weaponInfo.caliber then
                    caliber = weaponInfo.caliber
                    break
                end
            end
        end

        -- Get the ammo item name for this caliber/type
        local ammoType = newMag.metadata.ammoType
        local ammoConfig = caliber and Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][ammoType]

        if ammoConfig and ammoConfig.item then
            -- Return excess as loose ammo
            ox_inventory:AddItem(source, ammoConfig.item, excessRounds)

            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Capacity Limited',
                description = string.format('Weapon holds %d rounds. %d loose rounds returned.',
                    actualLoad, excessRounds),
                type = 'inform'
            })
        else
            -- Fallback: if we can't determine ammo item, notify player (ammo lost)
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Warning',
                description = string.format('Weapon holds %d rounds. %d rounds could not be returned.',
                    actualLoad, excessRounds),
                type = 'warning'
            })
        end

        -- Return empty magazine (the loaded magazine is now empty after transferring rounds)
        ox_inventory:AddItem(source, newMag.item, 1)  -- No metadata = empty = stackable
    end

    -- Tell client to apply the new magazine (with clamped count)
    TriggerClientEvent('ammo:magazineEquipped', source, {
        weaponHash = data.weaponHash,
        magazineItem = newMag.item,
        ammoType = newMag.metadata.ammoType,
        count = actualLoad,  -- Only load what weapon can hold
    })
end)

-- ============================================================================
-- COMBAT RELOAD
-- ============================================================================

--[[
    Handle combat reload - swap magazines during fight
    Respects weapon's physical capacity limit
    Excess rounds returned as LOOSE AMMO (not partial magazine) to prevent exploits
]]
RegisterNetEvent('ammo:combatReload', function(data)
    local source = source

    if not data.newMagazine or not data.weaponHash then
        return
    end

    local newMag = data.newMagazine
    local emptyMag = data.emptyMagazine
    local weaponClipSize = data.weaponClipSize or 999  -- Fallback if not provided

    local magInfo = Config.Magazines[newMag.item]
    local magazineRounds = newMag.metadata.count or 0

    -- Calculate how many rounds the weapon can actually accept
    local actualLoad = math.min(magazineRounds, weaponClipSize)
    local excessRounds = magazineRounds - actualLoad

    -- Remove new magazine from inventory
    local removed = ox_inventory:RemoveItem(source, newMag.item, 1, nil, newMag.slot)
    if not removed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Reload Failed',
            description = 'Magazine not available',
            type = 'error'
        })
        return
    end

    -- Return empty magazine to inventory (no metadata = empty = stackable)
    if emptyMag and emptyMag.item then
        ox_inventory:AddItem(source, emptyMag.item, 1)
    end

    -- If there are excess rounds that couldn't fit in the weapon,
    -- return them as LOOSE AMMO (not a partial magazine)
    if excessRounds > 0 then
        -- Get the caliber from the magazine's compatible weapons
        local caliber = nil
        if magInfo and magInfo.weapons then
            for _, weaponName in ipairs(magInfo.weapons) do
                local weaponInfo = Config.Weapons[GetHashKey(weaponName)]
                if weaponInfo and weaponInfo.caliber then
                    caliber = weaponInfo.caliber
                    break
                end
            end
        end

        -- Get the ammo item name for this caliber/type
        local ammoType = newMag.metadata.ammoType
        local ammoConfig = caliber and Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][ammoType]

        if ammoConfig and ammoConfig.item then
            -- Return excess as loose ammo
            ox_inventory:AddItem(source, ammoConfig.item, excessRounds)
        end

        -- Return empty magazine (the loaded magazine is now empty after transferring rounds)
        ox_inventory:AddItem(source, newMag.item, 1)  -- No metadata = empty = stackable
    end

    -- Apply new magazine (with clamped count)
    TriggerClientEvent('ammo:magazineEquipped', source, {
        weaponHash = data.weaponHash,
        magazineItem = newMag.item,
        ammoType = newMag.metadata.ammoType,
        count = actualLoad,  -- Only load what weapon can hold
    })
end)

-- ============================================================================
-- RETURN EMPTY MAGAZINE
-- ============================================================================

--[[
    Return an empty magazine to inventory (no ammo remaining)
]]
RegisterNetEvent('ammo:returnEmptyMagazine', function(data)
    local source = source

    if not data.magazineItem then return end

    -- Add empty magazine (no metadata = stackable)
    ox_inventory:AddItem(source, data.magazineItem, 1)

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Magazine Empty',
        description = 'Empty magazine returned to inventory',
        type = 'inform'
    })
end)

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

--[[
    Get weapon hash from name (server-side utility)
]]
function GetHashKey(name)
    return joaat(name)
end

--[[
    joaat hash function
]]
function joaat(s)
    local hash = 0
    s = string.lower(s)
    for i = 1, #s do
        hash = hash + string.byte(s, i)
        hash = hash + (hash << 10)
        hash = hash ~ (hash >> 6)
    end
    hash = hash + (hash << 3)
    hash = hash ~ (hash >> 11)
    hash = hash + (hash << 15)

    -- Convert to signed 32-bit integer
    if hash >= 2147483648 then
        hash = hash - 4294967296
    end

    return hash
end

-- ============================================================================
-- WEAPON MODIFICATIONS (Switches, Bump Stocks, Binary Triggers)
-- ============================================================================
--[[
    NOTE: Weapon conversion (G26 → G26_SWITCH) is DEPRECATED.

    The selective fire system now handles fire mode changes via component detection:
    - Player attaches COMPONENT_G26_SWITCH to WEAPON_G26
    - Selective fire system detects component via HasPedGotWeaponComponent()
    - Fire modes unlock: SEMI → SEMI/FULL
    - No weapon swap required, attachment is reversible

    See: free_selectivefire/shared/config.lua for modification component definitions
]]

-- ============================================================================
-- ADMIN COMMANDS (for testing)
-- ============================================================================

if Config.Debug then
    RegisterCommand('givemag', function(source, args)
        if source == 0 then return end -- Console only

        local magName = args[1]
        local count = tonumber(args[2]) or 1

        if Config.Magazines[magName] then
            ox_inventory:AddItem(source, magName, count)
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Admin',
                description = string.format('Given %dx %s', count, magName),
                type = 'success'
            })
        else
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Error',
                description = 'Unknown magazine: ' .. tostring(magName),
                type = 'error'
            })
        end
    end, true) -- Admin only
end
