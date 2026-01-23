fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development Project'
description 'weapon_sig_p22 Addon Weapon'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weaponcomponents.meta',
    'meta/weapon_sigp22.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'stream/*',
}

data_file 'WEAPONCOMPONENTSINFO_FILE' 'meta/weaponcomponents.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapon_sigp22.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
