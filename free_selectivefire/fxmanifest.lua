--[[
    FREE SELECTIVE FIRE SYSTEM
    A realistic fire mode selector for FiveM weapons

    Features:
    - Semi-automatic, burst, and full-automatic fire modes
    - Per-weapon configuration based on real-world equivalents
    - Modification support (Glock switches, bump stocks, etc.)
    - Subtle notification on mode change
    - Configurable toggle key
]]

fx_version 'cerulean'
game 'gta5'

author 'Custom Weapons Project'
description 'Selective Fire System - Realistic fire mode control for weapons'
version '1.0.0'

shared_scripts {
    'shared/config.lua',
}

client_scripts {
    'client/cl_firecontrol.lua',
}
