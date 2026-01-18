-- cl_weaponNames.lua
-- Glock 17 Gen 4 - Full-Size 9mm Pistol
-- Weapon display name registration

Citizen.CreateThread(function()
    AddTextEntry('WT_G17', 'Glock 17')
    
    -- Ammo type display names
    AddTextEntry('WCT_CLIP_FMJ', 'FMJ Magazine')
    AddTextEntry('WCD_CLIP_FMJ', 'Standard full metal jacket ammunition.')
    AddTextEntry('WCT_CLIP_HP', 'Hollow Point Magazine')
    AddTextEntry('WCD_CLIP_HP', 'Increased damage against unarmored targets.')
    AddTextEntry('WCT_CLIP_AP', 'Armor Piercing Magazine')
    AddTextEntry('WCD_CLIP_AP', 'Penetrates body armor and bulletproof glass.')
end)
