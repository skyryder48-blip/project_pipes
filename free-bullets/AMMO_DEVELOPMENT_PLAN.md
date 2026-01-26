# Ammunition Type System - Development Plan

## Research Summary

### External FiveM Resources Reviewed

| Resource | Features | Implementation Approach |
|----------|----------|------------------------|
| [Big Bang Advanced Ammo](https://big-bang-scripts.tebex.io/package/6878489) | 6 ammo types (AP, HP, FMJ, Tracer, Incendiary, Blanks), 0.00ms idle | Server-synced metadata, damage multipliers per type |
| [snag_weapon_metas](https://github.com/CyCoSnag/snag_weapon_metas) | Runtime weapon meta editing | Direct native manipulation |
| [ox_inventory Weapon System](https://deepwiki.com/overextended/ox_inventory/3.4-weapon-system) | Metadata-based ammo, durability | Item metadata stores ammo type |
| [Qbox Custom Weapons Guide](https://docs.qbox.re/blog/install-custom-weapons) | Custom weapon + ammo integration | Component-based system |
| [WeaponDamageSettings](https://github.com/benzon/WeaponDamageSettings) | Per-weapon damage multipliers | weaponDamageEvent interception |

### Key Technical Approaches

1. **Server-Side Damage Interception** (Recommended)
   - Use `weaponDamageEvent` to modify damage based on loaded ammo type
   - Server authority prevents cheating
   - Supports armor penetration flags

2. **Client-Side Visual Effects**
   - Tracers via `TracerFx` particle effects
   - Incendiary via fire particle attachment
   - Dragon's breath via trail effects

3. **StateBag Synchronization**
   - Sync ammo type to other players for visual consistency
   - Rate limited (75 packets/sec default)

---

## Current System Analysis

### What EXISTS (Complete)

| Component | Location | Status |
|-----------|----------|--------|
| Ammo type definitions (18 calibers, 40+ types) | `shared/config.lua` | ✅ Complete |
| Weapon-to-caliber mapping (90+ weapons) | `shared/weapons.lua` | ✅ Complete |
| Magazine definitions (60+ magazines) | `shared/magazines.lua` | ✅ Complete |
| Ammo meta XML files (19 calibers) | `meta/ammo_*.meta` | ✅ Complete |
| Client component management | `client/cl_ammo.lua` | ✅ Complete |
| Magazine loading/equipping UI | `client/magazine_client.lua` | ✅ Complete |
| Server helper functions | `server/sv_ammo.lua` | ✅ Basic |
| ox_inventory item hooks | `inventory/*.lua` | ✅ Partial |

### What's MISSING (Critical)

| Component | Priority | Description |
|-----------|----------|-------------|
| **Damage Modifier System** | CRITICAL | `weaponDamageEvent` handler to apply ammo-specific damage |
| **Armor Penetration Logic** | CRITICAL | AP ammo bypasses armor, HP reduced vs armor |
| **Ammo Type State Sync** | HIGH | StateBag to track current ammo type per player/weapon |
| **Visual Effects - Tracers** | HIGH | Tracer rounds visible to all players |
| **Visual Effects - Incendiary** | HIGH | Fire effects on hit |
| **Less-Lethal Effects** | MEDIUM | Beanbag knockback, pepperball vision blur |
| **Explosive Rounds** | MEDIUM | .50 BMG BOOM vehicle damage |
| **Tranquilizer System** | MEDIUM | Incapacitation over time |
| **Subsonic Sound Reduction** | LOW | .300 BLK subsonic quieter |

---

## Damage Modifier Specifications

### Base Damage Formula
```
Final Damage = Base Weapon Damage × Ammo Multiplier × Armor Factor × Range Falloff
```

### Ammo Type Modifiers

| Ammo Type | Damage Mult | Armor Factor | Penetration | Special Effect |
|-----------|-------------|--------------|-------------|----------------|
| **FMJ** | 1.00 | 1.00 | 0.70-0.85 | None (baseline) |
| **HP/JHP** | 1.10-1.25 | 0.50 vs armor | 0.40-0.55 | +25% unarmored |
| **AP** | 0.90-0.95 | 1.50 vs armor | 0.85-0.96 | Ignores armor |
| **Match** | 1.03-1.05 | 1.00 | Base | +accuracy (meta) |
| **Tracer** | 1.00 | 1.00 | Base | Visual trail |
| **Incendiary** | 0.95 | 0.80 | 0.60 | Fire DOT |
| **Blanks** | 0.00 | N/A | N/A | No damage |
| **Subsonic** | 0.90 | 0.90 | 0.65 | Reduced sound |

### Caliber-Specific Modifiers (Shotgun)

| 12ga Load | Pellets | Dmg/Pellet | Max Damage | Special |
|-----------|---------|------------|------------|---------|
| 00 Buck | 8 | 22 | 176 | Standard |
| #1 Buck | 12 | 14 | 168 | HP behavior |
| Slug | 1 | 120 | 120 | Precision |
| Birdshot | 19 | 8 | 152 | Wide spread |
| Dragon's Breath | 8 | 15 | 120 | Fire trail |
| Beanbag | 1 | 8 | 8 | Ragdoll |
| Breach | 1 | 40 | 40 | Door damage |

---

## Implementation Architecture

### File Structure (Enhanced)
```
ammo_system_standalone/
├── fxmanifest.lua
├── shared/
│   ├── config.lua           # Ammo type definitions (EXISTS)
│   ├── weapons.lua          # Weapon mapping (EXISTS)
│   ├── magazines.lua        # Magazine defs (EXISTS)
│   └── modifiers.lua        # NEW: Damage/effect modifiers
├── server/
│   ├── sv_ammo.lua          # Helper functions (EXISTS)
│   ├── sv_damage.lua        # NEW: weaponDamageEvent handler
│   └── sv_state.lua         # NEW: Player ammo state management
├── client/
│   ├── cl_ammo.lua          # Component management (EXISTS)
│   ├── magazine_client.lua  # Magazine UI (EXISTS)
│   ├── cl_effects.lua       # NEW: Visual effects (tracer, fire)
│   ├── cl_lesslethal.lua    # NEW: Beanbag, pepperball, tranq
│   └── cl_sync.lua          # NEW: StateBag handlers
├── meta/
│   └── ammo_*.meta          # Ammo definitions (EXISTS)
└── inventory/
    └── *.lua                # ox_inventory hooks (EXISTS)
```

### Data Flow
```
┌─────────────────────────────────────────────────────────────────┐
│                          CLIENT                                  │
├─────────────────────────────────────────────────────────────────┤
│  ox_inventory:currentWeapon event                               │
│           ↓                                                      │
│  Check weapon metadata for ammoType                             │
│           ↓                                                      │
│  Update StateBag: Player(source).state.ammoType                 │
│           ↓                                                      │
│  Apply visual component (TracerFx if tracer)                    │
│           ↓                                                      │
│  cl_effects.lua handles particle effects                        │
└─────────────────────────────────────────────────────────────────┘
                              ↕ StateBag / Events
┌─────────────────────────────────────────────────────────────────┐
│                          SERVER                                  │
├─────────────────────────────────────────────────────────────────┤
│  weaponDamageEvent fires on any damage                          │
│           ↓                                                      │
│  sv_damage.lua: GetPlayerAmmoType(source, weaponHash)           │
│           ↓                                                      │
│  Apply damage modifier from Config.AmmoModifiers                │
│           ↓                                                      │
│  Check armor: If AP → bypass, If HP → reduce vs armor           │
│           ↓                                                      │
│  Return modified damage or CancelEvent() for blanks             │
│           ↓                                                      │
│  Trigger effects: Fire DOT, knockback, incapacitation           │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Core Damage System (Critical)

### 1.1 Create Damage Modifier Config

**File: `shared/modifiers.lua`**
```lua
Config.AmmoModifiers = {
    -- Universal modifiers (all calibers)
    ['fmj'] = {
        damageMult = 1.00,
        armorMult = 1.00,      -- Normal vs armor
        penetration = 0.75,
        effects = {},
    },
    ['hp'] = {
        damageMult = 1.15,     -- +15% unarmored
        armorMult = 0.50,      -- -50% vs armor
        penetration = 0.45,
        effects = {},
    },
    ['jhp'] = {
        damageMult = 1.20,     -- +20% unarmored
        armorMult = 0.45,      -- -55% vs armor
        penetration = 0.40,
        effects = {},
    },
    ['ap'] = {
        damageMult = 0.92,     -- -8% base
        armorMult = 1.80,      -- +80% vs armor (effective bypass)
        penetration = 0.92,
        armorBypass = true,    -- Flag for complete bypass
        effects = {},
    },
    ['match'] = {
        damageMult = 1.05,
        armorMult = 1.00,
        penetration = 0.75,
        effects = { accuracy = 0.90 },  -- 10% better accuracy
    },
    ['tracer'] = {
        damageMult = 1.00,
        armorMult = 1.00,
        penetration = 0.75,
        effects = { tracer = true },
    },
    ['incendiary'] = {
        damageMult = 0.95,
        armorMult = 0.80,
        penetration = 0.60,
        effects = { fire = true, fireDuration = 5000, fireDamage = 5 },
    },
    ['blanks'] = {
        damageMult = 0.00,
        armorMult = 0.00,
        penetration = 0.00,
        effects = { noDamage = true },
    },

    -- Specialty ammo (caliber-specific)
    ['subsonic'] = {
        damageMult = 0.90,
        armorMult = 0.90,
        penetration = 0.65,
        effects = { suppressed = true, soundReduction = 0.60 },
    },
    ['bear'] = {  -- 10mm hard cast
        damageMult = 0.95,
        armorMult = 1.20,
        penetration = 0.95,
        effects = {},
    },

    -- Shotgun specialty
    ['dragonsbreath'] = {
        damageMult = 0.85,
        armorMult = 0.70,
        penetration = 0.30,
        effects = { fire = true, fireTrail = true, fireDuration = 3000 },
    },
    ['beanbag'] = {
        damageMult = 0.05,     -- Minimal damage
        armorMult = 0.80,
        penetration = 0.00,
        effects = { ragdoll = true, ragdollForce = 500 },
    },
    ['pepperball'] = {
        damageMult = 0.02,
        armorMult = 1.00,
        penetration = 0.00,
        effects = { blind = true, blindDuration = 8000, cough = true },
    },
    ['breach'] = {
        damageMult = 0.30,     -- Low vs people
        armorMult = 0.50,
        penetration = 0.00,
        effects = { envDamage = 5.0 },  -- High vs objects
    },

    -- .50 BMG specialty
    ['api'] = {  -- Armor Piercing Incendiary
        damageMult = 0.95,
        armorMult = 2.00,
        penetration = 1.00,
        armorBypass = true,
        effects = { fire = true, vehicleFire = true },
    },
    ['boom'] = {  -- Explosive
        damageMult = 1.10,
        armorMult = 1.50,
        penetration = 0.90,
        effects = { explosive = true, explosionType = 'TANKSHELL', vehicleExplosion = true },
    },

    -- Tranquilizer
    ['tranq'] = {
        damageMult = 0.02,
        armorMult = 0.00,
        penetration = 0.00,
        effects = { incapacitate = true, incapDuration = 30000 },
    },
}

-- Caliber overrides (specific caliber + ammo type combos)
Config.CaliberOverrides = {
    ['.357mag'] = {
        ['fmj'] = { damageMult = 1.00, penetration = 0.85 },
        ['jhp'] = { damageMult = 1.20, penetration = 0.50 },
    },
    ['.50bmg'] = {
        ['ball'] = { damageMult = 1.00, armorBypass = true },
        ['api'] = { damageMult = 0.95, armorBypass = true },
        ['boom'] = { damageMult = 1.10, armorBypass = true },
    },
}
```

### 1.2 Server Damage Handler

**File: `server/sv_damage.lua`**
```lua
--[[
    Ammunition Damage Handler
    =========================
    Intercepts weaponDamageEvent and applies ammo-type modifiers
]]

local playerAmmoState = {}  -- { [source] = { [weaponHash] = ammoType } }

-- ============================================================================
-- STATE MANAGEMENT
-- ============================================================================

local function GetPlayerAmmoType(source, weaponHash)
    if playerAmmoState[source] and playerAmmoState[source][weaponHash] then
        return playerAmmoState[source][weaponHash]
    end
    -- Fallback to default for caliber
    local weaponInfo = Config.Weapons[weaponHash]
    if weaponInfo then
        return Config.DefaultAmmoType[weaponInfo.caliber] or 'fmj'
    end
    return 'fmj'
end

local function SetPlayerAmmoType(source, weaponHash, ammoType)
    if not playerAmmoState[source] then
        playerAmmoState[source] = {}
    end
    playerAmmoState[source][weaponHash] = ammoType

    -- Sync to client via StateBag
    local key = ('ammo_%s'):format(weaponHash)
    Player(source).state:set(key, ammoType, true)
end

-- ============================================================================
-- DAMAGE CALCULATION
-- ============================================================================

local function GetAmmoModifier(ammoType, caliber)
    -- Check for caliber-specific override
    if Config.CaliberOverrides[caliber] and Config.CaliberOverrides[caliber][ammoType] then
        local base = Config.AmmoModifiers[ammoType] or Config.AmmoModifiers['fmj']
        local override = Config.CaliberOverrides[caliber][ammoType]
        -- Merge override into base
        local result = {}
        for k, v in pairs(base) do result[k] = v end
        for k, v in pairs(override) do result[k] = v end
        return result
    end

    return Config.AmmoModifiers[ammoType] or Config.AmmoModifiers['fmj']
end

local function TargetHasArmor(victimId)
    local victim = NetworkGetEntityFromNetworkId(victimId)
    if not DoesEntityExist(victim) then return false end

    local armor = GetPedArmour(victim)
    return armor > 0
end

local function CalculateDamage(baseDamage, ammoType, caliber, hasArmor)
    local modifier = GetAmmoModifier(ammoType, caliber)

    local damage = baseDamage * modifier.damageMult

    if hasArmor then
        if modifier.armorBypass then
            -- AP rounds: full damage through armor
            damage = damage * 1.0
        else
            -- Normal/HP rounds: reduced vs armor
            damage = damage * modifier.armorMult
        end
    end

    return math.floor(damage)
end

-- ============================================================================
-- WEAPON DAMAGE EVENT HANDLER
-- ============================================================================

AddEventHandler('weaponDamageEvent', function(source, data)
    -- data fields:
    -- weaponType: weapon hash
    -- weaponDamage: base damage amount
    -- hitGlobalId: victim network ID
    -- hitComponent: body part hit (may be 0 on some versions)
    -- damageFlags: damage type flags

    if not data or not data.weaponType then return end

    local weaponHash = data.weaponType
    local weaponInfo = Config.Weapons[weaponHash]

    -- Only process supported weapons
    if not weaponInfo then return end

    local ammoType = GetPlayerAmmoType(source, weaponHash)
    local modifier = GetAmmoModifier(ammoType, weaponInfo.caliber)

    -- Check for blanks (no damage)
    if modifier.effects and modifier.effects.noDamage then
        CancelEvent()
        return
    end

    -- Calculate armor status
    local hasArmor = data.hitGlobalId and TargetHasArmor(data.hitGlobalId)

    -- Apply damage modification
    local newDamage = CalculateDamage(data.weaponDamage, ammoType, weaponInfo.caliber, hasArmor)

    -- Modify the event data
    data.weaponDamage = newDamage

    -- Apply armor bypass flag if AP
    if modifier.armorBypass then
        data.damageFlags = data.damageFlags | 32  -- DAMAGE_FLAG_IGNORE_ARMOR
    end

    -- Trigger special effects
    if modifier.effects then
        TriggerEffects(source, data.hitGlobalId, modifier.effects, weaponInfo.caliber)
    end
end)

-- ============================================================================
-- SPECIAL EFFECTS
-- ============================================================================

local function TriggerEffects(source, victimNetId, effects, caliber)
    if not victimNetId then return end

    local victimSource = NetworkGetEntityOwner(NetworkGetEntityFromNetworkId(victimNetId))

    -- Fire effect (incendiary, dragon's breath)
    if effects.fire then
        TriggerClientEvent('ammo:applyFireEffect', victimSource, {
            duration = effects.fireDuration or 3000,
            damage = effects.fireDamage or 3,
            trail = effects.fireTrail or false,
        })
    end

    -- Ragdoll effect (beanbag)
    if effects.ragdoll then
        TriggerClientEvent('ammo:applyRagdoll', victimSource, {
            force = effects.ragdollForce or 300,
        })
    end

    -- Blind effect (pepperball)
    if effects.blind then
        TriggerClientEvent('ammo:applyBlindEffect', victimSource, {
            duration = effects.blindDuration or 5000,
            cough = effects.cough or false,
        })
    end

    -- Incapacitation (tranquilizer)
    if effects.incapacitate then
        TriggerClientEvent('ammo:applyIncapacitation', victimSource, {
            duration = effects.incapDuration or 30000,
        })
    end

    -- Explosion (BOOM rounds)
    if effects.explosive and effects.vehicleExplosion then
        local victim = NetworkGetEntityFromNetworkId(victimNetId)
        if DoesEntityExist(victim) and IsEntityAVehicle(victim) then
            local coords = GetEntityCoords(victim)
            AddExplosion(coords.x, coords.y, coords.z, 2, 50.0, true, false, 1.0)
        end
    end
end

-- ============================================================================
-- EVENTS FOR AMMO TYPE SYNC
-- ============================================================================

RegisterNetEvent('ammo:setAmmoType', function(weaponHash, ammoType)
    SetPlayerAmmoType(source, weaponHash, ammoType)
end)

RegisterNetEvent('ammo:magazineEquipped', function(data)
    -- Called when magazine is equipped, sync ammo type
    if data.weaponHash and data.ammoType then
        SetPlayerAmmoType(source, data.weaponHash, data.ammoType)
    end
end)

-- Cleanup on disconnect
AddEventHandler('playerDropped', function()
    playerAmmoState[source] = nil
end)

-- ============================================================================
-- EXPORTS
-- ============================================================================

exports('GetPlayerAmmoType', GetPlayerAmmoType)
exports('SetPlayerAmmoType', SetPlayerAmmoType)
exports('GetAmmoModifier', GetAmmoModifier)
```

---

## Phase 2: Visual Effects (High Priority)

### 2.1 Tracer Effects

**File: `client/cl_effects.lua`**
```lua
--[[
    Visual Effects for Ammunition Types
    - Tracer rounds
    - Incendiary fire trails
    - Muzzle flash variations
]]

local tracerColors = {
    ['red'] = { r = 255, g = 50, b = 50 },
    ['green'] = { r = 50, g = 255, b = 50 },
    ['white'] = { r = 255, g = 255, b = 255 },
    ['orange'] = { r = 255, g = 150, b = 50 },
}

-- Tracer FX names (must exist in game or custom asset)
local tracerFx = {
    ['default'] = 'proj_tracer',
    ['50cal'] = 'proj_tracer_50cal',
    ['incendiary'] = 'proj_tracer_inc',
}

-- ============================================================================
-- TRACER HANDLING
-- ============================================================================

local function GetTracerFxForWeapon(weaponHash)
    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo then return tracerFx['default'] end

    if weaponInfo.caliber == '.50bmg' then
        return tracerFx['50cal']
    end

    return tracerFx['default']
end

-- Monitor for tracer ammo and apply visual
CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)

        if weapon ~= `WEAPON_UNARMED` then
            local ammoType = GetCurrentAmmoType(weapon)

            if ammoType == 'tracer' or ammoType == 'api' then
                -- Tracers show on every shot
                -- Game handles this via TracerFx in weapons.meta
                -- We can enhance with custom particles here
            end
        else
            Wait(500)
        end
    end
end)

-- ============================================================================
-- FIRE EFFECTS
-- ============================================================================

RegisterNetEvent('ammo:applyFireEffect', function(data)
    local ped = PlayerPedId()
    local duration = data.duration or 3000
    local damage = data.damage or 3

    -- Start fire on player
    StartEntityFire(ped)

    -- Create damage over time thread
    CreateThread(function()
        local endTime = GetGameTimer() + duration
        while GetGameTimer() < endTime do
            Wait(500)
            if DoesEntityExist(ped) and not IsEntityDead(ped) then
                ApplyDamageToPed(ped, damage, false)
            end
        end
        StopEntityFire(ped)
    end)
end)

-- Dragon's breath fire trail (shooter sees this)
local function CreateFireTrail(startCoords, endCoords)
    -- Request particle asset
    RequestNamedPtfxAsset('core')
    while not HasNamedPtfxAssetLoaded('core') do Wait(10) end

    UseParticleFxAsset('core')
    local fx = StartParticleFxLoopedAtCoord('fire_petroltank_float', endCoords.x, endCoords.y, endCoords.z, 0.0, 0.0, 0.0, 0.5, false, false, false, false)

    SetTimeout(2000, function()
        StopParticleFxLooped(fx, false)
    end)
end

-- ============================================================================
-- EXPORTS
-- ============================================================================

exports('GetCurrentAmmoType', function(weaponHash)
    local mag = exports['ammo_system_standalone']:GetEquippedMagazine(weaponHash)
    return mag and mag.ammoType or 'fmj'
end)
```

---

## Phase 3: Less-Lethal Effects (Medium Priority)

### 3.1 Beanbag, Pepperball, Tranquilizer

**File: `client/cl_lesslethal.lua`**
```lua
--[[
    Less-Lethal Ammunition Effects
    - Beanbag: Ragdoll knockback
    - Pepperball: Vision blur + coughing
    - Tranquilizer: Progressive incapacitation
]]

-- ============================================================================
-- BEANBAG - RAGDOLL
-- ============================================================================

RegisterNetEvent('ammo:applyRagdoll', function(data)
    local ped = PlayerPedId()
    local force = data.force or 300

    -- Apply ragdoll
    SetPedToRagdoll(ped, 2000, 2000, 0, true, true, false)

    -- Apply force in direction of shot
    local coords = GetEntityCoords(ped)
    ApplyForceToEntity(ped, 1, 0.0, force, 0.0, 0.0, 0.0, 0.0, false, true, true, true, false, true)
end)

-- ============================================================================
-- PEPPERBALL - VISION BLUR + COUGH
-- ============================================================================

local isPeppered = false

RegisterNetEvent('ammo:applyBlindEffect', function(data)
    if isPeppered then return end
    isPeppered = true

    local duration = data.duration or 5000
    local endTime = GetGameTimer() + duration

    -- Start effects
    AnimpostfxPlay('DrugsMichaelAliensFight', 0, true)
    ShakeGameplayCam('DRUNK_SHAKE', 1.0)

    -- Coughing animation loop
    CreateThread(function()
        while GetGameTimer() < endTime do
            Wait(2000)
            local ped = PlayerPedId()
            if not IsEntityDead(ped) then
                -- Play cough animation
                TaskPlayAnim(ped, 'timetable@gardener@smoking_joint', 'idle_cough', 8.0, -8.0, 1500, 49, 0, false, false, false)
            end
        end

        -- Clear effects
        AnimpostfxStop('DrugsMichaelAliensFight')
        StopGameplayCamShaking(true)
        isPeppered = false
    end)
end)

-- ============================================================================
-- TRANQUILIZER - PROGRESSIVE INCAPACITATION
-- ============================================================================

local isTranqed = false

RegisterNetEvent('ammo:applyIncapacitation', function(data)
    if isTranqed then return end
    isTranqed = true

    local duration = data.duration or 30000
    local ped = PlayerPedId()

    -- Phase 1: Stumbling (first 5 seconds)
    lib.notify({ title = 'Tranquilized', description = 'You feel dizzy...', type = 'warning' })
    SetPedMovementClipset(ped, 'move_m@drunk@verydrunk', 1.0)
    ShakeGameplayCam('DRUNK_SHAKE', 0.5)

    Wait(5000)

    -- Phase 2: Falling (5-10 seconds)
    if not IsEntityDead(ped) then
        lib.notify({ title = 'Tranquilized', description = 'Your legs give out...', type = 'error' })
        SetPedToRagdoll(ped, 5000, 5000, 0, true, true, false)
        ShakeGameplayCam('DRUNK_SHAKE', 1.0)
    end

    Wait(5000)

    -- Phase 3: Unconscious (remaining duration)
    if not IsEntityDead(ped) then
        -- Freeze in place
        FreezeEntityPosition(ped, true)
        AnimpostfxPlay('DeathFailOut', 0, true)

        Wait(duration - 10000)

        -- Wake up
        FreezeEntityPosition(ped, false)
        AnimpostfxStop('DeathFailOut')
        StopGameplayCamShaking(true)
        ResetPedMovementClipset(ped, 1.0)

        lib.notify({ title = 'Waking Up', description = 'The sedative is wearing off...', type = 'inform' })
    end

    isTranqed = false
end)
```

---

## Phase 4: Integration & Polish (Low Priority)

### 4.1 Magazine System Integration

Update `magazine_client.lua` to sync ammo type when magazine is equipped:

```lua
-- In EquipMagazine success callback
RegisterNetEvent('ammo:magazineEquipped', function(data)
    -- ... existing code ...

    -- Sync ammo type to server for damage calculation
    TriggerServerEvent('ammo:setAmmoType', data.weaponHash, data.ammoType)
end)
```

### 4.2 ox_inventory Ammo Display

Show current ammo type in weapon tooltip:

```lua
-- Register custom metadata display for weapons
exports.ox_inventory:registerDisplayMetadata('ammoType', function(value)
    local ammoConfig = Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][value]
    if ammoConfig then
        return ammoConfig.label
    end
    return value:upper()
end)
```

---

## Implementation Order

### Sprint 1: Core Damage (Week 1-2)
- [ ] Create `shared/modifiers.lua` with all ammo type modifiers
- [ ] Create `server/sv_damage.lua` with weaponDamageEvent handler
- [ ] Add StateBag sync for ammo type
- [ ] Integrate with magazine system
- [ ] Test damage modifications (FMJ, HP, AP)

### Sprint 2: Armor & Penetration (Week 2-3)
- [ ] Implement armor detection
- [ ] AP armor bypass logic
- [ ] HP reduced effectiveness vs armor
- [ ] Test with body armor

### Sprint 3: Visual Effects (Week 3-4)
- [ ] Tracer particle effects
- [ ] Incendiary fire effects
- [ ] Dragon's breath trail
- [ ] Sync effects to other players

### Sprint 4: Less-Lethal (Week 4-5)
- [ ] Beanbag ragdoll implementation
- [ ] Pepperball vision/cough effects
- [ ] Tranquilizer phased incapacitation
- [ ] Balance testing

### Sprint 5: Specialty Ammo (Week 5-6)
- [ ] .50 BMG explosive rounds
- [ ] Subsonic sound reduction
- [ ] Match accuracy bonus
- [ ] Breach environmental damage

---

## GTA Natives Reference

```lua
-- Damage
AddEventHandler('weaponDamageEvent', callback)  -- Server-side damage interception
ApplyDamageToPed(ped, amount, armorFirst)
SetEntityHealth(entity, health)

-- Armor
GetPedArmour(ped)
SetPedArmour(ped, amount)

-- Effects
StartEntityFire(entity)
StopEntityFire(entity)
SetPedToRagdoll(ped, time1, time2, type, ...)
AnimpostfxPlay(effectName, duration, looped)
ShakeGameplayCam(shakeName, intensity)

-- Particles
RequestNamedPtfxAsset(assetName)
UseParticleFxAsset(assetName)
StartParticleFxLoopedAtCoord(...)

-- Movement
SetPedMovementClipset(ped, clipset, blend)
ResetPedMovementClipset(ped, blend)
FreezeEntityPosition(entity, frozen)

-- Network
Player(source).state:set(key, value, replicated)
NetworkGetEntityFromNetworkId(netId)
```

---

## Summary

Your existing ammo system has an **excellent foundation** with comprehensive ammo type definitions, weapon mappings, and magazine management. The critical missing piece is the **damage application layer** - the `weaponDamageEvent` handler that actually makes different ammo types have different effects.

**Minimum Viable Implementation:**
1. `shared/modifiers.lua` - Damage multipliers
2. `server/sv_damage.lua` - weaponDamageEvent handler
3. StateBag sync for ammo type

This alone will make FMJ, HP, and AP ammo behave differently. Visual effects and less-lethal can be added incrementally.
