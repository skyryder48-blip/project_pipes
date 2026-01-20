fx_version 'cerulean'
game 'gta5'

author 'Weapon Developer'
description 'WEAPON_SIGP226 - Custom Pistol Addon'
version '1.0.0'

files {
    'meta/*.meta',
}

data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapon_sigp226.meta'

client_script 'cl_weaponNames.lua'
