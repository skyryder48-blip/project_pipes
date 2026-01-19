fx_version 'cerulean'
game 'gta5'

author 'Project Pipes'
description 'weapon_kimber_eclipse - Kimber Eclipse Custom II .45 ACP Target 1911'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapon_kimber_eclipse.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'meta/weaponarchetypes.meta',
}

-- Load order matters: archetypes -> animations -> personality -> weapon
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapon_kimber_eclipse.meta'
