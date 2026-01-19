fx_version 'cerulean'
game 'gta5'

author 'Project Pipes'
description 'weapon_g22_gen4 - Glock 22 Gen 4 .40 S&W Law Enforcement Pistol'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapon_g22_gen4.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'meta/weaponarchetypes.meta',
}

-- Load order matters: archetypes -> animations -> personality -> weapon
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapon_g22_gen4.meta'
