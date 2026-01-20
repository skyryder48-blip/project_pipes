fx_version 'cerulean'
game 'gta5'

name 'weapon_sbr9'
description '9" SBR Custom Build - Illegal Civilian Short Barrel Rifle - 5.56 NATO'
author 'Custom Weapons Project'
version '1.0.0'

files {
    'meta/weapon_sbr9.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta'
}

data_file 'WEAPONINFO_FILE' 'meta/weapon_sbr9.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'

client_script 'cl_weaponNames.lua'
