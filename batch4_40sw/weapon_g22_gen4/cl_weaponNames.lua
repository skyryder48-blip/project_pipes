-- cl_weaponNames.lua
-- Glock 22 Gen 4 - .40 S&W Law Enforcement Pistol
-- Weapon display name registration

Citizen.CreateThread(function()
    AddTextEntry('WT_G22_GEN4', 'Glock 22')

    -- Ammo type display names
    AddTextEntry('WCT_CLIP_FMJ', 'FMJ Magazine')
    AddTextEntry('WCD_CLIP_FMJ', 'Standard full metal jacket ammunition.')
    AddTextEntry('WCT_CLIP_JHP', 'JHP Magazine')
    AddTextEntry('WCD_CLIP_JHP', 'Jacketed hollow point for increased stopping power.')
end)
