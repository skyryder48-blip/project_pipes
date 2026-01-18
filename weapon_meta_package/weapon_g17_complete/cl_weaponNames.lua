-- cl_weaponNames.lua
-- Glock 17 Gen 4 - Display Name Registration

Citizen.CreateThread(function()
    -- Weapon display name
    AddTextEntry('WT_G17', 'Glock 17')
    
    -- Component display names
    AddTextEntry('WCT_CLIP_FMJ', 'Standard Magazine (FMJ)')
    AddTextEntry('WCD_CLIP_FMJ', 'Standard 17-round magazine with FMJ ammunition.')
    
    AddTextEntry('WCT_CLIP_HP', 'Hollow Point Magazine')
    AddTextEntry('WCD_CLIP_HP', '17-round magazine loaded with hollow point ammunition. Increased damage to unarmored targets.')
    
    AddTextEntry('WCT_CLIP_AP', 'Armor Piercing Magazine')
    AddTextEntry('WCD_CLIP_AP', '15-round magazine loaded with armor piercing ammunition. Bypasses body armor.')
end)
