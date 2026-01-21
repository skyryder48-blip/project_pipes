-- ================================================================
-- MOSSBERG 590 SHOCKWAVE - 12-GAUGE STOCKLESS "FIREARM"
-- ================================================================
-- FiveM Resource Manifest
--
-- Weapon: Mossberg 590 Shockwave
-- Category: Stockless Pump-Action Shotgun
-- Caliber: 12 Gauge (00 Buckshot)
--
-- Installation:
-- 1. Place this folder in your server's resources directory
-- 2. Add 'ensure mossberg_shockwave' to your server.cfg
-- 3. Restart server or use 'refresh' + 'ensure mossberg_shockwave'
--
-- Note: Weapon resource should load BEFORE ox_inventory
-- ================================================================

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development Project'
description 'Mossberg 590 Shockwave - 12-Gauge Stockless Pump-Action with Raptor Grip'
version '1.0.0'

-- Client script for weapon display name
client_script 'cl_weaponNames.lua'

-- Meta files
files {
    'meta/weapons.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
}

-- Data file declarations for addon weapons
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
