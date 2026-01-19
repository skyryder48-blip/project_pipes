-- fxmanifest.lua
-- Colt Python .357 Magnum (6" barrel)
-- Batch 5: .357 Magnum & .38 Special Revolvers

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development'
description 'Colt Python .357 Magnum - 6" Barrel - The Rolls-Royce of Revolvers'
version '1.0.0'

-- Client script for weapon display name
client_script 'cl_weaponNames.lua'

-- Meta files
files {
    'meta/weapons.meta',
}

-- Data file declarations for addon weapons
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
