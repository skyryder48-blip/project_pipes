fx_version 'cerulean'
game 'gta5'

author 'Your Server Name'
description 'Glock 17 Gen 4 - Realistic 9mm Pistol'
version '1.0.0'

-- Client script for weapon and component names
client_script 'cl_weaponNames.lua'

-- Meta files to stream
files {
    'meta/weapons.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/weaponcomponents.meta',
}

--[[
    DATA FILE LOAD ORDER (CRITICAL!)
    Components must load BEFORE weapons.meta
    
    Order:
    1. weaponcomponents.meta - Define magazine components
    2. weaponarchetypes.meta - Link models to textures
    3. weaponanimations.meta - Animation references
    4. weapons.meta - Weapon definitions (loads last, references components)
]]

data_file 'WEAPONCOMPONENTSINFO_FILE' 'meta/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
