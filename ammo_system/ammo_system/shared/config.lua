--[[
    Ammunition System Configuration
    For Qbox Framework with ox_inventory
    
    Defines ammo types, damage modifiers, and weapon compatibility
]]

Config = {}

-- Debug mode for testing
Config.Debug = true

-- Ammo type definitions with their properties
-- These correspond to weapon component clips we defined in the weapon metas
Config.AmmoTypes = {
    -- 9mm Ammunition
    ['9mm'] = {
        fmj = {
            item = 'ammo_9mm_fmj',
            label = '9mm FMJ',
            component_suffix = '_CLIP_FMJ',
            damage_modifier = 1.0,      -- Baseline
            penetration = 0.15,
            description = 'Standard full metal jacket rounds'
        },
        hp = {
            item = 'ammo_9mm_hp',
            label = '9mm Hollow Point',
            component_suffix = '_CLIP_HP',
            damage_modifier = 1.10,     -- +10% damage
            penetration = 0.05,         -- Reduced penetration
            description = 'Increased damage to unarmored targets'
        },
        ap = {
            item = 'ammo_9mm_ap',
            label = '9mm Armor Piercing',
            component_suffix = '_CLIP_AP',
            damage_modifier = 0.90,     -- -10% damage
            penetration = 0.30,         -- Increased penetration
            description = 'Bypasses body armor, reduced soft tissue damage'
        }
    },
    
    -- .45 ACP Ammunition (for future batches)
    ['45acp'] = {
        fmj = {
            item = 'ammo_45acp_fmj',
            label = '.45 ACP FMJ',
            component_suffix = '_CLIP_FMJ',
            damage_modifier = 1.0,
            penetration = 0.20,
            description = 'Standard .45 ACP rounds'
        },
        hp = {
            item = 'ammo_45acp_hp',
            label = '.45 ACP Hollow Point',
            component_suffix = '_CLIP_HP',
            damage_modifier = 1.12,     -- +12% (larger bullet = more expansion)
            penetration = 0.08,
            description = 'Massive expansion, devastating soft tissue damage'
        },
        ap = {
            item = 'ammo_45acp_ap',
            label = '.45 ACP Armor Piercing',
            component_suffix = '_CLIP_AP',
            damage_modifier = 0.88,
            penetration = 0.35,
            description = 'Hardened core penetrator rounds'
        }
    },
    
    -- .40 S&W Ammunition (for future batches)
    ['40sw'] = {
        fmj = {
            item = 'ammo_40sw_fmj',
            label = '.40 S&W FMJ',
            component_suffix = '_CLIP_FMJ',
            damage_modifier = 1.0,
            penetration = 0.18,
            description = 'Standard .40 S&W rounds'
        },
        hp = {
            item = 'ammo_40sw_hp',
            label = '.40 S&W Hollow Point',
            component_suffix = '_CLIP_HP',
            damage_modifier = 1.11,
            penetration = 0.06,
            description = 'Controlled expansion rounds'
        },
        ap = {
            item = 'ammo_40sw_ap',
            label = '.40 S&W Armor Piercing',
            component_suffix = '_CLIP_AP',
            damage_modifier = 0.89,
            penetration = 0.32,
            description = 'Armor defeating rounds'
        }
    }
}

-- Default ammo type when none is specified
Config.DefaultAmmoType = 'fmj'

-- Whether weapons spawn with ammo or empty
Config.WeaponsSpawnEmpty = true

-- Return old ammo to inventory when swapping types
Config.ReturnOldAmmo = true

-- Notification settings
Config.Notifications = {
    ammoLoaded = true,
    ammoReturned = true,
    noCompatibleWeapon = true,
    notEnoughAmmo = true
}
