--[[
    Colt Junior .25 ACP - Batch 9 Pocket Pistols
    Deep concealment "gentleman's gun" - marginal terminal performance
    8 damage, 7 rounds, 2.25" barrel
]]

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Project'
description 'Colt Junior .25 ACP - Deep Concealment Pocket Pistol'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapon_coltjunior.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'stream/*'
}

data_file 'WEAPONINFO_FILE' 'meta/weapon_coltjunior.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
