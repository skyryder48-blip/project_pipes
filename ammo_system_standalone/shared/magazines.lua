--[[
    Magazine System Configuration
    ==============================

    FULL REALISTIC MAGAZINE SYSTEM

    Core Concepts:
    - Magazines are physical inventory items
    - Magazines must be loaded with ammo before use
    - Players carry multiple pre-loaded magazines into combat
    - Empty magazines persist and can be reloaded
    - Loading can be done directly from inventory (no workbench)

    Item Types:
    - Empty magazines: Stackable by type (mag_g26_standard, mag_g26_extended, etc.)
    - Loaded magazines: Unique items with metadata { ammoType, count }
    - Loose ammo: Stackable rounds (ammo_9mm_fmj, ammo_9mm_hp, etc.)
]]

Config.MagazineSystem = {
    -- Enable full realistic magazine system
    enabled = true,

    -- Time to load a single round into magazine (seconds)
    loadTimePerRound = 0.5,

    -- Time to swap magazines in combat (seconds)
    swapTime = {
        standard = 1.5,
        extended = 2.0,
        drum = 3.0,
    },

    -- Allow partial magazine loading (load 5 of 10 rounds)
    allowPartialLoad = true,

    -- Auto-reload from inventory when magazine empties in combat
    -- If false, player must manually select next magazine
    autoReloadFromInventory = true,

    -- Priority order for auto-reload (same ammo type first, then others)
    autoReloadPriority = 'same_ammo_first', -- 'same_ammo_first', 'highest_capacity', 'any'
}

--[[
    Magazine Definitions
    ====================

    Structure:
    Config.Magazines[magazineItemName] = {
        label = "Display Name",
        weapon = "WEAPON_HASH" or { "WEAPON_1", "WEAPON_2" }, -- Compatible weapons
        capacity = 33,
        type = "standard" | "extended" | "drum",
        componentSuffix = "_EXTCLIP_", -- Middle part of component name
        model = "prop_xxx", -- Optional: 3D model for dropped item
        weight = 150, -- Grams, for inventory weight system
        price = 45, -- Base price at gun stores
    }

    Component naming convention:
    COMPONENT_{WEAPON}_{SUFFIX}{AMMOTYPE}
    Example: COMPONENT_G26_EXTCLIP_FMJ
]]

Config.Magazines = {
    -- ========================================================================
    -- GLOCK 26 MAGAZINES (Compact 9mm)
    -- ========================================================================

    ['mag_g26_standard'] = {
        label = "Glock 26 Magazine (10rd)",
        weapons = { 'WEAPON_G26' },
        capacity = 10,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 80,
        price = 25,
    },

    ['mag_g26_extended'] = {
        label = "Glock 26 Extended Magazine (33rd)",
        weapons = { 'WEAPON_G26' },
        capacity = 33,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 180,
        price = 85,
    },

    ['mag_g26_drum'] = {
        label = "Glock 26 Drum Magazine (50rd)",
        weapons = { 'WEAPON_G26' },
        capacity = 50,
        type = 'drum',
        componentSuffix = '_DRUM_',
        weight = 450,
        price = 250,
    },

    -- G26 Switch uses same magazines but is always extended
    ['mag_g26switch_extended'] = {
        label = "Glock 26 Switch Magazine (33rd)",
        weapons = { 'WEAPON_G26_SWITCH' },
        capacity = 33,
        type = 'extended',
        componentSuffix = '_CLIP_', -- Switch default is extended
        weight = 180,
        price = 85,
    },

    -- ========================================================================
    -- GLOCK 17/19/45 MAGAZINES (Full-Size 9mm) - Cross-compatible
    -- ========================================================================

    ['mag_glock_standard'] = {
        label = "Glock 9mm Magazine (17rd)",
        weapons = {
            'WEAPON_G17', 'WEAPON_G17_BLK', 'WEAPON_G17_GEN5',
            'WEAPON_G19', 'WEAPON_G19X', 'WEAPON_G19XD',
            'WEAPON_G45', 'WEAPON_G45_TAN'
        },
        capacity = 17,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 95,
        price = 30,
    },

    ['mag_glock_extended'] = {
        label = "Glock 9mm Extended Magazine (33rd)",
        weapons = {
            'WEAPON_G17', 'WEAPON_G17_BLK', 'WEAPON_G17_GEN5',
            'WEAPON_G19', 'WEAPON_G19X', 'WEAPON_G19XD',
            'WEAPON_G45', 'WEAPON_G45_TAN'
        },
        capacity = 33,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 185,
        price = 90,
    },

    ['mag_glock_drum'] = {
        label = "Glock 9mm Drum Magazine (50rd)",
        weapons = {
            'WEAPON_G17', 'WEAPON_G17_BLK', 'WEAPON_G17_GEN5',
            'WEAPON_G19', 'WEAPON_G19X', 'WEAPON_G19XD',
            'WEAPON_G45', 'WEAPON_G45_TAN'
        },
        capacity = 50,
        type = 'drum',
        componentSuffix = '_DRUM_',
        weight = 460,
        price = 275,
    },

    -- ========================================================================
    -- GLOCK 19X SWITCH MAGAZINE
    -- ========================================================================

    ['mag_g19x_switch'] = {
        label = "Glock 19X Switch Magazine (33rd)",
        weapons = { 'WEAPON_G19X_SWITCH' },
        capacity = 33,
        type = 'extended',
        componentSuffix = '_CLIP_',
        weight = 185,
        price = 90,
    },

    -- ========================================================================
    -- GLOCK 21/30/41 MAGAZINES (.45 ACP)
    -- ========================================================================

    ['mag_glock45_standard'] = {
        label = "Glock .45 Magazine (13rd)",
        weapons = { 'WEAPON_G21', 'WEAPON_G41' },
        capacity = 13,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 120,
        price = 35,
    },

    ['mag_glock45_compact'] = {
        label = "Glock 30 Magazine (10rd)",
        weapons = { 'WEAPON_G30' },
        capacity = 10,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 100,
        price = 30,
    },

    ['mag_glock45_extended'] = {
        label = "Glock .45 Extended Magazine (26rd)",
        weapons = { 'WEAPON_G21', 'WEAPON_G30', 'WEAPON_G41' },
        capacity = 26,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 220,
        price = 120,
    },

    -- ========================================================================
    -- 1911 MAGAZINES (.45 ACP)
    -- ========================================================================

    ['mag_1911_standard'] = {
        label = "1911 Magazine (7rd)",
        weapons = { 'WEAPON_M45A1', 'WEAPON_KIMBER1911', 'WEAPON_JUNK1911' },
        capacity = 7,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 85,
        price = 25,
    },

    ['mag_1911_extended'] = {
        label = "1911 Extended Magazine (10rd)",
        weapons = { 'WEAPON_M45A1', 'WEAPON_KIMBER1911', 'WEAPON_KIMBER_ECLIPSE' },
        capacity = 10,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 110,
        price = 55,
    },

    -- ========================================================================
    -- BERETTA M9/M9A3/PX4 MAGAZINES (9mm)
    -- ========================================================================

    ['mag_beretta_standard'] = {
        label = "Beretta 9mm Magazine (15rd)",
        weapons = { 'WEAPON_M9', 'WEAPON_M9A3', 'WEAPON_PX4', 'WEAPON_PX4STORM' },
        capacity = 15,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 90,
        price = 28,
    },

    ['mag_beretta_extended'] = {
        label = "Beretta 9mm Extended Magazine (30rd)",
        weapons = { 'WEAPON_M9', 'WEAPON_M9A3', 'WEAPON_PX4', 'WEAPON_PX4STORM' },
        capacity = 30,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 175,
        price = 95,
    },

    -- ========================================================================
    -- SIG SAUER MAGAZINES (9mm)
    -- ========================================================================

    ['mag_sig_standard'] = {
        label = "SIG 9mm Magazine (15rd)",
        weapons = {
            'WEAPON_P320', 'WEAPON_SIGP320', 'WEAPON_SIGP226',
            'WEAPON_SIGP226MK25', 'WEAPON_SIGP229'
        },
        capacity = 15,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 92,
        price = 32,
    },

    ['mag_sig_extended'] = {
        label = "SIG 9mm Extended Magazine (21rd)",
        weapons = {
            'WEAPON_P320', 'WEAPON_SIGP320', 'WEAPON_SIGP226',
            'WEAPON_SIGP226MK25', 'WEAPON_SIGP229'
        },
        capacity = 21,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 135,
        price = 75,
    },

    ['mag_sig_p210'] = {
        label = "SIG P210 Magazine (8rd)",
        weapons = { 'WEAPON_SIGP210' },
        capacity = 8,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 75,
        price = 45, -- Premium Swiss magazine
    },

    -- ========================================================================
    -- REVOLVER SPEEDLOADERS (.357 MAG / .38 SPL / .44 MAG)
    -- ========================================================================

    ['speedloader_357'] = {
        label = ".357 Magnum Speedloader (6rd)",
        weapons = {
            'WEAPON_KINGCOBRA', 'WEAPON_KINGCOBRA_SNUB',
            'WEAPON_KINGCOBRA_TARGET', 'WEAPON_PYTHON', 'WEAPON_SW657'
        },
        capacity = 6,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 120,
        price = 15,
    },

    ['speedloader_38'] = {
        label = ".38 Special Speedloader (6rd)",
        weapons = { 'WEAPON_SW_MODEL15' },
        capacity = 6,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 95,
        price = 12,
    },

    ['speedloader_44'] = {
        label = ".44 Magnum Speedloader (6rd)",
        weapons = { 'WEAPON_SWMODEL29', 'WEAPON_RAGINGBULL' },
        capacity = 6,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 180,
        price = 20,
    },

    ['speedloader_500'] = {
        label = ".500 S&W Speedloader (5rd)",
        weapons = { 'WEAPON_SW500' },
        capacity = 5,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 280,
        price = 35,
    },

    -- ========================================================================
    -- 5.7x28mm MAGAZINES
    -- ========================================================================

    ['mag_fiveseven_standard'] = {
        label = "FN 5.7 Magazine (20rd)",
        weapons = { 'WEAPON_FN57', 'WEAPON_RUGER57' },
        capacity = 20,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 85,
        price = 40,
    },

    ['mag_fiveseven_extended'] = {
        label = "FN 5.7 Extended Magazine (30rd)",
        weapons = { 'WEAPON_FN57', 'WEAPON_RUGER57' },
        capacity = 30,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 125,
        price = 95,
    },

    -- ========================================================================
    -- .22 LR MAGAZINES
    -- ========================================================================

    ['mag_22lr_standard'] = {
        label = ".22 LR Magazine (10rd)",
        weapons = { 'WEAPON_P22', 'WEAPON_SIGP22' },
        capacity = 10,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 45,
        price = 15,
    },

    ['mag_fn502_standard'] = {
        label = "FN 502 Magazine (15rd)",
        weapons = { 'WEAPON_FN502' },
        capacity = 15,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 55,
        price = 25,
    },

    ['mag_pmr30_standard'] = {
        label = "PMR-30 Magazine (30rd)",
        weapons = { 'WEAPON_PMR30' },
        capacity = 30,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 75,
        price = 45,
    },

    -- ========================================================================
    -- 10mm AUTO MAGAZINES
    -- ========================================================================

    ['mag_glock20_standard'] = {
        label = "Glock 20 Magazine (15rd)",
        weapons = { 'WEAPON_GLOCK20' },
        capacity = 15,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 125,
        price = 38,
    },

    ['mag_glock20_extended'] = {
        label = "Glock 20 Extended Magazine (30rd)",
        weapons = { 'WEAPON_GLOCK20' },
        capacity = 30,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 230,
        price = 110,
    },

    -- ========================================================================
    -- SMG MAGAZINES (9mm)
    -- ========================================================================

    ['mag_mp5_standard'] = {
        label = "MP5 Magazine (30rd)",
        weapons = { 'WEAPON_MICRO_MP5' },
        capacity = 30,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 165,
        price = 55,
    },

    ['mag_mpx_standard'] = {
        label = "MPX Magazine (30rd)",
        weapons = { 'WEAPON_SIG_MPX' },
        capacity = 30,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 160,
        price = 60,
    },

    ['mag_scorpion_standard'] = {
        label = "Scorpion EVO Magazine (30rd)",
        weapons = { 'WEAPON_SCORPION' },
        capacity = 30,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 155,
        price = 50,
    },

    ['mag_scorpion_extended'] = {
        label = "Scorpion EVO Drum (50rd)",
        weapons = { 'WEAPON_SCORPION' },
        capacity = 50,
        type = 'drum',
        componentSuffix = '_DRUM_',
        weight = 380,
        price = 175,
    },

    ['mag_tec9_standard'] = {
        label = "TEC-9 Magazine (32rd)",
        weapons = { 'WEAPON_TEC9' },
        capacity = 32,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 170,
        price = 35,
    },

    ['mag_sub2000_standard'] = {
        label = "SUB-2000 Magazine (33rd)",
        weapons = { 'WEAPON_SUB2000' },
        capacity = 33,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 185,
        price = 45, -- Uses Glock mags
    },

    -- ========================================================================
    -- MAC MAGAZINES (.45 ACP)
    -- ========================================================================

    ['mag_mac10_standard'] = {
        label = "MAC-10 Magazine (30rd)",
        weapons = { 'WEAPON_MAC10', 'WEAPON_MAC4A1' },
        capacity = 30,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 195,
        price = 45,
    },

    ['mag_mac10_extended'] = {
        label = "MAC-10 Extended Magazine (50rd)",
        weapons = { 'WEAPON_MAC10', 'WEAPON_MAC4A1' },
        capacity = 50,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 320,
        price = 125,
    },

    -- ========================================================================
    -- 5.56 NATO MAGAZINES
    -- ========================================================================

    ['mag_556_standard'] = {
        label = "STANAG Magazine (30rd)",
        weapons = { 'WEAPON_MK18', 'WEAPON_ARP_BUMPSTOCK', 'WEAPON_SBR9' },
        capacity = 30,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 130,
        price = 25,
    },

    ['mag_556_extended'] = {
        label = "STANAG Extended Magazine (40rd)",
        weapons = { 'WEAPON_MK18', 'WEAPON_ARP_BUMPSTOCK', 'WEAPON_SBR9' },
        capacity = 40,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 175,
        price = 65,
    },

    ['mag_556_drum'] = {
        label = "5.56 Drum Magazine (60rd)",
        weapons = { 'WEAPON_MK18', 'WEAPON_ARP_BUMPSTOCK', 'WEAPON_SBR9' },
        capacity = 60,
        type = 'drum',
        componentSuffix = '_DRUM_',
        weight = 520,
        price = 195,
    },

    -- ========================================================================
    -- 6.8x51mm / .300 BLK MAGAZINES
    -- ========================================================================

    ['mag_68x51_standard'] = {
        label = "6.8x51mm Magazine (20rd)",
        weapons = { 'WEAPON_SIG_SPEAR', 'WEAPON_M7' },
        capacity = 20,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 145,
        price = 55,
    },

    ['mag_300blk_standard'] = {
        label = ".300 BLK Magazine (30rd)",
        weapons = { 'WEAPON_MCX300' },
        capacity = 30,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 155,
        price = 45,
    },
}

--[[
    Helper Functions
    ================
]]

-- Get magazine info by item name
function GetMagazineInfo(itemName)
    return Config.Magazines[itemName]
end

-- Get all compatible magazines for a weapon
function GetCompatibleMagazines(weaponHash)
    local compatible = {}
    local weaponName = type(weaponHash) == 'number' and GetWeaponNameFromHash(weaponHash) or weaponHash

    for magName, magInfo in pairs(Config.Magazines) do
        local weapons = type(magInfo.weapons) == 'table' and magInfo.weapons or { magInfo.weapons }
        for _, weapon in ipairs(weapons) do
            if weapon == weaponName then
                compatible[magName] = magInfo
                break
            end
        end
    end

    return compatible
end

-- Get component name for a magazine + ammo type combination
function GetMagazineComponentName(weaponHash, magazineItem, ammoType)
    local weaponInfo = Config.Weapons[weaponHash]
    local magInfo = Config.Magazines[magazineItem]

    if not weaponInfo or not magInfo then return nil end

    -- Build component name: COMPONENT_{WEAPON_BASE}{MAG_SUFFIX}{AMMO_TYPE}
    -- Example: COMPONENT_G26_EXTCLIP_FMJ
    local ammoConfig = Config.AmmoTypes[weaponInfo.caliber] and Config.AmmoTypes[weaponInfo.caliber][ammoType]
    if not ammoConfig then return nil end

    return weaponInfo.componentBase .. magInfo.componentSuffix .. string.upper(ammoType)
end

-- Check if weapon is compatible with magazine
function IsMagazineCompatible(weaponHash, magazineItem)
    local magInfo = Config.Magazines[magazineItem]
    if not magInfo then return false end

    local weaponName = type(weaponHash) == 'number' and GetWeaponNameFromHash(weaponHash) or weaponHash
    local weapons = type(magInfo.weapons) == 'table' and magInfo.weapons or { magInfo.weapons }

    for _, weapon in ipairs(weapons) do
        if weapon == weaponName then
            return true
        end
    end

    return false
end

-- Get weapon name from hash (utility)
function GetWeaponNameFromHash(hash)
    for name, info in pairs(Config.Weapons) do
        if GetHashKey(name) == hash or joaat(name) == hash then
            return name
        end
    end
    return nil
end
