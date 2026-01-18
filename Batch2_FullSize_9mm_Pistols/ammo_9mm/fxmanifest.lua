fx_version 'cerulean'
game 'gta5'

author 'Your Server Name'
description 'Centralized 9mm Ammunition System - FMJ, Hollow Point, Armor Piercing'
version '1.0.0'

--[[
    IMPORTANT: Load this resource BEFORE any 9mm weapon resources!
    
    In server.cfg:
        ensure ammo_9mm
        ensure weapon_g17
        ensure weapon_m9
        ...
    
    Ammo Effects (standardized for ALL 9mm weapons):
    - FMJ: Baseline damage, 0.15 penetration
    - Hollow Point: +10% damage, reduced vs armor
    - Armor Piercing: -10% damage, bypasses body armor
]]

client_script 'cl_ammoNames.lua'

files {
    'meta/ammo_9mm.meta',
    'meta/weaponcomponents_9mm.meta',
}

data_file 'WEAPONINFO_FILE_PATCH' 'meta/ammo_9mm.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'meta/weaponcomponents_9mm.meta'
