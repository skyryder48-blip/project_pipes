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
-- EQUIPPED STATE PERSISTENCE
-- ============================================================================
-- When a magazine/speedloader is removed from inventory and equipped to a
-- weapon, it's tracked here so it can be returned on disconnect or resource
-- stop. The client syncs updated ammo counts periodically.

local playerEquippedMags = {}         -- [playerId] = { [weaponHash] = { item, ammoType, count, maxCount, weaponSlot } }
local playerEquippedSpeedloaders = {} -- [playerId] = { [weaponHash] = { item, ammoType, count, weaponSlot } }

-- ============================================================================
-- WEAPON METADATA PERSISTENCE
-- ============================================================================
-- Persist equipped magazine/speedloader data into the weapon item's ox_inventory
-- metadata so it survives server restarts and crashes. The weapon's metadata is
-- saved to the database by ox_inventory, so even if the server crashes without
-- running onResourceStop, the data is preserved.

local function PersistMagToWeapon(playerId, weaponHash, weaponSlot, magData)
    if not weaponSlot then return false end

    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo or not weaponInfo.componentBase then return false end

    local weaponItemName = string.lower(weaponInfo.componentBase:gsub('COMPONENT_', 'WEAPON_'))

    local ok, result = pcall(function()
        return ox_inventory:Search(playerId, 'slots', weaponItemName)
    end)

    if not ok or not result then return false end

    -- Find the item at the specific inventory slot
    for _, slotData in pairs(result) do
        if slotData.slot == weaponSlot then
            local meta = slotData.metadata or {}
            if magData then
                meta.equippedMag = {
                    item = magData.item,
                    ammoType = magData.ammoType,
                    count = magData.count,
                    maxCount = magData.maxCount,
                    kind = magData.kind or 'magazine',
                }
            else
                meta.equippedMag = nil
            end

            local setOk = pcall(function()
                ox_inventory:SetMetadata(playerId, weaponSlot, meta)
            end)
            return setOk
        end
    end

    return false
end

local function ClearMagFromWeapon(playerId, weaponHash, weaponSlot)
    PersistMagToWeapon(playerId, weaponHash, weaponSlot, nil)
end

-- ============================================================================
-- TRACKING FUNCTIONS
-- ============================================================================

local function TrackEquippedMagazine(playerId, weaponHash, data)
    if not playerEquippedMags[playerId] then
        playerEquippedMags[playerId] = {}
    end
    playerEquippedMags[playerId][weaponHash] = data
    -- Persist to weapon metadata for crash/restart safety
    if data.weaponSlot then
        PersistMagToWeapon(playerId, weaponHash, data.weaponSlot, data)
    end
end

local function UntrackEquippedMagazine(playerId, weaponHash)
    if playerEquippedMags[playerId] then
        local data = playerEquippedMags[playerId][weaponHash]
        if data and data.weaponSlot then
            ClearMagFromWeapon(playerId, weaponHash, data.weaponSlot)
        end
        playerEquippedMags[playerId][weaponHash] = nil
    end
end

local function TrackEquippedSpeedloader(playerId, weaponHash, data)
    if not playerEquippedSpeedloaders[playerId] then
        playerEquippedSpeedloaders[playerId] = {}
    end
    playerEquippedSpeedloaders[playerId][weaponHash] = data
    -- Persist to weapon metadata for crash/restart safety
    if data.weaponSlot then
        PersistMagToWeapon(playerId, weaponHash, data.weaponSlot, {
            item = data.item,
            ammoType = data.ammoType,
            count = data.count,
            maxCount = data.count,
            kind = 'speedloader',
        })
    end
end

local function UntrackEquippedSpeedloader(playerId, weaponHash)
    if playerEquippedSpeedloaders[playerId] then
        local data = playerEquippedSpeedloaders[playerId][weaponHash]
        if data and data.weaponSlot then
            ClearMagFromWeapon(playerId, weaponHash, data.weaponSlot)
        end
        playerEquippedSpeedloaders[playerId][weaponHash] = nil
    end
end

-- Return all equipped magazines and speedloader rounds to a player's inventory.
-- Called on disconnect and resource stop.
local function ReturnEquippedToInventory(playerId)
    local mags = playerEquippedMags[playerId]
    if mags then
        for weaponHash, magData in pairs(mags) do
            -- Clear persisted state from weapon metadata since magazine is
            -- being returned to inventory as a separate item
            if magData.weaponSlot then
                ClearMagFromWeapon(playerId, weaponHash, magData.weaponSlot)
            end

            local magInfo = Config.Magazines[magData.item]
            if magData.count and magData.count > 0 then
                local metadata = {
                    ammoType = magData.ammoType,
                    count = magData.count,
                    maxCount = magData.maxCount or (magInfo and magInfo.capacity) or magData.count,
                    label = string.format('%s (%d/%d %s)',
                        magInfo and magInfo.label or magData.item,
                        magData.count,
                        magData.maxCount or (magInfo and magInfo.capacity) or magData.count,
                        string.upper(magData.ammoType or 'fmj')
                    ),
                }
                ox_inventory:AddItem(playerId, magData.item, 1, metadata)
            else
                -- Empty magazine - no metadata (stackable)
                ox_inventory:AddItem(playerId, magData.item, 1)
            end
        end
        playerEquippedMags[playerId] = nil
    end

    local sls = playerEquippedSpeedloaders[playerId]
    if sls then
        for weaponHash, slData in pairs(sls) do
            -- Clear persisted state from weapon metadata
            if slData.weaponSlot then
                ClearMagFromWeapon(playerId, weaponHash, slData.weaponSlot)
            end

            if slData.count and slData.count > 0 then
                -- Return remaining cylinder rounds as loose ammo
                local weaponInfo = Config.Weapons[weaponHash]
                if weaponInfo then
                    local ammoConfig = Config.AmmoTypes[weaponInfo.caliber]
                        and Config.AmmoTypes[weaponInfo.caliber][slData.ammoType]
                    if ammoConfig and ammoConfig.item then
                        ox_inventory:AddItem(playerId, ammoConfig.item, slData.count)
                    end
                end
            end
        end
        playerEquippedSpeedloaders[playerId] = nil
    end
end

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
-- MAGAZINE FILL (TOP OFF)
-- ============================================================================

--[[
    Fill a partially loaded magazine to capacity using the same ammo type.
    Removes the partial magazine and loose ammo, returns a fuller magazine.
]]
RegisterNetEvent('ammo:fillMagazine', function(data)
    local source = source

    if not data.magazineItem or not data.ammoItem or not data.fillAmount or not data.currentCount then
        return
    end

    local magInfo = Config.Magazines[data.magazineItem]
    if not magInfo then return end

    local fillAmount = math.min(data.fillAmount, data.maxCapacity - data.currentCount)
    if fillAmount <= 0 then return end

    -- Check player has enough loose ammo
    local ammoCount = ox_inventory:Search(source, 'count', data.ammoItem)
    if ammoCount < fillAmount then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Not enough ammunition',
            type = 'error'
        })
        return
    end

    -- Remove the partially loaded magazine
    local removed = ox_inventory:RemoveItem(source, data.magazineItem, 1, nil, data.magazineSlot)
    if not removed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to access magazine',
            type = 'error'
        })
        return
    end

    -- Remove the loose ammo
    local ammoRemoved = ox_inventory:RemoveItem(source, data.ammoItem, fillAmount)
    if not ammoRemoved then
        -- Refund the magazine with its original metadata
        local refundMeta = {
            ammoType = data.ammoType,
            count = data.currentCount,
            maxCount = data.maxCapacity,
            label = string.format('%s (%d/%d %s)', magInfo.label, data.currentCount, data.maxCapacity, string.upper(data.ammoType)),
        }
        ox_inventory:AddItem(source, data.magazineItem, 1, refundMeta)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to access ammunition',
            type = 'error'
        })
        return
    end

    -- Create the topped-off magazine
    local newCount = data.currentCount + fillAmount
    local metadata = {
        ammoType = data.ammoType,
        count = newCount,
        maxCount = data.maxCapacity,
        label = string.format('%s (%d/%d %s)', magInfo.label, newCount, data.maxCapacity, string.upper(data.ammoType)),
    }

    local added = ox_inventory:AddItem(source, data.magazineItem, 1, metadata)
    if added then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Magazine Filled',
            description = string.format('Added %d rounds (%d/%d %s)', fillAmount, newCount, data.maxCapacity, string.upper(data.ammoType)),
            type = 'success'
        })
    else
        -- Refund everything
        local refundMeta = {
            ammoType = data.ammoType,
            count = data.currentCount,
            maxCount = data.maxCapacity,
            label = string.format('%s (%d/%d %s)', magInfo.label, data.currentCount, data.maxCapacity, string.upper(data.ammoType)),
        }
        ox_inventory:AddItem(source, data.magazineItem, 1, refundMeta)
        ox_inventory:AddItem(source, data.ammoItem, fillAmount)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to create filled magazine',
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

    if not data.magazineItem or not data.ammoType or not data.ammoItem or not data.count then
        return
    end

    local magInfo = Config.Magazines[data.magazineItem]
    if not magInfo then return end

    -- Determine how many rounds to unload (default: all)
    local unloadAmount = data.unloadAmount or data.count
    unloadAmount = math.min(unloadAmount, data.count)  -- Can't unload more than magazine has
    local remaining = data.count - unloadAmount

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

    if remaining > 0 then
        -- Partial unload: return magazine with remaining rounds
        local metadata = {
            ammoType = data.ammoType,
            count = remaining,
            maxCount = magInfo.capacity,
            label = string.format('%s (%d/%d %s)', magInfo.label, remaining, magInfo.capacity, string.upper(data.ammoType)),
        }
        ox_inventory:AddItem(source, data.magazineItem, 1, metadata)
    else
        -- Full unload: return empty magazine (no metadata = stackable)
        ox_inventory:AddItem(source, data.magazineItem, 1)
    end

    -- Add unloaded rounds as loose ammo
    ox_inventory:AddItem(source, data.ammoItem, unloadAmount)

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Magazine Unloaded',
        description = string.format('Recovered %d %s rounds%s', unloadAmount, string.upper(data.ammoType),
            remaining > 0 and string.format(' (%d remaining)', remaining) or ''),
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

    -- Calculate how many rounds the weapon's clip can accept from the new magazine
    local takenFromMag = math.min(magazineRounds, weaponClipSize)
    local excessRounds = magazineRounds - takenFromMag

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

    -- Chambered round: either already in the weapon from a prior eject
    -- (client sends hasChamberedRound), or created now if the old magazine
    -- had rounds (1 stays in the chamber, returned mag gets count - 1).
    local hasChamberedRound = data.hasChamberedRound or false

    if currentMag and currentMag.item then
        local currentMagInfo = Config.Magazines[currentMag.item]
        local metadata = nil
        local returnCount = currentMag.count or 0

        if returnCount > 0 then
            hasChamberedRound = true
            returnCount = returnCount - 1  -- 1 round stays chambered
        end

        if returnCount > 0 then
            -- Return with remaining ammo (minus chambered round)
            metadata = {
                ammoType = currentMag.ammoType,
                count = returnCount,
                maxCount = currentMagInfo and currentMagInfo.capacity or returnCount,
                label = string.format('%s (%d/%d %s)',
                    currentMagInfo and currentMagInfo.label or currentMag.item,
                    returnCount,
                    currentMagInfo and currentMagInfo.capacity or returnCount,
                    string.upper(currentMag.ammoType)
                ),
            }
        end
        -- Empty mags (returnCount == 0) have no metadata (stackable)

        ox_inventory:AddItem(source, currentMag.item, 1, metadata)
    end

    -- Total rounds loaded: magazine rounds + chambered round (if applicable)
    local actualLoad = takenFromMag + (hasChamberedRound and 1 or 0)

    -- If there are excess rounds that couldn't fit in the weapon,
    -- return them as LOOSE AMMO only (magazine is now IN the weapon)
    if excessRounds > 0 then
        -- Get the caliber from the magazine's compatible weapons
        local caliber = nil
        if magInfo and magInfo.weapons then
            for _, weaponName in ipairs(magInfo.weapons) do
                local wHash = Config._WeaponNameToHash[weaponName]
                local weaponInfo = wHash and Config.Weapons[wHash]
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

        -- NOTE: Do NOT return empty magazine here!
        -- The magazine is now physically inside the weapon.
        -- It only comes back when player reloads/swaps magazines.
    end

    -- Track equipped magazine for disconnect persistence
    TrackEquippedMagazine(source, data.weaponHash, {
        item = newMag.item,
        ammoType = newMag.metadata.ammoType,
        count = actualLoad,
        maxCount = magInfo and magInfo.capacity or actualLoad,
        weaponSlot = data.weaponSlot,
    })

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
    local currentMag = data.currentMagazine  -- Contains actual remaining ammo count
    local weaponClipSize = data.weaponClipSize or 999  -- Fallback if not provided

    local magInfo = Config.Magazines[newMag.item]
    local magazineRounds = newMag.metadata.count or 0

    -- Calculate how many rounds the weapon's clip can accept from the new magazine
    local takenFromMag = math.min(magazineRounds, weaponClipSize)
    local excessRounds = magazineRounds - takenFromMag

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

    -- Chambered round: either already in the weapon from a prior eject
    -- (client sends hasChamberedRound), or created now if the old magazine
    -- had rounds (1 stays in the chamber, returned mag gets count - 1).
    local hasChamberedRound = data.hasChamberedRound or false

    if currentMag and currentMag.item then
        local currentMagInfo = Config.Magazines[currentMag.item]
        local returnCount = currentMag.count or 0

        if returnCount > 0 then
            hasChamberedRound = true
            returnCount = returnCount - 1  -- 1 round stays chambered
        end

        if returnCount > 0 then
            -- Return magazine with remaining ammo (minus chambered round)
            local metadata = {
                ammoType = currentMag.ammoType,
                count = returnCount,
                maxCount = currentMagInfo and currentMagInfo.capacity or returnCount,
                label = string.format('%s (%d/%d %s)',
                    currentMagInfo and currentMagInfo.label or currentMag.item,
                    returnCount,
                    currentMagInfo and currentMagInfo.capacity or returnCount,
                    string.upper(currentMag.ammoType or 'fmj')
                ),
            }
            ox_inventory:AddItem(source, currentMag.item, 1, metadata)
        else
            -- Empty magazine - no metadata (stackable)
            ox_inventory:AddItem(source, currentMag.item, 1)
        end
    end

    -- Total rounds loaded: magazine rounds + chambered round (if applicable)
    local actualLoad = takenFromMag + (hasChamberedRound and 1 or 0)

    -- If there are excess rounds that couldn't fit in the weapon,
    -- return them as LOOSE AMMO only (magazine is now IN the weapon)
    if excessRounds > 0 then
        -- Get the caliber from the magazine's compatible weapons
        local caliber = nil
        if magInfo and magInfo.weapons then
            for _, weaponName in ipairs(magInfo.weapons) do
                local wHash = Config._WeaponNameToHash[weaponName]
                local weaponInfo = wHash and Config.Weapons[wHash]
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
    end

    -- Track equipped magazine for disconnect persistence
    TrackEquippedMagazine(source, data.weaponHash, {
        item = newMag.item,
        ammoType = newMag.metadata.ammoType,
        count = actualLoad,
        maxCount = magInfo and magInfo.capacity or actualLoad,
        weaponSlot = data.weaponSlot,
    })

    -- Apply new magazine (with clamped count, includes chambered round)
    TriggerClientEvent('ammo:magazineEquipped', source, {
        weaponHash = data.weaponHash,
        magazineItem = newMag.item,
        ammoType = newMag.metadata.ammoType,
        count = actualLoad,  -- Clip rounds + chambered round
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

    -- Untrack: empty magazine is being returned to inventory
    if data.weaponHash then
        UntrackEquippedMagazine(source, data.weaponHash)
    end

    -- Add empty magazine (no metadata = stackable)
    ox_inventory:AddItem(source, data.magazineItem, 1)

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Magazine Empty',
        description = 'Empty magazine returned to inventory',
        type = 'inform'
    })
end)

-- ============================================================================
-- MANUAL MAGAZINE EJECT
-- ============================================================================

--[[
    Manually eject magazine from weapon (player-initiated)
    Returns magazine to inventory with current ammo count preserved.
    This allows single-magazine players to reload their only mag.
]]
RegisterNetEvent('ammo:ejectMagazine', function(data)
    local source = source

    if not data.magazineItem then return end

    -- Untrack: magazine is being returned to inventory
    if data.weaponHash then
        UntrackEquippedMagazine(source, data.weaponHash)
    end

    local magInfo = Config.Magazines[data.magazineItem]
    local roundCount = data.count or 0

    if roundCount > 0 then
        -- Magazine has ammo - return with metadata
        local metadata = {
            ammoType = data.ammoType,
            count = roundCount,
            maxCount = magInfo and magInfo.capacity or roundCount,
            label = string.format('%s (%d/%d %s)',
                magInfo and magInfo.label or data.magazineItem,
                roundCount,
                magInfo and magInfo.capacity or roundCount,
                string.upper(data.ammoType or 'fmj')
            ),
        }
        ox_inventory:AddItem(source, data.magazineItem, 1, metadata)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Magazine Ejected',
            description = string.format('Magazine returned with %d rounds', roundCount),
            type = 'success'
        })
    else
        -- Empty magazine - no metadata (stackable)
        ox_inventory:AddItem(source, data.magazineItem, 1)

        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Magazine Ejected',
            description = 'Empty magazine returned to inventory',
            type = 'inform'
        })
    end
end)

-- ============================================================================
-- SPEEDLOADER SYSTEM (Revolvers)
-- ============================================================================

--[[
    Load ammo into an empty speedloader
    Speedloaders are always fully loaded (all cylinder rounds at once)
]]
RegisterNetEvent('ammo:loadSpeedloader', function(data)
    local source = source

    if not data.speedloaderItem or not data.ammoItem or not data.capacity then
        return
    end

    local slInfo = Config.Speedloaders[data.speedloaderItem]
    if not slInfo then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Invalid speedloader type',
            type = 'error'
        })
        return
    end

    -- Check player has the speedloader
    local slCount = ox_inventory:Search(source, 'count', data.speedloaderItem)
    if slCount <= 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Speedloader not found in inventory',
            type = 'error'
        })
        return
    end

    -- Check player has enough ammo (need full cylinder)
    local ammoCount = ox_inventory:Search(source, 'count', data.ammoItem)
    local loadAmount = math.min(data.capacity, ammoCount)

    if loadAmount <= 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Not enough ammunition',
            type = 'error'
        })
        return
    end

    -- Remove empty speedloader
    local removed = ox_inventory:RemoveItem(source, data.speedloaderItem, 1, nil, data.speedloaderSlot)
    if not removed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to access speedloader',
            type = 'error'
        })
        return
    end

    -- Remove ammo
    local ammoRemoved = ox_inventory:RemoveItem(source, data.ammoItem, loadAmount)
    if not ammoRemoved then
        ox_inventory:AddItem(source, data.speedloaderItem, 1)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to access ammunition',
            type = 'error'
        })
        return
    end

    -- Add loaded speedloader with metadata
    local metadata = {
        ammoType = data.ammoType,
        count = loadAmount,
        maxCount = data.capacity,
        label = string.format('%s (%d/%d %s)', slInfo.label, loadAmount, data.capacity, string.upper(data.ammoType)),
    }

    local added = ox_inventory:AddItem(source, data.speedloaderItem, 1, metadata)
    if added then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Speedloader Loaded',
            description = string.format('Loaded %d %s rounds', loadAmount, string.upper(data.ammoType)),
            type = 'success'
        })
    else
        ox_inventory:AddItem(source, data.speedloaderItem, 1)
        ox_inventory:AddItem(source, data.ammoItem, loadAmount)
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to create loaded speedloader',
            type = 'error'
        })
    end
end)

--[[
    Unload ammo from a loaded speedloader back to loose rounds
]]
RegisterNetEvent('ammo:unloadSpeedloader', function(data)
    local source = source

    if not data.speedloaderItem or not data.ammoType or not data.ammoItem or not data.count then
        return
    end

    local slInfo = Config.Speedloaders[data.speedloaderItem]
    if not slInfo then return end

    -- Remove loaded speedloader
    local removed = ox_inventory:RemoveItem(source, data.speedloaderItem, 1, nil, data.speedloaderSlot)
    if not removed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to access speedloader',
            type = 'error'
        })
        return
    end

    -- Add empty speedloader back
    ox_inventory:AddItem(source, data.speedloaderItem, 1)

    -- Add loose ammo (ammo item resolved by client)
    ox_inventory:AddItem(source, data.ammoItem, data.count)

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Speedloader Unloaded',
        description = string.format('Recovered %d %s rounds', data.count, string.upper(data.ammoType)),
        type = 'success'
    })
end)

--[[
    Equip speedloader to revolver - dump rounds into cylinder
]]
RegisterNetEvent('ammo:equipSpeedloader', function(data)
    local source = source

    if not data.speedloader or not data.weaponHash then
        return
    end

    local sl = data.speedloader
    local weaponClipSize = data.weaponClipSize or 999

    local slInfo = Config.Speedloaders[sl.item]
    local slRounds = sl.metadata.count or 0
    local actualLoad = math.min(slRounds, weaponClipSize)

    -- Remove loaded speedloader from inventory
    local removed = ox_inventory:RemoveItem(source, sl.item, 1, nil, sl.slot)
    if not removed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Failed to access speedloader',
            type = 'error'
        })
        return
    end

    -- Return empty speedloader to inventory (no metadata = stackable)
    ox_inventory:AddItem(source, sl.item, 1)

    -- Track equipped speedloader rounds for disconnect persistence
    TrackEquippedSpeedloader(source, data.weaponHash, {
        item = sl.item,
        ammoType = sl.metadata.ammoType,
        count = actualLoad,
        weaponSlot = data.weaponSlot,
    })

    -- Tell client to apply the ammo
    TriggerClientEvent('ammo:speedloaderEquipped', source, {
        weaponHash = data.weaponHash,
        speedloaderItem = sl.item,
        ammoType = sl.metadata.ammoType,
        count = actualLoad,
    })
end)

--[[
    Combat reload with speedloader - automatic reload when cylinder empties
]]
RegisterNetEvent('ammo:combatReloadSpeedloader', function(data)
    local source = source

    if not data.newSpeedloader or not data.weaponHash then
        return
    end

    local sl = data.newSpeedloader
    local weaponClipSize = data.weaponClipSize or 999

    local slRounds = sl.metadata.count or 0
    local actualLoad = math.min(slRounds, weaponClipSize)

    -- Remove loaded speedloader
    local removed = ox_inventory:RemoveItem(source, sl.item, 1, nil, sl.slot)
    if not removed then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Reload Failed',
            description = 'Speedloader not available',
            type = 'error'
        })
        return
    end

    -- Return empty speedloader
    ox_inventory:AddItem(source, sl.item, 1)

    -- Track equipped speedloader rounds for disconnect persistence
    TrackEquippedSpeedloader(source, data.weaponHash, {
        item = sl.item,
        ammoType = sl.metadata.ammoType,
        count = actualLoad,
        weaponSlot = data.weaponSlot,
    })

    -- Apply new ammo
    TriggerClientEvent('ammo:speedloaderEquipped', source, {
        weaponHash = data.weaponHash,
        speedloaderItem = sl.item,
        ammoType = sl.metadata.ammoType,
        count = actualLoad,
    })
end)

-- ============================================================================
-- EQUIPPED STATE SYNC AND PERSISTENCE
-- ============================================================================

--[[
    Cylinder emptied with no speedloaders available - untrack so disconnect
    doesn't return phantom ammo.
]]
RegisterNetEvent('ammo:clearEquippedSpeedloader', function(data)
    local source = source
    if data.weaponHash then
        UntrackEquippedSpeedloader(source, data.weaponHash)
    end
end)

--[[
    Client periodically syncs its tracked ammo counts so the server has
    up-to-date data for disconnect persistence.
    Also persists updated counts to weapon metadata for crash safety.
]]
RegisterNetEvent('ammo:syncEquippedState', function(data)
    local source = source

    if data.magazines then
        playerEquippedMags[source] = data.magazines
        -- Persist updated counts to weapon metadata
        for weaponHash, magData in pairs(data.magazines) do
            if magData.weaponSlot then
                PersistMagToWeapon(source, weaponHash, magData.weaponSlot, magData)
            end
        end
    end

    if data.speedloaders then
        playerEquippedSpeedloaders[source] = data.speedloaders
        -- Persist updated counts to weapon metadata
        for weaponHash, slData in pairs(data.speedloaders) do
            if slData.weaponSlot then
                PersistMagToWeapon(source, weaponHash, slData.weaponSlot, {
                    item = slData.item,
                    ammoType = slData.ammoType,
                    count = slData.count,
                    maxCount = slData.count,
                    kind = 'speedloader',
                })
            end
        end
    end
end)

--[[
    Client detected persisted magazine data in weapon metadata after a
    server restart. Restore server-side tracking so disconnect persistence
    and ammo management continue to work correctly.
]]
RegisterNetEvent('ammo:restoreEquippedState', function(data)
    local source = source

    if not data.weaponHash or not data.equippedMag then return end

    local savedMag = data.equippedMag
    if savedMag.kind == 'speedloader' then
        TrackEquippedSpeedloader(source, data.weaponHash, {
            item = savedMag.item,
            ammoType = savedMag.ammoType,
            count = savedMag.count,
            weaponSlot = data.weaponSlot,
        })
    else
        TrackEquippedMagazine(source, data.weaponHash, {
            item = savedMag.item,
            ammoType = savedMag.ammoType,
            count = savedMag.count,
            maxCount = savedMag.maxCount,
            weaponSlot = data.weaponSlot,
        })
    end

    if Config.Debug then
        print(('[AMMO] Restored equipped state for player %s weapon %s from weapon metadata'):format(source, data.weaponHash))
    end
end)

--[[
    Return all equipped magazines/ammo to inventory when player disconnects.
]]
AddEventHandler('playerDropped', function()
    local source = source
    ReturnEquippedToInventory(source)
end)

--[[
    Return all equipped items for ALL players on resource stop (server restart).
]]
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for playerId, _ in pairs(playerEquippedMags) do
        ReturnEquippedToInventory(playerId)
    end
    -- Also catch any players only in speedloader table
    for playerId, _ in pairs(playerEquippedSpeedloaders) do
        if not playerEquippedMags[playerId] then
            ReturnEquippedToInventory(playerId)
        end
    end
end)

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

-- NOTE: GetHashKey and joaat are provided by FiveM as built-in functions.
-- Custom implementations were removed because lua54's 64-bit integers
-- cause incorrect hashes without proper 32-bit masking at each step.

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
