-- cl_weaponNames.lua
-- Colt M45A1 CQBP - .45 ACP Military 1911
-- Weapon display name registration

Citizen.CreateThread(function()
    AddTextEntry('WT_M45A1', 'Colt M45A1')

    -- Ammo type display names
    AddTextEntry('WCT_CLIP_FMJ', 'FMJ Magazine')
    AddTextEntry('WCD_CLIP_FMJ', 'Standard full metal jacket ammunition.')
    AddTextEntry('WCT_CLIP_JHP', 'JHP Magazine')
    AddTextEntry('WCD_CLIP_JHP', 'Jacketed hollow point for increased stopping power.')
end)
