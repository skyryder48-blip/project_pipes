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
    -- .40 S&W AMMUNITION (Batch 4)
    -- ============================================
    ['ammo_40sw_fmj'] = {
        label = '.40 S&W FMJ',
        weight = 18,  -- 18g per round (between 9mm and .45)
        stack = true,
        close = true,
        description = '.40 S&W full metal jacket. 36 base damage, 0.22 penetration. "Snappy" recoil, good penetration.',
        client = {
            image = 'ammo_40sw_fmj.png'
        }
    },
    ['ammo_40sw_jhp'] = {
        label = '.40 S&W JHP',
        weight = 18,
        stack = true,
        close = true,
        description = '.40 S&W jacketed hollow point. +16.7% damage (42), 0.14 penetration. Enhanced stopping power.',
        client = {
            image = 'ammo_40sw_jhp.png'
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
