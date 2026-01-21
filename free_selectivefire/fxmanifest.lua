--[[
    FREE SELECTIVE FIRE SYSTEM
    Integrated with ox_inventory and ox_lib

    Features:
    - Semi-automatic, burst, and full-automatic fire modes
    - Per-weapon configuration based on real-world equivalents
    - Universal modification components (Glock switches, bump stocks)
    - ox_inventory currentWeapon event for weapon detection
    - ox_lib keybind for fire mode toggle
    - Server-side fire rate validation
    - Death/respawn state cleanup
    - Character switch cleanup (Qbox/QBCore/ox_core)
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Custom Weapons Project'
description 'Selective Fire System - Realistic fire mode control for weapons'
version '2.0.0'

-- Dependencies
shared_script '@ox_lib/init.lua'

dependencies {
    'ox_lib',
    'ox_inventory',
}

shared_scripts {
    'shared/config.lua',
}

client_scripts {
    'client/cl_firecontrol.lua',
}

server_scripts {
    'server/sv_firevalidation.lua',
}

-- Meta files for modification components
files {
    'meta/weaponcomponents_modifications.meta',
}

data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_modifications.meta'
