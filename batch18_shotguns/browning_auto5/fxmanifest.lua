-- ================================================================
-- BROWNING AUTO-5 - 12-GAUGE SEMI-AUTOMATIC SHOTGUN
-- ================================================================
-- FiveM Resource Manifest
--
-- Weapon: Browning Auto-5
-- Category: Semi-Automatic Shotgun (Long-Recoil)
-- Caliber: 12 Gauge (00 Buckshot)
--
-- Installation:
-- 1. Place this folder in your server's resources directory
-- 2. Add 'ensure browning_auto5' to your server.cfg
-- 3. Restart server or use 'refresh' + 'ensure browning_auto5'
--
-- Note: Weapon resource should load BEFORE ox_inventory
-- ================================================================

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development Project'
description 'Browning Auto-5 - 12-Gauge Semi-Automatic Shotgun with Realistic Buckshot Ballistics'
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
