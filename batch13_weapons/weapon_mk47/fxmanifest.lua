fx_version 'cerulean'
game 'gta5'

author 'Custom Weapons Project'
description 'WEAPON_MK47 - CMMG Mk47 Mutant 16" Precision Hybrid Rifle - 7.62x39mm'
version '1.0.0'

files {
    'meta/*.meta',
}

data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapon_mk47.meta'

client_script 'cl_weaponNames.lua'
