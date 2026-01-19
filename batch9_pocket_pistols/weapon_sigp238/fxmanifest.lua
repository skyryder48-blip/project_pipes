-- fxmanifest.lua
-- SIG Sauer P238 .380 ACP - Batch 9 Pocket Pistols

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Project'
description 'SIG Sauer P238 .380 ACP - 1911-Style Pocket Pistol'
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
