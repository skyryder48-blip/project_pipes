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

    -- Apply new ammo
    TriggerClientEvent('ammo:speedloaderEquipped', source, {
        weaponHash = data.weaponHash,
        speedloaderItem = sl.item,
        ammoType = sl.metadata.ammoType,
        count = actualLoad,
    })
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
