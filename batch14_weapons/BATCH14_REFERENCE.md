# Batch 14: SIG MCX Platform Variants - FiveM Weapon Meta Reference

## Overview

Batch 14 introduces the cutting-edge SIG MCX platform across two revolutionary calibers: the 6.8x51mm (.277 Fury) and .300 AAC Blackout. The 6.8x51mm represents the US Army's Next Generation Squad Weapon program winner, featuring the highest chamber pressure of any commercial cartridge (80,000 PSI) and the ability to defeat Level IV body armor. The .300 Blackout MCX Rattler provides the ultimate suppressor-optimized compact platform.

**New Calibers Introduced:**
- 6.8x51mm (.277 Fury): 57 base damage (HIGHEST rifle tier)
- .300 AAC Blackout: 47 base damage supersonic / 39 subsonic

---

## Quick Reference Table

| Weapon | Real-World Model | Caliber | Barrel | Damage | Fire Mode | Recoil | Range |
|--------|------------------|---------|--------|--------|-----------|--------|-------|
| SIG Spear | MCX Spear Civilian | 6.8x51mm | 16" | 57 | Semi-Auto | 0.32 | 450m |
| M7 | XM7/M7 Military | 6.8x51mm | 13" | 55 | Select-Fire | 0.38 | 420m |
| MCX300 | MCX Rattler | .300 BLK | 5.5" | 44 | Semi-Auto | 0.26 | 180m |

---

## Caliber Profiles

### 6.8x51mm / .277 SIG Fury

The 6.8x51mm represents the most significant small arms ammunition advancement in decades, developed specifically to defeat modern body armor at extended ranges.

| Specification | Value |
|---------------|-------|
| Bullet Diameter | 6.8mm / .2775" |
| Case Length | 51.2mm (2.015") |
| Overall Length | 69.85mm (2.750") |
| **Chamber Pressure** | **80,000 PSI** (highest ever) |
| Standard Bullet | 135gr hybrid case |
| Muzzle Velocity (16") | 3,000 fps |
| Muzzle Energy (16") | 2,697 ft-lbs |

**Hybrid Case Technology:**
- Stainless steel base (contains extreme pressure)
- Brass case body (traditional function)
- Aluminum locking washer (bonds materials)

**Energy Comparisons:**
- +83.5% versus 5.56 NATO
- +23% versus 7.62 NATO
- +79% versus 7.62x39mm

### .300 AAC Blackout

The .300 Blackout was designed specifically for suppressed operations, offering both supersonic combat loads and subsonic stealth ammunition from the same platform.

| Specification | Value |
|---------------|-------|
| Bullet Diameter | .308" (7.82mm) |
| Case Length | 34.75mm (1.368") |
| Overall Length | 57.40mm (2.260") |
| Chamber Pressure | 55,000 PSI |
| Parent Case | Trimmed 5.56 NATO |

**Supersonic Loads (110-125gr):**
- Velocity: 2,200 fps (16" barrel)
- Energy: 1,350 ft-lbs
- Effective range: 300+ yards

**Subsonic Loads (190-220gr):**
- Velocity: 1,000-1,050 fps
- Energy: ~500 ft-lbs
- Effective range: 100-150 yards
- Near-silent with suppressor (115-120 dB)

---

## Detailed Weapon Profiles

### 1. SIG MCX Spear (WEAPON_SIG_SPEAR)

**Civilian Precision Rifle - Highest Damage Semi-Auto**

The civilian MCX Spear delivers the full power of 6.8x51mm in a semi-automatic configuration legal for civilian ownership. At $7,999 MSRP, it represents the pinnacle of commercial rifle technology.

**Real-World Specifications:**
- Caliber: 6.8x51mm (.277 Fury)
- Barrel: 16" (civilian legal)
- Weight: 9.2 lbs empty
- Overall Length: 38.3" extended / 28.1" folded
- Muzzle Velocity: 3,000 fps (135gr hybrid)
- Muzzle Energy: 2,697 ft-lbs
- Fire Control: Semi-automatic only
- Operating System: Short-stroke gas piston
- Trigger: Matchlite Duo 2-stage (~4-5 lbs)
- Magazine: 20-round (25-round available)

**Game Statistics:**
- Damage: 57 (HIGHEST rifle damage)
- Falloff: 90-280m, 0.40 modifier
- Accuracy Spread: 0.85 (excellent precision)
- Recoil: 0.32 (high but controlled)
- Fire Rate: 0.120s TBS (semi-auto)
- ADS Time: 0.42s
- Effective Range: 450m
- Armor Penetration: 0.65 (defeats Level IV)

**Unique Characteristics:**
- Highest base damage of any rifle
- Armor-defeating capability
- Semi-auto only (accuracy advantage)
- Premium tier ($7,999 reflects rarity)
- Folding stock for transport

---

### 2. US Army M7 (WEAPON_M7)

**Military Select-Fire Battle Rifle**

The M7 (formerly XM7) is the US Army's Next Generation Squad Weapon, replacing the M4 carbine for close combat forces. Its select-fire capability combined with 6.8x51mm firepower creates the most lethal individual weapon in US military history.

**Real-World Specifications:**
- Caliber: 6.8x51mm (.277 Fury)
- Barrel: 13" (military compact)
- Weight: 8.38 lbs empty
- Overall Length: 35-38.1" extended / 28.1" folded
- Muzzle Velocity: 2,800-3,000 fps
- Muzzle Energy: ~2,500-2,700 ft-lbs
- Fire Control: Safe-Semi-Auto (select-fire)
- Rate of Fire: ~750 RPM cyclic
- Operating System: Short-stroke gas piston
- Adoption: US Army 2022 (NGSW winner)

**Game Statistics:**
- Damage: 55 (96% of 16" due to 13" barrel)
- Falloff: 85-260m, 0.38 modifier
- Accuracy Spread: 1.00 (military spec)
- Recoil: 0.38 (HIGH - automatic fire of powerful cartridge)
- Fire Rate: 0.080s TBS (~750 RPM automatic)
- ADS Time: 0.40s
- Effective Range: 420m
- Armor Penetration: 0.62 (defeats Level IV)

**Fire Mode Implementation:**
The M7 is configured with the `Automatic` flag, allowing full-auto fire. For realistic select-fire behavior:
- Default: Full-auto enabled in meta
- Script enforcement: Use Lua to enforce semi-auto as default mode
- Toggle: Player keybind switches between semi/auto
- See fire mode script section for implementation

**Unique Characteristics:**
- ONLY automatic weapon with 6.8x51mm
- Highest sustained DPS of any rifle
- Military-restricted (rare/expensive in-game)
- Armor-defeating even at range
- Significant recoil penalty in auto

---

### 3. SIG MCX Rattler (WEAPON_MCX300)

**Ultra-Compact Suppressor-Optimized PDW**

The MCX Rattler represents the ultimate in compact rifle-caliber firepower. Its 5.5" barrel and folding stock create a package smaller than most SMGs while delivering .30-caliber terminal performance. USSOCOM selected it for the Concealable Personal Defense Weapon contract.

**Real-World Specifications:**
- Caliber: .300 AAC Blackout
- Barrel: 5.5" (ultra-compact)
- Weight: 6.4 lbs empty
- Overall Length: 20.3" / ~14.5" folded
- Muzzle Velocity: ~1,800 fps (supersonic 125gr)
- Muzzle Energy: ~900-1,000 ft-lbs
- Fire Control: Semi-automatic (civilian)
- Operating System: Short-stroke gas piston
- Suppressor: Factory SD handguard option
- Military: USSOCOM CPDW contract (2022)

**Game Statistics:**
- Damage: 44 (supersonic .300 BLK from 5.5")
- Falloff: 45-130m, 0.32 modifier (steep)
- Accuracy Spread: 1.40 (short barrel penalty)
- Recoil: 0.26 (manageable despite compact)
- Fire Rate: 0.110s TBS (semi-auto)
- ADS Time: 0.26s (FASTEST rifle ADS)
- Effective Range: 180m
- Armor Penetration: 0.32

**Ammunition Variants (Script Implementation):**

| Ammo Type | Damage | Velocity | Detection | Notes |
|-----------|--------|----------|-----------|-------|
| Supersonic | 44 | 550 m/s | Normal | Default configuration |
| Subsonic | 35 | 320 m/s | -80% | Near-silent with suppressor |

**Unique Characteristics:**
- Fastest ADS of any rifle-caliber weapon
- Suppressor synergy (designed for suppressed use)
- Subsonic option for stealth operations
- Ultra-compact (concealment advantage)
- CQB focused (limited range)

---

## Ammunition System

### 6.8x51mm Ammunition Types

| Type | Damage Mod | Armor Pen | Availability | Notes |
|------|------------|-----------|--------------|-------|
| Hybrid Ball (Military) | 1.0x | 0.65 | Military only | Defeats Level IV |
| Brass Training | 0.90x | 0.55 | Civilian | Reduced pressure loads |
| Hunting (Accubond) | 1.10x | 0.45 | Civilian | Expanding, +soft target |
| AP (Tungsten) | 0.95x | 0.80 | Restricted | Maximum penetration |

### .300 Blackout Ammunition Types

| Type | Weight | Damage | Velocity | Detection | Notes |
|------|--------|--------|----------|-----------|-------|
| Supersonic FMJ | 125gr | 44 | 550 m/s | 100% | Standard combat |
| Supersonic HP | 110gr | 48 | 580 m/s | 100% | +soft target damage |
| Subsonic FMJ | 220gr | 35 | 320 m/s | 20% | Stealth operations |
| Subsonic HP | 190gr | 38 | 330 m/s | 20% | Quiet + expansion |

---

## Shots-to-Kill Analysis (100 HP Target)

### Close Range (Full Damage)

| Weapon | Body Shots | Headshots |
|--------|------------|-----------|
| SIG Spear (57 dmg) | 2 shots | 1 shot |
| M7 (55 dmg) | 2 shots | 1 shot |
| MCX Rattler (44 dmg) | 3 shots | 1 shot |
| MCX Rattler Subsonic (35 dmg) | 3 shots | 2 shots |

### Maximum Range (With Falloff)

| Weapon | Min Damage | Body Shots | Headshots |
|--------|------------|------------|-----------|
| SIG Spear | 22.8 | 5 shots | 2 shots |
| M7 | 20.9 | 5 shots | 2 shots |
| MCX Rattler | 14.1 | 8 shots | 3 shots |

---

## Platform Comparison

### SIG Spear vs M7 (Same Caliber, Different Role)

| Attribute | SIG Spear (Civilian) | M7 (Military) |
|-----------|----------------------|---------------|
| Damage | 57 | 55 |
| Fire Mode | Semi-only | Select-fire |
| Accuracy | 0.85 (better) | 1.00 |
| Recoil | 0.32 (lower) | 0.38 (higher) |
| Fire Rate | 0.120s | 0.080s (auto) |
| Range | 450m | 420m |
| Role | Precision | Volume of fire |

### MCX Rattler vs Other Compacts

| Attribute | MCX Rattler | Micro Draco | CZ BREN |
|-----------|-------------|-------------|---------|
| Caliber | .300 BLK | 7.62x39mm | 5.56 NATO |
| Barrel | 5.5" | 6.25" | 14" |
| Damage | 44 | 45 | 38 |
| ADS Time | 0.26s | 0.25s | 0.32s |
| Recoil | 0.26 | 0.42 | 0.16 |
| Suppressor | Excellent | Poor | Moderate |
| Range | 180m | 150m | 400m |

---

## Stat Rankings (Updated with Batch 14)

### Damage (Highest to Lowest - Rifles)
1. **SIG Spear: 57** (NEW - Highest)
2. **M7: 55** (NEW)
3. Mk47 Mutant: 48
4. **MCX Rattler: 44** (NEW)
5. Micro Draco: 45
6. M16A4: 42
7. Steyr AUG: 42

### Recoil (Lowest to Highest)
1. CZ BREN: 0.16
2. Steyr AUG: 0.18
3. M16A4: 0.20
4. **MCX Rattler: 0.26** (NEW)
5. Mk47 Mutant: 0.28
6. **SIG Spear: 0.32** (NEW)
7. **M7: 0.38** (NEW)
8. Micro Draco: 0.42

### Armor Penetration (Highest to Lowest)
1. **SIG Spear: 0.65** (NEW - Defeats Level IV)
2. **M7: 0.62** (NEW - Defeats Level IV)
3. Mk47 Mutant: 0.38
4. **MCX Rattler: 0.32** (NEW)
5. M16A4: 0.30
6. 5.56 platforms: 0.26-0.30

### ADS Time (Fastest to Slowest)
1. Micro Draco: 0.25s
2. **MCX Rattler: 0.26s** (NEW)
3. CZ BREN: 0.32s
4. **M7: 0.40s** (NEW)
5. **SIG Spear: 0.42s** (NEW)
6. M16A4: 0.45s

---

## Fire Mode Script Implementation

For the M7's select-fire capability, add this client-side script:

```lua
-- cl_firemode.lua
local currentMode = 'semi' -- Default to semi-auto
local selectFireWeapons = {
    [`WEAPON_M7`] = true
}

RegisterKeyMapping('togglefiremode', 'Toggle Fire Mode', 'keyboard', 'B')
RegisterCommand('togglefiremode', function()
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    
    if selectFireWeapons[weapon] then
        currentMode = (currentMode == 'semi') and 'auto' or 'semi'
        -- Notify player
        TriggerEvent('chat:addMessage', {
            args = {'Fire Mode: ' .. currentMode:upper()}
        })
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)
        
        if selectFireWeapons[weapon] and currentMode == 'semi' then
            if IsControlJustPressed(0, 24) then
                -- Allow first shot
                Citizen.Wait(1)
                -- Block continued fire
                while IsDisabledControlPressed(1, 24) do
                    DisablePlayerFiring(PlayerId(), true)
                    Citizen.Wait(0)
                end
            end
        end
    end
end)
```

---

## Caliber Hierarchy (Updated)

| Caliber | Baseline Damage | Role |
|---------|-----------------|------|
| .22 LR | 18 | Training |
| .32 ACP | 22 | Pocket pistol |
| .380 ACP | 26 | Compact backup |
| 9mm Luger | 34 | Pistol standard |
| **.300 BLK Subsonic** | **35** | **Suppressed stealth** |
| .40 S&W | 36 | Enhanced pistol |
| .45 ACP | 38 | Heavy pistol |
| 5.56 NATO | 42 | Light rifle |
| **.300 BLK Supersonic** | **44-47** | **Compact rifle** |
| .357 Magnum | 44 | Magnum revolver |
| 10mm Auto | 46 | Power pistol |
| 7.62x39mm | 48 | Intermediate rifle |
| .44 Magnum | 52 | Heavy magnum |
| **6.8x51mm** | **55-57** | **Advanced battle rifle** |
| 7.62 NATO | 58+ | Battle rifle (future) |

---

## Installation

1. Extract each weapon folder to your server's `resources` directory
2. Add 3D model files (.ydr, .ytd) to each weapon's `stream/` folder
3. Add to `server.cfg`:
```
ensure weapon_sig_spear
ensure weapon_m7
ensure weapon_mcx300
```
4. Register weapons with ox_inventory or your inventory system
5. Create ammunition items for new calibers
6. (Optional) Add fire mode toggle script for M7

---

## Version History

- **v1.0.0** - Initial release with 3 SIG MCX platform variants
  - SIG MCX Spear (16" civilian 6.8x51mm)
  - US Army M7 (13" military select-fire 6.8x51mm)
  - MCX Rattler (5.5" compact .300 Blackout)
