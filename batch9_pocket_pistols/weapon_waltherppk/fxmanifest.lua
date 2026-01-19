--[[
    Walther PPK .380 ACP - Batch 9 Pocket Pistols
    James Bond's iconic concealment pistol
    20 damage, 7 rounds, 3.3" barrel
]]

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Project'
description 'Walther PPK .380 ACP - Iconic James Bond Concealment Pistol'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapon_waltherppk.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'stream/*'
}

data_file 'WEAPONINFO_FILE' 'meta/weapon_waltherppk.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
