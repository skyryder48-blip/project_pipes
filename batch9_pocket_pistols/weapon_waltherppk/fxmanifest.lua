-- fxmanifest.lua
-- Walther PPK .380 ACP - Batch 9 Pocket Pistols

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Project'
description 'Walther PPK .380 ACP - Iconic James Bond Concealment Pistol'
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
