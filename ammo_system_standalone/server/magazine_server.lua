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
]]
RegisterNetEvent('ammo:equipMagazine', function(data)
    local source = source

    if not data.newMagazine or not data.weaponHash then
        return
    end

    local newMag = data.newMagazine
    local currentMag = data.currentMagazine

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
        local magInfo = Config.Magazines[currentMag.item]
        local metadata = nil

        if currentMag.count and currentMag.count > 0 then
            -- Return with remaining ammo
            metadata = {
                ammoType = currentMag.ammoType,
                count = currentMag.count,
                maxCount = magInfo and magInfo.capacity or currentMag.count,
                label = string.format('%s (%d/%d %s)',
                    magInfo and magInfo.label or currentMag.item,
                    currentMag.count,
                    magInfo and magInfo.capacity or currentMag.count,
                    string.upper(currentMag.ammoType)
                ),
            }
        end
        -- Empty mags have no metadata (stackable)

        ox_inventory:AddItem(source, currentMag.item, 1, metadata)
    end

    -- Tell client to apply the new magazine
    TriggerClientEvent('ammo:magazineEquipped', source, {
        weaponHash = data.weaponHash,
        magazineItem = newMag.item,
        ammoType = newMag.metadata.ammoType,
        count = newMag.metadata.count,
    })
end)

-- ============================================================================
-- COMBAT RELOAD
-- ============================================================================

--[[
    Handle combat reload - swap magazines during fight
]]
RegisterNetEvent('ammo:combatReload', function(data)
    local source = source

    if not data.newMagazine or not data.weaponHash then
        return
    end

    local newMag = data.newMagazine
    local emptyMag = data.emptyMagazine

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

    -- Apply new magazine
    TriggerClientEvent('ammo:magazineEquipped', source, {
        weaponHash = data.weaponHash,
        magazineItem = newMag.item,
        ammoType = newMag.metadata.ammoType,
        count = newMag.metadata.count,
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
-- WEAPON SWITCH CONVERSION (e.g., G26 -> G26_SWITCH)
-- ============================================================================

--[[
    Convert a weapon to its switch variant
    Example: Player uses 'glock_switch' item on WEAPON_G26 -> WEAPON_G26_SWITCH
]]
RegisterNetEvent('ammo:convertWeaponSwitch', function(data)
    local source = source

    if not data.baseWeapon or not data.switchItem or not data.targetWeapon then
        return
    end

    -- Check player has the switch item
    local switchCount = ox_inventory:Search(source, 'count', data.switchItem)
    if switchCount <= 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Switch not found in inventory',
            type = 'error'
        })
        return
    end

    -- Check player has the base weapon
    local hasWeapon = ox_inventory:Search(source, 'count', data.baseWeapon)
    if hasWeapon <= 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Compatible weapon not equipped',
            type = 'error'
        })
        return
    end

    -- Remove the switch item (consumed - permanent modification)
    ox_inventory:RemoveItem(source, data.switchItem, 1)

    -- Remove the base weapon
    ox_inventory:RemoveItem(source, data.baseWeapon, 1)

    -- Add the converted weapon
    ox_inventory:AddItem(source, data.targetWeapon, 1)

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Weapon Modified',
        description = 'Switch installed - weapon is now full-auto',
        type = 'success'
    })

    -- Trigger client to update weapon
    TriggerClientEvent('ammo:weaponConverted', source, {
        oldWeapon = data.baseWeapon,
        newWeapon = data.targetWeapon,
    })
end)

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
