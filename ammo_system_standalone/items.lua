--[[
    ox_inventory Item Definitions
    =============================

    Add these items to your ox_inventory/data/items.lua
    Or merge with your existing items configuration.

    USAGE:
    Copy the contents of this file into your items.lua or use:
    local ammoItems = require('@ammo_system_standalone/items')
    for k, v in pairs(ammoItems) do Items[k] = v end
]]

return {
    -- ============================================
    -- 9mm AMMUNITION
    -- ============================================
    ['ammo_9mm_fmj'] = {
        label = '9mm FMJ',
        weight = 10,
        stack = true,
        close = true,
        description = 'Standard 9mm full metal jacket ammunition. Balanced penetration and damage.',
        client = {
            image = 'ammo_9mm_fmj.png'
        }
    },
    ['ammo_9mm_hp'] = {
        label = '9mm Hollow Point',
        weight = 10,
        stack = true,
        close = true,
        description = '9mm hollow point ammunition. +10% damage to unarmored targets, reduced armor effectiveness.',
        client = {
            image = 'ammo_9mm_hp.png'
        }
    },
    ['ammo_9mm_ap'] = {
        label = '9mm Armor Piercing',
        weight = 12,
        stack = true,
        close = true,
        description = '9mm armor piercing ammunition. Bypasses body armor, -10% base damage, -2 mag capacity.',
        client = {
            image = 'ammo_9mm_ap.png'
        }
    },

    -- ============================================
    -- .45 ACP AMMUNITION (Batch 3)
    -- ============================================
    ['ammo_45acp_fmj'] = {
        label = '.45 ACP FMJ',
        weight = 25,  -- 25g per round (heavier than 9mm)
        stack = true,
        close = true,
        description = 'Standard .45 ACP full metal jacket. 38 base damage, 0.20 penetration. Reliable feeding, over-penetration risk.',
        client = {
            image = 'ammo_45acp_fmj.png'
        }
    },
    ['ammo_45acp_jhp'] = {
        label = '.45 ACP JHP',
        weight = 25,
        stack = true,
        close = true,
        description = '.45 ACP jacketed hollow point. +15.8% damage (44), 0.12 penetration. Expansion: 0.85-0.95". Premium defensive ammunition.',
        client = {
            image = 'ammo_45acp_jhp.png'
        }
    },

    -- ============================================
    -- .40 S&W AMMUNITION (Batch 4) - Enhanced Ballistics
    -- ============================================
    ['ammo_40sw_fmj'] = {
        label = '.40 S&W FMJ',
        weight = 18,  -- 18g per round (between 9mm and .45)
        stack = true,
        close = true,
        description = '.40 S&W full metal jacket. 41 damage (~420 ft-lbs), 0.72 penetration. 990 fps, 25-32" gel penetration. "Snappy" recoil - 25% higher than 9mm.',
        client = {
            image = 'ammo_40sw_fmj.png'
        }
    },
    ['ammo_40sw_jhp'] = {
        label = '.40 S&W JHP',
        weight = 18,
        stack = true,
        close = true,
        description = '.40 S&W jacketed hollow point. 49 damage (+20%), 0.55 penetration. Federal HST 180gr: 0.72" expansion, 14.5-18.5" FBI gel standard.',
        client = {
            image = 'ammo_40sw_jhp.png'
        }
    },

    -- ============================================
    -- .357 MAGNUM AMMUNITION (Batch 5) - Enhanced Ballistics
    -- Barrel-dependent: 6"=58/70 dmg, 4"=49/59 dmg, 2"=40/35 dmg
    -- ============================================
    ['ammo_357mag_fmj'] = {
        label = '.357 Magnum FMJ',
        weight = 22,  -- 22g per round (heavy magnum round)
        stack = true,
        close = true,
        description = '.357 Magnum full metal jacket. 49-58 damage (barrel-dependent), 0.82-0.90 penetration. 1400-1650 fps. Devastating power - 545-710 ft-lbs energy.',
        client = {
            image = 'ammo_357mag_fmj.png'
        }
    },
    ['ammo_357mag_jhp'] = {
        label = '.357 Magnum JHP',
        weight = 22,
        stack = true,
        close = true,
        description = '.357 Magnum JHP. 59-70 damage (+20%), 0.52-0.55 penetration. The legendary 125gr "man-stopper" - 96% one-shot rating from 4"+ barrels.',
        client = {
            image = 'ammo_357mag_jhp.png'
        }
    },

    -- ============================================
    -- .38 SPECIAL AMMUNITION (Batch 5) - Enhanced Ballistics
    -- WARNING: Only 57% of 9mm energy (200 vs 350 ft-lbs)
    -- ============================================
    ['ammo_38spl_fmj'] = {
        label = '.38 Special FMJ',
        weight = 14,  -- 14g per round (lighter than .357)
        stack = true,
        close = true,
        description = '.38 Special full metal jacket. 20 base damage (200 ft-lbs), 0.65 penetration. 755 fps. Classic 158gr police load - light recoil, controlled penetration.',
        client = {
            image = 'ammo_38spl_fmj.png'
        }
    },
    ['ammo_38spl_jhp'] = {
        label = '.38 Special +P JHP',
        weight = 14,
        stack = true,
        close = true,
        description = '.38 Special +P JHP. 27 damage (+35%), 0.50 penetration. WARNING: Most JHP fails from short barrels. Federal HST Micro recommended.',
        client = {
            image = 'ammo_38spl_jhp.png'
        }
    },

    -- ============================================
    -- .44 MAGNUM AMMUNITION (Batch 6) - Enhanced Ballistics
    -- The "Dirty Harry" cartridge - 65-80% more energy than .357 Magnum
    -- ============================================
    ['ammo_44mag_fmj'] = {
        label = '.44 Magnum FMJ',
        weight = 28,  -- 28g per round (heavy magnum)
        stack = true,
        close = true,
        description = '.44 Magnum full metal jacket. 82-115 damage (barrel-dependent), 0.85 penetration. 1050-1500 fps. OVERKILL for defense - 20-30" gel penetration.',
        client = {
            image = 'ammo_44mag_fmj.png'
        }
    },
    ['ammo_44mag_jhp'] = {
        label = '.44 Magnum JHP',
        weight = 28,
        stack = true,
        close = true,
        description = '.44 Magnum JHP. 98-138 damage (+20%), 0.70 penetration. Hornady 240gr XTP: 0.628" expansion, 25" penetration. Devastating terminal performance.',
        client = {
            image = 'ammo_44mag_jhp.png'
        }
    },

    -- ============================================
    -- .500 S&W MAGNUM AMMUNITION (Batch 6) - Enhanced Ballistics
    -- THE MOST POWERFUL PRODUCTION HANDGUN CARTRIDGE
    -- Equals .308 Winchester / .30-06 Springfield rifle performance
    -- ============================================
    ['ammo_500sw_fmj'] = {
        label = '.500 S&W FMJ',
        weight = 45,  -- 45g per round (massive cartridge)
        stack = true,
        close = true,
        description = '.500 S&W FMJ. 160-215 damage (barrel-dependent), 0.90 penetration. RIFLE-LEVEL POWER - 3,032 ft-lbs @ 8.375". 700gr hard cast: 5-6 FEET penetration.',
        client = {
            image = 'ammo_500sw_fmj.png'
        }
    },
    ['ammo_500sw_jhp'] = {
        label = '.500 S&W JHP',
        weight = 45,
        stack = true,
        close = true,
        description = '.500 S&W JHP. 192-258 damage (+20%), 0.75 penetration. 350gr XTP: 19.5" gel. EXTREME RECOIL - 3x .44 Magnum. Fire rate: 40-60 RPM max.',
        client = {
            image = 'ammo_500sw_jhp.png'
        }
    },

    -- ============================================
    -- 5.7x28mm AMMUNITION - PDW Caliber
    -- High velocity (1,650-2,200 fps), low recoil (30% less than 9mm)
    -- 20-round capacity, flat trajectory, rifle-like performance
    -- ============================================
    ['ammo_57x28_fmj'] = {
        label = '5.7x28mm FMJ',
        weight = 8,  -- 8g per round (lightweight PDW cartridge)
        stack = true,
        close = true,
        description = '5.7x28mm V-MAX (SS197SR). 28 damage, 0.70 penetration. 1,700 fps, 250 ft-lbs. Civilian hunting/sporting load - fragmenting polymer tip.',
        client = {
            image = 'ammo_57x28_fmj.png'
        }
    },
    ['ammo_57x28_jhp'] = {
        label = '5.7x28mm JHP',
        weight = 8,
        stack = true,
        close = true,
        description = '5.7x28mm Speer Gold Dot. 35 damage (+25%), 0.55 penetration. 1,800 fps, 288 ft-lbs. BEST defensive choice - controlled expansion, 12-20" gel.',
        client = {
            image = 'ammo_57x28_jhp.png'
        }
    },
    ['ammo_57x28_ap'] = {
        label = '5.7x28mm AP',
        weight = 6,  -- 6g (lighter 31gr bullet)
        stack = true,
        close = true,
        description = '5.7x28mm SS190 AP. 30 damage, 0.96 penetration. 2,100 fps, 315 ft-lbs. DEFEATS Level IIIA armor. Military/LE RESTRICTED - black tip.',
        client = {
            image = 'ammo_57x28_ap.png'
        }
    },

    -- ============================================
    -- 10mm AUTO AMMUNITION (Batch 10 - Full-Power 10mm)
    -- DUAL PERSONALITY: FBI-spec (~400 ft-lbs) vs Full-power (~650 ft-lbs)
    -- FBI-spec = .40 S&W equivalent, Full-power = .357 Magnum equivalent
    -- 15+1 capacity semi-auto with magnum-class power
    -- ============================================
    ['ammo_10mm_fbi'] = {
        label = '10mm FBI Service',
        weight = 20,  -- 20g per round (heavy semi-auto cartridge)
        stack = true,
        close = true,
        description = '10mm FBI-spec 180gr @ 1,000 fps. 42 damage, 0.72 penetration. ~400 ft-lbs - matches .40 S&W. Federal Hydra-Shok standard defensive load.',
        client = {
            image = 'ammo_10mm_fbi.png'
        }
    },
    ['ammo_10mm_fullpower'] = {
        label = '10mm Full Power',
        weight = 20,
        stack = true,
        close = true,
        description = '10mm Full Power 180gr @ 1,300 fps. 52 damage (+24%), 0.65 penetration. ~650 ft-lbs - equals .357 Magnum. Underwood/Buffalo Bore premium.',
        client = {
            image = 'ammo_10mm_fullpower.png'
        }
    },
    ['ammo_10mm_bear'] = {
        label = '10mm Bear Defense',
        weight = 25,  -- 25g (heavier 220gr hard cast)
        stack = true,
        close = true,
        description = '10mm Hard Cast 220gr @ 1,200 fps. 50 damage, 0.95 penetration. ~700 ft-lbs, 32"+ gel penetration. Denmark issues G20 for polar bears.',
        client = {
            image = 'ammo_10mm_bear.png'
        }
    },

    -- ============================================
    -- .22 LR AMMUNITION (Batch 8 - Rimfire Pistols)
    -- LOWEST POWER handgun cartridge: 80-115 ft-lbs
    -- Minimal recoil, high capacity, suppressor-friendly
    -- PMR-30 uses .22 WMR ballistics but same ammo system
    -- ============================================
    ['ammo_22lr_fmj'] = {
        label = '.22 LR FMJ',
        weight = 3,  -- 3g per round (very light rimfire)
        stack = true,
        close = true,
        description = '.22 LR CCI Mini-Mag 40gr. 12-15 damage, 0.50 penetration. ~1,000 fps from pistol barrel. Reliable cycling, suppressor-friendly.',
        client = {
            image = 'ammo_22lr_fmj.png'
        }
    },
    ['ammo_22lr_jhp'] = {
        label = '.22 LR JHP',
        weight = 3,
        stack = true,
        close = true,
        description = '.22 LR CCI Velocitor 40gr HP. +20% damage, 0.35 penetration. ~1,100 fps. WARNING: Hollow points rarely expand from pistol barrels.',
        client = {
            image = 'ammo_22lr_jhp.png'
        }
    },

    -- ============================================
    -- 12 GAUGE SHOTGUN AMMUNITION (Future)
    -- ============================================
    ['ammo_12ga_buckshot'] = {
        label = '12 Gauge Buckshot',
        weight = 30,
        stack = true,
        close = true,
        description = '12 gauge 00 buckshot. 8 pellets per shell - standard defensive load.',
        client = {
            image = 'ammo_12ga_buckshot.png'
        }
    },
    ['ammo_12ga_slug'] = {
        label = '12 Gauge Slug',
        weight = 35,
        stack = true,
        close = true,
        description = '12 gauge slug. Single heavy projectile for extended range accuracy.',
        client = {
            image = 'ammo_12ga_slug.png'
        }
    },
    ['ammo_12ga_birdshot'] = {
        label = '12 Gauge Birdshot',
        weight = 25,
        stack = true,
        close = true,
        description = '12 gauge birdshot. Many small pellets, wide spread, close range only.',
        client = {
            image = 'ammo_12ga_birdshot.png'
        }
    },
    ['ammo_12ga_dragon'] = {
        label = '12 Gauge Dragon\'s Breath',
        weight = 35,
        stack = true,
        close = true,
        description = '12 gauge incendiary rounds. Sets targets on fire.',
        client = {
            image = 'ammo_12ga_dragon.png'
        }
    },

    -- ============================================
    -- 5.56 NATO RIFLE AMMUNITION (Future)
    -- ============================================
    ['ammo_556_fmj'] = {
        label = '5.56 NATO FMJ',
        weight = 8,
        stack = true,
        close = true,
        description = 'Standard 5.56 NATO rifle ammunition.',
        client = {
            image = 'ammo_556_fmj.png'
        }
    },
    ['ammo_556_hp'] = {
        label = '5.56 NATO HP',
        weight = 8,
        stack = true,
        close = true,
        description = '5.56 NATO hollow point. Increased soft tissue damage.',
        client = {
            image = 'ammo_556_hp.png'
        }
    },
    ['ammo_556_ap'] = {
        label = '5.56 NATO AP',
        weight = 10,
        stack = true,
        close = true,
        description = '5.56 NATO armor piercing. Penetrator rounds for armored targets.',
        client = {
            image = 'ammo_556_ap.png'
        }
    },
    ['ammo_556_tracer'] = {
        label = '5.56 NATO Tracer',
        weight = 8,
        stack = true,
        close = true,
        description = '5.56 NATO tracer rounds. Visible bullet path for target marking.',
        client = {
            image = 'ammo_556_tracer.png'
        }
    },

    -- ============================================
    -- 7.62x39mm RIFLE AMMUNITION (Future)
    -- ============================================
    ['ammo_762x39_fmj'] = {
        label = '7.62x39mm FMJ',
        weight = 12,
        stack = true,
        close = true,
        description = 'Standard 7.62x39mm rifle ammunition.',
        client = {
            image = 'ammo_762x39_fmj.png'
        }
    },
    ['ammo_762x39_hp'] = {
        label = '7.62x39mm HP',
        weight = 12,
        stack = true,
        close = true,
        description = '7.62x39mm hollow point ammunition.',
        client = {
            image = 'ammo_762x39_hp.png'
        }
    },
    ['ammo_762x39_ap'] = {
        label = '7.62x39mm AP',
        weight = 14,
        stack = true,
        close = true,
        description = '7.62x39mm armor piercing ammunition.',
        client = {
            image = 'ammo_762x39_ap.png'
        }
    },
}
