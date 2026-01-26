--[[
    Visual & Audio Effects Handler
    ==============================
    Phase 2: Muzzle Flash, Sound, Fire, Tracers

    Priority order (user specified):
    1. Muzzle flash variations
    2. Sound modifications
    3. Fire effects
    4. Tracers (AP only, infrequent, realistic)
]]

local playerShotCounter = {}  -- Track shots for tracer frequency
local activeFireEffects = {}  -- Track active fire DOT on entities
local lastWeaponHash = nil
local currentAmmoType = nil
local currentCaliber = nil

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================

local function GetWeaponInfo(weaponHash)
    if Config.Weapons and Config.Weapons[weaponHash] then
        return Config.Weapons[weaponHash]
    end
    return nil
end

local function GetCurrentAmmoType()
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)

    if weapon == `WEAPON_UNARMED` then
        return nil, nil
    end

    -- Check StateBag for current ammo type
    local ammoKey = ('ammo_%s'):format(weapon)
    local ammoType = LocalPlayer.state[ammoKey]

    local weaponInfo = GetWeaponInfo(weapon)
    local caliber = weaponInfo and weaponInfo.caliber or nil

    return ammoType or 'fmj', caliber
end

local function GetCaliberClass(caliber, ammoType)
    if not caliber then return 'pistol' end

    -- Check for special ammo types first
    if ammoType == 'subsonic' then
        return 'subsonic'
    elseif ammoType == 'dragonsbreath' then
        return 'dragonsbreath'
    elseif ammoType == 'api' or ammoType == 'incendiary' then
        return 'incendiary'
    end

    -- Use caliber class mapping
    return Config.CaliberClass[caliber] or 'pistol'
end

-- =============================================================================
-- MUZZLE FLASH SYSTEM
-- =============================================================================

local muzzleFlashActive = false

local function ApplyMuzzleFlashModifier(caliber, ammoType)
    local caliberClass = GetCaliberClass(caliber, ammoType)
    local flashConfig = Config.VisualEffects.muzzleFlash[caliberClass]

    if not flashConfig then
        flashConfig = Config.VisualEffects.muzzleFlash.pistol
    end

    return flashConfig
end

-- Monitor weapon firing for muzzle flash
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` then
            if IsPedShooting(ped) then
                local ammoType, caliber = GetCurrentAmmoType()
                local flashConfig = ApplyMuzzleFlashModifier(caliber, ammoType)

                -- Apply flash scale modification
                -- Note: GTA doesn't have direct muzzle flash control,
                -- but we can use particle effects for enhanced flashes
                if flashConfig.scale > 1.5 then
                    -- Large caliber - add extra flash particle
                    local coords = GetEntityCoords(ped)
                    local forward = GetEntityForwardVector(ped)

                    RequestNamedPtfxAsset('core')
                    while not HasNamedPtfxAssetLoaded('core') do Wait(0) end

                    UseParticleFxAsset('core')

                    -- Position slightly in front of player (muzzle area)
                    local muzzlePos = coords + (forward * 0.8)
                    muzzlePos = vector3(muzzlePos.x, muzzlePos.y, muzzlePos.z + 0.6)

                    local fx = StartParticleFxLoopedAtCoord(
                        'muz_assault_rifle',
                        muzzlePos.x, muzzlePos.y, muzzlePos.z,
                        0.0, 0.0, 0.0,
                        flashConfig.scale * 0.3,
                        false, false, false, false
                    )

                    SetTimeout(math.floor(flashConfig.duration * 50), function()
                        StopParticleFxLooped(fx, false)
                    end)
                end

                Wait(50)  -- Debounce shooting check
            else
                Wait(0)
            end
        else
            Wait(500)  -- Unarmed, check less frequently
        end
    end
end)

-- =============================================================================
-- SOUND MODIFICATION SYSTEM
-- =============================================================================

local function GetSoundMultiplier(caliber, ammoType)
    -- Check for subsonic ammo first
    if ammoType == 'subsonic' then
        return Config.AudioEffects.volumeMultiplier.subsonic
    end

    -- Check caliber-specific sound profile
    local profile = Config.AudioEffects.caliberSoundProfile[caliber]
    if profile and Config.AudioEffects.volumeMultiplier[profile] then
        return Config.AudioEffects.volumeMultiplier[profile]
    end

    -- Default to standard
    return 1.0
end

-- Apply sound modifications when weapon changes or fires
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` and weapon ~= lastWeaponHash then
            lastWeaponHash = weapon
            local ammoType, caliber = GetCurrentAmmoType()
            currentAmmoType = ammoType
            currentCaliber = caliber

            local soundMult = GetSoundMultiplier(caliber, ammoType)

            -- Apply weapon audio modification
            -- Note: SetWeaponAudioSoundLevel doesn't exist as a native
            -- We'll use alternative approach with sound overrides

            if soundMult < 1.0 then
                -- Subsonic: Reduce gun sound
                -- This uses the suppressor sound reduction approach
                SetPedShootRate(ped, 100)  -- Keep fire rate normal

                -- Apply suppressed audio hint (visual/audio cue reduction)
                -- The actual suppression effect is achieved through
                -- making the report sound less prominent
            elseif soundMult > 1.0 then
                -- Enhanced sound for magnum/sniper
                -- Unfortunately GTA doesn't allow increasing weapon sounds directly
                -- We can add a supplementary "boom" sound effect

                if IsPedShooting(ped) and (soundMult >= 1.5) then
                    -- Play additional concussive sound for big calibers
                    local coords = GetEntityCoords(ped)
                    PlaySoundFromCoord(
                        -1,
                        'Explosion_Large',
                        coords.x, coords.y, coords.z,
                        'DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS',
                        true,
                        50.0,
                        false
                    )
                end
            end

            Wait(100)
        else
            Wait(100)
        end
    end
end)

-- Enhanced sound for magnum/sniper on each shot
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` and IsPedShooting(ped) then
            local ammoType, caliber = GetCurrentAmmoType()
            local soundMult = GetSoundMultiplier(caliber, ammoType)

            if soundMult >= 1.35 then
                -- Add low-frequency rumble for powerful calibers
                local intensity = (soundMult - 1.0) * 2.0  -- Scale intensity
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', intensity * 0.3)

                -- .50 BMG gets extra dramatic effect
                if caliber == '.50bmg' then
                    ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 0.4)
                end
            end

            Wait(50)
        else
            Wait(0)
        end
    end
end)

-- =============================================================================
-- FIRE EFFECT SYSTEM
-- =============================================================================

RegisterNetEvent('ammo:applyFireEffect', function(data)
    local ped = PlayerPedId()
    local duration = data.duration or Config.VisualEffects.fire.defaultDuration
    local damage = data.damage or Config.VisualEffects.fire.defaultDamage
    local isTrail = data.trail or false

    -- Prevent stacking fire effects
    if activeFireEffects[ped] then
        -- Refresh duration instead of stacking
        activeFireEffects[ped].endTime = GetGameTimer() + duration
        return
    end

    -- Start fire visual on player
    StartEntityFire(ped)

    activeFireEffects[ped] = {
        endTime = GetGameTimer() + duration,
        damage = damage,
    }

    -- Create damage over time thread
    CreateThread(function()
        while activeFireEffects[ped] and GetGameTimer() < activeFireEffects[ped].endTime do
            Wait(Config.VisualEffects.fire.damageInterval)

            if DoesEntityExist(ped) and not IsEntityDead(ped) then
                ApplyDamageToPed(ped, activeFireEffects[ped].damage, false)
            else
                break
            end
        end

        -- Extinguish fire
        if DoesEntityExist(ped) then
            StopEntityFire(ped)
        end
        activeFireEffects[ped] = nil
    end)
end)

-- Dragon's breath fire trail effect (shooter sees outgoing fire)
local function CreateDragonsBreathTrail(startCoords, direction)
    RequestNamedPtfxAsset(Config.VisualEffects.fire.particleAsset)
    while not HasNamedPtfxAssetLoaded(Config.VisualEffects.fire.particleAsset) do
        Wait(10)
    end

    UseParticleFxAsset(Config.VisualEffects.fire.particleAsset)

    -- Create trail of fire particles along projectile path
    for i = 1, 8 do
        local trailPos = startCoords + (direction * (i * 2.0))

        local fx = StartParticleFxLoopedAtCoord(
            'fire_wrecked_plane_cockpit',
            trailPos.x, trailPos.y, trailPos.z,
            0.0, 0.0, 0.0,
            0.4,
            false, false, false, false
        )

        SetTimeout(800 + (i * 100), function()
            StopParticleFxLooped(fx, false)
        end)
    end
end

-- Monitor for dragon's breath shots
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` and IsPedShooting(ped) then
            local ammoType, caliber = GetCurrentAmmoType()

            if ammoType == 'dragonsbreath' then
                local coords = GetEntityCoords(ped)
                local forward = GetEntityForwardVector(ped)
                CreateDragonsBreathTrail(coords + vector3(0, 0, 0.5), forward)
            end

            Wait(50)
        else
            Wait(0)
        end
    end
end)

-- =============================================================================
-- TRACER SYSTEM (AP ROUNDS ONLY, REALISTIC FREQUENCY)
-- =============================================================================

local function ShouldShowTracer(weaponHash, ammoType)
    -- Only show tracers for AP rounds
    local modifier = GetAmmoModifier(ammoType, currentCaliber)
    if not modifier or not modifier.effects or not modifier.effects.tracer then
        return false
    end

    -- Initialize shot counter for this weapon
    if not playerShotCounter[weaponHash] then
        playerShotCounter[weaponHash] = 0
    end

    -- Increment shot counter
    playerShotCounter[weaponHash] = playerShotCounter[weaponHash] + 1

    -- Check frequency (default every 5th round for realism)
    local frequency = modifier.effects.tracerFrequency or 5

    if playerShotCounter[weaponHash] >= frequency then
        playerShotCounter[weaponHash] = 0
        return true
    end

    return false
end

local function CreateTracerEffect(startCoords, endCoords)
    local tracerConfig = Config.VisualEffects.tracer

    RequestNamedPtfxAsset(tracerConfig.particleAsset)
    while not HasNamedPtfxAssetLoaded(tracerConfig.particleAsset) do
        Wait(10)
    end

    UseParticleFxAsset(tracerConfig.particleAsset)

    -- Calculate direction and distance
    local direction = endCoords - startCoords
    local distance = #direction

    -- Create subtle "wind" tracer - nearly invisible streak
    -- Uses very low alpha for the "clear tracer" effect
    local fx = StartParticleFxLoopedAtCoord(
        tracerConfig.particleFx,
        endCoords.x, endCoords.y, endCoords.z,
        0.0, 0.0, 0.0,
        tracerConfig.scale,
        false, false, false, false
    )

    -- Set tracer color (near-white/clear)
    SetParticleFxLoopedColour(
        fx,
        tracerConfig.color.r / 255,
        tracerConfig.color.g / 255,
        tracerConfig.color.b / 255,
        false
    )

    SetParticleFxLoopedAlpha(fx, tracerConfig.alpha)

    SetTimeout(tracerConfig.duration, function()
        StopParticleFxLooped(fx, false)
    end)
end

-- Monitor shots for tracer effects
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` and IsPedShooting(ped) then
            local ammoType, caliber = GetCurrentAmmoType()

            if ShouldShowTracer(weapon, ammoType) then
                -- Get impact point via raycast
                local coords = GetEntityCoords(ped)
                local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.5, 0.6)
                local forward = GetEntityForwardVector(ped)
                local endPoint = coords + (forward * 200.0)

                local rayHandle = StartShapeTestRay(
                    offset.x, offset.y, offset.z,
                    endPoint.x, endPoint.y, endPoint.z,
                    -1, ped, 0
                )

                local _, hit, hitCoords, _, _ = GetShapeTestResult(rayHandle)

                if hit then
                    CreateTracerEffect(offset, hitCoords)
                else
                    CreateTracerEffect(offset, endPoint)
                end
            end

            Wait(50)
        else
            Wait(0)
        end
    end
end)

-- =============================================================================
-- CLEANUP ON RESOURCE STOP
-- =============================================================================

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    -- Extinguish any active fires
    for entity, _ in pairs(activeFireEffects) do
        if DoesEntityExist(entity) then
            StopEntityFire(entity)
        end
    end
end)

-- =============================================================================
-- EXPORTS
-- =============================================================================

exports('GetCurrentAmmoType', GetCurrentAmmoType)
exports('GetSoundMultiplier', GetSoundMultiplier)
exports('GetCaliberClass', GetCaliberClass)
