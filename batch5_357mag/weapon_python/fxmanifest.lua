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
    'meta/weapon_python.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
}

-- Data file declarations for addon weapons
data_file 'WEAPONINFO_FILE' 'meta/weapon_python.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'WEAPONARCHETYPES_FILE' 'meta/weaponarchetypes.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
