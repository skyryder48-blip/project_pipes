--[[
    Ammunition System Configuration
    ================================

    This file defines all ammunition types, their inventory items,
    and the component suffixes used for magazine swapping.
]]

Config = {}

-- Debug mode (set to false in production)
Config.Debug = false

-- Return old ammo to inventory when swapping types
Config.ReturnOldAmmo = true

-- Notification settings
Config.Notifications = {
    ammoLoaded = true,
    ammoReturned = true,
    wrongCaliber = true,
    noWeapon = true,
}

-- Reload animation duration (ms) - time to wait before applying ammo change
Config.ReloadDelay = 1500

--[[
    AMMO TYPES CONFIGURATION

    Structure:
    Config.AmmoTypes[caliber][type] = {
        item = 'inventory_item_name',
        label = 'Display Name',
        componentSuffix = '_CLIP_TYPE',  -- Appended to weapon component base
        ammoInfo = 'AMMO_CALIBER_TYPE',  -- AmmoInfo reference in meta
    }
]]

Config.AmmoTypes = {
    -- ==================== 9mm AMMUNITION ====================
    ['9mm'] = {
        ['fmj'] = {
            item = 'ammo_9mm_fmj',
            label = '9mm FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_9MM_FMJ',
            description = 'Standard full metal jacket. Balanced performance.',
        },
        ['hp'] = {
            item = 'ammo_9mm_hp',
            label = '9mm Hollow Point',
            componentSuffix = '_CLIP_HP',
            ammoInfo = 'AMMO_9MM_HP',
            description = '+10% damage to unarmored targets. Reduced vs armor.',
        },
        ['ap'] = {
            item = 'ammo_9mm_ap',
            label = '9mm Armor Piercing',
            componentSuffix = '_CLIP_AP',
            ammoInfo = 'AMMO_9MM_AP',
            description = 'Bypasses body armor. -10% base damage, -2 capacity.',
        },
    },

    -- ==================== .45 ACP AMMUNITION ====================
    -- Batch 3: Full-Size .45 ACP Pistols (1911s and Glocks)
    -- Base damage: 38 (FMJ), 44 (JHP +15.8%)
    ['.45acp'] = {
        ['fmj'] = {
            item = 'ammo_45acp_fmj',
            label = '.45 ACP FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_45ACP_FMJ',
            description = 'Heavy .45 caliber full metal jacket. 38 base damage, 0.20 penetration.',
        },
        ['jhp'] = {
            item = 'ammo_45acp_jhp',
            label = '.45 ACP JHP',
            componentSuffix = '_CLIP_JHP',
            ammoInfo = 'AMMO_45ACP_JHP',
            description = 'Jacketed hollow point. +15.8% damage (44), reduced armor effectiveness.',
        },
    },

    -- ==================== .40 S&W AMMUNITION ====================
    -- Batch 4: .40 S&W Pistols (G22 Gen 4/5, Glock Demon)
    -- Enhanced Ballistics: FMJ 41 dmg, JHP 49 (+20%)
    -- "Snappy" recoil - 25% higher than 9mm, 18-33% more energy
    ['.40sw'] = {
        ['fmj'] = {
            item = 'ammo_40sw_fmj',
            label = '.40 S&W FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_40SW_FMJ',
            description = '.40 S&W full metal jacket. 41 damage, 0.72 penetration. 990 fps, ~420 ft-lbs.',
        },
        ['jhp'] = {
            item = 'ammo_40sw_jhp',
            label = '.40 S&W JHP',
            componentSuffix = '_CLIP_JHP',
            ammoInfo = 'AMMO_40SW_JHP',
            description = 'Jacketed hollow point. 49 damage (+20%), 0.55 penetration. Federal HST expansion.',
        },
    },

    -- ==================== .357 MAGNUM AMMUNITION ====================
    -- Batch 5: .357 Magnum Revolvers (King Cobra variants, Python)
    -- Enhanced Ballistics - BARREL DEPENDENT:
    -- 6" barrel: FMJ 58, JHP 70 (+20%) | 4" barrel: FMJ 49, JHP 59 | 2" barrel: compromised
    ['.357mag'] = {
        ['fmj'] = {
            item = 'ammo_357mag_fmj',
            label = '.357 Magnum FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_357MAG_FMJ',
            description = '.357 Magnum full metal jacket. 49-58 damage (barrel), 0.82-0.90 penetration. 1400-1650 fps.',
        },
        ['jhp'] = {
            item = 'ammo_357mag_jhp',
            label = '.357 Magnum JHP',
            componentSuffix = '_CLIP_JHP',
            ammoInfo = 'AMMO_357MAG_JHP',
            description = '.357 Magnum JHP. 59-70 damage (+20%), legendary "man-stopper" from 4"+ barrels.',
        },
    },

    -- ==================== .38 SPECIAL AMMUNITION ====================
    -- Batch 5: .38 Special Revolver (S&W Model 15)
    -- Enhanced Ballistics - WARNING: Only 57% of 9mm energy
    -- FMJ: 20 damage (200 ft-lbs), JHP +P: 27 damage (+35%)
    ['.38spl'] = {
        ['fmj'] = {
            item = 'ammo_38spl_fmj',
            label = '.38 Special FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_38SPL_FMJ',
            description = '.38 Special full metal jacket. 20 damage, 0.65 penetration. 755 fps, classic police round.',
        },
        ['jhp'] = {
            item = 'ammo_38spl_jhp',
            label = '.38 Special +P JHP',
            componentSuffix = '_CLIP_JHP',
            ammoInfo = 'AMMO_38SPL_JHP',
            description = '.38 Special +P JHP. 27 damage (+35%), 0.50 penetration. Short barrel expansion unreliable.',
        },
    },

    -- ==================== .44 MAGNUM AMMUNITION ====================
    -- Batch 6: .44 Magnum Revolvers (S&W Model 29, Taurus Raging Bull)
    -- Enhanced Ballistics - BARREL DEPENDENT:
    -- 4" barrel: FMJ 82, JHP 98 | 6.5" barrel: FMJ 100, JHP 120 | 8.375" barrel: FMJ 115, JHP 138
    -- The "Dirty Harry" cartridge - 65-80% more energy than .357 Magnum
    ['.44mag'] = {
        ['fmj'] = {
            item = 'ammo_44mag_fmj',
            label = '.44 Magnum FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_44MAG_FMJ',
            description = '.44 Magnum FMJ. 82-115 damage (barrel), 0.85 penetration. OVERKILL for defense - 20-30" gel.',
        },
        ['jhp'] = {
            item = 'ammo_44mag_jhp',
            label = '.44 Magnum JHP',
            componentSuffix = '_CLIP_JHP',
            ammoInfo = 'AMMO_44MAG_JHP',
            description = '.44 Magnum JHP. 98-138 damage (+20%), 0.70 penetration. Devastating terminal performance.',
        },
    },

    -- ==================== .500 S&W MAGNUM AMMUNITION ====================
    -- Batch 6: .500 S&W Revolver (S&W Model 500)
    -- THE MOST POWERFUL PRODUCTION HANDGUN CARTRIDGE
    -- Equals .308 Winchester / .30-06 Springfield rifle performance
    -- 4" barrel: 160 dmg | 6.5" barrel: 185 dmg | 8.375" barrel: 200 dmg | 10.5" barrel: 215 dmg
    ['.500sw'] = {
        ['fmj'] = {
            item = 'ammo_500sw_fmj',
            label = '.500 S&W FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_500SW_FMJ',
            description = '.500 S&W FMJ. 160-215 damage, 0.90 penetration. RIFLE-LEVEL POWER - 3,032 ft-lbs @ 8.375".',
        },
        ['jhp'] = {
            item = 'ammo_500sw_jhp',
            label = '.500 S&W JHP',
            componentSuffix = '_CLIP_JHP',
            ammoInfo = 'AMMO_500SW_JHP',
            description = '.500 S&W JHP. 192-258 damage (+20%), 0.75 penetration. Extreme recoil - 3x .44 Magnum.',
        },
    },

    -- ==================== 5.7x28mm AMMUNITION ====================
    -- PDW Caliber: FN Five-seveN, Ruger-57
    -- High velocity (1,650-2,200 fps), low recoil (30% less than 9mm)
    -- 20-round standard capacity, flat trajectory, 60-70% of 9mm energy
    ['5.7x28'] = {
        ['fmj'] = {
            item = 'ammo_57x28_fmj',
            label = '5.7x28mm FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_57X28_FMJ',
            description = '5.7x28mm V-MAX. 35 damage, 0.65 penetration. 1,700 fps, civilian hunting/sporting load.',
        },
        ['jhp'] = {
            item = 'ammo_57x28_jhp',
            label = '5.7x28mm JHP',
            componentSuffix = '_CLIP_JHP',
            ammoInfo = 'AMMO_57X28_JHP',
            description = '5.7x28mm Gold Dot. 42 damage (+20%), 0.50 penetration. BEST defensive choice - controlled expansion.',
        },
        ['ap'] = {
            item = 'ammo_57x28_ap',
            label = '5.7x28mm AP',
            componentSuffix = '_CLIP_AP',
            ammoInfo = 'AMMO_57X28_AP',
            description = '5.7x28mm SS190 AP. 32 damage, 0.95 penetration. DEFEATS Level IIIA armor. Military/LE restricted.',
        },
    },

    -- ==================== FUTURE CALIBERS ====================
    -- Uncomment and configure when adding new calibers

    --[[
    ['12ga'] = {
        ['buckshot'] = {
            item = 'ammo_12ga_buckshot',
            label = '12ga 00 Buckshot',
            componentSuffix = '_CLIP_BUCK',
            ammoInfo = 'AMMO_12GA_BUCKSHOT',
            description = '8 pellets per shell. Standard defensive load.',
        },
        ['slug'] = {
            item = 'ammo_12ga_slug',
            label = '12ga Slug',
            componentSuffix = '_CLIP_SLUG',
            ammoInfo = 'AMMO_12GA_SLUG',
            description = 'Single heavy projectile. Extended range.',
        },
        ['birdshot'] = {
            item = 'ammo_12ga_birdshot',
            label = '12ga Birdshot',
            componentSuffix = '_CLIP_BIRD',
            ammoInfo = 'AMMO_12GA_BIRDSHOT',
            description = 'Many small pellets. Wide spread, close range.',
        },
        ['dragon'] = {
            item = 'ammo_12ga_dragon',
            label = '12ga Dragon\'s Breath',
            componentSuffix = '_CLIP_DRAGON',
            ammoInfo = 'AMMO_12GA_DRAGON',
            description = 'Incendiary rounds. Sets targets on fire.',
        },
    },
    ]]
}

-- Default ammo type for each caliber (used when weapon is first equipped)
Config.DefaultAmmoType = {
    ['9mm'] = 'fmj',
    ['.45acp'] = 'fmj',
    ['.40sw'] = 'fmj',
    ['.357mag'] = 'fmj',
    ['.38spl'] = 'fmj',
    ['.44mag'] = 'fmj',
    ['.500sw'] = 'fmj',
    ['5.7x28'] = 'fmj',
    ['12ga'] = 'buckshot',
}
