-- cl_weaponNames.lua
-- Kimber Eclipse Custom II 1911 - Target-Grade .45 ACP Pistol
-- Weapon display name registration

Citizen.CreateThread(function()
    AddTextEntry('WT_KIMBER_ECLIPSE', 'Kimber Eclipse')

    -- Ammo type display names
    AddTextEntry('WCT_CLIP_FMJ', 'FMJ Magazine')
    AddTextEntry('WCD_CLIP_FMJ', 'Standard full metal jacket ammunition.')
    AddTextEntry('WCT_CLIP_JHP', 'JHP Magazine')
    AddTextEntry('WCD_CLIP_JHP', 'Jacketed hollow point for increased stopping power.')
end)
