--[[
    Kel-Tec PMR-30 - .22 WMR (uses .22 LR ammo system)
    Batch 8: Rimfire Pistols

    Ultra-light high-capacity combat rimfire
    4.3" barrel, SAO trigger, 30+1 capacity (HIGHEST)
    .22 WMR ballistics = 1.6x .22 LR energy, significant muzzle flash
]]

fx_version 'cerulean'
game 'gta5'

author 'Weapon Meta Development'
description 'Kel-Tec PMR-30 - .22 Winchester Magnum Rimfire'
version '1.0.0'

client_script 'cl_weaponNames.lua'

files {
    'meta/weapon_pmr30.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/pedpersonality.meta',
    'stream/*'
}

data_file 'WEAPONINFO_FILE' 'meta/weapon_pmr30.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
