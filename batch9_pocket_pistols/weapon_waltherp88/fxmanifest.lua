-- fxmanifest.lua
-- Walther P88 9mm - Batch 9 Pocket Pistols (9mm Service Pistol)

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Project'
description 'Walther P88 9mm - Premium German Service Pistol'
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
