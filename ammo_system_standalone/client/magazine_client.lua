--[[
    Magazine System - Client
    =========================

    Full Realistic Magazine Management:
    - Load magazines with ammo directly from inventory
    - Unload magazines back to loose ammo
    - Equip/swap magazines on weapons
    - Combat reload management with pre-loaded magazines
]]

local currentMagazine = nil -- Currently equipped magazine data
local equippedMagazines = {} -- Per-weapon equipped magazine tracking

-- ============================================================================
-- MAGAZINE LOADING (From Inventory)
-- ============================================================================

--[[
    Load ammo into an empty magazine
    Called when player right-clicks empty magazine in inventory

    @param magazineItem - The magazine item name (e.g., 'mag_g26_extended')
    @param magazineSlot - The inventory slot of the magazine
]]
function LoadMagazine(magazineItem, magazineSlot)
    local magInfo = Config.Magazines[magazineItem]
    if not magInfo then
        lib.notify({ title = 'Error', description = 'Unknown magazine type', type = 'error' })
        return
    end

    -- Get the caliber for this magazine's compatible weapons
    local caliber = nil
    for _, weaponName in ipairs(magInfo.weapons) do
        local weaponInfo = Config.Weapons[GetHashKey(weaponName)]
        if weaponInfo then
            caliber = weaponInfo.caliber
            break
        end
    end

    if not caliber then
        lib.notify({ title = 'Error', description = 'Cannot determine ammo type', type = 'error' })
        return
    end

    -- Get available ammo types for this caliber
    local ammoTypes = Config.AmmoTypes[caliber]
    if not ammoTypes then
        lib.notify({ title = 'Error', description = 'No ammo types for this caliber', type = 'error' })
        return
    end

    -- Build options menu for ammo selection
    local options = {}
    for ammoType, ammoConfig in pairs(ammoTypes) do
        -- Check player's inventory for this ammo type
        local ammoCount = exports.ox_inventory:Search('count', ammoConfig.item)
        if ammoCount > 0 then
            table.insert(options, {
                title = ammoConfig.label,
                description = string.format('Available: %d rounds', ammoCount),
                icon = 'bullet',
                arrow = true,
                args = {
                    magazineItem = magazineItem,
                    magazineSlot = magazineSlot,
                    ammoType = ammoType,
                    ammoItem = ammoConfig.item,
                    maxCapacity = magInfo.capacity,
                    available = ammoCount,
                }
            })
        end
    end

    if #options == 0 then
        lib.notify({ title = 'No Ammo', description = 'You have no compatible ammunition', type = 'error' })
        return
    end

    -- Show ammo selection menu
    lib.registerContext({
        id = 'magazine_load_ammo',
        title = 'Load Magazine - Select Ammo',
        options = options,
        onSelect = function(selected, args)
            SelectLoadAmount(args)
        end
    })

    lib.showContext('magazine_load_ammo')
end

--[[
    Select how many rounds to load
]]
function SelectLoadAmount(args)
    local maxLoad = math.min(args.maxCapacity, args.available)

    -- Quick load options
    local options = {
        {
            title = 'Load Full (' .. maxLoad .. ' rounds)',
            description = string.format('Load maximum %d rounds', maxLoad),
            args = { amount = maxLoad, base = args }
        },
    }

    -- Add partial load options
    if maxLoad > 10 then
        table.insert(options, {
            title = 'Load Half (' .. math.floor(maxLoad / 2) .. ' rounds)',
            args = { amount = math.floor(maxLoad / 2), base = args }
        })
    end

    if Config.MagazineSystem.allowPartialLoad then
        table.insert(options, {
            title = 'Custom Amount...',
            description = 'Enter specific number of rounds',
            args = { amount = 'custom', base = args }
        })
    end

    lib.registerContext({
        id = 'magazine_load_amount',
        title = 'Load ' .. args.magazineItem,
        menu = 'magazine_load_ammo',
        options = options,
        onSelect = function(selected, data)
            if data.amount == 'custom' then
                local input = lib.inputDialog('Load Magazine', {
                    { type = 'number', label = 'Rounds to Load', default = maxLoad, min = 1, max = maxLoad }
                })
                if input and input[1] then
                    PerformMagazineLoad(data.base, input[1])
                end
            else
                PerformMagazineLoad(data.base, data.amount)
            end
        end
    })

    lib.showContext('magazine_load_amount')
end

--[[
    Actually perform the magazine loading with progress bar
]]
function PerformMagazineLoad(args, amount)
    local loadTime = amount * Config.MagazineSystem.loadTimePerRound * 1000

    -- Progress bar for loading
    if lib.progressCircle({
        duration = loadTime,
        label = 'Loading magazine...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = false,
            combat = true,
        },
        anim = {
            dict = 'weapons@pistol@',
            clip = 'reload_aim',
        },
    }) then
        -- Success - trigger server to update inventory
        TriggerServerEvent('ammo:loadMagazine', {
            magazineItem = args.magazineItem,
            magazineSlot = args.magazineSlot,
            ammoItem = args.ammoItem,
            ammoType = args.ammoType,
            amount = amount,
            maxCapacity = args.maxCapacity,
        })
    else
        lib.notify({ title = 'Cancelled', description = 'Magazine loading cancelled', type = 'error' })
    end
end

-- ============================================================================
-- MAGAZINE UNLOADING
-- ============================================================================

--[[
    Unload ammo from a loaded magazine back to loose rounds
]]
function UnloadMagazine(magazineItem, magazineSlot, metadata)
    if not metadata or not metadata.count or metadata.count <= 0 then
        lib.notify({ title = 'Empty', description = 'Magazine is already empty', type = 'error' })
        return
    end

    local unloadTime = metadata.count * (Config.MagazineSystem.loadTimePerRound * 0.5) * 1000

    if lib.progressCircle({
        duration = unloadTime,
        label = 'Unloading magazine...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = false,
            combat = true,
        },
    }) then
        TriggerServerEvent('ammo:unloadMagazine', {
            magazineItem = magazineItem,
            magazineSlot = magazineSlot,
            ammoType = metadata.ammoType,
            count = metadata.count,
        })
    else
        lib.notify({ title = 'Cancelled', description = 'Unloading cancelled', type = 'error' })
    end
end

-- ============================================================================
-- MAGAZINE EQUIPPING (To Weapon)
-- ============================================================================

--[[
    Equip a loaded magazine to currently held weapon
]]
function EquipMagazine(magazineItem, magazineSlot, metadata)
    local ped = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(ped)

    if currentWeapon == `WEAPON_UNARMED` then
        lib.notify({ title = 'No Weapon', description = 'Equip a weapon first', type = 'error' })
        return
    end

    -- Check compatibility
    if not IsMagazineCompatible(currentWeapon, magazineItem) then
        lib.notify({ title = 'Incompatible', description = 'Magazine does not fit this weapon', type = 'error' })
        return
    end

    -- Check if magazine is loaded
    if not metadata or not metadata.count or metadata.count <= 0 then
        lib.notify({ title = 'Empty', description = 'Magazine is empty - load it first', type = 'error' })
        return
    end

    -- Get current magazine if any (to return to inventory)
    local currentMag = equippedMagazines[currentWeapon]

    -- Calculate swap time based on magazine type
    local magInfo = Config.Magazines[magazineItem]
    local swapTime = Config.MagazineSystem.swapTime[magInfo.type] or 1.5

    if lib.progressCircle({
        duration = swapTime * 1000,
        label = 'Swapping magazine...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
        anim = {
            dict = 'weapons@pistol@',
            clip = 'reload_aim',
        },
    }) then
        TriggerServerEvent('ammo:equipMagazine', {
            weaponHash = currentWeapon,
            newMagazine = {
                item = magazineItem,
                slot = magazineSlot,
                metadata = metadata,
            },
            currentMagazine = currentMag,
        })
    end
end

--[[
    Server callback - Magazine equipped successfully
]]
RegisterNetEvent('ammo:magazineEquipped', function(data)
    local weaponHash = data.weaponHash
    local magInfo = Config.Magazines[data.magazineItem]
    local weaponInfo = Config.Weapons[weaponHash]

    if not magInfo or not weaponInfo then return end

    -- Store equipped magazine data
    equippedMagazines[weaponHash] = {
        item = data.magazineItem,
        ammoType = data.ammoType,
        count = data.count,
        maxCount = magInfo.capacity,
    }

    -- Build and apply the correct weapon component
    local componentName = GetMagazineComponentName(weaponHash, data.magazineItem, data.ammoType)
    if componentName then
        local componentHash = GetHashKey(componentName)

        -- Remove any existing clip components first
        RemoveAllClipComponents(weaponHash)

        -- Apply new component
        GiveWeaponComponentToPed(PlayerPedId(), weaponHash, componentHash)

        -- Set ammo count
        SetPedAmmo(PlayerPedId(), weaponHash, data.count)
    end

    lib.notify({
        title = 'Magazine Loaded',
        description = string.format('%s loaded with %d %s rounds', magInfo.label, data.count, string.upper(data.ammoType)),
        type = 'success'
    })
end)

-- NOTE: RemoveAllClipComponents is now defined in cl_ammo.lua and exported
-- This file uses the shared function from cl_ammo.lua

-- ============================================================================
-- COMBAT RELOAD MANAGEMENT
-- ============================================================================

local isReloading = false

--[[
    Monitor ammo consumption and trigger reloads
]]
CreateThread(function()
    while true do
        Wait(100)

        if Config.MagazineSystem.enabled then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)

            if weapon ~= `WEAPON_UNARMED` and equippedMagazines[weapon] then
                local currentAmmo = GetAmmoInPedWeapon(ped, weapon)
                local magData = equippedMagazines[weapon]

                -- Update tracked count
                if currentAmmo < magData.count then
                    magData.count = currentAmmo

                    -- Magazine empty - need to reload
                    if currentAmmo <= 0 and not isReloading then
                        HandleEmptyMagazine(weapon)
                    end
                end
            end
        end
    end
end)

--[[
    Handle when magazine is emptied in combat
]]
function HandleEmptyMagazine(weaponHash)
    isReloading = true

    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo then
        isReloading = false
        return
    end

    -- Get compatible loaded magazines from inventory
    local loadedMags = GetLoadedMagazinesFromInventory(weaponHash)

    if #loadedMags == 0 then
        lib.notify({
            title = 'No Magazines',
            description = 'No loaded magazines available!',
            type = 'error'
        })
        -- Return empty magazine to inventory
        ReturnEmptyMagazine(weaponHash)
        isReloading = false
        return
    end

    if Config.MagazineSystem.autoReloadFromInventory then
        -- Auto-select best magazine based on priority
        local selectedMag = SelectBestMagazine(loadedMags, equippedMagazines[weaponHash])

        if selectedMag then
            -- Perform automatic reload
            PerformCombatReload(weaponHash, selectedMag)
        end
    else
        -- Show magazine selection menu
        ShowMagazineSelectionMenu(weaponHash, loadedMags)
    end
end

--[[
    Get all loaded magazines compatible with weapon from inventory
]]
function GetLoadedMagazinesFromInventory(weaponHash)
    local loadedMags = {}
    local items = exports.ox_inventory:GetPlayerItems()

    for _, item in ipairs(items) do
        local magInfo = Config.Magazines[item.name]
        if magInfo and IsMagazineCompatible(weaponHash, item.name) then
            -- Check if magazine is loaded (has ammo)
            if item.metadata and item.metadata.count and item.metadata.count > 0 then
                table.insert(loadedMags, {
                    item = item.name,
                    slot = item.slot,
                    metadata = item.metadata,
                    magInfo = magInfo,
                })
            end
        end
    end

    return loadedMags
end

--[[
    Select best magazine based on priority setting
]]
function SelectBestMagazine(loadedMags, currentMag)
    if #loadedMags == 0 then return nil end

    local priority = Config.MagazineSystem.autoReloadPriority

    if priority == 'same_ammo_first' and currentMag then
        -- Prefer same ammo type
        for _, mag in ipairs(loadedMags) do
            if mag.metadata.ammoType == currentMag.ammoType then
                return mag
            end
        end
    elseif priority == 'highest_capacity' then
        -- Sort by capacity
        table.sort(loadedMags, function(a, b)
            return a.metadata.count > b.metadata.count
        end)
    end

    -- Return first available
    return loadedMags[1]
end

--[[
    Perform combat reload with selected magazine
]]
function PerformCombatReload(weaponHash, selectedMag)
    local magInfo = Config.Magazines[selectedMag.item]
    local swapTime = Config.MagazineSystem.swapTime[magInfo.type] or 1.5

    -- Return current empty magazine to inventory first
    local currentMag = equippedMagazines[weaponHash]

    TriggerServerEvent('ammo:combatReload', {
        weaponHash = weaponHash,
        newMagazine = selectedMag,
        emptyMagazine = currentMag and {
            item = currentMag.item,
            ammoType = currentMag.ammoType,
            count = 0, -- Empty
        } or nil,
    })

    -- Play reload animation (handled by game, but we set the timing)
    Wait(swapTime * 1000)

    isReloading = false
end

--[[
    Return empty magazine to inventory
]]
function ReturnEmptyMagazine(weaponHash)
    local currentMag = equippedMagazines[weaponHash]
    if currentMag then
        TriggerServerEvent('ammo:returnEmptyMagazine', {
            magazineItem = currentMag.item,
            ammoType = currentMag.ammoType,
        })
        equippedMagazines[weaponHash] = nil
    end
end

-- ============================================================================
-- INVENTORY CONTEXT MENU INTEGRATION
-- ============================================================================

--[[
    Register context menu options for magazines in ox_inventory
]]
exports('magazineContextMenu', function(data)
    local item = data.item
    local magInfo = Config.Magazines[item.name]

    if not magInfo then return end

    local options = {}

    -- Check if magazine is loaded or empty
    local isLoaded = item.metadata and item.metadata.count and item.metadata.count > 0

    if isLoaded then
        -- Loaded magazine options
        table.insert(options, {
            title = 'Equip to Weapon',
            description = string.format('%d/%d %s rounds', item.metadata.count, magInfo.capacity, string.upper(item.metadata.ammoType)),
            icon = 'gun',
            onSelect = function()
                EquipMagazine(item.name, item.slot, item.metadata)
            end
        })

        table.insert(options, {
            title = 'Unload Magazine',
            description = 'Remove ammo from magazine',
            icon = 'arrow-down',
            onSelect = function()
                UnloadMagazine(item.name, item.slot, item.metadata)
            end
        })
    else
        -- Empty magazine options
        table.insert(options, {
            title = 'Load Magazine',
            description = 'Load ammo into magazine',
            icon = 'arrow-up',
            onSelect = function()
                LoadMagazine(item.name, item.slot)
            end
        })
    end

    return options
end)

-- ============================================================================
-- WEAPON SWITCH HANDLING
-- ============================================================================

--[[
    When weapon is converted (e.g., G26 → G26_SWITCH), transfer magazine state
]]
RegisterNetEvent('ammo:weaponConverted', function(data)
    local oldWeapon = data.oldWeapon
    local newWeapon = data.newWeapon

    -- Transfer magazine state from old weapon to new weapon
    if equippedMagazines[oldWeapon] then
        equippedMagazines[newWeapon] = equippedMagazines[oldWeapon]
        equippedMagazines[oldWeapon] = nil
    end

    -- Apply component to new weapon if magazine was equipped
    if equippedMagazines[newWeapon] then
        local magData = equippedMagazines[newWeapon]
        local componentName = GetMagazineComponentName(newWeapon, magData.item, magData.ammoType)

        if componentName then
            local componentHash = GetHashKey(componentName)
            local ped = PlayerPedId()

            RemoveAllClipComponents(newWeapon)
            GiveWeaponComponentToPed(ped, newWeapon, componentHash)
            SetPedAmmo(ped, newWeapon, magData.count)
        end
    end
end)

-- ============================================================================
-- EXPORTS
-- ============================================================================

exports('LoadMagazine', LoadMagazine)
exports('UnloadMagazine', UnloadMagazine)
exports('EquipMagazine', EquipMagazine)
exports('GetEquippedMagazine', function(weaponHash)
    return equippedMagazines[weaponHash]
end)
