fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development Project'
description 'weapon_red_aug Addon Weapon'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapons.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'stream/*',
}

data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
