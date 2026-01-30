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

-- Hash-keyed table that normalizes number keys to unsigned 32-bit integers.
-- Fixes two Lua 5.4 issues with weapon hashes used as table keys:
-- 1. Float/integer: msgpack can deserialize hashes as floats (3221225319.0 ~= 3221225319)
-- 2. Signed/unsigned: hashes > 2^31 flip sign during msgpack round-trip
--    (client sends 3221225319, server returns -1073741977 — same bits, different Lua value)
-- The bitwise AND with 0xFFFFFFFF normalizes both to the same unsigned 32-bit integer.
local function HashKeyTable()
    return setmetatable({}, {
        __index = function(t, k)
            if type(k) == 'number' then k = math.floor(k) & 0xFFFFFFFF end
            return rawget(t, k)
        end,
        __newindex = function(t, k, v)
            if type(k) == 'number' then k = math.floor(k) & 0xFFFFFFFF end
            rawset(t, k, v)
        end
    })
end

local equippedMagazines = HashKeyTable() -- Per-weapon equipped magazine tracking
local chamberedRounds = HashKeyTable()   -- Tracks weapons with a chambered round after eject
local equippedSpeedloaders = HashKeyTable() -- Per-weapon equipped speedloader tracking

-- Get weapon's physical clip size from Config.Weapons
function GetWeaponClipSize(weaponHash)
    local weaponInfo = Config.Weapons[weaponHash]
    if weaponInfo and weaponInfo.clipSize then
        return weaponInfo.clipSize
    end
    return 17 -- default fallback
end

-- ============================================================================
-- MAGAZINE LOADING (From Inventory)
-- ============================================================================

--[[
    Load ammo into an empty magazine
    Called when player right-clicks empty magazine in inventory

    @param magazineItem - The magazine item name (e.g., 'mag_g26_extended')
    @param magazineSlot - The inventory slot of the magazine
]]
function LoadMagazine(magazineItem, magazineSlot, selectAmount)
    local magInfo = Config.Magazines[magazineItem]
    if not magInfo then
        lib.notify({ title = 'Error', description = 'Unknown magazine type', type = 'error' })
        return
    end

    -- Get the caliber for this magazine's compatible weapons
    local caliber = nil
    for _, weaponName in ipairs(magInfo.weapons) do
        local wHash = Config._WeaponNameToHash[weaponName]
        local weaponInfo = wHash and Config.Weapons[wHash]
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
            local maxLoad = math.min(magInfo.capacity, ammoCount)
            table.insert(options, {
                title = ammoConfig.label,
                description = string.format('%s (%d available)', selectAmount and 'Choose amount' or string.format('Load %d rounds', maxLoad), ammoCount),
                icon = 'bullet',
                onSelect = function()
                    local loadArgs = {
                        magazineItem = magazineItem,
                        magazineSlot = magazineSlot,
                        ammoType = ammoType,
                        ammoItem = ammoConfig.item,
                        maxCapacity = magInfo.capacity,
                        available = ammoCount,
                    }
                    if selectAmount then
                        -- Show input dialog for custom amount
                        local input = lib.inputDialog('Load Magazine', {
                            { type = 'number', label = 'Rounds to load (max ' .. maxLoad .. ')', default = maxLoad, min = 1, max = maxLoad }
                        })
                        if input and input[1] then
                            PerformMagazineLoad(loadArgs, math.floor(input[1]))
                        end
                    else
                        -- Full load
                        PerformMagazineLoad(loadArgs, maxLoad)
                    end
                end
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
        title = selectAmount and 'Select Ammo Type' or 'Full Load - Select Ammo',
        options = options,
    })

    lib.showContext('magazine_load_ammo')
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
function UnloadMagazine(magazineItem, magazineSlot, metadata, selectAmount)
    local metaCount = metadata and tonumber(metadata.count)
    if not metaCount or metaCount <= 0 then
        lib.notify({ title = 'Empty', description = 'Magazine is already empty', type = 'error' })
        return
    end

    -- Resolve the ammo item on client side to avoid server hash lookups
    local magInfo = Config.Magazines[magazineItem]
    local ammoItem = nil
    if magInfo then
        for _, weaponName in ipairs(magInfo.weapons) do
            local wHash = Config._WeaponNameToHash[weaponName]
            local weaponInfo = wHash and Config.Weapons[wHash]
            if weaponInfo then
                local ammoConfig = Config.AmmoTypes[weaponInfo.caliber] and Config.AmmoTypes[weaponInfo.caliber][metadata.ammoType]
                if ammoConfig then
                    ammoItem = ammoConfig.item
                end
                break
            end
        end
    end

    if not ammoItem then
        lib.notify({ title = 'Error', description = 'Cannot determine ammo type', type = 'error' })
        return
    end

    -- Determine unload amount
    local unloadAmount = metadata.count  -- Default: full unload

    if selectAmount then
        local input = lib.inputDialog('Unload Magazine', {
            { type = 'number', label = 'Rounds to unload (max ' .. metadata.count .. ')', default = metadata.count, min = 1, max = metadata.count }
        })
        if not input or not input[1] then return end
        unloadAmount = math.floor(input[1])
    end

    local unloadTime = unloadAmount * (Config.MagazineSystem.loadTimePerRound * 0.5) * 1000

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
            ammoItem = ammoItem,
            count = metadata.count,        -- Total rounds in magazine
            unloadAmount = unloadAmount,    -- How many to remove
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

    Supports shared magazine compatibility:
    - Magazines can be compatible with multiple weapons (e.g., Glock mags fit G17, G19, G26)
    - Each weapon has its own physical capacity limit (ClipSize in weaponcomponents.meta)
    - If magazine has more rounds than weapon can hold, excess stays in magazine
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
    local metaCount = metadata and tonumber(metadata.count)
    if not metaCount or metaCount <= 0 then
        lib.notify({ title = 'Empty', description = 'Magazine is empty - load it first', type = 'error' })
        return
    end

    -- Get current magazine if any (to return to inventory)
    local currentMag = equippedMagazines[currentWeapon]

    -- Update current magazine with live ammo count for chambered round calculation
    if currentMag then
        currentMag.count = GetAmmoInPedWeapon(ped, currentWeapon)
    end

    -- Get the weapon's actual clip size (from weaponcomponents.meta)
    -- This respects per-weapon physical magazine capacity
    local weaponClipSize = GetWeaponClipSize(currentWeapon)

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
            weaponClipSize = weaponClipSize,  -- Send weapon's physical capacity limit
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
    Uses weapon's actual clip size for tracking (not magazine's theoretical capacity)
]]
RegisterNetEvent('ammo:magazineEquipped', function(data)
    local weaponHash = data.weaponHash
    local magInfo = Config.Magazines[data.magazineItem]
    local weaponInfo = Config.Weapons[weaponHash]

    if not magInfo or not weaponInfo then return end

    -- Get the weapon's actual clip size (physical limit)
    local weaponClipSize = GetWeaponClipSize(weaponHash)

    -- Store equipped magazine data with weapon's actual capacity
    equippedMagazines[weaponHash] = {
        item = data.magazineItem,
        ammoType = data.ammoType,
        count = data.count,
        maxCount = weaponClipSize,  -- Use weapon's physical capacity, not magazine's
        magazineCapacity = magInfo.capacity,  -- Keep magazine's capacity for reference
    }
    chamberedRounds[weaponHash] = nil  -- Magazine supersedes any chambered round

    -- Build and apply the correct weapon component.
    -- Add the new component first, then remove only OTHER clip components.
    -- This ensures the weapon always has a valid clip (never zero components).
    local componentName = GetMagazineComponentName(weaponHash, data.magazineItem, data.ammoType)
    local ped = PlayerPedId()
    if componentName then
        local componentHash = GetHashKey(componentName)

        -- Add new component (GTA auto-replaces clips in some weapon models)
        GiveWeaponComponentToPed(ped, weaponHash, componentHash)

        if HasPedGotWeaponComponent(ped, weaponHash, componentHash) then
            -- New component applied - remove only OTHER clip components
            local weaponInfo = Config.Weapons[weaponHash]
            if weaponInfo and weaponInfo.caliber then
                local ammoTypes = Config.AmmoTypes[weaponInfo.caliber]
                if ammoTypes then
                    for ammoType, _ in pairs(ammoTypes) do
                        for _, suffix in ipairs({ '_CLIP_', '_EXTCLIP_', '_DRUM_' }) do
                            local otherName = weaponInfo.componentBase .. suffix .. string.upper(ammoType)
                            local otherHash = GetHashKey(otherName)
                            if otherHash ~= componentHash and HasPedGotWeaponComponent(ped, weaponHash, otherHash) then
                                RemoveWeaponComponentFromPed(ped, weaponHash, otherHash)
                            end
                        end
                    end
                end
            end
        end
        -- If component doesn't exist, keep whatever clip is already on the weapon
    end

    -- Always set ammo count regardless of component success
    -- SetPedAmmo sets total ammo pool, SetAmmoInClip loads rounds into the weapon's clip
    SetPedAmmo(ped, weaponHash, data.count)
    SetAmmoInClip(ped, weaponHash, data.count)

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
    Block GTA's native reload and handle keybind reload
    - Blocks native R key auto-reload behavior
    - Detects keybind press to trigger manual reload from inventory
]]
CreateThread(function()
    local keybindCfg = Config.MagazineSystem.keybindReload
    local reloadKey = keybindCfg and keybindCfg.key or 45

    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` then
            -- Always block native reload when disableNativeReload is on
            if Config.MagazineSystem.disableNativeReload then
                DisableControlAction(0, reloadKey, true)

                if IsPedReloading(ped) then
                    ClearPedTasks(ped)
                end
            end

            -- Keybind reload: detect disabled control press to trigger manual reload
            if keybindCfg and keybindCfg.enabled and not isReloading then
                if IsDisabledControlJustPressed(0, reloadKey) then
                    KeybindReload(weapon)
                end
            end

            Wait(0) -- Must run every frame to block input
        else
            Wait(200)
        end
    end
end)

--[[
    Keybind reload: select best mag or speedloader and reload
]]
function KeybindReload(weaponHash)
    -- Try speedloader first (revolvers)
    local slData = equippedSpeedloaders and equippedSpeedloaders[weaponHash]
    local isRevolver = false
    for slName, slInfo in pairs(Config.Speedloaders) do
        if IsSpeedloaderCompatible(weaponHash, slName) then
            isRevolver = true
            break
        end
    end

    if isRevolver then
        local loadedSLs = GetLoadedSpeedloadersFromInventory(weaponHash)
        if #loadedSLs == 0 then
            lib.notify({ title = 'No Speedloaders', description = 'No loaded speedloaders available', type = 'error' })
            return
        end
        local selected = SelectBestSpeedloader(loadedSLs, equippedSpeedloaders[weaponHash])
        if selected then
            isReloading = true
            local weaponClipSize = GetWeaponClipSize(weaponHash)
            TriggerServerEvent('ammo:combatReloadSpeedloader', {
                weaponHash = weaponHash,
                weaponClipSize = weaponClipSize,
                newSpeedloader = selected,
            })
            Wait(Config.SpeedloaderSystem.equipTime * 1000)
            isReloading = false
        end
        return
    end

    -- Magazine weapons
    local loadedMags = GetLoadedMagazinesFromInventory(weaponHash)
    if #loadedMags == 0 then
        lib.notify({ title = 'No Magazines', description = 'No loaded magazines available', type = 'error' })
        return
    end

    local currentMag = equippedMagazines[weaponHash]
    local selected = SelectBestMagazine(loadedMags, currentMag)
    if selected then
        isReloading = true
        -- Don't call ReturnEmptyMagazine separately - PerformCombatReload
        -- sends current mag data to server for chambered round accounting
        PerformCombatReload(weaponHash, selected)
    end
end

--[[
    Select best speedloader using the same priority config as magazines
]]
function SelectBestSpeedloader(loadedSLs, currentSL)
    if #loadedSLs == 0 then return nil end
    local priority = Config.MagazineSystem.keybindReload and Config.MagazineSystem.keybindReload.priority
        or { 'same_ammo', 'highest_count' }

    table.sort(loadedSLs, function(a, b)
        return ComparePriority(a, b, currentSL and currentSL.item, currentSL and currentSL.ammoType, priority)
    end)

    return loadedSLs[1]
end

--[[
    Monitor ammo consumption, enforce magazine-only loading, and trigger reloads
]]
CreateThread(function()
    local lastMonitoredWeapon = nil

    while true do
        Wait(100)

        if Config.MagazineSystem.enabled then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)

            if weapon ~= `WEAPON_UNARMED` then
                -- Weapon just drawn or switched
                if weapon ~= lastMonitoredWeapon then
                    lastMonitoredWeapon = weapon

                    if equippedMagazines[weapon] then
                        -- Re-apply tracked ammo when re-drawing weapon with magazine.
                        -- GTA resets ammo to weapon-meta defaults during draw, which
                        -- corrupts our count and causes eject to return empty mags.
                        local magData = equippedMagazines[weapon]
                        SetPedAmmo(ped, weapon, magData.count)
                        SetAmmoInClip(ped, weapon, magData.count)
                    elseif equippedSpeedloaders[weapon] then
                        -- Same re-apply for speedloader-loaded revolvers
                        local slData = equippedSpeedloaders[weapon]
                        SetPedAmmo(ped, weapon, slData.count)
                        SetAmmoInClip(ped, weapon, slData.count)
                    elseif chamberedRounds[weapon] then
                        -- Chambered round from a previous eject - validate and enforce
                        local currentAmmo = GetAmmoInPedWeapon(ped, weapon)
                        if currentAmmo <= 0 then
                            chamberedRounds[weapon] = nil
                        elseif currentAmmo > 1 then
                            SetPedAmmo(ped, weapon, 1)
                            SetAmmoInClip(ped, weapon, 1)
                        end
                    else
                        -- No tracking at all - zero the weapon (pool + clip)
                        SetPedAmmo(ped, weapon, 0)
                        SetAmmoInClip(ped, weapon, 0)
                    end
                end

                -- Track ammo for weapons with equipped magazines
                if equippedMagazines[weapon] then
                    local currentAmmo = GetAmmoInPedWeapon(ped, weapon)
                    local magData = equippedMagazines[weapon]

                    if currentAmmo > magData.count then
                        -- GTA re-applied default ammo above tracked count - correct it
                        SetPedAmmo(ped, weapon, magData.count)
                        SetAmmoInClip(ped, weapon, magData.count)
                    elseif currentAmmo < magData.count then
                        -- Rounds consumed by firing - update tracking
                        magData.count = currentAmmo

                        -- Magazine empty - need to reload
                        if currentAmmo <= 0 and not isReloading then
                            HandleEmptyMagazine(weapon)
                        end
                    end
                end

                -- Ongoing enforcement: GTA can re-apply default ammo after our
                -- initial zero during the draw animation. Keep enforcing for
                -- weapons with no tracked magazine, speedloader, or chambered round.
                if not equippedMagazines[weapon] and not equippedSpeedloaders[weapon] then
                    if chamberedRounds[weapon] then
                        local currentAmmo = GetAmmoInPedWeapon(ped, weapon)
                        if currentAmmo <= 0 then
                            chamberedRounds[weapon] = nil
                        elseif currentAmmo > 1 then
                            SetPedAmmo(ped, weapon, 1)
                            SetAmmoInClip(ped, weapon, 1)
                        end
                    else
                        if GetAmmoInPedWeapon(ped, weapon) > 0 then
                            SetPedAmmo(ped, weapon, 0)
                            SetAmmoInClip(ped, weapon, 0)
                        end
                    end
                end
            else
                lastMonitoredWeapon = nil
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
        else
            isReloading = false
        end
    else
        -- Manual reload mode: return empty mag and wait for player to press R
        lib.notify({
            title = 'Magazine Empty',
            description = 'Press R to reload, K to eject magazine',
            type = 'inform'
        })
        ReturnEmptyMagazine(weaponHash)
        isReloading = false
    end
end

--[[
    Get all loaded magazines compatible with weapon from inventory
]]
function GetLoadedMagazinesFromInventory(weaponHash)
    local loadedMags = {}
    local items = exports.ox_inventory:GetPlayerItems()

    for _, item in pairs(items) do
        local magInfo = Config.Magazines[item.name]
        if magInfo and IsMagazineCompatible(weaponHash, item.name) then
            -- Check if magazine is loaded (has ammo)
            local count = item.metadata and tonumber(item.metadata.count)
            if count and count > 0 then
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
    Compare two candidates using the configurable priority hierarchy.
    Each priority rule returns true/false/nil (nil = tie, continue to next rule).
    Options: 'same_ammo', 'same_mag', 'highest_count', 'lowest_count', 'fifo'
]]
function ComparePriority(a, b, currentItemName, currentAmmoType, priority)
    for _, rule in ipairs(priority) do
        if rule == 'same_ammo' and currentAmmoType then
            local aMatch = a.metadata.ammoType == currentAmmoType
            local bMatch = b.metadata.ammoType == currentAmmoType
            if aMatch ~= bMatch then return aMatch end

        elseif rule == 'same_mag' and currentItemName then
            local aMatch = a.item == currentItemName
            local bMatch = b.item == currentItemName
            if aMatch ~= bMatch then return aMatch end

        elseif rule == 'highest_count' then
            if a.metadata.count ~= b.metadata.count then
                return a.metadata.count > b.metadata.count
            end

        elseif rule == 'lowest_count' then
            if a.metadata.count ~= b.metadata.count then
                return a.metadata.count < b.metadata.count
            end

        elseif rule == 'fifo' then
            if a.slot ~= b.slot then
                return a.slot < b.slot
            end
        end
    end

    -- Final fallback: lowest slot
    return a.slot < b.slot
end

--[[
    Select best magazine using configurable priority hierarchy
]]
function SelectBestMagazine(loadedMags, currentMag)
    if #loadedMags == 0 then return nil end

    local priority = Config.MagazineSystem.keybindReload and Config.MagazineSystem.keybindReload.priority
        or { 'same_ammo', 'highest_count' }
    local currentItem = currentMag and currentMag.item
    local currentAmmo = currentMag and currentMag.ammoType

    table.sort(loadedMags, function(a, b)
        return ComparePriority(a, b, currentItem, currentAmmo, priority)
    end)

    return loadedMags[1]
end

--[[
    Perform combat reload with selected magazine
    Respects weapon's physical capacity limit (weaponClipSize from meta)
]]
function PerformCombatReload(weaponHash, selectedMag)
    local magInfo = Config.Magazines[selectedMag.item]
    local swapTime = Config.MagazineSystem.swapTime[magInfo.type] or 1.5

    -- Get the weapon's actual clip size for capacity limiting
    local weaponClipSize = GetWeaponClipSize(weaponHash)

    -- Get current magazine and live ammo count for chambered round calculation
    local currentMag = equippedMagazines[weaponHash]
    local currentAmmo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)

    TriggerServerEvent('ammo:combatReload', {
        weaponHash = weaponHash,
        weaponClipSize = weaponClipSize,  -- Send weapon's physical capacity limit
        newMagazine = selectedMag,
        currentMagazine = currentMag and {
            item = currentMag.item,
            ammoType = currentMag.ammoType,
            count = currentAmmo,  -- Actual remaining rounds for chambered round calc
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

--[[
    Manually eject magazine from weapon (even if it has rounds remaining)
    This allows single-magazine players to:
    1. Eject their mag
    2. Load it with ammo from inventory
    3. Re-insert it

    Returns magazine to inventory with current round count preserved.
]]
function EjectMagazine()
    local ped = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(ped)

    if currentWeapon == `WEAPON_UNARMED` then
        lib.notify({ title = 'No Weapon', description = 'No weapon equipped', type = 'error' })
        return false
    end

    local currentMag = equippedMagazines[currentWeapon]
    if not currentMag then
        lib.notify({ title = 'No Magazine', description = 'No magazine in weapon', type = 'error' })
        return false
    end

    -- Get current ammo count from weapon (may have changed from firing)
    local currentAmmo = GetAmmoInPedWeapon(ped, currentWeapon)

    -- Chambered round: if weapon has ammo, 1 round stays in the chamber
    -- Magazine is returned with (count - 1) since the chambered round stays
    local magReturnCount = currentAmmo
    local hasChamberedRound = false
    if currentAmmo > 0 then
        hasChamberedRound = true
        magReturnCount = currentAmmo - 1
    end

    -- Trigger server to return magazine to inventory
    TriggerServerEvent('ammo:ejectMagazine', {
        weaponHash = currentWeapon,
        magazineItem = currentMag.item,
        ammoType = currentMag.ammoType,
        count = magReturnCount,
    })

    -- Clear magazine tracking, set chambered round flag
    equippedMagazines[currentWeapon] = nil
    chamberedRounds[currentWeapon] = hasChamberedRound or nil

    -- Keep chambered round in weapon or clear completely
    if hasChamberedRound then
        SetPedAmmo(ped, currentWeapon, 1)
        SetAmmoInClip(ped, currentWeapon, 1)
    else
        SetPedAmmo(ped, currentWeapon, 0)
        SetAmmoInClip(ped, currentWeapon, 0)
    end

    return true
end

-- Export for external use (keybinds, other scripts)
exports('EjectMagazine', EjectMagazine)

-- Command to manually eject magazine
RegisterCommand('ejectmag', function()
    EjectMagazine()
end, false)

-- Optional keybind (K by default, can be rebound in FiveM settings)
RegisterKeyMapping('ejectmag', 'Eject Magazine from Weapon', 'keyboard', 'k')

-- ============================================================================
-- INVENTORY CONTEXT MENU INTEGRATION
-- ============================================================================

--[[
    Register context menu for magazines in ox_inventory
    Checks export data first for metadata, then falls back to inventory lookup.
    Uses pairs() for sparse slot-indexed tables from GetPlayerItems().
]]
exports('magazineContextMenu', function(data)
    local magInfo = Config.Magazines[data.name]
    if not magInfo then return end

    -- Prefer data.metadata from ox_inventory export (includes instance metadata
    -- in newer versions). Fall back to inventory slot lookup if not available.
    local item = nil

    if data.metadata and data.metadata.count then
        item = data
    else
        local playerItems = exports.ox_inventory:GetPlayerItems()
        if data.slot then
            for _, invItem in pairs(playerItems) do
                if invItem.slot == data.slot then
                    item = invItem
                    break
                end
            end
        end
    end

    if not item then
        item = data -- final fallback
    end

    local options = {}
    local count = item.metadata and tonumber(item.metadata.count)
    local isLoaded = count and count > 0

    if isLoaded then
        table.insert(options, {
            title = 'Equip to Weapon',
            description = string.format('%d/%d %s rounds', item.metadata.count, magInfo.capacity, string.upper(item.metadata.ammoType)),
            icon = 'gun',
            onSelect = function()
                EquipMagazine(item.name, item.slot, item.metadata)
            end
        })

        table.insert(options, {
            title = 'Full Unload',
            description = string.format('Remove all %d rounds', item.metadata.count),
            icon = 'arrow-down',
            onSelect = function()
                UnloadMagazine(item.name, item.slot, item.metadata, false)
            end
        })

        table.insert(options, {
            title = 'Select Amount to Unload',
            description = 'Choose how many rounds to remove',
            icon = 'hashtag',
            onSelect = function()
                UnloadMagazine(item.name, item.slot, item.metadata, true)
            end
        })
    else
        table.insert(options, {
            title = 'Full Load',
            description = string.format('Load to full capacity (%d rounds)', magInfo.capacity),
            icon = 'arrow-up',
            onSelect = function()
                LoadMagazine(item.name, item.slot, false)
            end
        })

        table.insert(options, {
            title = 'Select Amount to Load',
            description = 'Choose how many rounds to load',
            icon = 'hashtag',
            onSelect = function()
                LoadMagazine(item.name, item.slot, true)
            end
        })
    end

    lib.registerContext({
        id = 'magazine_context_menu',
        title = magInfo.label or item.name,
        options = options,
    })

    lib.showContext('magazine_context_menu')
end)

-- ============================================================================
-- WEAPON MODIFICATIONS
-- ============================================================================
--[[
    NOTE: Weapon swap conversion is DEPRECATED.

    Fire mode modifications (switches, bump stocks, binary triggers) are now
    handled by the selective fire system via component detection:

    1. Player uses switch item on compatible weapon
    2. Switch item attaches COMPONENT_G26_SWITCH to weapon
    3. Selective fire system detects component and unlocks full-auto mode
    4. Same weapon, same magazines - only fire behavior changes

    This approach is preferred because:
    - No separate weapon variants needed (G26 vs G26_SWITCH)
    - Magazines work identically on base weapon
    - Modification is reversible (can detach component)
    - Simpler inventory management
]]

-- ============================================================================
-- EXPORTS
-- ============================================================================

exports('LoadMagazine', LoadMagazine)
exports('UnloadMagazine', UnloadMagazine)
exports('EquipMagazine', EquipMagazine)
exports('GetEquippedMagazine', function(weaponHash)
    return equippedMagazines[weaponHash]
end)

-- ============================================================================
-- SPEEDLOADER SYSTEM (Revolvers)
-- ============================================================================

--[[
    Load ammo into an empty speedloader
    Called when player right-clicks empty speedloader in inventory

    @param speedloaderItem - The speedloader item name (e.g., 'speedloader_357')
    @param speedloaderSlot - The inventory slot of the speedloader
]]
function LoadSpeedloader(speedloaderItem, speedloaderSlot)
    local slInfo = Config.Speedloaders[speedloaderItem]
    if not slInfo then
        lib.notify({ title = 'Error', description = 'Unknown speedloader type', type = 'error' })
        return
    end

    -- Get the caliber for this speedloader's compatible weapons
    local caliber = nil
    for _, weaponName in ipairs(slInfo.weapons) do
        local wHash = Config._WeaponNameToHash[weaponName]
        local weaponInfo = wHash and Config.Weapons[wHash]
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
        local ammoCount = exports.ox_inventory:Search('count', ammoConfig.item)
        if ammoCount > 0 then
            table.insert(options, {
                title = ammoConfig.label,
                description = string.format('Available: %d rounds (need %d)', ammoCount, slInfo.capacity),
                icon = 'bullet',
                onSelect = function()
                    PerformSpeedloaderLoad({
                        speedloaderItem = speedloaderItem,
                        speedloaderSlot = speedloaderSlot,
                        ammoType = ammoType,
                        ammoItem = ammoConfig.item,
                        capacity = slInfo.capacity,
                    })
                end
            })
        end
    end

    if #options == 0 then
        lib.notify({ title = 'No Ammo', description = 'You have no compatible ammunition', type = 'error' })
        return
    end

    lib.registerContext({
        id = 'speedloader_load_ammo',
        title = 'Load Speedloader - Select Ammo',
        options = options,
    })

    lib.showContext('speedloader_load_ammo')
end

--[[
    Perform speedloader loading with progress bar
    Speedloaders are always fully loaded (all rounds at once)
]]
function PerformSpeedloaderLoad(args)
    local loadTime = args.capacity * Config.SpeedloaderSystem.loadTimePerRound * 1000

    if lib.progressCircle({
        duration = loadTime,
        label = 'Loading speedloader...',
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
        TriggerServerEvent('ammo:loadSpeedloader', {
            speedloaderItem = args.speedloaderItem,
            speedloaderSlot = args.speedloaderSlot,
            ammoItem = args.ammoItem,
            ammoType = args.ammoType,
            capacity = args.capacity,
        })
    else
        lib.notify({ title = 'Cancelled', description = 'Speedloader loading cancelled', type = 'error' })
    end
end

--[[
    Unload ammo from a loaded speedloader back to loose rounds
]]
function UnloadSpeedloader(speedloaderItem, speedloaderSlot, metadata)
    local metaCount = metadata and tonumber(metadata.count)
    if not metaCount or metaCount <= 0 then
        lib.notify({ title = 'Empty', description = 'Speedloader is already empty', type = 'error' })
        return
    end

    -- Resolve the ammo item on client side to avoid server hash lookups
    local slInfo = Config.Speedloaders[speedloaderItem]
    local ammoItem = nil
    if slInfo then
        for _, weaponName in ipairs(slInfo.weapons) do
            local wHash = Config._WeaponNameToHash[weaponName]
        local weaponInfo = wHash and Config.Weapons[wHash]
            if weaponInfo then
                local ammoConfig = Config.AmmoTypes[weaponInfo.caliber] and Config.AmmoTypes[weaponInfo.caliber][metadata.ammoType]
                if ammoConfig then
                    ammoItem = ammoConfig.item
                end
                break
            end
        end
    end

    if not ammoItem then
        lib.notify({ title = 'Error', description = 'Cannot determine ammo type', type = 'error' })
        return
    end

    local unloadTime = metadata.count * (Config.SpeedloaderSystem.loadTimePerRound * 0.5) * 1000

    if lib.progressCircle({
        duration = unloadTime,
        label = 'Unloading speedloader...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = false,
            combat = true,
        },
    }) then
        TriggerServerEvent('ammo:unloadSpeedloader', {
            speedloaderItem = speedloaderItem,
            speedloaderSlot = speedloaderSlot,
            ammoType = metadata.ammoType,
            ammoItem = ammoItem,
            count = metadata.count,
        })
    else
        lib.notify({ title = 'Cancelled', description = 'Unloading cancelled', type = 'error' })
    end
end

--[[
    Equip a loaded speedloader to currently held revolver
    Dumps all rounds into the cylinder at once
]]
function EquipSpeedloader(speedloaderItem, speedloaderSlot, metadata)
    local ped = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(ped)

    if currentWeapon == `WEAPON_UNARMED` then
        lib.notify({ title = 'No Weapon', description = 'Equip a revolver first', type = 'error' })
        return
    end

    -- Check compatibility
    if not IsSpeedloaderCompatible(currentWeapon, speedloaderItem) then
        lib.notify({ title = 'Incompatible', description = 'Speedloader does not fit this revolver', type = 'error' })
        return
    end

    -- Check if speedloader is loaded
    local metaCount = metadata and tonumber(metadata.count)
    if not metaCount or metaCount <= 0 then
        lib.notify({ title = 'Empty', description = 'Speedloader is empty - load it first', type = 'error' })
        return
    end

    local weaponClipSize = GetWeaponClipSize(currentWeapon)
    local equipTime = Config.SpeedloaderSystem.equipTime

    if lib.progressCircle({
        duration = equipTime * 1000,
        label = 'Loading cylinder...',
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
        TriggerServerEvent('ammo:equipSpeedloader', {
            weaponHash = currentWeapon,
            weaponClipSize = weaponClipSize,
            speedloader = {
                item = speedloaderItem,
                slot = speedloaderSlot,
                metadata = metadata,
            },
        })
    end
end

--[[
    Server callback - Speedloader equipped successfully
]]
RegisterNetEvent('ammo:speedloaderEquipped', function(data)
    local weaponHash = data.weaponHash
    local slInfo = Config.Speedloaders[data.speedloaderItem]
    local weaponInfo = Config.Weapons[weaponHash]

    if not slInfo or not weaponInfo then return end

    -- Track equipped speedloader data
    equippedSpeedloaders[weaponHash] = {
        item = data.speedloaderItem,
        ammoType = data.ammoType,
        count = data.count,
        maxCount = slInfo.capacity,
    }

    -- Build and apply the correct weapon component
    -- For revolvers, use weapon's componentBase directly with ammo type suffix
    local revolverComponent = weaponInfo.componentBase .. '_CLIP_' .. string.upper(data.ammoType)
    local componentHash = GetHashKey(revolverComponent)
    local ped = PlayerPedId()

    -- Add new component first, then remove only others (never leave weapon clip-less)
    GiveWeaponComponentToPed(ped, weaponHash, componentHash)
    if HasPedGotWeaponComponent(ped, weaponHash, componentHash) then
        if weaponInfo.caliber then
            local ammoTypes = Config.AmmoTypes[weaponInfo.caliber]
            if ammoTypes then
                for ammoType, _ in pairs(ammoTypes) do
                    for _, suffix in ipairs({ '_CLIP_', '_EXTCLIP_', '_DRUM_' }) do
                        local otherName = weaponInfo.componentBase .. suffix .. string.upper(ammoType)
                        local otherHash = GetHashKey(otherName)
                        if otherHash ~= componentHash and HasPedGotWeaponComponent(ped, weaponHash, otherHash) then
                            RemoveWeaponComponentFromPed(ped, weaponHash, otherHash)
                        end
                    end
                end
            end
        end
    end

    -- Set ammo count (total + clip)
    SetPedAmmo(ped, weaponHash, data.count)
    SetAmmoInClip(ped, weaponHash, data.count)

    lib.notify({
        title = 'Cylinder Loaded',
        description = string.format('%d %s rounds loaded', data.count, string.upper(data.ammoType)),
        type = 'success'
    })
end)

--[[
    Combat reload monitoring for revolvers with speedloaders
    Integrates into the existing ammo monitoring thread
]]
CreateThread(function()
    while true do
        Wait(100)

        if Config.SpeedloaderSystem and Config.SpeedloaderSystem.enabled then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)

            if weapon ~= `WEAPON_UNARMED` and equippedSpeedloaders[weapon] then
                local currentAmmo = GetAmmoInPedWeapon(ped, weapon)
                local slData = equippedSpeedloaders[weapon]

                if currentAmmo > slData.count then
                    -- GTA re-applied default ammo above tracked count - correct it
                    SetPedAmmo(ped, weapon, slData.count)
                    SetAmmoInClip(ped, weapon, slData.count)
                elseif currentAmmo < slData.count then
                    slData.count = currentAmmo

                    -- Cylinder empty - auto-reload with speedloader if available
                    if currentAmmo <= 0 and not isReloading and Config.SpeedloaderSystem.autoReloadFromInventory then
                        HandleEmptyCylinder(weapon)
                    end
                end
            end
        end
    end
end)

--[[
    Handle empty cylinder - find loaded speedloader and auto-reload
]]
function HandleEmptyCylinder(weaponHash)
    isReloading = true

    local loadedSpeedloaders = GetLoadedSpeedloadersFromInventory(weaponHash)

    if #loadedSpeedloaders == 0 then
        lib.notify({
            title = 'No Speedloaders',
            description = 'No loaded speedloaders available!',
            type = 'error'
        })
        equippedSpeedloaders[weaponHash] = nil
        isReloading = false
        return
    end

    -- Auto-select best speedloader (highest count, then same ammo type)
    local selected = loadedSpeedloaders[1]
    local currentSl = equippedSpeedloaders[weaponHash]

    for _, sl in ipairs(loadedSpeedloaders) do
        if sl.metadata.count > selected.metadata.count then
            selected = sl
        elseif sl.metadata.count == selected.metadata.count and currentSl and sl.metadata.ammoType == currentSl.ammoType then
            selected = sl
        end
    end

    local weaponClipSize = GetWeaponClipSize(weaponHash)

    TriggerServerEvent('ammo:combatReloadSpeedloader', {
        weaponHash = weaponHash,
        weaponClipSize = weaponClipSize,
        newSpeedloader = selected,
    })

    Wait(Config.SpeedloaderSystem.equipTime * 1000)
    isReloading = false
end

--[[
    Get all loaded speedloaders compatible with weapon from inventory
]]
function GetLoadedSpeedloadersFromInventory(weaponHash)
    local loaded = {}
    local items = exports.ox_inventory:GetPlayerItems()

    for _, item in pairs(items) do
        local slInfo = Config.Speedloaders[item.name]
        if slInfo and IsSpeedloaderCompatible(weaponHash, item.name) then
            local count = item.metadata and tonumber(item.metadata.count)
            if count and count > 0 then
                table.insert(loaded, {
                    item = item.name,
                    slot = item.slot,
                    metadata = item.metadata,
                    slInfo = slInfo,
                })
            end
        end
    end

    return loaded
end

-- ============================================================================
-- SPEEDLOADER CONTEXT MENU
-- ============================================================================

exports('speedloaderContextMenu', function(data)
    local slInfo = Config.Speedloaders[data.name]
    if not slInfo then return end

    -- Prefer data.metadata from ox_inventory export, fall back to slot lookup
    local item = nil

    if data.metadata and data.metadata.count then
        item = data
    else
        local playerItems = exports.ox_inventory:GetPlayerItems()
        if data.slot then
            for _, invItem in pairs(playerItems) do
                if invItem.slot == data.slot then
                    item = invItem
                    break
                end
            end
        end
    end

    if not item then
        item = data
    end

    local options = {}
    local count = item.metadata and tonumber(item.metadata.count)
    local isLoaded = count and count > 0

    if isLoaded then
        table.insert(options, {
            title = 'Load into Revolver',
            description = string.format('%d/%d %s rounds', item.metadata.count, slInfo.capacity, string.upper(item.metadata.ammoType)),
            icon = 'gun',
            onSelect = function()
                EquipSpeedloader(item.name, item.slot, item.metadata)
            end
        })

        table.insert(options, {
            title = 'Unload Speedloader',
            description = 'Remove ammo from speedloader',
            icon = 'arrow-down',
            onSelect = function()
                UnloadSpeedloader(item.name, item.slot, item.metadata)
            end
        })
    else
        table.insert(options, {
            title = 'Load Speedloader',
            description = 'Load ammo into speedloader',
            icon = 'arrow-up',
            onSelect = function()
                LoadSpeedloader(item.name, item.slot)
            end
        })
    end

    lib.registerContext({
        id = 'speedloader_context_menu',
        title = slInfo.label or item.name,
        options = options,
    })

    lib.showContext('speedloader_context_menu')
end)

-- ============================================================================
-- SPEEDLOADER EXPORTS
-- ============================================================================

exports('LoadSpeedloader', LoadSpeedloader)
exports('UnloadSpeedloader', UnloadSpeedloader)
exports('EquipSpeedloader', EquipSpeedloader)
exports('GetEquippedSpeedloader', function(weaponHash)
    return equippedSpeedloaders[weaponHash]
end)
