fx_version 'cerulean'
game 'gta5'

author 'Your Server Name'
description 'Realistic Ammunition System - Caliber-based ammo types with FMJ/HP/AP variants'
version '1.0.0'

-- Dependencies
dependencies {
    'qbx_core',
    'ox_inventory',
    'ox_lib'
}

-- Shared files (loaded first)
shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/weapons.lua'
}

-- Client scripts
client_scripts {
    'client/cl_ammo.lua'
}

-- Server scripts
server_scripts {
    'server/sv_ammo.lua'
}

-- Lua 5.4 for better performance
lua54 'yes'
