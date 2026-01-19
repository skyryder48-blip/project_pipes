-- cl_weaponNames.lua
-- Glock Demon - Full-Auto .40 S&W Converted Street Weapon
-- Weapon display name registration

Citizen.CreateThread(function()
    AddTextEntry('WT_GLOCK_DEMON', 'Glock Demon')

    -- Ammo type display names
    AddTextEntry('WCT_CLIP_FMJ', 'FMJ Magazine')
    AddTextEntry('WCD_CLIP_FMJ', 'Standard full metal jacket ammunition.')
    AddTextEntry('WCT_CLIP_JHP', 'JHP Magazine')
    AddTextEntry('WCD_CLIP_JHP', 'Jacketed hollow point for increased stopping power.')
end)
