fx_version 'cerulean'
game 'gta5'

author 'Your Server Name'
description 'Centralized Ammunition System - Multi-Caliber Support'
version '1.0.0'

--[[
    AMMUNITION SYSTEM
    =================

    This resource provides a centralized ammunition system supporting multiple calibers
    with FMJ, Hollow Point, and Armor Piercing variants.

    INSTALLATION:
    1. Place this resource in your [weapons] folder
    2. In server.cfg, ensure this resource loads BEFORE any weapon resources:

        ensure ammo_system_standalone
        ensure weapon_g17
        ensure weapon_m9
        ...

    3. Add the items from items.lua to your ox_inventory items configuration

    SUPPORTED CALIBERS:
    - 9mm (Pistols): FMJ, HP, AP
    - .45 ACP (Pistols): FMJ, JHP
    - .40 S&W (Pistols): FMJ, JHP
    - .357 Magnum (Revolvers): FMJ, JHP
    - .38 Special (Revolvers): FMJ, JHP
    - .44 Magnum (Revolvers): FMJ, JHP - "Dirty Harry" cartridge
    - .500 S&W Magnum (Revolvers): FMJ, JHP - Most powerful production handgun
    - 5.7x28mm (PDW): FMJ, JHP, AP - High velocity, low recoil, armor defeat
    - .22 LR (Rimfire): FMJ, JHP - Lowest power, high capacity, suppressor-friendly
    - Future: 5.56 NATO, 7.62x39, 12 Gauge, etc.

    AMMO EFFECTS:
    - FMJ: Baseline damage, standard penetration
    - HP (Hollow Point): +10% damage, reduced armor effectiveness, lower penetration
    - AP (Armor Piercing): -10% damage, bypasses body armor, higher penetration
]]

-- Shared configuration
shared_scripts {
    'shared/config.lua',
    'shared/weapons.lua',
}

-- Client-side ammo handling
client_scripts {
    'client/cl_ammo.lua',
}

-- Server-side inventory integration
server_scripts {
    'server/sv_ammo.lua',
}

-- Meta files for ammunition definitions and components
files {
    -- 9mm Ammunition
    'meta/ammo_9mm.meta',
    'meta/weaponcomponents_9mm.meta',
    -- .45 ACP Ammunition
    'meta/ammo_45acp.meta',
    'meta/weaponcomponents_45acp.meta',
    -- .40 S&W Ammunition
    'meta/ammo_40sw.meta',
    'meta/weaponcomponents_40sw.meta',
    -- .357 Magnum Ammunition
    'meta/ammo_357mag.meta',
    'meta/weaponcomponents_357mag.meta',
    -- .38 Special Ammunition
    'meta/ammo_38spl.meta',
    'meta/weaponcomponents_38spl.meta',
    -- .44 Magnum Ammunition
    'meta/ammo_44mag.meta',
    'meta/weaponcomponents_44mag.meta',
    -- .500 S&W Magnum Ammunition
    'meta/ammo_500sw.meta',
    'meta/weaponcomponents_500sw.meta',
    -- 5.7x28mm Ammunition (PDW)
    'meta/ammo_57x28.meta',
    'meta/weaponcomponents_57x28.meta',
    -- .22 LR Ammunition (Rimfire)
    'meta/ammo_22lr.meta',
    'meta/weaponcomponents_22lr.meta',
    -- Future calibers:
    -- 'meta/ammo_12ga.meta',
    -- 'meta/weaponcomponents_12ga.meta',
}

-- Data file declarations
-- 9mm
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_9mm.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_9mm.meta'
-- .45 ACP
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_45acp.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_45acp.meta'
-- .40 S&W
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_40sw.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_40sw.meta'
-- .357 Magnum
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_357mag.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_357mag.meta'
-- .38 Special
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_38spl.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_38spl.meta'
-- .44 Magnum
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_44mag.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_44mag.meta'
-- .500 S&W Magnum
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_500sw.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_500sw.meta'
-- 5.7x28mm (PDW)
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_57x28.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_57x28.meta'
-- .22 LR (Rimfire)
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_22lr.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_22lr.meta'
-- Future calibers:
-- data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_12ga.meta'
-- data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_12ga.meta'
