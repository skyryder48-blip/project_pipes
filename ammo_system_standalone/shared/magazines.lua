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

    WEAPONS WITH EXTENDED MAG OPTIONS:
    - Semi-auto pistols with detachable box magazines
    - SMGs with detachable magazines
    - AR-platform rifles

    WEAPONS WITHOUT EXTENDED MAGS (ammo types only):
    - Revolvers (fixed cylinder capacity)
    - Shotguns (tube-fed, fixed capacity)
    - Bolt-action/hunting rifles
]]

Config.MagazineSystem = {
    enabled = true,
    loadTimePerRound = 0.5,
    swapTime = {
        standard = 1.5,
        extended = 2.0,
        drum = 3.0,
    },
    allowPartialLoad = true,
    autoReloadFromInventory = true,
    autoReloadPriority = 'same_ammo_first',
}

--[[
    Magazine Definitions
    ====================

    Only weapons with DETACHABLE BOX MAGAZINES that realistically
    have extended capacity options are included here.

    Revolvers use speedloaders (single capacity).
    Shotguns are tube-fed (capacity fixed by weapon).
]]

Config.Magazines = {

    -- ========================================================================
    -- COMPACT 9mm PISTOLS (10-11 round base)
    -- Extended: 15-17rd basepad, 33rd stick
    -- ========================================================================

    ['mag_g26_standard'] = {
        label = "Glock 26 Magazine (10rd)",
        weapons = { 'WEAPON_G26', 'WEAPON_G43X' },
        capacity = 10,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 80,
        price = 25,
    },

    ['mag_g26_extended'] = {
        label = "Glock 26 Extended (17rd)",
        weapons = { 'WEAPON_G26', 'WEAPON_G43X' },
        capacity = 17,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 120,
        price = 55,
    },

    ['mag_g26_stick'] = {
        label = "Glock 9mm Stick Magazine (33rd)",
        weapons = { 'WEAPON_G26', 'WEAPON_G43X', 'WEAPON_G26_SWITCH' },
        capacity = 33,
        type = 'extended',
        componentSuffix = '_STICK_',
        weight = 185,
        price = 95,
    },

    ['mag_compact9_standard'] = {
        label = "Compact 9mm Magazine (11rd)",
        weapons = { 'WEAPON_GX4', 'WEAPON_HELLCAT' },
        capacity = 11,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 75,
        price = 25,
    },

    ['mag_compact9_extended'] = {
        label = "Compact 9mm Extended (15rd)",
        weapons = { 'WEAPON_GX4', 'WEAPON_HELLCAT' },
        capacity = 15,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 100,
        price = 45,
    },

    -- ========================================================================
    -- FULL-SIZE GLOCK 9mm (17 round base)
    -- Extended: 33rd stick, 50rd drum
    -- ========================================================================

    ['mag_glock9_standard'] = {
        label = "Glock 9mm Magazine (17rd)",
        weapons = {
            'WEAPON_G17', 'WEAPON_G17_BLK', 'WEAPON_G17_GEN5',
            'WEAPON_G18',
            'WEAPON_G19', 'WEAPON_G19X', 'WEAPON_G19XD',
            'WEAPON_G45', 'WEAPON_G45_TAN',
        },
        capacity = 17,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 95,
        price = 30,
    },

    ['mag_glock9_extended'] = {
        label = "Glock 9mm Stick (33rd)",
        weapons = {
            'WEAPON_G17', 'WEAPON_G17_BLK', 'WEAPON_G17_GEN5',
            'WEAPON_G18',
            'WEAPON_G19', 'WEAPON_G19X', 'WEAPON_G19XD', 'WEAPON_G19X_SWITCH',
            'WEAPON_G45', 'WEAPON_G45_TAN',
        },
        capacity = 33,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 185,
        price = 90,
    },

    ['mag_glock9_drum'] = {
        label = "Glock 9mm Drum (50rd)",
        weapons = {
            'WEAPON_G17', 'WEAPON_G17_BLK', 'WEAPON_G17_GEN5',
            'WEAPON_G18',
            'WEAPON_G19', 'WEAPON_G19X', 'WEAPON_G19XD', 'WEAPON_G19X_SWITCH',
            'WEAPON_G45', 'WEAPON_G45_TAN',
        },
        capacity = 50,
        type = 'drum',
        componentSuffix = '_DRUM_',
        weight = 460,
        price = 275,
    },

    -- ========================================================================
    -- BERETTA 9mm (15-17 round base)
    -- Extended: 30rd
    -- ========================================================================

    ['mag_beretta_standard'] = {
        label = "Beretta 9mm Magazine (15rd)",
        weapons = { 'WEAPON_M9', 'WEAPON_PX4', 'WEAPON_PX4STORM' },
        capacity = 15,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 90,
        price = 28,
    },

    ['mag_beretta_m9a3'] = {
        label = "Beretta M9A3 Magazine (17rd)",
        weapons = { 'WEAPON_M9A3' },
        capacity = 17,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 100,
        price = 32,
    },

    ['mag_beretta_extended'] = {
        label = "Beretta 9mm Extended (30rd)",
        weapons = { 'WEAPON_M9', 'WEAPON_M9A3', 'WEAPON_PX4', 'WEAPON_PX4STORM' },
        capacity = 30,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 175,
        price = 85,
    },

    -- ========================================================================
    -- SIG SAUER 9mm (8-17 round base depending on model)
    -- Extended: 21rd
    -- ========================================================================

    ['mag_sig_p210'] = {
        label = "SIG P210 Magazine (8rd)",
        weapons = { 'WEAPON_SIGP210' },
        capacity = 8,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 75,
        price = 45,
    },

    ['mag_sig_standard'] = {
        label = "SIG 9mm Magazine (15rd)",
        weapons = { 'WEAPON_P320', 'WEAPON_SIGP320', 'WEAPON_SIGP226', 'WEAPON_SIGP226MK25', 'WEAPON_SIGP229' },
        capacity = 15,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 92,
        price = 35,
    },

    ['mag_sig_extended'] = {
        label = "SIG 9mm Extended (21rd)",
        weapons = { 'WEAPON_P320', 'WEAPON_SIGP320', 'WEAPON_SIGP226', 'WEAPON_SIGP226MK25', 'WEAPON_SIGP229' },
        capacity = 21,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 135,
        price = 75,
    },

    -- ========================================================================
    -- OTHER 9mm PISTOLS
    -- ========================================================================

    ['mag_fn509_standard'] = {
        label = "FN 509 Magazine (17rd)",
        weapons = { 'WEAPON_FN509' },
        capacity = 17,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 95,
        price = 35,
    },

    ['mag_fn509_extended'] = {
        label = "FN 509 Extended (24rd)",
        weapons = { 'WEAPON_FN509' },
        capacity = 24,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 140,
        price = 80,
    },

    ['mag_tp9sf_standard'] = {
        label = "Canik TP9SF Magazine (18rd)",
        weapons = { 'WEAPON_TP9SF' },
        capacity = 18,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 98,
        price = 30,
    },

    ['mag_walther_standard'] = {
        label = "Walther P88 Magazine (15rd)",
        weapons = { 'WEAPON_WALTHERP88' },
        capacity = 15,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 90,
        price = 40,
    },

    ['mag_rugersr9_standard'] = {
        label = "Ruger SR9 Magazine (17rd)",
        weapons = { 'WEAPON_RUGERSR9' },
        capacity = 17,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 95,
        price = 28,
    },

    ['mag_psadagger_standard'] = {
        label = "PSA Dagger Magazine (15rd)",
        weapons = { 'WEAPON_PSADAGGER' },
        capacity = 15,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 88,
        price = 22,
    },

    -- ========================================================================
    -- GLOCK .45 ACP (10-13 round base)
    -- Extended: 26rd
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
        label = "Glock .45 Extended (26rd)",
        weapons = { 'WEAPON_G21', 'WEAPON_G30', 'WEAPON_G41' },
        capacity = 26,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 220,
        price = 110,
    },

    -- ========================================================================
    -- 1911 .45 ACP (7-8 round base)
    -- Extended: 10rd basepad only (no stick mags for 1911s realistically)
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

    ['mag_1911_8rd'] = {
        label = "1911 Magazine (8rd)",
        weapons = { 'WEAPON_M45A1', 'WEAPON_KIMBER_ECLIPSE' },
        capacity = 8,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 90,
        price = 28,
    },

    ['mag_1911_extended'] = {
        label = "1911 Extended (10rd)",
        weapons = { 'WEAPON_M45A1', 'WEAPON_KIMBER1911', 'WEAPON_KIMBER_ECLIPSE' },
        capacity = 10,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 110,
        price = 55,
    },

    ['mag_sigp220_standard'] = {
        label = "SIG P220 Magazine (8rd)",
        weapons = { 'WEAPON_SIGP220' },
        capacity = 8,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 95,
        price = 35,
    },

    -- ========================================================================
    -- .40 S&W (13-15 round base)
    -- Extended: 22rd
    -- ========================================================================

    ['mag_glock40_standard'] = {
        label = "Glock .40 Magazine (15rd)",
        weapons = { 'WEAPON_G22_GEN4', 'WEAPON_G22_GEN5' },
        capacity = 15,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 105,
        price = 32,
    },

    ['mag_glock40_compact'] = {
        label = "Glock Demon Magazine (13rd)",
        weapons = { 'WEAPON_GLOCK_DEMON' },
        capacity = 13,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 95,
        price = 30,
    },

    ['mag_glock40_extended'] = {
        label = "Glock .40 Extended (22rd)",
        weapons = { 'WEAPON_G22_GEN4', 'WEAPON_G22_GEN5', 'WEAPON_GLOCK_DEMON' },
        capacity = 22,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 160,
        price = 85,
    },

    -- ========================================================================
    -- 5.7x28mm (20 round base)
    -- Extended: 30rd
    -- ========================================================================

    ['mag_57_standard'] = {
        label = "5.7x28mm Magazine (20rd)",
        weapons = { 'WEAPON_FN57', 'WEAPON_RUGER57' },
        capacity = 20,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 85,
        price = 40,
    },

    ['mag_57_extended'] = {
        label = "5.7x28mm Extended (30rd)",
        weapons = { 'WEAPON_FN57', 'WEAPON_RUGER57' },
        capacity = 30,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 125,
        price = 95,
    },

    -- ========================================================================
    -- .22 LR (10-30 round base depending on model)
    -- Most .22s have high capacity standard, limited extended options
    -- ========================================================================

    ['mag_22_standard'] = {
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
    -- 10mm AUTO (15 round base)
    -- Extended: 30rd
    -- ========================================================================

    ['mag_10mm_standard'] = {
        label = "Glock 20 Magazine (15rd)",
        weapons = { 'WEAPON_GLOCK20' },
        capacity = 15,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 125,
        price = 38,
    },

    ['mag_10mm_extended'] = {
        label = "Glock 20 Extended (30rd)",
        weapons = { 'WEAPON_GLOCK20' },
        capacity = 30,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 230,
        price = 110,
    },

    -- ========================================================================
    -- 9mm SMGs (30-33 round base)
    -- Drums available for some
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

    ['mag_scorpion_drum'] = {
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

    ['mag_mpa30_standard'] = {
        label = "MPA30 Magazine (30rd)",
        weapons = { 'WEAPON_MPA30' },
        capacity = 30,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 165,
        price = 40,
    },

    ['mag_sub2000_standard'] = {
        label = "SUB-2000 Magazine (33rd)",
        weapons = { 'WEAPON_SUB2000' },
        capacity = 33,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 185,
        price = 45,
    },

    ['mag_ram9_standard'] = {
        label = "RAM-9 Magazine (33rd)",
        weapons = { 'WEAPON_RAM9_DESERT' },
        capacity = 33,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 180,
        price = 50,
    },

    -- ========================================================================
    -- .45 ACP SMGs (MAC-10/MAC-4A1)
    -- Standard: 30rd, Extended: 50rd
    -- ========================================================================

    ['mag_mac_standard'] = {
        label = "MAC .45 Magazine (30rd)",
        weapons = { 'WEAPON_MAC10', 'WEAPON_MAC4A1' },
        capacity = 30,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 195,
        price = 45,
    },

    ['mag_mac_extended'] = {
        label = "MAC .45 Extended (50rd)",
        weapons = { 'WEAPON_MAC10', 'WEAPON_MAC4A1' },
        capacity = 50,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 320,
        price = 125,
    },

    -- ========================================================================
    -- 5.56 NATO RIFLES (30 round base)
    -- Extended: 40rd, Drum: 60rd
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
        label = "STANAG Extended (40rd)",
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
    -- 6.8x51mm RIFLES (20 round base)
    -- Limited extended options for new military caliber
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

    -- ========================================================================
    -- .300 BLACKOUT RIFLES (30 round base)
    -- Uses STANAG-compatible mags
    -- ========================================================================

    ['mag_300blk_standard'] = {
        label = ".300 BLK Magazine (30rd)",
        weapons = { 'WEAPON_MCX300' },
        capacity = 30,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 155,
        price = 45,
    },

    -- ========================================================================
    -- AR-9 PISTOLS/PCCs (Use Glock mags)
    -- ========================================================================

    ['mag_ar9_standard'] = {
        label = "AR-9 Magazine (17rd)",
        weapons = { 'WEAPON_UDP9', 'WEAPON_BLUEARP' },
        capacity = 17,
        type = 'standard',
        componentSuffix = '_CLIP_',
        weight = 95,
        price = 30,
    },

    ['mag_ar9_extended'] = {
        label = "AR-9 Extended (33rd)",
        weapons = { 'WEAPON_UDP9', 'WEAPON_BLUEARP' },
        capacity = 33,
        type = 'extended',
        componentSuffix = '_EXTCLIP_',
        weight = 185,
        price = 85,
    },
}

-- ============================================================================
-- SPEEDLOADERS (Revolvers - Single Capacity, Ammo Type Changes Only)
-- ============================================================================
-- Note: Revolvers don't have "extended" options. Cylinder capacity is fixed.
-- Speedloaders are just for faster reloading, not capacity increase.

Config.Speedloaders = {
    ['speedloader_357'] = {
        label = ".357 Magnum Speedloader",
        weapons = { 'WEAPON_KINGCOBRA', 'WEAPON_KINGCOBRA_SNUB', 'WEAPON_KINGCOBRA_TARGET', 'WEAPON_PYTHON', 'WEAPON_SW657' },
        capacity = 6,
        weight = 120,
        price = 15,
    },

    ['speedloader_38'] = {
        label = ".38 Special Speedloader",
        weapons = { 'WEAPON_SW_MODEL15' },
        capacity = 6,
        weight = 95,
        price = 12,
    },

    ['speedloader_44'] = {
        label = ".44 Magnum Speedloader",
        weapons = { 'WEAPON_SWMODEL29', 'WEAPON_RAGINGBULL' },
        capacity = 6,
        weight = 180,
        price = 20,
    },

    ['speedloader_500'] = {
        label = ".500 S&W Speedloader",
        weapons = { 'WEAPON_SW500' },
        capacity = 5,
        weight = 280,
        price = 35,
    },
}

-- ============================================================================
-- SHOTGUNS - NO MAGAZINES (Tube-Fed)
-- ============================================================================
-- Shotguns in this system are tube-fed. Capacity is fixed by weapon.
-- Only ammo TYPE changes, not capacity. No magazine items needed.
--
-- Mini Shotty:      4 rounds (tube)
-- Model 680:        5 rounds (tube)
-- Remington 870:    5 rounds (tube)
-- Mossberg 500:     6 rounds (tube)
-- Browning Auto-5:  5 rounds (tube)
-- Beretta 1301:     8 rounds (tube)
-- Shockwave:        6 rounds (tube)

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

function GetMagazineInfo(itemName)
    return Config.Magazines[itemName]
end

function GetSpeedloaderInfo(itemName)
    return Config.Speedloaders[itemName]
end

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

function GetWeaponNameFromHash(hash)
    for name, info in pairs(Config.Weapons) do
        if GetHashKey(name) == hash or joaat(name) == hash then
            return name
        end
    end
    return nil
end

function GetMagazineComponentName(weaponHash, magazineItem, ammoType)
    local weaponInfo = Config.Weapons[weaponHash]
    local magInfo = Config.Magazines[magazineItem]

    if not weaponInfo or not magInfo then return nil end

    local ammoConfig = Config.AmmoTypes[weaponInfo.caliber] and Config.AmmoTypes[weaponInfo.caliber][ammoType]
    if not ammoConfig then return nil end

    return weaponInfo.componentBase .. magInfo.componentSuffix .. string.upper(ammoType)
end
