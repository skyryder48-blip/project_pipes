-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Project'
description 'SIG Sauer P226 MK25 - Official Navy SEAL Sidearm'
version '1.0.0'

-- Client script for weapon name registration
client_script 'cl_weaponNames.lua'

-- Meta files for weapon configuration
files {
    'meta/weapons.meta'
}

-- Data file declarations for addon weapons
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
