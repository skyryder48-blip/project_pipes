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
        ['bear'] = {
            item = 'ammo_500sw_bear',
            label = '.500 S&W Bear Defense',
            componentSuffix = '_CLIP_BEAR',
            ammoInfo = 'AMMO_500SW_BEAR',
            description = '.500 S&W Hard Cast 440gr @ 1,625 fps. MAXIMUM PENETRATION - defeats anything. Anti-dangerous game.',
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
            description = '5.7x28mm V-MAX. 28 damage, 0.70 penetration. 1,700 fps, civilian hunting/sporting load.',
        },
        ['jhp'] = {
            item = 'ammo_57x28_jhp',
            label = '5.7x28mm JHP',
            componentSuffix = '_CLIP_JHP',
            ammoInfo = 'AMMO_57X28_JHP',
            description = '5.7x28mm Gold Dot. 35 damage (+25%), 0.55 penetration. BEST defensive choice - controlled expansion.',
        },
        ['ap'] = {
            item = 'ammo_57x28_ap',
            label = '5.7x28mm AP',
            componentSuffix = '_CLIP_AP',
            ammoInfo = 'AMMO_57X28_AP',
            description = '5.7x28mm SS190 AP. 30 damage, 0.96 penetration. DEFEATS Level IIIA armor. Military/LE restricted.',
        },
    },

    -- ==================== 10mm AUTO AMMUNITION ====================
    -- Batch 10: Full-Power 10mm Pistols (Glock 20)
    -- DUAL PERSONALITY: FBI-spec (~400 ft-lbs) vs Full-power (~650 ft-lbs)
    -- FBI-spec = .40 S&W equivalent, Full-power = .357 Magnum equivalent
    -- 15+1 capacity in semi-auto platform with magnum-class power
    ['10mm'] = {
        ['fbi'] = {
            item = 'ammo_10mm_fbi',
            label = '10mm FBI Service',
            componentSuffix = '_CLIP_FBI',
            ammoInfo = 'AMMO_10MM_FBI',
            description = '10mm FBI-spec 180gr @ 1,000 fps. 42 damage, 0.72 penetration. = .40 S&W ballistics.',
        },
        ['fullpower'] = {
            item = 'ammo_10mm_fullpower',
            label = '10mm Full Power',
            componentSuffix = '_CLIP_FULLPOWER',
            ammoInfo = 'AMMO_10MM_FULLPOWER',
            description = '10mm Full Power 180gr @ 1,300 fps. 52 damage (+24%), 0.65 penetration. = .357 Magnum.',
        },
        ['bear'] = {
            item = 'ammo_10mm_bear',
            label = '10mm Bear Defense',
            componentSuffix = '_CLIP_BEAR',
            ammoInfo = 'AMMO_10MM_BEAR',
            description = '10mm Hard Cast 220gr @ 1,200 fps. 50 damage, 0.95 penetration. 32"+ gel penetration.',
        },
    },

    -- ==================== .22 LR AMMUNITION ====================
    -- Batch 8: Rimfire Pistols (P22, SIG P22, FN 502, PMR-30)
    -- LOWEST POWER handgun cartridge: 80-115 ft-lbs from pistol barrels
    -- Minimal recoil, high capacity, high headshot multipliers compensate
    -- PMR-30 uses .22 WMR ballistics (160 ft-lbs) but same ammo system
    ['.22lr'] = {
        ['fmj'] = {
            item = 'ammo_22lr_fmj',
            label = '.22 LR FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_22LR_FMJ',
            description = '.22 LR CCI Mini-Mag. 12-15 damage, 0.50 penetration. ~1,000 fps, suppressor-friendly.',
        },
        ['jhp'] = {
            item = 'ammo_22lr_jhp',
            label = '.22 LR JHP',
            componentSuffix = '_CLIP_JHP',
            ammoInfo = 'AMMO_22LR_JHP',
            description = '.22 LR CCI Velocitor. +20% damage, 0.35 penetration. HP rarely expands from short barrels.',
        },
    },

    -- ==================== 12 GAUGE SHOTGUN AMMUNITION ====================
    -- Batch 18: 12 Gauge Shotguns
    -- UNIQUE MECHANICS: BulletsInBatch (pellet count), BatchSpread (cone angle)
    -- Damage is PER PELLET - total damage = pellets × damage × hit percentage
    -- 8 ammo types: Combat loads (4) + Specialty loads (4)
    ['12ga'] = {
        -- COMBAT LOADS --
        ['00buck'] = {
            item = 'ammo_12ga_00buck',
            label = '12ga 00 Buckshot',
            componentSuffix = '_CLIP_00BUCK',
            ammoInfo = 'AMMO_12G_00BUCK',
            description = '8 pellets @ 22 dmg each = 176 max. Standard combat load, 30m effective range.',
        },
        ['1buck'] = {
            item = 'ammo_12ga_1buck',
            label = '12ga #1 Buckshot',
            componentSuffix = '_CLIP_1BUCK',
            ammoInfo = 'AMMO_12G_1BUCK',
            description = '12 pellets @ 14 dmg each = 168 max. More pellets, HollowPoint behavior, 25m range.',
        },
        ['slug'] = {
            item = 'ammo_12ga_slug',
            label = '12ga Slug',
            componentSuffix = '_CLIP_SLUG',
            ammoInfo = 'AMMO_12G_SLUG',
            description = 'Single 120 dmg projectile. Precision accuracy, 80m effective range, FMJ penetration.',
        },
        ['birdshot'] = {
            item = 'ammo_12ga_birdshot',
            label = '12ga Birdshot',
            componentSuffix = '_CLIP_BIRDSHOT',
            ammoInfo = 'AMMO_12G_BIRDSHOT',
            description = '19 pellets @ 8 dmg each = 152 max. Wide spread, crowd control, 20m range.',
        },

        -- SPECIALTY LOADS --
        ['pepperball'] = {
            item = 'ammo_12ga_pepperball',
            label = '12ga Pepperball',
            componentSuffix = '_CLIP_PEPPERBALL',
            ammoInfo = 'AMMO_12G_PEPPERBALL',
            description = '6 irritant pellets. Causes coughing + vision blur effects. Requires client script.',
        },
        ['dragonsbreath'] = {
            item = 'ammo_12ga_dragonsbreath',
            label = '12ga Dragon\'s Breath',
            componentSuffix = '_CLIP_DRAGONSBREATH',
            ammoInfo = 'AMMO_12G_DRAGONSBREATH',
            description = '8 incendiary pellets. Magnesium fire trail, ignites targets on hit, 25m range.',
        },
        ['beanbag'] = {
            item = 'ammo_12ga_beanbag',
            label = '12ga Beanbag',
            componentSuffix = '_CLIP_BEANBAG',
            ammoInfo = 'AMMO_12G_BEANBAG',
            description = 'Less-lethal fabric round. 8 damage only, causes ragdoll knockback effect.',
        },
        ['breach'] = {
            item = 'ammo_12ga_breach',
            label = '12ga Breaching',
            componentSuffix = '_CLIP_BREACH',
            ammoInfo = 'AMMO_12G_BREACH',
            description = 'Frangible slug for door locks/hinges. High env damage, 3m effective range, no ricochet.',
        },
    },

    -- ==================== 5.56 NATO AMMUNITION ====================
    -- Batch 17: 5.56 NATO AR Pistols / SBRs (Mk18, ARP Bumpstock, SBR9)
    -- STANDARDIZED 3-TYPE SYSTEM matching 9mm pattern
    ['5.56'] = {
        ['fmj'] = {
            item = 'ammo_556_fmj',
            label = '5.56 NATO FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_556_FMJ',
            description = '5.56 M193 ball ammunition. Baseline damage, standard penetration.',
        },
        ['sp'] = {
            item = 'ammo_556_sp',
            label = '5.56 NATO Soft Point',
            componentSuffix = '_CLIP_SP',
            ammoInfo = 'AMMO_556_SP',
            description = '5.56 soft point. +10% damage, civilian defense/hunting, reduced penetration.',
        },
        ['ap'] = {
            item = 'ammo_556_ap',
            label = '5.56 NATO AP',
            componentSuffix = '_CLIP_AP',
            ammoInfo = 'AMMO_556_AP',
            description = '5.56 armor piercing. -10% damage, enhanced barrier penetration.',
        },
    },

    -- ==================== 6.8x51mm AMMUNITION ====================
    -- Batch 14: NGSW Rifles (SIG SPEAR, XM7)
    ['6.8x51'] = {
        ['fmj'] = {
            item = 'ammo_68x51_fmj',
            label = '6.8x51mm FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_68X51_FMJ',
            description = '6.8x51mm ball. NGSW standard issue, defeats Level IV armor.',
        },
        ['ap'] = {
            item = 'ammo_68x51_ap',
            label = '6.8x51mm AP',
            componentSuffix = '_CLIP_AP',
            ammoInfo = 'AMMO_68X51_AP',
            description = '6.8x51mm armor piercing. Maximum penetration for hardened targets.',
        },
    },

    -- ==================== .300 BLACKOUT AMMUNITION ====================
    -- Batch 14: .300 BLK Rifles (MCX 300), Batch 11: Blue ARP
    ['.300blk'] = {
        ['hunting'] = {
            item = 'ammo_300blk_hunting',
            label = '.300 BLK Hunting',
            componentSuffix = '_CLIP_HUNTING',
            ammoInfo = 'AMMO_300BLK_HUNTING',
            description = '.300 BLK 110gr V-MAX @ 2,350 fps. Supersonic expanding, max terminal effect.',
        },
        ['subsonic'] = {
            item = 'ammo_300blk_subsonic',
            label = '.300 BLK Subsonic',
            componentSuffix = '_CLIP_SUBSONIC',
            ammoInfo = 'AMMO_300BLK_SUBSONIC',
            description = '.300 BLK 220gr OTM @ 1,050 fps. Below speed of sound, suppressor-optimized.',
        },
    },

    -- ==================== 7.62x39mm AMMUNITION ====================
    -- Batch 13: AK-Platform Rifles (Micro Draco, CMMG Mk47 Mutant)
    -- Soviet intermediate cartridge: 123gr @ 2,350 fps = 1,508 ft-lbs
    -- +14% more damage than 5.56 NATO, superior short-barrel performance
    ['7.62x39'] = {
        ['fmj'] = {
            item = 'ammo_762x39_fmj',
            label = '7.62x39mm FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_762X39_FMJ',
            description = '7.62x39 M43/M67 ball. 48 damage baseline, 0.38 penetration. Soviet standard issue.',
        },
        ['sp'] = {
            item = 'ammo_762x39_sp',
            label = '7.62x39mm Soft Point',
            componentSuffix = '_CLIP_SP',
            ammoInfo = 'AMMO_762X39_SP',
            description = '7.62x39 expanding hunting load. +15% soft tissue damage, -40% barrier penetration.',
        },
        ['ap'] = {
            item = 'ammo_762x39_ap',
            label = '7.62x39mm AP',
            componentSuffix = '_CLIP_AP',
            ammoInfo = 'AMMO_762X39_AP',
            description = '7.62x39 7N23 BP armor piercing. -10% damage, +50% vs armor. Tool steel penetrator.',
        },
    },

    -- ==================== 7.62x51mm NATO / .308 WINCHESTER ====================
    -- Batch 19: Precision Rifles (Remington 700, Sauer 101, Remington M24)
    -- Full-power battle rifle cartridge: 147gr @ 2,800 fps = 2,627 ft-lbs
    -- 74% more energy than 7.62x39, NATO standard sniper/DMR round
    ['7.62x51'] = {
        ['fmj'] = {
            item = 'ammo_308_fmj',
            label = '7.62 NATO FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_762X51_FMJ',
            description = '7.62 NATO M80 ball. 147gr @ 2,800 fps, 2,627 ft-lbs. Standard military issue.',
        },
        ['match'] = {
            item = 'ammo_308_match',
            label = '7.62 NATO Match',
            componentSuffix = '_CLIP_MATCH',
            ammoInfo = 'AMMO_762X51_MATCH',
            description = '7.62 NATO Sierra MatchKing 168gr HPBT. +5% damage, sub-MOA precision.',
        },
        ['ap'] = {
            item = 'ammo_308_ap',
            label = '7.62 NATO AP',
            componentSuffix = '_CLIP_AP',
            ammoInfo = 'AMMO_762X51_AP',
            description = '7.62 NATO M993 tungsten AP. -5% damage, defeats Level III+ armor.',
        },
    },

    -- ==================== .300 WINCHESTER MAGNUM ====================
    -- Batch 19: Long-Range Precision (NEMO Omen Watchman)
    -- Magnum hunting/sniper cartridge: 180gr @ 2,960 fps = 3,700 ft-lbs
    -- 40% more energy than .308, 1000+ yard effective range
    ['.300wm'] = {
        ['fmj'] = {
            item = 'ammo_300wm_fmj',
            label = '.300 Win Mag FMJ',
            componentSuffix = '_CLIP_FMJ',
            ammoInfo = 'AMMO_300WM_FMJ',
            description = '.300 Win Mag 180gr hunting load. 3,700 ft-lbs, long-range big game standard.',
        },
        ['match'] = {
            item = 'ammo_300wm_match',
            label = '.300 Win Mag Match',
            componentSuffix = '_CLIP_MATCH',
            ammoInfo = 'AMMO_300WM_MATCH',
            description = '.300 Win Mag 190gr Sierra MK. +3% damage, competition precision load.',
        },
    },

    -- ==================== .50 BMG (12.7x99mm NATO) ====================
    -- Batch 19: Anti-Materiel Rifles (Barrett M82A1, M107A1, Victus XMR)
    -- THE MOST POWERFUL conventional small arms cartridge
    -- 647gr @ 2,910 fps = 13,200 ft-lbs (36x 9mm energy)
    ['.50bmg'] = {
        ['ball'] = {
            item = 'ammo_50bmg_ball',
            label = '.50 BMG Ball',
            componentSuffix = '_CLIP_BALL',
            ammoInfo = 'AMMO_50BMG_BALL',
            description = '.50 BMG M33 ball. 647gr @ 2,910 fps, 13,200 ft-lbs. Anti-personnel baseline.',
        },
        ['api'] = {
            item = 'ammo_50bmg_api',
            label = '.50 BMG API',
            componentSuffix = '_CLIP_API',
            ammoInfo = 'AMMO_50BMG_API',
            description = '.50 BMG M8 Armor Piercing Incendiary. -5% damage, ignites on armor impact.',
        },
        ['boom'] = {
            item = 'ammo_50bmg_boom',
            label = '.50 BMG BOOM',
            componentSuffix = '_CLIP_BOOM',
            ammoInfo = 'AMMO_50BMG_BOOM',
            description = '.50 BMG explosive multipurpose. +10% damage, DEVASTATING vs vehicles. Penetrate→fragment→explode.',
        },
    },

    -- ==================== TRANQUILIZER DART ====================
    -- Batch 20: Dart Gun (Special Non-Lethal)
    -- Unique incapacitation system - not ballistic ammunition
    ['dart'] = {
        ['tranq'] = {
            item = 'ammo_dart_tranq',
            label = 'Tranquilizer Dart',
            componentSuffix = '_CLIP_TRANQ',
            ammoInfo = 'AMMO_DART_TRANQ',
            description = 'Sedative dart. 2 damage, 30-second incapacitation (stumble→ragdoll→freeze).',
        },
    },
}

-- Default ammo type for each caliber (used when weapon is first equipped)
-- NOTE: 12ga default will be set PER-WEAPON during batch 18 review
Config.DefaultAmmoType = {
    ['9mm'] = 'fmj',
    ['.45acp'] = 'fmj',
    ['.40sw'] = 'fmj',
    ['.357mag'] = 'fmj',
    ['.38spl'] = 'fmj',
    ['.44mag'] = 'fmj',
    ['.500sw'] = 'fmj',
    ['5.7x28'] = 'fmj',
    ['10mm'] = 'fbi',
    ['.22lr'] = 'fmj',
    ['5.56'] = 'fmj',
    ['6.8x51'] = 'fmj',
    ['.300blk'] = 'supersonic',
    ['12ga'] = '00buck',
    ['7.62x39'] = 'fmj',    -- Batch 13: AK platforms
    ['7.62x51'] = 'fmj',    -- Batch 19: Precision rifles
    ['.300wm'] = 'fmj',     -- Batch 19: NEMO Watchman
    ['.50bmg'] = 'ball',    -- Batch 19: Anti-materiel rifles
    ['dart'] = 'tranq',     -- Batch 20: Dart gun
}
