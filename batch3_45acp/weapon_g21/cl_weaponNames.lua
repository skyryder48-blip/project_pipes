-- cl_weaponNames.lua
-- Glock 21 Gen 4 - .45 ACP Full-Size Pistol
-- Weapon display name registration

Citizen.CreateThread(function()
    AddTextEntry('WT_G21', 'Glock 21')

    -- Ammo type display names
    AddTextEntry('WCT_CLIP_FMJ', 'FMJ Magazine')
    AddTextEntry('WCD_CLIP_FMJ', 'Standard full metal jacket ammunition.')
    AddTextEntry('WCT_CLIP_JHP', 'JHP Magazine')
    AddTextEntry('WCD_CLIP_JHP', 'Jacketed hollow point for increased stopping power.')
end)
