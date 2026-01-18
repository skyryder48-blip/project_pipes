--[[
    ox_inventory Item Definitions
    
    Add these to your ox_inventory/data/items.lua
    Or include this file in your items configuration
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
        description = '9mm hollow point ammunition. Increased damage to unarmored targets, reduced penetration.',
        client = {
            image = 'ammo_9mm_hp.png'
        }
    },
    ['ammo_9mm_ap'] = {
        label = '9mm Armor Piercing',
        weight = 12,
        stack = true,
        close = true,
        description = '9mm armor piercing ammunition. Bypasses body armor but reduced soft tissue damage.',
        client = {
            image = 'ammo_9mm_ap.png'
        }
    },
    
    -- ============================================
    -- .45 ACP AMMUNITION
    -- ============================================
    ['ammo_45acp_fmj'] = {
        label = '.45 ACP FMJ',
        weight = 15,
        stack = true,
        close = true,
        description = 'Standard .45 ACP full metal jacket ammunition. Heavy hitting rounds.',
        client = {
            image = 'ammo_45acp_fmj.png'
        }
    },
    ['ammo_45acp_hp'] = {
        label = '.45 ACP Hollow Point',
        weight = 15,
        stack = true,
        close = true,
        description = '.45 ACP hollow point ammunition. Massive expansion for devastating soft tissue damage.',
        client = {
            image = 'ammo_45acp_hp.png'
        }
    },
    ['ammo_45acp_ap'] = {
        label = '.45 ACP Armor Piercing',
        weight = 18,
        stack = true,
        close = true,
        description = '.45 ACP armor piercing ammunition. Hardened core penetrator rounds.',
        client = {
            image = 'ammo_45acp_ap.png'
        }
    },
    
    -- ============================================
    -- .40 S&W AMMUNITION
    -- ============================================
    ['ammo_40sw_fmj'] = {
        label = '.40 S&W FMJ',
        weight = 12,
        stack = true,
        close = true,
        description = 'Standard .40 S&W full metal jacket ammunition.',
        client = {
            image = 'ammo_40sw_fmj.png'
        }
    },
    ['ammo_40sw_hp'] = {
        label = '.40 S&W Hollow Point',
        weight = 12,
        stack = true,
        close = true,
        description = '.40 S&W hollow point ammunition. Controlled expansion rounds.',
        client = {
            image = 'ammo_40sw_hp.png'
        }
    },
    ['ammo_40sw_ap'] = {
        label = '.40 S&W Armor Piercing',
        weight = 14,
        stack = true,
        close = true,
        description = '.40 S&W armor piercing ammunition. Armor defeating rounds.',
        client = {
            image = 'ammo_40sw_ap.png'
        }
    },
    
    -- ============================================
    -- FUTURE CALIBERS (Add as needed)
    -- ============================================
    
    -- 5.7x28mm (FN 57, Ruger 5.7)
    ['ammo_57x28_fmj'] = {
        label = '5.7x28mm FMJ',
        weight = 8,
        stack = true,
        close = true,
        description = 'Standard 5.7x28mm ammunition. High velocity, low recoil.',
        client = {
            image = 'ammo_57x28_fmj.png'
        }
    },
    ['ammo_57x28_ap'] = {
        label = '5.7x28mm AP',
        weight = 8,
        stack = true,
        close = true,
        description = '5.7x28mm armor piercing. Designed to defeat body armor.',
        client = {
            image = 'ammo_57x28_ap.png'
        }
    },
    
    -- .22 LR (Sig P22, FN 502)
    ['ammo_22lr'] = {
        label = '.22 LR',
        weight = 3,
        stack = true,
        close = true,
        description = 'Standard .22 Long Rifle ammunition. Low power, low recoil.',
        client = {
            image = 'ammo_22lr.png'
        }
    },
    
    -- .357 Magnum (Revolvers)
    ['ammo_357mag_fmj'] = {
        label = '.357 Magnum FMJ',
        weight = 20,
        stack = true,
        close = true,
        description = 'Standard .357 Magnum ammunition. Powerful revolver rounds.',
        client = {
            image = 'ammo_357mag_fmj.png'
        }
    },
    ['ammo_357mag_hp'] = {
        label = '.357 Magnum HP',
        weight = 20,
        stack = true,
        close = true,
        description = '.357 Magnum hollow point. Devastating soft tissue damage.',
        client = {
            image = 'ammo_357mag_hp.png'
        }
    },
    
    -- .44 Magnum (Revolvers)
    ['ammo_44mag_fmj'] = {
        label = '.44 Magnum FMJ',
        weight = 25,
        stack = true,
        close = true,
        description = 'Standard .44 Magnum ammunition. Very powerful revolver rounds.',
        client = {
            image = 'ammo_44mag_fmj.png'
        }
    },
    ['ammo_44mag_hp'] = {
        label = '.44 Magnum HP',
        weight = 25,
        stack = true,
        close = true,
        description = '.44 Magnum hollow point. Extreme stopping power.',
        client = {
            image = 'ammo_44mag_hp.png'
        }
    },
    
    -- .500 S&W Magnum
    ['ammo_500sw'] = {
        label = '.500 S&W Magnum',
        weight = 40,
        stack = true,
        close = true,
        description = '.500 S&W Magnum ammunition. The most powerful production handgun cartridge.',
        client = {
            image = 'ammo_500sw.png'
        }
    },
    
    -- 5.56 NATO (Rifles)
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
        description = '5.56 NATO armor piercing. Penetrator rounds.',
        client = {
            image = 'ammo_556_ap.png'
        }
    },
    ['ammo_556_tracer'] = {
        label = '5.56 NATO Tracer',
        weight = 8,
        stack = true,
        close = true,
        description = '5.56 NATO tracer rounds. Visible bullet path.',
        client = {
            image = 'ammo_556_tracer.png'
        }
    },
    
    -- 7.62x39mm (AK variants)
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
    
    -- 12 Gauge (Shotguns)
    ['ammo_12ga_buckshot'] = {
        label = '12 Gauge Buckshot',
        weight = 30,
        stack = true,
        close = true,
        description = '12 gauge 00 buckshot. 8 pellets per shell.',
        client = {
            image = 'ammo_12ga_buckshot.png'
        }
    },
    ['ammo_12ga_slug'] = {
        label = '12 Gauge Slug',
        weight = 35,
        stack = true,
        close = true,
        description = '12 gauge slug. Single heavy projectile for range.',
        client = {
            image = 'ammo_12ga_slug.png'
        }
    },
    ['ammo_12ga_birdshot'] = {
        label = '12 Gauge Birdshot',
        weight = 25,
        stack = true,
        close = true,
        description = '12 gauge birdshot. Many small pellets, wide spread.',
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
    
    -- .308 / 7.62 NATO (Sniper/DMR)
    ['ammo_308_fmj'] = {
        label = '.308 Winchester FMJ',
        weight = 15,
        stack = true,
        close = true,
        description = 'Standard .308 rifle ammunition.',
        client = {
            image = 'ammo_308_fmj.png'
        }
    },
    ['ammo_308_match'] = {
        label = '.308 Match Grade',
        weight = 15,
        stack = true,
        close = true,
        description = '.308 match grade ammunition. Enhanced accuracy.',
        client = {
            image = 'ammo_308_match.png'
        }
    },
    ['ammo_308_ap'] = {
        label = '.308 Armor Piercing',
        weight = 18,
        stack = true,
        close = true,
        description = '.308 armor piercing ammunition. Defeats heavy armor.',
        client = {
            image = 'ammo_308_ap.png'
        }
    },
}
