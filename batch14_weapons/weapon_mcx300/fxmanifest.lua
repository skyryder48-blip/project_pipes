fx_version 'cerulean'
game 'gta5'

author 'Custom Weapons Project'
description 'WEAPON_MCX300 - Next-Gen Tactical Rifle Platform'
version '1.0.0'

files {
    'meta/*.meta',
}

data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapon_mcx300.meta'

client_script 'cl_weaponNames.lua'
