--[[
    Weapon to Caliber Mapping
    ==========================

    Maps weapon hashes to their caliber and component base name.

    Structure:
    Config.Weapons[weaponHash] = {
        caliber = 'caliber_key',       -- Must match key in Config.AmmoTypes
        componentBase = 'COMPONENT_X', -- Base name for components (suffix added)
        clipSize = 17,                 -- Standard magazine capacity
    }
]]

Config.Weapons = {
    -- ======================================================================
    -- BATCH 2: FULL-SIZE 9mm PISTOLS
    -- ======================================================================

    -- Glock 17 Gen 4 (17 rounds)
    [`WEAPON_G17`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G17',
        clipSize = 17,
    },

    -- Glock 17 Black (17 rounds)
    [`WEAPON_G17_BLK`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G17_BLK',
        clipSize = 17,
    },

    -- Glock 17 Gen 5 (17 rounds)
    [`WEAPON_G17_GEN5`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G17_GEN5',
        clipSize = 17,
    },

    -- Glock 19 (15 rounds)
    [`WEAPON_G19`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G19',
        clipSize = 15,
    },

    -- Glock 19X (17 rounds)
    [`WEAPON_G19X`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G19X',
        clipSize = 17,
    },

    -- Glock 19X with Switch (33 rounds, full-auto)
    [`WEAPON_G19X_SWITCH`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G19X_SWITCH',
        clipSize = 33,
    },

    -- Glock 19XD (17 rounds)
    [`WEAPON_G19XD`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G19XD',
        clipSize = 17,
    },

    -- Glock 45 (17 rounds)
    [`WEAPON_G45`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G45',
        clipSize = 17,
    },

    -- Glock 45 Tan (17 rounds)
    [`WEAPON_G45_TAN`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G45_TAN',
        clipSize = 17,
    },

    -- Beretta M9 (15 rounds)
    [`WEAPON_M9`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_M9',
        clipSize = 15,
    },

    -- Beretta M9A3 (17 rounds)
    [`WEAPON_M9A3`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_M9A3',
        clipSize = 17,
    },

    -- Beretta PX4 Storm (17 rounds)
    [`WEAPON_PX4`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_PX4',
        clipSize = 17,
    },

    -- SIG Sauer P320 (17 rounds)
    [`WEAPON_P320`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_P320',
        clipSize = 17,
    },

    -- Canik TP9SF (18 rounds)
    [`WEAPON_TP9SF`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_TP9SF',
        clipSize = 18,
    },

    -- FN 509 (17 rounds)
    [`WEAPON_FN509`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_FN509',
        clipSize = 17,
    },

    -- ======================================================================
    -- BATCH 1: COMPACT 9mm PISTOLS
    -- ======================================================================

    -- Glock 26 Gen 5 (10 rounds)
    [`WEAPON_G26`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G26',
        clipSize = 10,
    },

    -- Glock 26 with Switch (33 rounds, full-auto)
    [`WEAPON_G26_SWITCH`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G26_SWITCH',
        clipSize = 33,
    },

    -- Glock 43X (10 rounds)
    [`WEAPON_G43X`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G43X',
        clipSize = 10,
    },

    -- Taurus GX4 (11 rounds)
    [`WEAPON_GX4`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_GX4',
        clipSize = 11,
    },

    -- Springfield Hellcat (11 rounds)
    [`WEAPON_HELLCAT`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_HELLCAT',
        clipSize = 11,
    },

    -- ======================================================================
    -- FUTURE WEAPONS (uncomment when adding)
    -- ======================================================================

    --[[
    -- .45 ACP Pistols
    [`WEAPON_GLOCK21`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_G21',
        clipSize = 13,
    },

    [`WEAPON_1911`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_1911',
        clipSize = 7,
    },

    -- 12 Gauge Shotguns
    [`WEAPON_MOSSBERG590`] = {
        caliber = '12ga',
        componentBase = 'COMPONENT_M590',
        clipSize = 8,
    },
    ]]
}

-- Helper function to get weapon info
function GetWeaponInfo(weaponHash)
    return Config.Weapons[weaponHash]
end

-- Helper function to check if weapon is supported
function IsWeaponSupported(weaponHash)
    return Config.Weapons[weaponHash] ~= nil
end

-- Helper function to get component name for a weapon and ammo type
function GetComponentName(weaponHash, ammoType)
    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo then return nil end

    local caliber = weaponInfo.caliber
    local ammoConfig = Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][ammoType]
    if not ammoConfig then return nil end

    return weaponInfo.componentBase .. ammoConfig.componentSuffix
end

-- Helper function to get all component names for a weapon
function GetAllComponentNames(weaponHash)
    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo then return {} end

    local components = {}
    local caliber = weaponInfo.caliber
    local ammoTypes = Config.AmmoTypes[caliber]

    if ammoTypes then
        for ammoType, ammoConfig in pairs(ammoTypes) do
            components[ammoType] = weaponInfo.componentBase .. ammoConfig.componentSuffix
        end
    end

    return components
end
