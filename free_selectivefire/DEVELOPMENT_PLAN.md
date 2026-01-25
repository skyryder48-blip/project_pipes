# Selective Fire System - Development Plan

## Current System Analysis

### Strengths
- **Clean architecture**: Client/Server/Shared separation
- **ox_lib integration**: Keybind system, proper event handling
- **ox_inventory integration**: Automatic weapon detection via `currentWeapon` event
- **Universal components**: Single item modifies multiple compatible weapons
- **Per-weapon configuration**: Burst counts, default modes, modification options
- **Framework support**: QBCore, Qbox, ox_core compatibility
- **Performance**: Event-driven, cached ped references, <0.1ms idle

### Issues Identified

1. **Burst Fire Logic Bug** (cl_firecontrol.lua:232-272)
   - `burstShotsRemaining` never properly decrements in `TrackShotsFired()`
   - Burst completion detection is unreliable
   - Delay between bursts doesn't consistently apply

2. **No Fire Rate Modification**
   - System only blocks control inputs
   - Doesn't modify actual weapon fire rate via natives
   - RPM differences between modes not reflected

3. **No Recoil Differentiation**
   - Semi/Burst/Full all have same recoil
   - Real weapons have less recoil in semi-auto (better control)

4. **Missing Safety Mode**
   - Common feature in other implementations
   - Prevents accidental discharge

5. **Basic UI Feedback**
   - Only text notification on mode change
   - No persistent HUD indicator

6. **No Fire Rate Sync with weapons.meta**
   - Config.FireRates is static
   - Doesn't use actual weapon TimeBetweenShots values

---

## Enhancement Proposal

### Phase 1: Core Fixes (Priority: Critical)

#### 1.1 Fix Burst Fire Implementation
```lua
-- Problem: Current implementation doesn't properly track burst shots
-- Solution: Rewrite burst handler with proper state machine

local burstState = {
    active = false,
    shotsRemaining = 0,
    lastBurstEnd = 0,
    shotTimes = {},
}

local function HandleBurstFire()
    local now = GetGameTimer()
    local burstCount = GetBurstCount(currentWeaponHash)

    if IsControlPressed(0, 24) then
        if not burstState.active then
            -- Check if we can start a new burst
            if (now - burstState.lastBurstEnd) >= Config.BurstDelay then
                burstState.active = true
                burstState.shotsRemaining = burstCount
                burstState.shotTimes = {}
            else
                -- Still in delay, block firing
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 257, true)
            end
        elseif burstState.shotsRemaining <= 0 then
            -- Burst complete, block until trigger released
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 257, true)
        end
        -- Allow shot if burst active and shots remaining
    else
        -- Trigger released
        if burstState.active and burstState.shotsRemaining <= burstCount then
            burstState.lastBurstEnd = now
        end
        burstState.active = false
        burstState.shotsRemaining = burstCount
    end
end

-- Track actual shots via ammo change
local function OnShotFired()
    if currentMode == 'BURST' and burstState.active then
        burstState.shotsRemaining = burstState.shotsRemaining - 1
    end
end
```

#### 1.2 Improve Shot Detection
```lua
-- Use native event instead of polling ammo
AddEventHandler('CEventGunShot', function(entities, eventEntity, args)
    if eventEntity == cachedPed then
        OnShotFired()
        TriggerServerEvent('selectivefire:shotFired', currentWeaponHash, currentMode)
    end
end)

-- Alternative: Use weapon damage event
AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventGunShot' then
        local shooter = args[1]
        if shooter == cachedPed then
            OnShotFired()
        end
    end
end)
```

---

### Phase 2: Fire Rate Control (Priority: High)

#### 2.1 Native Fire Rate Modification
```lua
-- GTA natives for fire rate control
-- SET_PED_SHOOT_RATE(ped, rate) - 0.0 to 1.0, affects AI
-- For players, we need to use timing-based blocking

-- Per-weapon fire rate from weapons.meta
Config.WeaponFireRates = {
    [`WEAPON_M16`] = {
        SEMI = 0.12,      -- 500 RPM effective
        BURST = 0.075,    -- 800 RPM within burst
    },
    [`WEAPON_MICRO_MP5`] = {
        SEMI = 0.12,
        BURST = 0.075,
        FULL = 0.075,     -- 800 RPM
    },
    -- ... per weapon
}

local function GetFireRateForMode(weaponHash, mode)
    local weaponRates = Config.WeaponFireRates[weaponHash]
    if weaponRates and weaponRates[mode] then
        return weaponRates[mode]
    end
    return Config.FireRates[mode] / 1000  -- Convert ms to seconds
end
```

#### 2.2 Enforced Timing Between Shots
```lua
local lastShotTime = 0
local minimumShotInterval = 0

local function UpdateFireRate()
    minimumShotInterval = GetFireRateForMode(currentWeaponHash, currentMode) * 1000
end

local function CanFire()
    local now = GetGameTimer()
    return (now - lastShotTime) >= minimumShotInterval
end

-- In main loop
if currentMode == 'SEMI' then
    if IsControlPressed(0, 24) then
        if not isTriggerHeld then
            isTriggerHeld = true
            if CanFire() then
                -- Allow first shot
            else
                DisableControlAction(0, 24, true)
            end
        else
            -- Block subsequent shots while held
            DisableControlAction(0, 24, true)
        end
    else
        isTriggerHeld = false
    end
end
```

---

### Phase 3: Recoil Modifiers (Priority: High)

#### 3.1 Per-Mode Recoil Multipliers
```lua
-- Recoil is lower in semi-auto due to better shot control
Config.RecoilModifiers = {
    SEMI = 0.70,    -- 30% less recoil
    BURST = 0.85,   -- 15% less recoil
    FULL = 1.00,    -- Base recoil
}

-- Accuracy modifiers (spread)
Config.AccuracyModifiers = {
    SEMI = 0.60,    -- 40% better accuracy
    BURST = 0.80,   -- 20% better accuracy
    FULL = 1.00,    -- Base accuracy
}
```

#### 3.2 Apply Recoil via Natives
```lua
-- SET_WEAPON_RECOIL_SHAKE_AMPLITUDE doesn't exist
-- Must use camera shake and accuracy manipulation

local function ApplyRecoilModifier(mode)
    local recoilMod = Config.RecoilModifiers[mode] or 1.0
    local accuracyMod = Config.AccuracyModifiers[mode] or 1.0

    -- Modify player accuracy
    -- SET_PLAYER_WEAPON_ACCURACY(player, accuracy * accuracyMod)

    -- For camera shake, intercept after shot
    if mode == 'SEMI' then
        -- Reduce camera shake effect
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', recoilMod * 0.5)
    end
end

-- Alternative: Modify recoil recovery
local function ModifyRecoilRecovery(mode)
    -- Semi-auto: faster recoil reset between shots
    -- This simulates the benefit of controlled fire
    local recoveryBonus = {
        SEMI = 1.5,
        BURST = 1.2,
        FULL = 1.0,
    }
    -- Apply via animation blending or camera manipulation
end
```

---

### Phase 4: Safety Mode (Priority: Medium)

#### 4.1 Add Safety to Fire Mode Cycle
```lua
-- Add 'SAFE' mode
local modeNames = {
    SAFE = 'Safety On',
    SEMI = 'Semi-Auto',
    BURST = 'Burst',
    FULL = 'Full-Auto',
}

-- Weapons that support safety
Config.Weapons[`WEAPON_M16`] = {
    modes = {'SAFE', 'SEMI', 'BURST'},  -- Add SAFE
    defaultMode = 'SAFE',
    -- ...
}

local function HandleSafety()
    -- Block all firing
    DisableControlAction(0, 24, true)   -- Attack
    DisableControlAction(0, 257, true)  -- Attack 2
    DisableControlAction(0, 140, true)  -- Melee light
    DisableControlAction(0, 141, true)  -- Melee heavy
end
```

#### 4.2 Safety Indicator
```lua
-- Visual feedback when safety is on
local function DrawSafetyIndicator()
    if currentMode == 'SAFE' then
        -- Draw "SAFE" on screen or use scaleform
        SetTextFont(4)
        SetTextScale(0.4, 0.4)
        SetTextColour(255, 100, 100, 200)
        SetTextEntry('STRING')
        AddTextComponentString('~r~SAFE')
        DrawText(0.95, 0.85)
    end
end
```

---

### Phase 5: Enhanced UI (Priority: Medium)

#### 5.1 HUD Fire Mode Indicator
```lua
-- Persistent mode display
local function DrawFireModeHUD()
    if not isArmed or not currentWeaponHash then return end

    local modeText = modeNames[currentMode] or currentMode
    local modeColor = {
        SAFE = {255, 100, 100},
        SEMI = {255, 255, 255},
        BURST = {255, 200, 100},
        FULL = {100, 255, 100},
    }

    local color = modeColor[currentMode] or {255, 255, 255}

    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(color[1], color[2], color[3], 220)
    SetTextOutline()
    SetTextEntry('STRING')
    AddTextComponentString(modeText)
    DrawText(0.945, 0.88)
end

-- Add to render thread (separate from fire control)
CreateThread(function()
    while true do
        if isArmed then
            DrawFireModeHUD()
            Wait(0)
        else
            Wait(500)
        end
    end
end)
```

#### 5.2 Mode Change Animation/Sound
```lua
local function OnModeChanged(newMode)
    -- Sound variation per mode
    local sounds = {
        SAFE = 'WEAPON_SAFETY_ON',
        SEMI = 'WEAPON_PURCHASE',
        BURST = 'WEAPON_PURCHASE',
        FULL = 'WEAPON_PURCHASE',
    }

    PlaySoundFrontend(-1, sounds[newMode] or 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', true)

    -- Brief notification
    lib.notify({
        title = 'Fire Mode',
        description = modeNames[newMode],
        type = 'inform',
        duration = 1500,
    })
end
```

---

### Phase 6: Integration & Polish (Priority: Low)

#### 6.1 Sync with weapons.meta Values
```lua
-- Read actual weapon stats from game
local function GetWeaponTimeBetweenShots(weaponHash)
    -- GTA native to get weapon data
    local timeBetweenShots = GetWeaponTimeBetweenShots(weaponHash)
    return timeBetweenShots
end

-- Dynamic fire rate based on weapon
local function CalculateEffectiveRPM(weaponHash, mode)
    local baseTime = GetWeaponTimeBetweenShots(weaponHash)
    local modeMultiplier = {
        SEMI = 2.0,   -- Half the fire rate
        BURST = 1.0,  -- Full speed within burst
        FULL = 1.0,   -- Full speed
    }
    return 60 / (baseTime * (modeMultiplier[mode] or 1.0))
end
```

#### 6.2 Suppressor Detection
```lua
-- Check for suppressor and adjust behavior
local function HasSuppressor(ped, weaponHash)
    -- Common suppressor component names
    local suppressors = {
        'COMPONENT_AT_AR_SUPP',
        'COMPONENT_AT_AR_SUPP_02',
        'COMPONENT_AT_PI_SUPP',
        'COMPONENT_AT_PI_SUPP_02',
        'COMPONENT_AT_SR_SUPP',
        'COMPONENT_AT_SR_SUPP_03',
    }

    for _, comp in ipairs(suppressors) do
        if HasPedGotWeaponComponent(ped, weaponHash, GetHashKey(comp)) then
            return true
        end
    end
    return false
end

-- Suppressed weapons: slightly reduced recoil, different sound
local function GetSuppressionBonus(ped, weaponHash)
    if HasSuppressor(ped, weaponHash) then
        return {
            recoil = 0.90,   -- 10% less recoil
            sound = true,    -- Use suppressed sound
        }
    end
    return { recoil = 1.0, sound = false }
end
```

#### 6.3 Ammo Type Modifiers
```lua
-- Different ammo affects fire behavior
-- Integration with ammo_system_standalone
local function GetAmmoModifiers()
    local ammoType = exports['ammo_system_standalone']:GetCurrentAmmoType()

    local modifiers = {
        ['standard'] = { recoil = 1.0, damage = 1.0 },
        ['hp'] = { recoil = 0.95, damage = 1.15 },      -- Hollow point
        ['ap'] = { recoil = 1.05, damage = 0.95 },      -- Armor piercing
        ['subsonic'] = { recoil = 0.85, damage = 0.90 }, -- Suppressor optimized
    }

    return modifiers[ammoType] or modifiers['standard']
end
```

---

## Implementation Order

### Sprint 1: Core Fixes (Week 1)
1. [ ] Fix burst fire state machine
2. [ ] Improve shot detection (use game events)
3. [ ] Add proper timing between semi-auto shots
4. [ ] Fix trigger release detection

### Sprint 2: Fire Rate & Recoil (Week 2)
1. [ ] Implement per-weapon fire rates
2. [ ] Add recoil modifiers per mode
3. [ ] Add accuracy modifiers per mode
4. [ ] Sync fire rates with weapons.meta

### Sprint 3: Safety & UI (Week 3)
1. [ ] Add safety mode
2. [ ] Implement HUD fire mode indicator
3. [ ] Add mode-specific sounds
4. [ ] Add ox_lib notifications

### Sprint 4: Integration (Week 4)
1. [ ] Suppressor detection and bonuses
2. [ ] Ammo system integration
3. [ ] Server validation improvements
4. [ ] Performance optimization

---

## File Structure (Enhanced)

```
free_selectivefire/
├── fxmanifest.lua
├── client/
│   ├── cl_firecontrol.lua      # Core fire mode logic
│   ├── cl_recoil.lua           # Recoil modifiers
│   ├── cl_hud.lua              # Fire mode HUD
│   └── cl_utils.lua            # Shared utilities
├── server/
│   ├── sv_firevalidation.lua   # Anti-cheat
│   └── sv_logging.lua          # Optional logging
├── shared/
│   ├── config.lua              # Weapon definitions
│   ├── firerates.lua           # Per-weapon fire rates
│   └── modifiers.lua           # Recoil/accuracy modifiers
└── data/
    └── weaponcomponents.meta   # Custom components
```

---

## Key GTA Natives Reference

```lua
-- Weapon control
DisableControlAction(0, 24, true)    -- Block attack
DisablePlayerFiring(ped, true)       -- Completely disable firing
SetPlayerCanDoDriveBy(player, false) -- Disable drive-by

-- Weapon info
GetSelectedPedWeapon(ped)
GetAmmoInClip(ped, weaponHash)
GetWeaponClipSize(weaponHash)
HasPedGotWeaponComponent(ped, weaponHash, componentHash)

-- Accuracy/Recoil (limited)
SetPlayerWeaponAccuracy(player, accuracy)
SetPedAccuracy(ped, accuracy)

-- Camera shake (for recoil feel)
ShakeGameplayCam(shakeName, intensity)
StopGameplayCamShaking(instant)

-- Events for shot detection
AddEventHandler('gameEventTriggered', callback)
-- Events: CEventGunShot, CEventNetworkEntityDamage
```

---

## Community Resources

- [FiveM Weapon Fire Mode Changer](https://forum.cfx.re/t/weapon-fire-mode-changer-standalone/5133773) - Standalone implementation
- [SelectiveFire GTA5 Mod](https://github.com/David-Lor/SelectiveFire) - C# reference implementation
- [FiveM Recoil & Fire Rate Selection](https://github.com/RCPisAwesome/Recoil-Fire-Rate-Selection) - UI-based approach (outdated)

---

## Decision Points

### Option A: Enhance Current System
- **Pros**: Faster, builds on solid foundation
- **Cons**: Some structural limitations
- **Effort**: 2-3 weeks

### Option B: Rewrite from Scratch
- **Pros**: Cleaner architecture, address all issues
- **Cons**: More time, lose working code
- **Effort**: 4-6 weeks

### Recommendation: Option A (Enhance)
The current system has a solid foundation. The issues are fixable without a full rewrite. Focus on:
1. Fix burst fire logic (critical bug)
2. Add fire rate control
3. Add recoil modifiers
4. Add safety mode
5. Improve UI

This approach preserves working code while addressing all identified issues.
