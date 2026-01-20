fx_version 'cerulean'
game 'gta5'

name 'weapon_arp_bumpstock'
description '7.5" AR Pistol with Bump Stock - Full-Auto Chaos - 5.56 NATO'
author 'Custom Weapons Project'
version '1.0.0'

files {
    'meta/weapon_arp_bumpstock.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta'
}

data_file 'WEAPONINFO_FILE' 'meta/weapon_arp_bumpstock.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'

client_script 'cl_weaponNames.lua'
