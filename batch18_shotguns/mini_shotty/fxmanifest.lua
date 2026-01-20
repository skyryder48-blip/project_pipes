-- ================================================================
-- MINI SHOTTY - ILLEGAL SAWN-OFF PISTOL GRIP 12-GAUGE
-- ================================================================
-- FiveM Resource Manifest
-- 
-- Weapon: Mini Shotty (Sawn-Off)
-- Category: Illegal Short Barreled Shotgun (SBS)
-- Caliber: 12 Gauge (00 Buckshot)
-- 
-- Installation:
-- 1. Place this folder in your server's resources directory
-- 2. Add 'ensure mini_shotty' to your server.cfg
-- 3. Restart server or use 'refresh' + 'ensure mini_shotty'
-- 
-- Note: Weapon resource should load BEFORE ox_inventory
-- ================================================================

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development Project'
description 'Mini Shotty - Illegal Sawn-Off Pistol Grip 12-Gauge with Realistic Buckshot Ballistics'
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
