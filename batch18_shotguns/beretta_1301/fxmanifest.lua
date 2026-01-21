-- ================================================================
-- BERETTA 1301 TACTICAL - 12-GAUGE SEMI-AUTOMATIC SHOTGUN
-- ================================================================
-- FiveM Resource Manifest
--
-- Weapon: Beretta 1301 Tactical
-- Category: Semi-Automatic Shotgun (Gas-Operated)
-- Caliber: 12 Gauge (00 Buckshot)
--
-- Installation:
-- 1. Place this folder in your server's resources directory
-- 2. Add 'ensure beretta_1301' to your server.cfg
-- 3. Restart server or use 'refresh' + 'ensure beretta_1301'
--
-- Note: Weapon resource should load BEFORE ox_inventory
-- ================================================================

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development Project'
description 'Beretta 1301 Tactical - 12-Gauge Semi-Automatic Shotgun with BLINK Gas System'
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
