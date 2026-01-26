--[[
    Client-Side Bullet Penetration Handler
    =======================================

    Handles:
    1. Raycasting to find secondary targets (overpenetration)
    2. Material detection for cover penetration
    3. Visual effects for penetration (exit holes, sparks)
    4. Applying penetration damage locally

    Works with server/sv_penetration.lua
]]

-- =============================================================================
-- CONFIGURATION
-- =============================================================================

local PenetrationConfig = {
    -- Debug visualization
    Debug = false,
    DebugDrawTime = 3000,  -- How long to show debug lines (ms)

    -- Raycast settings
    RaycastFlags = 1 + 2 + 4 + 8 + 16,  -- Everything except vegetation
    MaxRaycastDistance = 50.0,

    -- Secondary target detection
    TargetDetectionCone = 5.0,  -- Degrees
    MaxTargetDistance = 30.0,

    -- Visual effects
    ShowExitHoles = true,
    ShowSparks = true,
}

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================

--- Get all peds in a cone from a point
-- @param origin vector3 Starting point
-- @param direction vector3 Direction to check
-- @param maxDistance number Maximum distance
-- @param coneAngle number Cone angle in degrees
-- @param excludeNetIds table Network IDs to exclude
-- @return table List of { ped, netId, distance }
local function GetPedsInCone(origin, direction, maxDistance, coneAngle, excludeNetIds)
    local results = {}
    local excludeSet = {}

    for _, netId in ipairs(excludeNetIds or {}) do
        excludeSet[netId] = true
    end

    -- Normalize direction
    local dirNorm = norm(direction)
    local cosAngle = math.cos(math.rad(coneAngle))

    -- Get all peds in range
    local playerPed = PlayerPedId()

    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if ped ~= playerPed then
            local pedCoords = GetEntityCoords(ped)
            local toPed = pedCoords - origin
            local distance = #toPed

            if distance <= maxDistance and distance > 0.5 then
                -- Check if ped is within cone
                local toPedNorm = toPed / distance
                local dot = dirNorm.x * toPedNorm.x + dirNorm.y * toPedNorm.y + dirNorm.z * toPedNorm.z

                if dot >= cosAngle then
                    local netId = PedToNet(ped)
                    if not excludeSet[netId] then
                        table.insert(results, {
                            ped = ped,
                            netId = netId,
                            distance = distance,
                            coords = pedCoords,
                        })
                    end
                end
            end
        end
    end

    -- Sort by distance
    table.sort(results, function(a, b) return a.distance < b.distance end)

    return results
end

--- Normalize a vector
-- @param v vector3
-- @return vector3
function norm(v)
    local len = #v
    if len == 0 then return vector3(0, 0, 0) end
    return v / len
end

--- Do a raycast and get material info
-- @param start vector3 Start point
-- @param endPoint vector3 End point
-- @param ignore entity Entity to ignore
-- @return table { hit, coords, normal, material, entity }
local function DoMaterialRaycast(start, endPoint, ignore)
    local ray = StartShapeTestLosProbe(
        start.x, start.y, start.z,
        endPoint.x, endPoint.y, endPoint.z,
        PenetrationConfig.RaycastFlags,
        ignore, 0
    )

    local _, hit, coords, normal, materialHash, entity = GetShapeTestResultIncludingMaterial(ray)

    return {
        hit = hit,
        coords = coords,
        normal = normal,
        material = materialHash,
        entity = entity,
    }
end

-- =============================================================================
-- SECONDARY TARGET DETECTION (OVERPENETRATION)
-- =============================================================================

--- Find targets behind the primary victim
-- @param data table Data from server including direction, primary victim, etc.
RegisterNetEvent('ammo:findSecondaryTargets', function(data)
    if not data then return end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- Calculate direction from player to impact point
    local impactCoords = data.impactCoords
    local direction

    if impactCoords then
        direction = norm(vector3(impactCoords.x, impactCoords.y, impactCoords.z) - playerCoords)
    else
        -- Fallback to player's forward vector
        direction = GetEntityForwardVector(playerPed)
    end

    -- Find secondary targets in the bullet's path
    local excludeNetIds = { data.primaryVictimNetId }
    local potentialTargets = GetPedsInCone(
        impactCoords or playerCoords,
        direction,
        PenetrationConfig.MaxTargetDistance,
        PenetrationConfig.TargetDetectionCone,
        excludeNetIds
    )

    -- Limit to max targets
    local targets = {}
    for i = 1, math.min(#potentialTargets, data.maxTargets or 3) do
        local target = potentialTargets[i]

        -- Verify line of sight (no obstacles between)
        local startPos = impactCoords or playerCoords
        local ray = StartShapeTestRay(
            startPos.x, startPos.y, startPos.z,
            target.coords.x, target.coords.y, target.coords.z,
            PenetrationConfig.RaycastFlags,
            playerPed, 0
        )

        local _, hit, hitCoords, _, hitEntity = GetShapeTestResult(ray)

        -- Check if we hit our intended target
        if hit and hitEntity == target.ped then
            table.insert(targets, {
                netId = target.netId,
                distance = target.distance,
            })

            -- Debug visualization
            if PenetrationConfig.Debug then
                DrawLine(
                    startPos.x, startPos.y, startPos.z,
                    target.coords.x, target.coords.y, target.coords.z,
                    255, 0, 0, 255
                )
            end
        end
    end

    -- Send results to server
    if #targets > 0 then
        TriggerServerEvent('ammo:secondaryTargetsFound', {
            targets = targets,
            caliber = data.caliber,
            ammoType = data.ammoType,
            baseDamage = data.baseDamage,
            damageRetained = data.damageRetained,
        })

        -- Visual feedback: penetration "exit" effect
        if PenetrationConfig.ShowExitHoles and impactCoords then
            CreatePenetrationEffect(impactCoords, direction)
        end
    end
end)

-- =============================================================================
-- MATERIAL PENETRATION
-- =============================================================================

--- Check for material penetration when shooting cover
-- Called when player shoots and hits non-ped entity
local function CheckMaterialPenetration(weaponHash, impactCoords, surfaceNormal, materialHash, hitEntity)
    if not Config.Penetration or not Config.Penetration.enabled then return end

    local weaponInfo = Config.Weapons and Config.Weapons[weaponHash]
    if not weaponInfo then return end

    local caliber = weaponInfo.caliber
    local ammoType = exports['free-bullets']:GetAmmoType(weaponHash)

    -- Calculate direction through the material
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local direction = norm(impactCoords - playerCoords)

    -- Raycast from behind the impact point to find exit and targets
    local penetrationDepth = 2.0  -- How far to check behind cover
    local behindCover = impactCoords + (direction * penetrationDepth)

    local exitRay = DoMaterialRaycast(behindCover, impactCoords, hitEntity)

    -- Find targets behind cover
    local targets = GetPedsInCone(
        behindCover,
        direction,
        PenetrationConfig.MaxTargetDistance,
        PenetrationConfig.TargetDetectionCone * 2,  -- Wider cone for cover
        {}
    )

    local secondaryVictim = targets[1]

    -- Send to server for processing
    TriggerServerEvent('ammo:materialPenetrationResult', {
        caliber = caliber,
        ammoType = ammoType,
        materialHash = materialHash,
        baseDamage = GetWeaponDamage(weaponHash, 0),  -- Base weapon damage
        impactCoords = impactCoords,
        exitCoords = exitRay.hit and exitRay.coords or nil,
        secondaryVictimNetId = secondaryVictim and secondaryVictim.netId or nil,
    })
end

-- =============================================================================
-- PENETRATION DAMAGE APPLICATION
-- =============================================================================

--- Apply penetration damage to local player
RegisterNetEvent('ammo:applyPenetrationDamage', function(data)
    if not data then return end

    local ped = PlayerPedId()
    local damage = data.damage or 0

    if damage > 0 and not IsEntityDead(ped) then
        -- Apply damage
        ApplyDamageToPed(ped, damage, false)

        -- Visual/audio feedback for being hit through cover/body
        if data.isPenetration then
            -- Slight screen shake for penetration hit
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)

            -- Notify player they were hit through something
            if lib and lib.notify then
                lib.notify({
                    title = 'Penetration Hit',
                    description = 'A bullet passed through and hit you',
                    type = 'error',
                    duration = 2000,
                })
            end
        end

        if PenetrationConfig.Debug then
            print(('[PENETRATION] Received %d penetration damage from %s %s'):format(
                damage, data.caliber or 'unknown', data.ammoType or 'unknown'
            ))
        end
    end
end)

-- =============================================================================
-- VISUAL EFFECTS
-- =============================================================================

--- Create penetration visual effect (sparks, dust)
-- @param coords vector3 Impact/exit point
-- @param direction vector3 Bullet direction
function CreatePenetrationEffect(coords, direction)
    if not PenetrationConfig.ShowSparks then return end

    -- Request particle asset
    local asset = 'core'
    RequestNamedPtfxAsset(asset)

    local timeout = 1000
    while not HasNamedPtfxAssetLoaded(asset) and timeout > 0 do
        Wait(10)
        timeout = timeout - 10
    end

    if HasNamedPtfxAssetLoaded(asset) then
        UseParticleFxAsset(asset)

        -- Spark effect for metal/hard surface penetration
        StartParticleFxNonLoopedAtCoord(
            'sp_intdesert_dvtv_lod',  -- Sparks particle
            coords.x, coords.y, coords.z,
            0.0, 0.0, 0.0,
            0.3,
            false, false, false
        )

        -- Small dust puff
        StartParticleFxNonLoopedAtCoord(
            'ent_dst_concrete',  -- Dust particle
            coords.x, coords.y, coords.z,
            0.0, 0.0, 0.0,
            0.2,
            false, false, false
        )
    end
end

--- Visual feedback when penetration occurs
RegisterNetEvent('ammo:penetrationResult', function(data)
    if not data then return end

    if data.penetrated and data.exitCoords then
        CreatePenetrationEffect(
            vector3(data.exitCoords.x, data.exitCoords.y, data.exitCoords.z),
            vector3(0, 0, 1)  -- Default up direction
        )

        if PenetrationConfig.Debug then
            print(('[PENETRATION] Visual: Bullet penetrated %s'):format(data.material or 'unknown'))
        end
    end
end)

-- =============================================================================
-- SHOOTING DETECTION (for material penetration)
-- =============================================================================

-- Monitor player shots to detect material impacts
CreateThread(function()
    local lastShotTime = 0

    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` and IsPedShooting(ped) then
            local currentTime = GetGameTimer()

            -- Debounce
            if currentTime - lastShotTime > 50 then
                lastShotTime = currentTime

                -- Get impact point via raycast
                local coords = GetEntityCoords(ped)
                local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.5, 0.6)
                local direction = GetEntityForwardVector(ped)
                local endPoint = coords + (direction * PenetrationConfig.MaxRaycastDistance)

                local result = DoMaterialRaycast(offset, endPoint, ped)

                if result.hit then
                    local hitEntity = result.entity

                    -- Check if we hit cover (non-ped entity)
                    if hitEntity and not IsPedAPlayer(hitEntity) and GetEntityType(hitEntity) ~= 1 then
                        -- Hit an object or vehicle - check for material penetration
                        CheckMaterialPenetration(
                            weapon,
                            result.coords,
                            result.normal,
                            result.material,
                            hitEntity
                        )
                    end
                end
            end

            Wait(0)
        else
            Wait(100)
        end
    end
end)

-- =============================================================================
-- INTEGRATION WITH DAMAGE SYSTEM
-- =============================================================================

-- Server requests impact coordinates for penetration check
RegisterNetEvent('ammo:requestImpactCoords', function(data)
    if not data then return end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)

    -- Get victim position
    local victimCoords = nil
    if data.victimNetId then
        local victim = NetToEnt(data.victimNetId)
        if DoesEntityExist(victim) then
            victimCoords = GetEntityCoords(victim)
        end
    end

    -- Calculate direction
    local direction = forward
    if victimCoords then
        direction = norm(victimCoords - coords)
    end

    -- Send penetration check to server
    TriggerServerEvent('ammo:checkOverpenetration', {
        caliber = data.caliber,
        ammoType = data.ammoType,
        baseDamage = data.baseDamage,
        victimNetId = data.victimNetId,
        impactCoords = victimCoords,
        direction = { x = direction.x, y = direction.y, z = direction.z },
    })
end)

-- Hook into the main damage event to trigger penetration check
-- This is called after primary damage is calculated
AddEventHandler('ammo:primaryDamageApplied', function(data)
    -- Check if we should overpenetrate
    if data and data.victimNetId and data.caliber then
        TriggerServerEvent('ammo:checkOverpenetration', {
            caliber = data.caliber,
            ammoType = data.ammoType,
            baseDamage = data.damage,
            victimNetId = data.victimNetId,
            impactCoords = data.impactCoords,
        })
    end
end)

-- =============================================================================
-- DEBUG VISUALIZATION
-- =============================================================================

if PenetrationConfig.Debug then
    CreateThread(function()
        while PenetrationConfig.Debug do
            Wait(0)

            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local forward = GetEntityForwardVector(ped)

            -- Draw forward ray
            local endPoint = coords + (forward * 20.0)
            DrawLine(
                coords.x, coords.y, coords.z + 0.5,
                endPoint.x, endPoint.y, endPoint.z + 0.5,
                0, 255, 0, 200
            )
        end
    end)
end

-- =============================================================================
-- EXPORTS
-- =============================================================================

exports('CheckMaterialPenetration', CheckMaterialPenetration)
exports('CreatePenetrationEffect', CreatePenetrationEffect)
exports('GetPedsInCone', GetPedsInCone)

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

CreateThread(function()
    print('[PENETRATION] Client penetration handler initialized')
end)
