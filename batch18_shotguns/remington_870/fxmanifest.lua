-- ================================================================
-- REMINGTON 870 EXPRESS - 12-GAUGE PUMP-ACTION SHOTGUN
-- ================================================================
-- FiveM Resource Manifest
-- 
-- Weapon: Remington 870 Express
-- Category: Pump-Action Shotgun
-- Caliber: 12 Gauge (00 Buckshot)
-- 
-- Installation:
-- 1. Place this folder in your server's resources directory
-- 2. Add 'ensure remington_870' to your server.cfg
-- 3. Restart server or use 'refresh' + 'ensure remington_870'
-- 
-- Note: Weapon resource should load BEFORE ox_inventory
-- ================================================================

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development Project'
description 'Remington 870 Express - 12-Gauge Pump-Action Shotgun with Realistic Buckshot Ballistics'
version '1.0.0'

-- Client script for weapon display name
client_script 'cl_weaponNames.lua'

-- Meta files
files {
    'meta/weapons.meta',
    'meta/weaponarchetypes.meta',
}

-- Data file declarations for addon weapons
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
