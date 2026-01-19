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
    ['12ga'] = 'buckshot',
}
