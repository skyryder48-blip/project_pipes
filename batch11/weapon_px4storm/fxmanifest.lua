fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development Project'
description 'weapon_px4storm Addon Weapon'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapon_px4storm.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'stream/*',
}

data_file 'WEAPONINFO_FILE' 'meta/weapon_px4storm.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
