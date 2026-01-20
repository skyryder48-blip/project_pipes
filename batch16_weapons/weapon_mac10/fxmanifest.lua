fx_version 'cerulean'
game 'gta5'

name 'weapon_mac10'
description 'Ingram MAC-10 - Classic .45 ACP Machine Pistol - 1,100 RPM'
author 'Custom Weapons Project'
version '1.0.0'

files {
    'meta/weapon_mac10.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta'
}

data_file 'WEAPONINFO_FILE' 'meta/weapon_mac10.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'

client_script 'cl_weaponNames.lua'
