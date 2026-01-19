-- fxmanifest.lua
-- Glock 20 Gen 4 10mm Auto - Batch 10

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Project'
description 'Glock 20 Gen 4 10mm Auto - Full-Power Semi-Auto'
version '1.0.0'

-- Client script for weapon display name
client_script 'cl_weaponNames.lua'

-- Stream assets (models/textures)
files {
    'stream/*.ydr',
    'stream/*.ytd',
    'meta/weapons.meta'
}

-- Data file declarations for addon weapon
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
