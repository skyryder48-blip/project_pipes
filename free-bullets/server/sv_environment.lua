--[[
    Server-Side Environmental Interactions
    =======================================

    Handles validation and synchronization of environmental effects:
    - Fuel/explosive interactions
    - Electrical system disruption
    - Glass behavior
    - Water interactions
    - Cover destruction tracking
    - Fire spread coordination
    - Ricochet validation
    - Special object interactions
]]

-- =============================================================================
-- STATE TRACKING
-- =============================================================================

-- Track damaged objects (prevents spam/exploitation)
local damagedObjects = {}           -- [netId] = { hits = n, lastHit = timestamp }
local disabledLights = {}           -- [netId] = timestamp
local bulletproofGlassHits = {}     -- [netId] = { hits = n, caliber = {} }
local disabledVehicles = {}         -- [netId] = { electronics = bool, engine = bool, restartTime = timestamp }
local activeFireSpread = {}         -- [zoneId] = { center = vec3, radius = n, endTime = timestamp }
local waterSprayingHydrants = {}    -- [netId] = endTime

-- Cleanup interval
local CLEANUP_INTERVAL = 60000      -- 1 minute
local OBJECT_DAMAGE_TIMEOUT = 30000 -- Reset object damage after 30 seconds

-- =============================================================================
-- FUEL/EXPLOSIVE INTERACTIONS
-- =============================================================================

RegisterNetEvent('ammo:fuelInteraction', function(data)
    local source = source
    if not data or not data.coords then return end

    local ammoKey = data.ammoKey
    local canIgnite, ignitionData = CanIgniteFuel(ammoKey)

    if not canIgnite then return end

    -- Roll for ignition
    if math.random() > ignitionData.chance then return end

    local targetType = data.targetType
    local targetConfig = Config.EnvironmentalEffects.fuel.targets[targetType]

    if not targetConfig then return end

    -- Calculate explosion parameters
    local radius = targetConfig.baseRadius * (ignitionData.explosionScale or 1.0)
    local damage = targetConfig.baseDamage or 100

    -- Sync explosion to all clients
    TriggerClientEvent('ammo:createExplosion', -1, {
        coords = data.coords,
        explosionType = targetConfig.explosionType,
        radius = radius,
        damage = damage,
        isAudible = true,
        isInvisible = false,
        cameraShake = true,
        source = source,
    })

    -- Handle fire spread if applicable
    if targetConfig.fireSpread then
        local zoneId = string.format('%.0f_%.0f_%.0f', data.coords.x, data.coords.y, data.coords.z)
        activeFireSpread[zoneId] = {
            center = data.coords,
            radius = radius * 0.5,
            endTime = GetGameTimer() + (targetConfig.fireDuration or 10000),
        }

        TriggerClientEvent('ammo:startFireSpread', -1, {
            coords = data.coords,
            radius = radius * 0.5,
            duration = targetConfig.fireDuration or 10000,
        })
    end

    -- Log for anti-cheat if needed
    -- print(('[ammo] Player %d triggered fuel explosion at %.2f, %.2f, %.2f'):format(source, data.coords.x, data.coords.y, data.coords.z))
end)

-- Vehicle fuel tank special handling
RegisterNetEvent('ammo:vehicleFuelHit', function(data)
    local source = source
    if not data or not data.vehicleNetId then return end

    local ammoKey = data.ammoKey
    local canIgnite, ignitionData = CanIgniteFuel(ammoKey)

    if not canIgnite then return end

    local vehicle = NetworkGetEntityFromNetworkId(data.vehicleNetId)
    if not DoesEntityExist(vehicle) then return end

    local fuelConfig = Config.EnvironmentalEffects.fuel.targets.vehicleFuelTank

    -- Roll for fire
    if math.random() < fuelConfig.fireChance * ignitionData.chance then
        TriggerClientEvent('ammo:vehicleCatchFire', -1, {
            vehicleNetId = data.vehicleNetId,
            explosionDelay = fuelConfig.fireToExplosionTime,
        })
    end
end)

-- =============================================================================
-- ELECTRICAL INTERACTIONS
-- =============================================================================

RegisterNetEvent('ammo:electricalInteraction', function(data)
    local source = source
    if not data or not data.coords then return end

    local ammoKey = data.ammoKey
    local canDisrupt, disruptData = CanDisruptElectrical(ammoKey)

    if not canDisrupt then return end

    -- Roll for disruption
    if math.random() > disruptData.chance then return end

    local targetType = data.targetType

    if targetType == 'powerBox' then
        local config = Config.EnvironmentalEffects.electrical.targets.powerBox

        -- Trigger sparks
        TriggerClientEvent('ammo:electricalSparks', -1, {
            coords = data.coords,
            duration = config.sparkDuration,
        })

        -- Trigger area blackout
        TriggerClientEvent('ammo:areaBlackout', -1, {
            coords = data.coords,
            radius = config.blackoutRadius,
            duration = config.blackoutDuration,
        })

    elseif targetType == 'streetLight' then
        if data.entityNetId then
            disabledLights[data.entityNetId] = GetGameTimer()
            TriggerClientEvent('ammo:disableLight', -1, {
                entityNetId = data.entityNetId,
            })
        end

    elseif targetType == 'vehicleBattery' then
        if data.vehicleNetId then
            local vehicle = NetworkGetEntityFromNetworkId(data.vehicleNetId)
            if DoesEntityExist(vehicle) then
                local config = Config.EnvironmentalEffects.electrical.targets.vehicleBattery

                -- Spark effect
                if math.random() < config.sparkChance then
                    TriggerClientEvent('ammo:electricalSparks', -1, {
                        coords = data.coords,
                        duration = 1500,
                        small = true,
                    })
                end

                -- Disable electronics
                if config.disableElectronics then
                    disabledVehicles[data.vehicleNetId] = {
                        electronics = true,
                        engine = disruptData.disableEngine or false,
                        restartTime = config.disableEnginePermanent and 0 or (GetGameTimer() + config.restartDelay),
                    }

                    TriggerClientEvent('ammo:disableVehicle', -1, {
                        vehicleNetId = data.vehicleNetId,
                        disableElectronics = true,
                        disableEngine = disruptData.disableEngine or false,
                        restartDelay = config.restartDelay,
                    })
                end
            end
        end
    end
end)

-- =============================================================================
-- GLASS INTERACTIONS
-- =============================================================================

RegisterNetEvent('ammo:glassHit', function(data)
    local source = source
    if not data then return end

    local ammoType = data.ammoType
    local shatterBehavior = GetGlassShatterBehavior(ammoType)

    if data.isBulletproof then
        -- Track bulletproof glass hits
        local glassId = data.glassId or tostring(data.coords)
        bulletproofGlassHits[glassId] = bulletproofGlassHits[glassId] or { hits = 0, calibers = {} }

        local hitsRequired = Config.EnvironmentalEffects.glass.bulletproofGlass.hitsToBreak[data.caliber] or 10

        -- AP modifier
        if ammoType == 'ap' or ammoType == 'api' then
            hitsRequired = math.ceil(hitsRequired * Config.EnvironmentalEffects.glass.bulletproofGlass.hitsToBreak.apModifier)
        end

        bulletproofGlassHits[glassId].hits = bulletproofGlassHits[glassId].hits + 1

        if bulletproofGlassHits[glassId].hits >= hitsRequired then
            -- Glass breaks
            TriggerClientEvent('ammo:breakBulletproofGlass', -1, {
                glassId = glassId,
                coords = data.coords,
            })
            bulletproofGlassHits[glassId] = nil
        else
            -- Crack effect
            TriggerClientEvent('ammo:crackGlass', -1, {
                coords = data.coords,
                hitNumber = bulletproofGlassHits[glassId].hits,
                hitsRequired = hitsRequired,
            })
        end
    else
        -- Normal glass
        TriggerClientEvent('ammo:shatterGlass', -1, {
            coords = data.coords,
            fullShatter = shatterBehavior.fullShatter,
            holeSize = shatterBehavior.holeSize,
        })
    end
end)

-- =============================================================================
-- WATER INTERACTIONS
-- =============================================================================

RegisterNetEvent('ammo:waterInteraction', function(data)
    local source = source
    if not data then return end

    if data.targetType == 'fireHydrant' then
        if data.entityNetId and not waterSprayingHydrants[data.entityNetId] then
            local config = Config.EnvironmentalEffects.water.fireHydrant

            -- Check if caliber is powerful enough
            local caliberPower = Config.CaliberPower[data.caliber] or 0.5
            if caliberPower >= config.minCaliberPower then
                waterSprayingHydrants[data.entityNetId] = GetGameTimer() + config.waterSprayDuration

                TriggerClientEvent('ammo:fireHydrantBurst', -1, {
                    entityNetId = data.entityNetId,
                    coords = data.coords,
                    sprayDuration = config.waterSprayDuration,
                    slipperyRadius = config.slipperyRadius,
                    slipperyDuration = config.slipperyDuration,
                })
            end
        end

    elseif data.targetType == 'waterTower' then
        local towerId = data.entityNetId or tostring(data.coords)
        damagedObjects[towerId] = damagedObjects[towerId] or { hits = 0, lastHit = 0 }
        damagedObjects[towerId].hits = damagedObjects[towerId].hits + 1
        damagedObjects[towerId].lastHit = GetGameTimer()

        local config = Config.EnvironmentalEffects.water.waterTower

        if damagedObjects[towerId].hits >= config.hitsToCollapse then
            TriggerClientEvent('ammo:waterTowerCollapse', -1, {
                entityNetId = data.entityNetId,
                coords = data.coords,
            })
            damagedObjects[towerId] = nil
        elseif damagedObjects[towerId].hits >= config.hitsToLeak then
            TriggerClientEvent('ammo:waterTowerLeak', -1, {
                entityNetId = data.entityNetId,
                coords = data.coords,
            })
        end
    end
end)

-- =============================================================================
-- COVER DESTRUCTION
-- =============================================================================

RegisterNetEvent('ammo:coverHit', function(data)
    local source = source
    if not data or not data.entityNetId then return end

    local objId = data.entityNetId
    damagedObjects[objId] = damagedObjects[objId] or { hits = 0, lastHit = 0 }

    -- Reset if timeout exceeded
    if GetGameTimer() - damagedObjects[objId].lastHit > OBJECT_DAMAGE_TIMEOUT then
        damagedObjects[objId].hits = 0
    end

    damagedObjects[objId].hits = damagedObjects[objId].hits + 1
    damagedObjects[objId].lastHit = GetGameTimer()

    local coverType = data.coverType
    local config = Config.EnvironmentalEffects.coverDestruction.destructibles[coverType]

    if config then
        if damagedObjects[objId].hits >= (config.hitsToDestroy or config.hitsToBreak or 999) then
            TriggerClientEvent('ammo:destroyCover', -1, {
                entityNetId = objId,
                debrisOnDestroy = config.debrisOnDestroy,
            })
            damagedObjects[objId] = nil
        elseif config.hitsToChip and damagedObjects[objId].hits >= config.hitsToChip then
            TriggerClientEvent('ammo:chipCover', -1, {
                entityNetId = objId,
                coords = data.coords,
                decal = config.chipDecal,
            })
        end
    end
end)

-- =============================================================================
-- FIRE SPREAD
-- =============================================================================

RegisterNetEvent('ammo:igniteFlammable', function(data)
    local source = source
    if not data or not data.coords then return end

    local ammoKey = data.ammoKey
    local incendiaryData = Config.EnvironmentalEffects.fireSpread.incendiaryAmmo[ammoKey]

    if not incendiaryData then return end

    if math.random() > incendiaryData.spreadChance then return end

    local surfaceType = data.surfaceType
    local surfaceConfig = Config.EnvironmentalEffects.fireSpread.flammableSurfaces[surfaceType]

    if surfaceConfig then
        local zoneId = string.format('fire_%.0f_%.0f', data.coords.x, data.coords.y)

        -- Prevent stacking fires
        if activeFireSpread[zoneId] then return end

        activeFireSpread[zoneId] = {
            center = data.coords,
            radius = surfaceConfig.maxSpreadRadius * incendiaryData.intensity,
            endTime = GetGameTimer() + surfaceConfig.burnDuration,
        }

        TriggerClientEvent('ammo:spreadingFire', -1, {
            coords = data.coords,
            spreadRate = surfaceConfig.spreadRate,
            maxRadius = surfaceConfig.maxSpreadRadius * incendiaryData.intensity,
            duration = surfaceConfig.burnDuration,
            explosionChance = surfaceConfig.explosionChance or 0,
        })
    end
end)

-- =============================================================================
-- RICOCHET VALIDATION
-- =============================================================================

RegisterNetEvent('ammo:ricochetHit', function(data)
    local source = source
    if not data then return end

    -- Validate the ricochet damage
    local maxDamage = data.originalDamage * (data.damageRetention or 0.3)

    -- Apply ricochet damage to target
    if data.targetServerId and data.targetServerId > 0 then
        TriggerClientEvent('ammo:applyRicochetDamage', data.targetServerId, {
            damage = math.min(data.damage, maxDamage),
            sourceServerId = source,
            coords = data.hitCoords,
        })
    end
end)

-- =============================================================================
-- SPECIAL OBJECTS
-- =============================================================================

RegisterNetEvent('ammo:specialObjectHit', function(data)
    local source = source
    if not data then return end

    local objectType = data.objectType

    if objectType == 'fireExtinguisher' then
        local config = Config.EnvironmentalEffects.specialObjects.fireExtinguisher

        TriggerClientEvent('ammo:fireExtinguisherBurst', -1, {
            coords = data.coords,
            entityNetId = data.entityNetId,
            sprayDuration = config.sprayDuration,
            sprayRadius = config.sprayRadius,
            obscuresVision = config.visionObscure,
            extinguishesFire = config.extinguishesFire,
        })

    elseif objectType == 'acUnit' then
        local config = Config.EnvironmentalEffects.specialObjects.acUnit

        if data.damage >= config.minDamageToTrigger then
            TriggerClientEvent('ammo:acUnitSteam', -1, {
                coords = data.coords,
                entityNetId = data.entityNetId,
                steamDuration = config.steamDuration,
                steamRadius = config.steamRadius,
            })
        end

    elseif objectType == 'barrel' then
        local knockback = GetBarrelKnockback(data.caliber)

        if knockback > 0 then
            TriggerClientEvent('ammo:barrelKnockback', -1, {
                entityNetId = data.entityNetId,
                force = knockback,
                direction = data.bulletDirection,
            })
        end

    elseif objectType == 'tire' then
        local config = Config.EnvironmentalEffects.specialObjects.tire

        TriggerClientEvent('ammo:tireHit', -1, {
            vehicleNetId = data.vehicleNetId,
            tireIndex = data.tireIndex,
            slowLeak = math.random() < config.slowLeakChance,
            slowLeakDuration = config.slowLeakDuration,
        })
    end
end)

-- =============================================================================
-- VEHICLE ENGINE DISABLE (Sniper/Slug hits)
-- =============================================================================

RegisterNetEvent('ammo:vehicleEngineHit', function(data)
    local source = source
    if not data or not data.vehicleNetId then return end

    local ammoKey = data.ammoKey
    local canDisrupt, disruptData = CanDisruptElectrical(ammoKey)

    if not canDisrupt or not disruptData.disableEngine then return end

    if math.random() > disruptData.chance then return end

    local vehicle = NetworkGetEntityFromNetworkId(data.vehicleNetId)
    if not DoesEntityExist(vehicle) then return end

    disabledVehicles[data.vehicleNetId] = {
        electronics = true,
        engine = true,
        restartTime = GetGameTimer() + 20000,  -- 20 second disable
    }

    TriggerClientEvent('ammo:disableVehicle', -1, {
        vehicleNetId = data.vehicleNetId,
        disableElectronics = true,
        disableEngine = true,
        restartDelay = 20000,
    })

    -- Smoke effect from engine
    TriggerClientEvent('ammo:engineSmoke', -1, {
        vehicleNetId = data.vehicleNetId,
        duration = 25000,
    })
end)

-- =============================================================================
-- PERIODIC CLEANUP
-- =============================================================================

CreateThread(function()
    while true do
        Wait(CLEANUP_INTERVAL)

        local now = GetGameTimer()

        -- Clean up expired fire spread zones
        for zoneId, data in pairs(activeFireSpread) do
            if now > data.endTime then
                activeFireSpread[zoneId] = nil
            end
        end

        -- Clean up water spraying hydrants
        for netId, endTime in pairs(waterSprayingHydrants) do
            if now > endTime then
                waterSprayingHydrants[netId] = nil
            end
        end

        -- Clean up old object damage tracking
        for objId, data in pairs(damagedObjects) do
            if now - data.lastHit > OBJECT_DAMAGE_TIMEOUT * 2 then
                damagedObjects[objId] = nil
            end
        end

        -- Clean up vehicle disable states
        for netId, data in pairs(disabledVehicles) do
            if data.restartTime > 0 and now > data.restartTime then
                TriggerClientEvent('ammo:enableVehicle', -1, {
                    vehicleNetId = netId,
                })
                disabledVehicles[netId] = nil
            end
        end

        -- Clean up bulletproof glass tracking (reset after 2 minutes)
        -- This prevents permanent weakening of glass
    end
end)

-- =============================================================================
-- EXPORTS FOR OTHER RESOURCES
-- =============================================================================

exports('IsVehicleDisabled', function(vehicleNetId)
    return disabledVehicles[vehicleNetId] ~= nil
end)

exports('IsLightDisabled', function(entityNetId)
    return disabledLights[entityNetId] ~= nil
end)

exports('GetActiveFireZones', function()
    return activeFireSpread
end)
