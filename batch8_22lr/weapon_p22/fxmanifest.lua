--[[
    Walther P22 - .22 LR
    Batch 8: Rimfire Pistols

    Budget rimfire trainer with DA/SA operation
    3.42" barrel, 10+1 capacity, $329 MSRP
    Entry-level suppressor host, ideal for training
]]

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development'
description 'Walther P22 - .22 Long Rifle'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapon_p22.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'stream/*'
}

data_file 'WEAPONINFO_FILE' 'meta/weapon_p22.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
