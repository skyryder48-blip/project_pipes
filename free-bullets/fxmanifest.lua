fx_version 'cerulean'
game 'gta5'

author 'Your Server Name'
description 'Unified Ammunition & Magazine System - Multi-Caliber Support'
version '2.0.0'

--[[
    UNIFIED AMMUNITION & MAGAZINE SYSTEM
    =====================================

    This resource provides a complete weapon ammunition system:
    - Physical magazines as inventory items
    - Multiple ammo types per caliber (FMJ, HP, AP, etc.)
    - Extended magazines (standard, extended, drum)
    - Realistic magazine loading workflow

    WORKFLOW:
    1. Player purchases empty magazines
    2. Player purchases loose ammunition
    3. Player loads ammunition into magazines (via inventory)
    4. Player equips loaded magazines to weapons
    5. Empty magazines return to inventory for reloading

    INSTALLATION:
    1. Place this resource in your [weapons] folder
    2. In server.cfg, ensure this loads BEFORE weapon resources:

        ensure ammo_system_standalone
        ensure weapon_g17
        ensure weapon_m9
        ...

    3. Add items from inventory/magazine_items.lua to ox_inventory items.lua

    SUPPORTED CALIBERS (19 calibers, 51 ammo types):
    - 9mm: FMJ, HP, AP
    - .45 ACP: FMJ, JHP
    - .40 S&W: FMJ, JHP
    - .357 Magnum: FMJ, JHP
    - .38 Special: FMJ, JHP
    - .44 Magnum: FMJ, JHP
    - .500 S&W: FMJ, JHP
    - 5.7x28mm: FMJ, JHP, AP
    - .22 LR: FMJ, JHP
    - 10mm Auto: FBI, Full Power, Bear Defense
    - 12 Gauge: 00 Buck, #1 Buck, Slug, Birdshot + Specialty
    - 5.56 NATO: FMJ, SP, AP
    - 6.8x51mm: FMJ, AP
    - .300 Blackout: Supersonic, Subsonic
    - 7.62x39mm: FMJ, SP, AP (AK platforms)
    - 7.62x51mm/.308: FMJ, Match, AP (precision rifles)
    - .300 Win Mag: FMJ, Match (NEMO Watchman)
    - .50 BMG: Ball, API, BOOM (anti-materiel)
    - Dart: Tranq (non-lethal incapacitation)
]]

-- Shared configuration (load order matters)
shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/weapons.lua',
    'shared/magazines.lua',
    'shared/modifiers.lua',  -- Ammo damage modifiers
}

-- Client-side scripts
client_scripts {
    'client/cl_ammo.lua',
    'client/magazine_client.lua',
    'client/cl_sync.lua',        -- StateBag synchronization
    'client/cl_effects.lua',     -- Visual & audio effects (Phase 2)
    'client/cl_lesslethal.lua',  -- Beanbag, pepperball, tranquilizer effects
    'client/cl_penetration.lua', -- Bullet penetration system
    'client/cl_limbdamage.lua',  -- Limb damage effects & med script integration
    'client/cl_environment.lua', -- Environmental interactions
}

-- Server-side scripts
server_scripts {
    'server/sv_ammo.lua',
    'server/magazine_server.lua',
    'server/sv_damage.lua',      -- Damage modifier handler
    'server/sv_penetration.lua', -- Bullet penetration system
    'server/sv_environment.lua', -- Environmental interactions
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
    -- 10mm Auto Ammunition
    'meta/ammo_10mm.meta',
    'meta/weaponcomponents_10mm.meta',
    -- 12 Gauge Ammunition
    'meta/ammo_12gauge.meta',
    'meta/weaponcomponents_12gauge.meta',
    -- 5.56 NATO Ammunition
    'meta/ammo_556.meta',
    'meta/weaponcomponents_556.meta',
    -- 6.8x51mm Ammunition
    'meta/ammo_68x51.meta',
    'meta/weaponcomponents_68x51.meta',
    -- .300 Blackout Ammunition
    'meta/ammo_300blk.meta',
    'meta/weaponcomponents_300blk.meta',
    -- 7.62x39mm Ammunition (AK Platforms)
    'meta/ammo_762x39.meta',
    -- 7.62x51mm/.308 Win Ammunition (Precision Rifles)
    'meta/ammo_762x51.meta',
    -- .300 Winchester Magnum Ammunition
    'meta/ammo_300wm.meta',
    -- .50 BMG Ammunition (Anti-Materiel)
    'meta/ammo_50bmg.meta',
    -- Tranquilizer Dart Ammunition
    'meta/ammo_dart.meta',
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
-- 10mm Auto
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_10mm.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_10mm.meta'
-- 12 Gauge
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_12gauge.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_12gauge.meta'
-- 5.56 NATO
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_556.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_556.meta'
-- 6.8x51mm
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_68x51.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_68x51.meta'
-- .300 Blackout
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_300blk.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_300blk.meta'
-- 7.62x39mm (AK Platforms)
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_762x39.meta'
-- 7.62x51mm/.308 Win (Precision Rifles)
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_762x51.meta'
-- .300 Winchester Magnum
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_300wm.meta'
-- .50 BMG (Anti-Materiel)
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_50bmg.meta'
-- Tranquilizer Dart
data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_dart.meta'

-- Dependencies
dependencies {
    'ox_lib',
    'ox_inventory',
}

lua54 'yes'
