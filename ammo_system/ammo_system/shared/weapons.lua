--[[
    Weapon Configuration
    Maps weapons to their caliber type and component names
    
    Each weapon entry contains:
    - caliber: The ammo caliber this weapon uses (matches Config.AmmoTypes keys)
    - capacity: Magazine capacity
    - component_prefix: The prefix used for ammo components (e.g., COMPONENT_G17)
]]

Config.Weapons = {
    -- ============================================
    -- BATCH 1: Compact 9mm Pistols
    -- ============================================
    [`weapon_g26`] = {
        caliber = '9mm',
        capacity = 10,
        component_prefix = 'COMPONENT_G26',
        label = 'Glock 26 Gen 5'
    },
    [`weapon_g26_switch`] = {
        caliber = '9mm',
        capacity = 10,
        component_prefix = 'COMPONENT_G26_SWITCH',
        label = 'Glock 26 Switch'
    },
    [`weapon_g43x`] = {
        caliber = '9mm',
        capacity = 10,
        component_prefix = 'COMPONENT_G43X',
        label = 'Glock 43X'
    },
    [`weapon_hellcat`] = {
        caliber = '9mm',
        capacity = 11,
        component_prefix = 'COMPONENT_HELLCAT',
        label = 'Springfield Hellcat'
    },
    [`weapon_gx4`] = {
        caliber = '9mm',
        capacity = 11,
        component_prefix = 'COMPONENT_GX4',
        label = 'Taurus GX4'
    },
    
    -- ============================================
    -- BATCH 2: Full-Size 9mm Pistols
    -- ============================================
    [`weapon_g17`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_G17',
        label = 'Glock 17 Gen 4'
    },
    [`weapon_g17_gen5`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_G17_GEN5',
        label = 'Glock 17 Gen 5'
    },
    [`weapon_g17_blk`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_G17_BLK',
        label = 'Glock 17 Blackout'
    },
    [`weapon_g19`] = {
        caliber = '9mm',
        capacity = 15,
        component_prefix = 'COMPONENT_G19',
        label = 'Glock 19 Gen 4'
    },
    [`weapon_g19x`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_G19X',
        label = 'Glock 19X'
    },
    [`weapon_g19xd`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_G19XD',
        label = 'Glock 19X Deluxe'
    },
    [`weapon_g19x_switch`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_G19X_SWITCH',
        label = 'Glock 19X Switch'
    },
    [`weapon_g45`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_G45',
        label = 'Glock 45'
    },
    [`weapon_g45_tan`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_G45_TAN',
        label = 'Glock 45 Tan'
    },
    [`weapon_m9`] = {
        caliber = '9mm',
        capacity = 15,
        component_prefix = 'COMPONENT_M9',
        label = 'Beretta M9'
    },
    [`weapon_m9a3`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_M9A3',
        label = 'Beretta M9A3'
    },
    [`weapon_px4`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_PX4',
        label = 'Beretta PX4 Storm'
    },
    [`weapon_p320`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_P320',
        label = 'Sig P320'
    },
    [`weapon_tp9sf`] = {
        caliber = '9mm',
        capacity = 18,
        component_prefix = 'COMPONENT_TP9SF',
        label = 'Canik TP9SF'
    },
    [`weapon_fn509`] = {
        caliber = '9mm',
        capacity = 17,
        component_prefix = 'COMPONENT_FN509',
        label = 'FN 509'
    },
    
    -- ============================================
    -- BATCH 3: .45 ACP Pistols (Future)
    -- ============================================
    [`weapon_m45a1`] = {
        caliber = '45acp',
        capacity = 7,
        component_prefix = 'COMPONENT_M45A1',
        label = 'Colt M45A1'
    },
    [`weapon_kimber1911`] = {
        caliber = '45acp',
        capacity = 7,
        component_prefix = 'COMPONENT_KIMBER1911',
        label = 'Kimber 1911'
    },
    [`weapon_kimber_eclipse`] = {
        caliber = '45acp',
        capacity = 8,
        component_prefix = 'COMPONENT_KIMBER_ECLIPSE',
        label = 'Kimber Eclipse 1911'
    },
    [`weapon_g21`] = {
        caliber = '45acp',
        capacity = 13,
        component_prefix = 'COMPONENT_G21',
        label = 'Glock 21'
    },
    [`weapon_g30`] = {
        caliber = '45acp',
        capacity = 10,
        component_prefix = 'COMPONENT_G30',
        label = 'Glock 30'
    },
    [`weapon_g41`] = {
        caliber = '45acp',
        capacity = 13,
        component_prefix = 'COMPONENT_G41',
        label = 'Glock 41'
    },
    [`weapon_1911_scrap`] = {
        caliber = '45acp',
        capacity = 7,
        component_prefix = 'COMPONENT_1911_SCRAP',
        label = '1911 (Worn)'
    },
    
    -- ============================================
    -- .40 S&W Pistols (Future)
    -- ============================================
    [`weapon_g22`] = {
        caliber = '40sw',
        capacity = 15,
        component_prefix = 'COMPONENT_G22',
        label = 'Glock 22'
    },
    [`weapon_g22_gen4`] = {
        caliber = '40sw',
        capacity = 15,
        component_prefix = 'COMPONENT_G22_GEN4',
        label = 'Glock 22 Gen 4'
    },
    [`weapon_g22s`] = {
        caliber = '40sw',
        capacity = 15,
        component_prefix = 'COMPONENT_G22S',
        label = 'Glock 22S'
    },
}

-- Helper function to get weapon config by hash
function GetWeaponConfig(weaponHash)
    return Config.Weapons[weaponHash]
end

-- Helper function to check if a weapon uses a specific caliber
function WeaponUsesCaliber(weaponHash, caliber)
    local config = Config.Weapons[weaponHash]
    return config and config.caliber == caliber
end

-- Get all weapons that use a specific caliber
function GetWeaponsByCaliber(caliber)
    local weapons = {}
    for hash, config in pairs(Config.Weapons) do
        if config.caliber == caliber then
            weapons[hash] = config
        end
    end
    return weapons
end

-- Build component hash from weapon config and ammo type
function GetComponentHash(weaponConfig, ammoType)
    local suffix = Config.AmmoTypes[weaponConfig.caliber][ammoType].component_suffix
    local componentName = weaponConfig.component_prefix .. suffix
    return joaat(componentName)
end
