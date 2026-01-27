--[[
    Client-Side Environmental Interactions
    =======================================

    Handles detection and rendering of environmental effects:
    - Bullet impact detection and target identification
    - Visual/audio effects rendering
    - Physics interactions (knockback, debris)
    - Local state management
]]

-- =============================================================================
-- LOCAL STATE
-- =============================================================================

local disabledLights = {}           -- [entityNetId] = true
local slipperyZones = {}            -- { center = vec3, radius = n, endTime = timestamp }
local activeFireZones = {}          -- { center = vec3, radius = n, endTime = timestamp }
local disabledVehicles = {}         -- [vehicleNetId] = { electronics, engine, restartTime }
local bulletproofGlassState = {}    -- [glassId] = hitCount

-- Particle assets
local particleAssets = {
    'core',
    'scr_apartment_mp',
    'scr_trevor1',
    'scr_carsteal4',
    'scr_powerplay',
}

-- =============================================================================
-- PARTICLE ASSET LOADING
-- =============================================================================

local function LoadParticleAsset(asset)
    if not HasNamedPtfxAssetLoaded(asset) then
        RequestNamedPtfxAsset(asset)
        local timeout = 0
        while not HasNamedPtfxAssetLoaded(asset) and timeout < 1000 do
            Wait(10)
            timeout = timeout + 10
        end
    end
    return HasNamedPtfxAssetLoaded(asset)
end

-- Preload common particle assets
CreateThread(function()
    for _, asset in ipairs(particleAssets) do
        LoadParticleAsset(asset)
    end
end)

-- =============================================================================
-- BULLET IMPACT DETECTION
-- =============================================================================

-- Model hash lookup tables (built once)
local fuelTargetModels = {}
local electricalTargetModels = {}
local waterTargetModels = {}
local specialObjectModels = {}
local destructibleModels = {}

-- Build lookup tables from config
CreateThread(function()
    -- Wait for config to load
    while not Config or not Config.EnvironmentalEffects do
        Wait(100)
    end

    -- Fuel targets
    for targetType, data in pairs(Config.EnvironmentalEffects.fuel.targets) do
        if data.models then
            for _, model in ipairs(data.models) do
                fuelTargetModels[GetHashKey(model)] = targetType
            end
        end
    end

    -- Electrical targets
    for targetType, data in pairs(Config.EnvironmentalEffects.electrical.targets) do
        if data.models then
            for _, model in ipairs(data.models) do
                electricalTargetModels[GetHashKey(model)] = targetType
            end
        end
    end

    -- Water targets
    if Config.EnvironmentalEffects.water.fireHydrant then
        for _, model in ipairs(Config.EnvironmentalEffects.water.fireHydrant.models) do
            waterTargetModels[GetHashKey(model)] = 'fireHydrant'
        end
    end
    if Config.EnvironmentalEffects.water.waterTower then
        for _, model in ipairs(Config.EnvironmentalEffects.water.waterTower.models) do
            waterTargetModels[GetHashKey(model)] = 'waterTower'
        end
    end

    -- Special objects
    for objectType, data in pairs(Config.EnvironmentalEffects.specialObjects) do
        if type(data) == 'table' and data.models then
            for _, model in ipairs(data.models) do
                specialObjectModels[GetHashKey(model)] = objectType
            end
        end
    end

    -- Destructibles
    for coverType, data in pairs(Config.EnvironmentalEffects.coverDestruction.destructibles) do
        if data.models then
            for _, model in ipairs(data.models) do
                destructibleModels[GetHashKey(model)] = coverType
            end
        end
    end
end)

-- =============================================================================
-- WEAPON FIRE DETECTION
-- =============================================================================

local lastShotTime = 0
local SHOT_COOLDOWN = 50  -- Minimum ms between shot detections

CreateThread(function()
    while true do
        local ped = PlayerPedId()

        if IsPedShooting(ped) then
            local now = GetGameTimer()
            if now - lastShotTime >= SHOT_COOLDOWN then
                lastShotTime = now

                local weapon = GetSelectedPedWeapon(ped)
                if weapon ~= `WEAPON_UNARMED` then
                    ProcessBulletImpact(ped, weapon)
                end
            end
        end

        Wait(0)
    end
end)

-- Process bullet impact and detect environmental interactions
function ProcessBulletImpact(ped, weapon)
    local pedCoords = GetEntityCoords(ped)
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)

    -- Calculate bullet direction
    local direction = RotationToDirection(camRot)
    local endCoords = camCoords + direction * 500.0

    -- Perform raycast
    local ray = StartExpensiveSynchronousShapeTestLosProbe(
        camCoords.x, camCoords.y, camCoords.z,
        endCoords.x, endCoords.y, endCoords.z,
        -1, ped, 7
    )

    local _, hit, hitCoords, surfaceNormal, materialHash, hitEntity = GetShapeTestResultIncludingMaterial(ray)

    if not hit then return end

    -- Get ammo info from player state
    local ammoType = LocalPlayer.state.currentAmmoType or 'fmj'
    local caliber = LocalPlayer.state.currentCaliber or '9mm'
    local ammoKey = GetAmmoKey(caliber, ammoType)

    -- Check what was hit
    if hitEntity and hitEntity ~= 0 then
        local entityType = GetEntityType(hitEntity)
        local modelHash = GetEntityModel(hitEntity)
        local entityNetId = NetworkGetNetworkIdFromEntity(hitEntity)

        -- Check fuel targets
        local fuelTarget = fuelTargetModels[modelHash]
        if fuelTarget then
            TriggerServerEvent('ammo:fuelInteraction', {
                coords = hitCoords,
                targetType = fuelTarget,
                ammoKey = ammoKey,
                entityNetId = entityNetId,
            })
        end

        -- Check electrical targets
        local electricalTarget = electricalTargetModels[modelHash]
        if electricalTarget then
            TriggerServerEvent('ammo:electricalInteraction', {
                coords = hitCoords,
                targetType = electricalTarget,
                ammoKey = ammoKey,
                entityNetId = entityNetId,
            })
        end

        -- Check water targets
        local waterTarget = waterTargetModels[modelHash]
        if waterTarget then
            TriggerServerEvent('ammo:waterInteraction', {
                coords = hitCoords,
                targetType = waterTarget,
                caliber = caliber,
                entityNetId = entityNetId,
            })
        end

        -- Check special objects
        local specialObject = specialObjectModels[modelHash]
        if specialObject then
            TriggerServerEvent('ammo:specialObjectHit', {
                coords = hitCoords,
                objectType = specialObject,
                caliber = caliber,
                ammoKey = ammoKey,
                entityNetId = entityNetId,
                bulletDirection = direction,
                damage = GetWeaponDamage(weapon, 0),
            })
        end

        -- Check destructibles
        local destructible = destructibleModels[modelHash]
        if destructible then
            TriggerServerEvent('ammo:coverHit', {
                coords = hitCoords,
                coverType = destructible,
                entityNetId = entityNetId,
            })
        end

        -- Vehicle-specific checks
        if entityType == 2 then  -- Vehicle
            local vehicleNetId = NetworkGetNetworkIdFromEntity(hitEntity)

            -- Check if hit fuel tank area (rear of vehicle)
            local vehCoords = GetEntityCoords(hitEntity)
            local vehForward = GetEntityForwardVector(hitEntity)
            local hitOffset = hitCoords - vehCoords
            local dotProduct = hitOffset.x * vehForward.x + hitOffset.y * vehForward.y

            if dotProduct < -1.5 then  -- Hit rear
                TriggerServerEvent('ammo:vehicleFuelHit', {
                    vehicleNetId = vehicleNetId,
                    ammoKey = ammoKey,
                })
            end

            -- Check if hit engine area (front of vehicle)
            if dotProduct > 2.0 then  -- Hit front
                TriggerServerEvent('ammo:vehicleEngineHit', {
                    vehicleNetId = vehicleNetId,
                    ammoKey = ammoKey,
                })
            end

            -- Check if hit battery area (under hood, near engine)
            if dotProduct > 1.5 and math.abs(hitOffset.z - vehCoords.z) < 0.5 then
                TriggerServerEvent('ammo:electricalInteraction', {
                    coords = hitCoords,
                    targetType = 'vehicleBattery',
                    ammoKey = ammoKey,
                    vehicleNetId = vehicleNetId,
                })
            end

            -- Check tire hits
            for i = 0, 7 do
                local boneIndex = GetEntityBoneIndexByName(hitEntity, 'wheel_' .. ({'lf', 'rf', 'lm', 'rm', 'lr', 'rr', 'lm1', 'rm1'})[i+1])
                if boneIndex ~= -1 then
                    local bonePos = GetWorldPositionOfEntityBone(hitEntity, boneIndex)
                    if #(hitCoords - bonePos) < 0.5 then
                        TriggerServerEvent('ammo:specialObjectHit', {
                            objectType = 'tire',
                            vehicleNetId = vehicleNetId,
                            tireIndex = i,
                        })
                        break
                    end
                end
            end
        end
    end

    -- Check surface material for ricochet and fire spread
    CheckSurfaceInteractions(hitCoords, surfaceNormal, materialHash, ammoType, ammoKey, direction)
end

-- Check surface-based interactions
function CheckSurfaceInteractions(hitCoords, surfaceNormal, materialHash, ammoType, ammoKey, bulletDirection)
    -- Ricochet check
    if Config.EnvironmentalEffects.ricochet.enabled then
        local bulletAngle = CalculateBulletAngle(bulletDirection, surfaceNormal)

        local shouldRicochet, reflectedAngle, damageRetention = CalculateRicochet(materialHash, bulletAngle, ammoType)

        if shouldRicochet then
            -- Calculate ricochet direction
            local reflectedDir = ReflectVector(bulletDirection, surfaceNormal)

            -- Spawn ricochet effects
            SpawnRicochetEffects(hitCoords, reflectedDir, materialHash)

            -- Check for ricochet target
            CheckRicochetTarget(hitCoords, reflectedDir, damageRetention)
        end
    end

    -- Fire spread check (incendiary rounds on flammable surfaces)
    if Config.EnvironmentalEffects.fireSpread.enabled then
        local surfaceType = GetFlammableSurfaceType(materialHash)
        if surfaceType and Config.EnvironmentalEffects.fireSpread.incendiaryAmmo[ammoKey] then
            TriggerServerEvent('ammo:igniteFlammable', {
                coords = hitCoords,
                surfaceType = surfaceType,
                ammoKey = ammoKey,
            })
        end
    end
end

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

function RotationToDirection(rotation)
    local z = math.rad(rotation.z)
    local x = math.rad(rotation.x)
    local num = math.abs(math.cos(x))
    return vector3(
        -math.sin(z) * num,
        math.cos(z) * num,
        math.sin(x)
    )
end

function GetAmmoKey(caliber, ammoType)
    local caliberMap = Config.CaliberAmmoMap[caliber]
    if caliberMap and caliberMap[ammoType] then
        return caliberMap[ammoType]
    end
    return caliber .. '_' .. ammoType
end

function CalculateBulletAngle(bulletDir, surfaceNormal)
    local dot = bulletDir.x * surfaceNormal.x + bulletDir.y * surfaceNormal.y + bulletDir.z * surfaceNormal.z
    return math.deg(math.acos(math.abs(dot)))
end

function ReflectVector(incident, normal)
    local dot = incident.x * normal.x + incident.y * normal.y + incident.z * normal.z
    return vector3(
        incident.x - 2 * dot * normal.x,
        incident.y - 2 * dot * normal.y,
        incident.z - 2 * dot * normal.z
    )
end

function GetFlammableSurfaceType(materialHash)
    for surfaceType, data in pairs(Config.EnvironmentalEffects.fireSpread.flammableSurfaces) do
        if data.materialHashes then
            for _, hash in ipairs(data.materialHashes) do
                if hash == materialHash then
                    return surfaceType
                end
            end
        end
    end
    return nil
end

-- =============================================================================
-- EFFECT HANDLERS - EXPLOSIONS
-- =============================================================================

RegisterNetEvent('ammo:createExplosion', function(data)
    if not data or not data.coords then return end

    local explosionType = GetExplosionTypeHash(data.explosionType)

    AddExplosion(
        data.coords.x, data.coords.y, data.coords.z,
        explosionType,
        data.radius or 5.0,
        data.isAudible ~= false,
        data.isInvisible == true,
        data.cameraShake and 1.0 or 0.0
    )
end)

function GetExplosionTypeHash(typeName)
    local explosionTypes = {
        ['EXPLOSION_PETROL_PUMP'] = 16,
        ['EXPLOSION_PROPANE'] = 17,
        ['EXPLOSION_MOLOTOV'] = 9,
        ['EXPLOSION_CAR'] = 7,
        ['EXPLOSION_TANKER'] = 10,
        ['EXPLOSION_GAS_CANISTER'] = 14,
    }
    return explosionTypes[typeName] or 2
end

-- =============================================================================
-- EFFECT HANDLERS - ELECTRICAL
-- =============================================================================

RegisterNetEvent('ammo:electricalSparks', function(data)
    if not data or not data.coords then return end

    if LoadParticleAsset('core') then
        UseParticleFxAssetNextCall('core')
        local particle = StartParticleFxLoopedAtCoord(
            'sp_intleak_spark',
            data.coords.x, data.coords.y, data.coords.z,
            0.0, 0.0, 0.0,
            data.small and 0.5 or 1.0,
            false, false, false, false
        )

        SetTimeout(data.duration or 3000, function()
            StopParticleFxLooped(particle, false)
        end)
    end

    -- Spark sound
    PlaySoundFromCoord(-1, 'Spark', data.coords.x, data.coords.y, data.coords.z, 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', false, 50.0, false)
end)

RegisterNetEvent('ammo:areaBlackout', function(data)
    if not data or not data.coords then return end

    local playerCoords = GetEntityCoords(PlayerPedId())
    if #(playerCoords - vector3(data.coords.x, data.coords.y, data.coords.z)) > data.radius then
        return
    end

    -- Darken screen briefly for local effect
    SetTimecycleModifier('NG_filmnoir_BW01')
    SetTimecycleModifierStrength(0.3)

    SetTimeout(data.duration or 30000, function()
        ClearTimecycleModifier()
    end)
end)

RegisterNetEvent('ammo:disableLight', function(data)
    if not data or not data.entityNetId then return end

    local entity = NetworkGetEntityFromNetworkId(data.entityNetId)
    if DoesEntityExist(entity) then
        SetEntityLights(entity, true)  -- Disable lights
        disabledLights[data.entityNetId] = true
    end
end)

-- =============================================================================
-- EFFECT HANDLERS - VEHICLES
-- =============================================================================

RegisterNetEvent('ammo:vehicleCatchFire', function(data)
    if not data or not data.vehicleNetId then return end

    local vehicle = NetworkGetEntityFromNetworkId(data.vehicleNetId)
    if not DoesEntityExist(vehicle) then return end

    -- Start engine fire
    local engineBone = GetEntityBoneIndexByName(vehicle, 'engine')
    local enginePos = GetWorldPositionOfEntityBone(vehicle, engineBone)

    if LoadParticleAsset('core') then
        UseParticleFxAssetNextCall('core')
        local fireParticle = StartParticleFxLoopedAtCoord(
            'fire_object_md',
            enginePos.x, enginePos.y, enginePos.z,
            0.0, 0.0, 0.0,
            1.5,
            false, false, false, false
        )

        -- Explode after delay
        SetTimeout(data.explosionDelay or 5000, function()
            StopParticleFxLooped(fireParticle, false)
            if DoesEntityExist(vehicle) then
                local coords = GetEntityCoords(vehicle)
                AddExplosion(coords.x, coords.y, coords.z, 7, 5.0, true, false, 1.0)
            end
        end)
    end
end)

RegisterNetEvent('ammo:disableVehicle', function(data)
    if not data or not data.vehicleNetId then return end

    local vehicle = NetworkGetEntityFromNetworkId(data.vehicleNetId)
    if not DoesEntityExist(vehicle) then return end

    disabledVehicles[data.vehicleNetId] = {
        electronics = data.disableElectronics,
        engine = data.disableEngine,
        restartTime = GetGameTimer() + (data.restartDelay or 15000),
    }

    -- Disable engine
    if data.disableEngine then
        SetVehicleEngineOn(vehicle, false, true, true)
        SetVehicleUndriveable(vehicle, true)
    end

    -- Disable electronics (lights, radio)
    if data.disableElectronics then
        SetVehicleLights(vehicle, 1)  -- Force off
        SetVehicleRadioEnabled(vehicle, false)
    end
end)

RegisterNetEvent('ammo:enableVehicle', function(data)
    if not data or not data.vehicleNetId then return end

    local vehicle = NetworkGetEntityFromNetworkId(data.vehicleNetId)
    if DoesEntityExist(vehicle) then
        SetVehicleUndriveable(vehicle, false)
        SetVehicleLights(vehicle, 0)  -- Auto
        SetVehicleRadioEnabled(vehicle, true)
    end

    disabledVehicles[data.vehicleNetId] = nil
end)

RegisterNetEvent('ammo:engineSmoke', function(data)
    if not data or not data.vehicleNetId then return end

    local vehicle = NetworkGetEntityFromNetworkId(data.vehicleNetId)
    if not DoesEntityExist(vehicle) then return end

    local engineBone = GetEntityBoneIndexByName(vehicle, 'engine')

    if LoadParticleAsset('core') then
        UseParticleFxAssetNextCall('core')
        local smokeParticle = StartParticleFxLoopedOnEntityBone(
            'ent_ray_heli_damage_fire',
            vehicle,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            engineBone,
            0.8,
            false, false, false
        )

        SetTimeout(data.duration or 25000, function()
            StopParticleFxLooped(smokeParticle, false)
        end)
    end
end)

-- =============================================================================
-- EFFECT HANDLERS - WATER
-- =============================================================================

RegisterNetEvent('ammo:fireHydrantBurst', function(data)
    if not data or not data.coords then return end

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    -- Water spray particle
    if LoadParticleAsset('core') then
        UseParticleFxAssetNextCall('core')
        local waterParticle = StartParticleFxLoopedAtCoord(
            'water_cannon_jet',
            coords.x, coords.y, coords.z + 0.5,
            -90.0, 0.0, 0.0,
            3.0,
            false, false, false, false
        )

        -- Add slippery zone
        table.insert(slipperyZones, {
            center = coords,
            radius = data.slipperyRadius or 5.0,
            endTime = GetGameTimer() + (data.slipperyDuration or 45000),
        })

        SetTimeout(data.sprayDuration or 60000, function()
            StopParticleFxLooped(waterParticle, false)
        end)
    end

    -- Water burst sound
    PlaySoundFromCoord(-1, 'Burst', coords.x, coords.y, coords.z, 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 100.0, false)
end)

RegisterNetEvent('ammo:waterTowerLeak', function(data)
    if not data or not data.coords then return end

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    if LoadParticleAsset('core') then
        UseParticleFxAssetNextCall('core')
        StartParticleFxLoopedAtCoord(
            'water_cannon_jet',
            coords.x, coords.y, coords.z - 2.0,
            0.0, 0.0, 0.0,
            1.5,
            false, false, false, false
        )
    end
end)

RegisterNetEvent('ammo:waterTowerCollapse', function(data)
    if not data or not data.coords then return end

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    -- Major water splash
    if LoadParticleAsset('scr_apartment_mp') then
        UseParticleFxAssetNextCall('scr_apartment_mp')
        StartParticleFxNonLoopedAtCoord(
            'scr_apa_yacht_splash',
            coords.x, coords.y, coords.z - 5.0,
            0.0, 0.0, 0.0,
            10.0,
            false, false, false
        )
    end

    -- Destruction sound
    PlaySoundFromCoord(-1, 'Crash', coords.x, coords.y, coords.z, 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 200.0, false)
end)

-- =============================================================================
-- EFFECT HANDLERS - FIRE SPREAD
-- =============================================================================

RegisterNetEvent('ammo:startFireSpread', function(data)
    if not data or not data.coords then return end

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    table.insert(activeFireZones, {
        center = coords,
        radius = data.radius or 5.0,
        endTime = GetGameTimer() + (data.duration or 10000),
    })

    -- Initial fire particles
    if LoadParticleAsset('core') then
        UseParticleFxAssetNextCall('core')
        StartParticleFxLoopedAtCoord(
            'fire_object_md',
            coords.x, coords.y, coords.z,
            0.0, 0.0, 0.0,
            data.radius / 5.0,
            false, false, false, false
        )
    end
end)

RegisterNetEvent('ammo:spreadingFire', function(data)
    if not data or not data.coords then return end

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    -- Start small, grow over time
    local currentRadius = 0.5
    local maxRadius = data.maxRadius or 8.0
    local spreadRate = data.spreadRate or 1.0

    CreateThread(function()
        local startTime = GetGameTimer()
        local endTime = startTime + (data.duration or 20000)
        local particles = {}

        while GetGameTimer() < endTime do
            currentRadius = math.min(maxRadius, currentRadius + (spreadRate * 0.1))

            -- Spawn fire at random points within radius
            if #particles < 10 then
                local angle = math.random() * 2 * math.pi
                local dist = math.random() * currentRadius
                local firePos = vector3(
                    coords.x + math.cos(angle) * dist,
                    coords.y + math.sin(angle) * dist,
                    coords.z
                )

                if LoadParticleAsset('core') then
                    UseParticleFxAssetNextCall('core')
                    local p = StartParticleFxLoopedAtCoord(
                        'fire_object_md',
                        firePos.x, firePos.y, firePos.z,
                        0.0, 0.0, 0.0,
                        0.8,
                        false, false, false, false
                    )
                    table.insert(particles, p)
                end
            end

            -- Random explosion chance
            if data.explosionChance and math.random() < data.explosionChance * 0.01 then
                local angle = math.random() * 2 * math.pi
                local dist = math.random() * currentRadius
                AddExplosion(
                    coords.x + math.cos(angle) * dist,
                    coords.y + math.sin(angle) * dist,
                    coords.z,
                    9, 1.0, true, false, 0.2
                )
            end

            Wait(1000)
        end

        -- Cleanup particles
        for _, p in ipairs(particles) do
            StopParticleFxLooped(p, false)
        end
    end)
end)

-- =============================================================================
-- EFFECT HANDLERS - RICOCHET
-- =============================================================================

function SpawnRicochetEffects(hitCoords, reflectedDir, materialHash)
    -- Spark effect for metal
    local isMetal = false
    for _, hash in ipairs(Config.EnvironmentalEffects.ricochet.surfaces.metal.materialHashes or {}) do
        if hash == materialHash then
            isMetal = true
            break
        end
    end

    if isMetal then
        if LoadParticleAsset('core') then
            UseParticleFxAssetNextCall('core')
            StartParticleFxNonLoopedAtCoord(
                'sp_intleak_spark',
                hitCoords.x, hitCoords.y, hitCoords.z,
                reflectedDir.x * 90, reflectedDir.y * 90, reflectedDir.z * 90,
                0.5,
                false, false, false
            )
        end
    else
        -- Dust/debris for concrete
        if LoadParticleAsset('core') then
            UseParticleFxAssetNextCall('core')
            StartParticleFxNonLoopedAtCoord(
                'ent_dst_concrete_large',
                hitCoords.x, hitCoords.y, hitCoords.z,
                0.0, 0.0, 0.0,
                0.3,
                false, false, false
            )
        end
    end

    -- Ricochet sound
    PlaySoundFromCoord(-1, 'Ricochet', hitCoords.x, hitCoords.y, hitCoords.z, 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 30.0, false)
end

function CheckRicochetTarget(hitCoords, reflectedDir, damageRetention)
    -- Raycast in reflected direction
    local endCoords = hitCoords + reflectedDir * 30.0

    local ray = StartExpensiveSynchronousShapeTestLosProbe(
        hitCoords.x, hitCoords.y, hitCoords.z,
        endCoords.x, endCoords.y, endCoords.z,
        -1, PlayerPedId(), 7
    )

    local _, hit, ricochetHitCoords, _, _, hitEntity = GetShapeTestResultEx(ray)

    if hit and hitEntity and hitEntity ~= 0 then
        if IsEntityAPed(hitEntity) and not IsPedAPlayer(hitEntity) then
            -- Hit an NPC - apply ricochet damage locally
            -- (Server would validate player hits)
        elseif IsEntityAPed(hitEntity) and IsPedAPlayer(hitEntity) then
            local targetPlayer = NetworkGetPlayerIndexFromPed(hitEntity)
            if targetPlayer ~= PlayerId() then
                TriggerServerEvent('ammo:ricochetHit', {
                    targetServerId = GetPlayerServerId(targetPlayer),
                    hitCoords = ricochetHitCoords,
                    damageRetention = damageRetention,
                    originalDamage = 50,  -- Base estimate
                })
            end
        end
    end
end

-- =============================================================================
-- EFFECT HANDLERS - SPECIAL OBJECTS
-- =============================================================================

RegisterNetEvent('ammo:fireExtinguisherBurst', function(data)
    if not data or not data.coords then return end

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    if LoadParticleAsset('core') then
        UseParticleFxAssetNextCall('core')
        local particle = StartParticleFxLoopedAtCoord(
            'ent_sht_smoke',
            coords.x, coords.y, coords.z,
            0.0, 0.0, 0.0,
            2.0,
            false, false, false, false
        )

        SetTimeout(data.sprayDuration or 5000, function()
            StopParticleFxLooped(particle, false)
        end)
    end

    -- Hissing sound
    PlaySoundFromCoord(-1, 'Gas_Hissing', coords.x, coords.y, coords.z, 'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS', false, 30.0, false)

    -- Vision obscuring for nearby players
    if data.obscuresVision then
        local playerCoords = GetEntityCoords(PlayerPedId())
        if #(playerCoords - coords) < data.sprayRadius then
            SetTimecycleModifier('NG_filmic01')
            SetTimecycleModifierStrength(0.5)

            SetTimeout(data.sprayDuration or 5000, function()
                ClearTimecycleModifier()
            end)
        end
    end
end)

RegisterNetEvent('ammo:acUnitSteam', function(data)
    if not data or not data.coords then return end

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    if LoadParticleAsset('core') then
        UseParticleFxAssetNextCall('core')
        local particle = StartParticleFxLoopedAtCoord(
            'ent_amb_steam_sm',
            coords.x, coords.y, coords.z,
            0.0, 0.0, 0.0,
            2.0,
            false, false, false, false
        )

        SetTimeout(data.steamDuration or 8000, function()
            StopParticleFxLooped(particle, false)
        end)
    end

    -- Steam sound
    PlaySoundFromCoord(-1, 'Steam', coords.x, coords.y, coords.z, 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 20.0, false)
end)

RegisterNetEvent('ammo:barrelKnockback', function(data)
    if not data or not data.entityNetId then return end

    local entity = NetworkGetEntityFromNetworkId(data.entityNetId)
    if not DoesEntityExist(entity) then return end

    local force = data.force or 100
    local dir = data.direction or vector3(0, 0, 0)

    -- Apply physics force
    ApplyForceToEntity(
        entity,
        1,
        dir.x * force * 0.1,
        dir.y * force * 0.1,
        force * 0.05,
        0.0, 0.0, 0.0,
        0,
        false, true, true, false, true
    )
end)

RegisterNetEvent('ammo:tireHit', function(data)
    if not data or not data.vehicleNetId then return end

    local vehicle = NetworkGetEntityFromNetworkId(data.vehicleNetId)
    if not DoesEntityExist(vehicle) then return end

    -- Enhanced tire burst effect
    if data.slowLeak then
        -- Gradual deflation
        CreateThread(function()
            local startTime = GetGameTimer()
            local endTime = startTime + (data.slowLeakDuration or 30000)

            while GetGameTimer() < endTime do
                if not DoesEntityExist(vehicle) then break end

                -- Reduce tire health gradually
                local currentHealth = GetVehicleWheelHealth(vehicle, data.tireIndex)
                if currentHealth > 0 then
                    SetVehicleWheelHealth(vehicle, data.tireIndex, currentHealth - 50)
                else
                    break
                end

                Wait(2000)
            end

            -- Final burst
            if DoesEntityExist(vehicle) then
                SetVehicleTyreBurst(vehicle, data.tireIndex, true, 1000.0)
            end
        end)
    end
end)

-- =============================================================================
-- EFFECT HANDLERS - GLASS
-- =============================================================================

RegisterNetEvent('ammo:shatterGlass', function(data)
    if not data or not data.coords then return end

    -- Glass shatter is mostly handled by GTA natively
    -- We add enhanced sound effects

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    if data.fullShatter then
        PlaySoundFromCoord(-1, 'Glass_Shatter', coords.x, coords.y, coords.z, 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 30.0, false)
    end
end)

RegisterNetEvent('ammo:crackGlass', function(data)
    -- Bulletproof glass crack effect
    if not data or not data.coords then return end

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    -- Impact sound
    PlaySoundFromCoord(-1, 'Glass_Crack', coords.x, coords.y, coords.z, 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 20.0, false)
end)

RegisterNetEvent('ammo:breakBulletproofGlass', function(data)
    if not data or not data.coords then return end

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    -- Major shatter
    PlaySoundFromCoord(-1, 'Glass_Shatter_Large', coords.x, coords.y, coords.z, 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 50.0, false)

    -- Glass debris particle
    if LoadParticleAsset('core') then
        UseParticleFxAssetNextCall('core')
        StartParticleFxNonLoopedAtCoord(
            'scr_apa_yacht_splash',
            coords.x, coords.y, coords.z,
            0.0, 0.0, 0.0,
            0.5,
            false, false, false
        )
    end
end)

-- =============================================================================
-- EFFECT HANDLERS - COVER DESTRUCTION
-- =============================================================================

RegisterNetEvent('ammo:destroyCover', function(data)
    if not data or not data.entityNetId then return end

    local entity = NetworkGetEntityFromNetworkId(data.entityNetId)
    if not DoesEntityExist(entity) then return end

    local coords = GetEntityCoords(entity)

    -- Debris effect
    if data.debrisOnDestroy then
        if LoadParticleAsset('core') then
            UseParticleFxAssetNextCall('core')
            StartParticleFxNonLoopedAtCoord(
                'ent_dst_wood',
                coords.x, coords.y, coords.z,
                0.0, 0.0, 0.0,
                1.5,
                false, false, false
            )
        end
    end

    -- Destruction sound
    PlaySoundFromCoord(-1, 'Destruction', coords.x, coords.y, coords.z, 'DLC_HEISTS_GENERAL_FRONTEND_SOUNDS', false, 30.0, false)

    -- Delete or hide entity
    SetEntityAsMissionEntity(entity, true, true)
    DeleteEntity(entity)
end)

RegisterNetEvent('ammo:chipCover', function(data)
    if not data or not data.coords then return end

    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    -- Small debris
    if LoadParticleAsset('core') then
        UseParticleFxAssetNextCall('core')
        StartParticleFxNonLoopedAtCoord(
            'ent_dst_concrete_small',
            coords.x, coords.y, coords.z,
            0.0, 0.0, 0.0,
            0.3,
            false, false, false
        )
    end
end)

-- =============================================================================
-- SLIPPERY ZONE HANDLING
-- =============================================================================

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local now = GetGameTimer()

        -- Check if player is in slippery zone
        local inSlipperyZone = false
        for i = #slipperyZones, 1, -1 do
            local zone = slipperyZones[i]
            if now > zone.endTime then
                table.remove(slipperyZones, i)
            elseif #(coords - zone.center) < zone.radius then
                inSlipperyZone = true
            end
        end

        if inSlipperyZone and IsPedOnFoot(ped) then
            -- Apply slip effect when running
            if GetEntitySpeed(ped) > 3.0 then
                if math.random() < 0.02 then  -- 2% chance per frame when running
                    SetPedToRagdoll(ped, 1500, 2000, 0, false, false, false)
                end
            end
        end

        Wait(100)
    end
end)

-- =============================================================================
-- FIRE ZONE DAMAGE
-- =============================================================================

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local now = GetGameTimer()

        -- Check if player is in fire zone
        for i = #activeFireZones, 1, -1 do
            local zone = activeFireZones[i]
            if now > zone.endTime then
                table.remove(activeFireZones, i)
            elseif #(coords - zone.center) < zone.radius then
                -- Apply fire damage
                if not IsEntityOnFire(ped) then
                    StartEntityFire(ped)
                end
            end
        end

        Wait(500)
    end
end)
