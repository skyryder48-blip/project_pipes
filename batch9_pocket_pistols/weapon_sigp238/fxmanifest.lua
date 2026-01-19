--[[
    SIG Sauer P238 .380 ACP - Batch 9 Pocket Pistols
    Scaled-down 1911 with crisp SAO trigger
    18 damage, 7 rounds, 2.7" barrel
]]

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Project'
description 'SIG Sauer P238 .380 ACP - 1911-Style Pocket Pistol'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapon_sigp238.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'stream/*'
}

data_file 'WEAPONINFO_FILE' 'meta/weapon_sigp238.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
