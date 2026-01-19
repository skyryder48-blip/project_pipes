--[[
    Glock 20 Gen 4 10mm Auto - Batch 10
    Full-power 10mm semi-automatic
    .357 Magnum energy with 15+1 capacity
    50 damage, 4.61" barrel
]]

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Project'
description 'Glock 20 Gen 4 10mm Auto - Full-Power Semi-Auto'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapon_glock20.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'stream/*'
}

data_file 'WEAPONINFO_FILE' 'meta/weapon_glock20.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
