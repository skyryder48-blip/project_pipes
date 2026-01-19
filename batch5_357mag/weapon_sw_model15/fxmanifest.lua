-- fxmanifest.lua
-- S&W Model 15 "Combat Masterpiece" .38 Special (4" barrel)
-- Batch 5: .357 Magnum & .38 Special Revolvers

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development'
description 'S&W Model 15 Combat Masterpiece .38 Special - Classic Police Revolver'
version '1.0.0'

-- Client script for weapon display name
client_script 'cl_weaponNames.lua'

-- Meta files
files {
    'meta/weapons.meta',
}

-- Data file declarations for addon weapons
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
