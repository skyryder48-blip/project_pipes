--[[
    Pepperball Server Handler
    ==========================

    Server-side damage detection for pepperball rounds.
    Triggers client-side effects when a player is hit.
]]

-- Track which weapons are loaded with pepperball ammo
local playerAmmoTypes = {}

-- Register when a player loads pepperball ammo
RegisterNetEvent('ammo:setAmmoType')
AddEventHandler('ammo:setAmmoType', function(weaponHash, ammoType, caliber)
    local source = source
    if caliber == '12ga' and ammoType == 'pepperball' then
        playerAmmoTypes[source] = playerAmmoTypes[source] or {}
        playerAmmoTypes[source][weaponHash] = true
    elseif playerAmmoTypes[source] then
        playerAmmoTypes[source][weaponHash] = nil
    end
end)

-- Handle weapon damage events
AddEventHandler('weaponDamageEvent', function(sender, data)
    -- Check if attacker is using pepperball ammo
    if playerAmmoTypes[sender] then
        local weaponHash = data.weaponType

        if playerAmmoTypes[sender][weaponHash] then
            -- Victim was hit with pepperball
            local victim = data.hitGlobalId

            if victim and victim > 0 then
                -- Find the player who was hit
                local players = GetPlayers()
                for _, playerId in ipairs(players) do
                    local playerPed = GetPlayerPed(playerId)
                    if playerPed and NetworkGetNetworkIdFromEntity(playerPed) == victim then
                        -- Trigger pepper effect on victim
                        TriggerClientEvent('ammo:pepperball:applyEffect', playerId, 0.4)
                        break
                    end
                end
            end
        end
    end
end)

-- Cleanup on player disconnect
AddEventHandler('playerDropped', function()
    local source = source
    playerAmmoTypes[source] = nil
end)
