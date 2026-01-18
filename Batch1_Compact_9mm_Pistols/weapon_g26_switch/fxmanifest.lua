fx_version 'cerulean'
game 'gta5'

author 'Your Server Name'
description 'Glock 26 Switch - Full-Auto Conversion'
version '1.0.0'

-- Client script for weapon name
client_script 'cl_weaponNames.lua'

-- Meta files
files {
    'meta/weapon_g26_switch.meta',
}

-- Data file declarations
data_file 'WEAPONINFO_FILE_PATCH' 'meta/weapon_g26_switch.meta'
