fx_version 'cerulean'
game 'gta5'

author 'Custom Weapons Project'
description 'WEAPON_M7 - Next-Gen Tactical Rifle Platform'
version '1.0.0'

files {
    'meta/*.meta',
}

data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapon_m7.meta'

client_script 'cl_weaponNames.lua'
