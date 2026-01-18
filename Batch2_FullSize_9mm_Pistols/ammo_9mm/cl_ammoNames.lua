-- cl_ammoNames.lua
-- Centralized 9mm Ammunition Display Names
-- These entries are shared across ALL 9mm weapons

Citizen.CreateThread(function()
    -- Magazine/Ammo Type Names
    AddTextEntry('WCT_CLIP_FMJ', 'FMJ Magazine')
    AddTextEntry('WCD_CLIP_FMJ', 'Standard full metal jacket rounds. Balanced performance.')
    
    AddTextEntry('WCT_CLIP_HP', 'Hollow Point Mag')
    AddTextEntry('WCD_CLIP_HP', 'Expanding rounds. +10% damage to unarmored targets, reduced armor penetration.')
    
    AddTextEntry('WCT_CLIP_AP', 'Armor Piercing Mag')
    AddTextEntry('WCD_CLIP_AP', 'Hardened steel core. Bypasses body armor, -10% base damage, reduced capacity.')
end)
