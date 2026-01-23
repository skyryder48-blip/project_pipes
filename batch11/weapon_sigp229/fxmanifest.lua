fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development Project'
description 'weapon_sigp229 Addon Weapon'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapon_sigp229.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/weaponcomponents.meta',
    'meta/pedpersonality.meta',
    'stream/*',
}

--[[
    DATA FILE LOAD ORDER (CRITICAL!)
    Components must load BEFORE weapons.meta
]]

data_file 'WEAPONCOMPONENTSINFO_FILE' 'meta/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapon_sigp229.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
