# Comprehensive FiveM weapon meta development guide

Creating realistic weapon behavior in FiveM requires understanding the mathematical relationship between weapon.meta parameters, GTA V's damage calculation engine, and real-world ballistics. This guide provides the complete technical framework to translate real firearm specifications into balanced, authentic weapon meta files where **9mm pistols require 8 body shots at range but only 3 up close**, headshots deliver instant kills at point-blank, and each caliber performs proportionally to its real-world counterpart.

## Understanding the damage calculation engine

FiveM players have **100 usable health points** (200 max health minus 100 death threshold). Every damage calculation flows through a formula that combines base damage, distance-based falloff, body part multipliers, and network modifiers. Mastering this formula is essential for predictable weapon balancing.

**The core damage formula** works as follows:

```
Final Damage = Base Damage × Falloff Modifier × Body Part Multiplier × Network Modifier
```

Distance falloff uses **linear interpolation** between two range values. Within `DamageFallOffRangeMin`, weapons deal full damage. Beyond `DamageFallOffRangeMax`, damage reduces to the `DamageFallOffModifier` percentage (typically 30-40%). Between these values, damage decreases linearly:

```
If distance ≤ RangeMin: Falloff = 1.0
If distance ≥ RangeMax: Falloff = DamageFallOffModifier
Otherwise: Falloff = 1.0 - (1.0 - Modifier) × ((distance - RangeMin) / (RangeMax - RangeMin))
```

Body part multipliers stack with falloff: headshots multiply by `HeadShotDamageModifierPlayer` (typically **1.5-3.0x**), while limb shots reduce damage via `HitLimbsDamageModifier` (typically **0.4-0.5x** in singleplayer, **0.8x** in multiplayer via `NetworkHitLimbsDamageModifier`).

## Complete weapon meta parameter reference

The weapons.meta XML structure contains approximately 80+ parameters organized into functional categories. Here are the critical parameters for realistic weapon balancing:

### Damage and falloff parameters

| Parameter | Function | Typical Range |
|-----------|----------|---------------|
| `Damage` | Base damage per hit | 10-220 |
| `DamageFallOffRangeMin` | Distance (meters) where falloff begins | 10-250 |
| `DamageFallOffRangeMax` | Distance where minimum damage reached | 50-500 |
| `DamageFallOffModifier` | Minimum damage multiplier at max range | 0.3-1.0 |
| `HeadShotDamageModifierPlayer` | Headshot multiplier vs players | 1.5-5.0 |
| `MaxHeadShotDistancePlayer` | Max range for headshot bonus | 7-300 |
| `HitLimbsDamageModifier` | Limb damage multiplier (SP) | 0.4-0.5 |
| `NetworkHitLimbsDamageModifier` | Limb multiplier (multiplayer) | 0.8-1.0 |
| `NetworkPlayerDamageModifier` | Overall PvP damage modifier | 0.5-2.0 |

### Bullet and performance parameters

| Parameter | Function | Typical Range |
|-----------|----------|---------------|
| `Speed` | Bullet velocity (meters/second) | 280-1000 |
| `Penetration` | Armor/material penetration | 0.0-1.0 |
| `WeaponRange` | Maximum bullet travel distance | 50-500 |
| `TimeBetweenShots` | Fire rate delay (seconds) | 0.025-1.5 |
| `ClipSize` | Magazine capacity | 6-100 |
| `AccuracySpread` | Base bullet spread | 0.1-3.0 |
| `RecoilShakeAmplitude` | Camera shake intensity | 0.05-1.0 |
| `Force` | Base physics knockback | 50-500 |
| `ForceHitPed` | Force on pedestrian hits | 50-300 |

### Fire type and damage type

The `FireType` parameter determines projectile behavior: `INSTANT_HIT` creates hitscan bullets traveling at the Speed value, `DELAYED_HIT` adds projectile physics, and `PROJECTILE` uses AmmoInfo for grenades/rockets. The `DamageType` hash (typically `BULLET`) affects fuel tank interactions and damage categorization.

## Achieving the target balancing goals

To create 9mm pistols requiring **8 shots at range and 3 up close** with **1-shot headshot kills point-blank but 2+ at distance**, calculate backward from the 100 usable HP:

**Step 1: Calculate base damage for 3-shot close-range kills**
```
Base Damage = 100 HP ÷ 3 shots = 33.3 → use 34
```

**Step 2: Determine falloff modifier for 8-shot ranged kills**
```
Falloff Modifier = (100 HP ÷ 8 shots) ÷ 34 base = 12.5 ÷ 34 = 0.37 → use 0.38
```

**Step 3: Calculate headshot modifier for 1-shot close-range kills**
```
HeadShotModifier = 100 HP ÷ 34 base = 2.94 → use 3.0
```

**Step 4: Limit headshot effectiveness at range**
Set `MaxHeadShotDistancePlayer` to **7.0** so beyond 7 units, headshots lose their bonus multiplier and require 2+ shots due to combined falloff.

### Complete 9mm pistol example (Glock 17 style)

```xml
<Item>
  <Name>WEAPON_PISTOL_9MM</Name>
  <HumanNameHash>WT_PISTOL9MM</HumanNameHash>
  
  <!-- Damage values for 3-shot close/8-shot far balancing -->
  <Damage value="34.000000" />
  <DamageFallOffRangeMin value="15.000000" />
  <DamageFallOffRangeMax value="50.000000" />
  <DamageFallOffModifier value="0.380000" />
  
  <!-- Headshot: 1-shot at 0-7 units, 2+ beyond -->
  <HeadShotDamageModifierPlayer value="3.000000" />
  <HeadShotDamageModifierAI value="5.000000" />
  <MinHeadShotDistancePlayer value="0.000000" />
  <MaxHeadShotDistancePlayer value="7.000000" />
  
  <!-- Limb damage reduction -->
  <HitLimbsDamageModifier value="0.500000" />
  <NetworkHitLimbsDamageModifier value="0.800000" />
  
  <!-- Realistic 9mm velocity: ~365 m/s -->
  <Speed value="365.000000" />
  <WeaponRange value="100.000000" />
  
  <!-- Semi-auto ~150 RPM practical = 0.4s between shots -->
  <TimeBetweenShots value="0.180000" />
  <ClipSize value="17" />
  
  <!-- Light 9mm recoil -->
  <RecoilShakeAmplitude value="0.200000" />
  <AccuracySpread value="1.500000" />
  
  <!-- Minimal armor penetration -->
  <Penetration value="0.150000" />
  <Force value="50.000000" />
  <ForceHitPed value="40.000000" />
</Item>
```

## Real-world to FiveM conversion methodology

### Converting muzzle velocity to Speed parameter

GTA V's Speed parameter uses **meters per second**. Apply real-world muzzle velocity directly or with minor scaling:

| Caliber | Real Velocity (m/s) | Recommended Speed |
|---------|---------------------|-------------------|
| .22 LR | 329-500 | 350-450 |
| 9mm | 350-366 | 365-400 |
| .45 ACP | 253-287 | 280-320 |
| 5.7×28mm | 518-716 | 600-700 |
| .357 Magnum | 378-518 | 450-520 |
| .500 S&W | 366-602 | 500-550 |
| 5.56 NATO | 823-994 | 850-940 |
| 7.62×39mm | 701-732 | 715-750 |

Higher Speed values create faster-feeling weapons with less noticeable bullet travel time. Values above 1000 appear nearly instant.

### Converting muzzle energy to Damage values

Using 9mm as the baseline caliber (34 damage for 3-shot kills), scale other calibers by their **muzzle energy ratio**:

| Caliber | Energy (Joules) | Ratio vs 9mm | Damage Value | Shots to Kill |
|---------|-----------------|--------------|--------------|---------------|
| .22 LR | 163-200 | 0.40× | 14 | 8 close / 18+ far |
| 9mm | 460-500 | 1.00× | 34 | 3 close / 8 far |
| .45 ACP | 480-540 | 1.05× | 36 | 3 close / 7 far |
| 5.7×28mm | 340-460 | 0.85× | 29 | 4 close / 10 far |
| .357 Mag | 680-810 | 1.60× | 54 | 2 close / 5 far |
| .500 S&W | 2890-4100 | 7.50× | 90 | 2 close / 3 far |
| 5.56 NATO | 1200-1700 | 3.00× | 48 | 3 close / 6 far |
| 7.62×39mm | 2000-2170 | 4.30× | 58 | 2 close / 5 far |
| 12ga slug | 3300-4200 | 8.00× | 120 | 1 close / 2 far |
| 12ga buck | ~2300 total | N/A | 22×8 pellets | 1-2 close |

### Converting rate of fire to TimeBetweenShots

The formula is straightforward: **TimeBetweenShots = 60 ÷ RPM**

| Weapon Type | Real RPM | TimeBetweenShots |
|-------------|----------|------------------|
| Semi-auto pistol | 120-180 | 0.333-0.500 |
| Revolver (DA) | 30-50 | 1.200-2.000 |
| SMG (MP5) | 800 | 0.075 |
| AR-15/M4 | 700-950 | 0.063-0.086 |
| AK-47 | 600 | 0.100 |
| Minigun | 3000-6000 | 0.010-0.020 |

### Converting effective range to falloff parameters

Map real-world effective range to damage falloff distances:

```
DamageFallOffRangeMin = Effective_Range × 0.3-0.5
DamageFallOffRangeMax = Effective_Range × 0.8-1.0
WeaponRange = Effective_Range × 1.5-2.0
```

| Caliber | Effective Range | FallOffMin | FallOffMax | WeaponRange |
|---------|-----------------|------------|------------|-------------|
| 9mm | 50m | 15 | 50 | 100 |
| .45 ACP | 50m | 12 | 45 | 80 |
| .357 Mag | 75m | 25 | 70 | 150 |
| 5.56 NATO | 500m | 150 | 400 | 800 |
| 7.62×39mm | 350m | 100 | 300 | 600 |
| 12ga buck | 40m | 10 | 35 | 60 |

### Caliber-based recoil scaling

Match `RecoilShakeAmplitude` to real-world felt recoil:

| Caliber | Recoil Energy | RecoilShakeAmplitude | AccuracySpread |
|---------|---------------|----------------------|----------------|
| .22 LR | Minimal | 0.05-0.10 | 1.0-1.5 |
| 5.7×28mm | Very light | 0.08-0.12 | 1.2-1.6 |
| 9mm | Light | 0.15-0.25 | 1.5-2.0 |
| .45 ACP | Moderate | 0.20-0.30 | 1.8-2.3 |
| .357 Mag | Heavy | 0.35-0.50 | 2.0-2.5 |
| 5.56 NATO | Light rifle | 0.15-0.25 | 1.0-1.5 |
| 7.62×39mm | Moderate rifle | 0.30-0.40 | 1.5-2.0 |
| .500 S&W | Extreme | 0.80-1.00 | 2.5-3.0 |

## Complete caliber baseline reference values

### 9mm handguns (Glock 17, Beretta M9, Sig P320)
```xml
<Damage value="34.000000" />
<Speed value="365.000000" />
<DamageFallOffRangeMin value="15.000000" />
<DamageFallOffRangeMax value="50.000000" />
<DamageFallOffModifier value="0.380000" />
<HeadShotDamageModifierPlayer value="3.000000" />
<MaxHeadShotDistancePlayer value="7.000000" />
<TimeBetweenShots value="0.180000" />
<ClipSize value="17" />
<Penetration value="0.150000" />
<RecoilShakeAmplitude value="0.200000" />
```

### .45 ACP pistols (Glock 21, 1911)
```xml
<Damage value="38.000000" />
<Speed value="280.000000" />
<DamageFallOffRangeMin value="12.000000" />
<DamageFallOffRangeMax value="45.000000" />
<DamageFallOffModifier value="0.350000" />
<HeadShotDamageModifierPlayer value="2.800000" />
<MaxHeadShotDistancePlayer value="8.000000" />
<TimeBetweenShots value="0.220000" />
<ClipSize value="13" />  <!-- Glock 21 --> 
<!-- <ClipSize value="7" /> for 1911 -->
<Penetration value="0.200000" />
<RecoilShakeAmplitude value="0.280000" />
```

### .357 Magnum revolvers (Colt Python, King Cobra)
```xml
<Damage value="56.000000" />
<Speed value="450.000000" />
<DamageFallOffRangeMin value="25.000000" />
<DamageFallOffRangeMax value="70.000000" />
<DamageFallOffModifier value="0.400000" />
<HeadShotDamageModifierPlayer value="2.200000" />
<MaxHeadShotDistancePlayer value="12.000000" />
<TimeBetweenShots value="0.450000" />
<ClipSize value="6" />
<Penetration value="0.350000" />
<RecoilShakeAmplitude value="0.450000" />
```

### .500 S&W Magnum revolvers
```xml
<Damage value="92.000000" />
<Speed value="530.000000" />
<DamageFallOffRangeMin value="40.000000" />
<DamageFallOffRangeMax value="120.000000" />
<DamageFallOffModifier value="0.450000" />
<HeadShotDamageModifierPlayer value="1.500000" />
<MaxHeadShotDistancePlayer value="20.000000" />
<TimeBetweenShots value="0.700000" />
<ClipSize value="5" />
<Penetration value="0.600000" />
<RecoilShakeAmplitude value="0.950000" />
```

### 5.7×28mm pistols (FN Five-seveN, Ruger 5.7)
```xml
<Damage value="28.000000" />
<Speed value="650.000000" />
<DamageFallOffRangeMin value="30.000000" />
<DamageFallOffRangeMax value="90.000000" />
<DamageFallOffModifier value="0.450000" />
<HeadShotDamageModifierPlayer value="3.600000" />
<MaxHeadShotDistancePlayer value="15.000000" />
<TimeBetweenShots value="0.150000" />
<ClipSize value="20" />
<Penetration value="0.400000" />  <!-- Higher due to armor-piercing capability -->
<RecoilShakeAmplitude value="0.100000" />
```

### .22 LR pistols (Sig P22, FN 502)
```xml
<Damage value="14.000000" />
<Speed value="380.000000" />
<DamageFallOffRangeMin value="10.000000" />
<DamageFallOffRangeMax value="40.000000" />
<DamageFallOffModifier value="0.300000" />
<HeadShotDamageModifierPlayer value="5.000000" />  <!-- Higher to allow 2-shot headshot kills -->
<MaxHeadShotDistancePlayer value="5.000000" />
<TimeBetweenShots value="0.150000" />
<ClipSize value="10" />
<Penetration value="0.050000" />
<RecoilShakeAmplitude value="0.060000" />
```

### 5.56mm rifles (AR-15, M16, M4)
```xml
<Damage value="48.000000" />
<Speed value="940.000000" />
<DamageFallOffRangeMin value="150.000000" />
<DamageFallOffRangeMax value="400.000000" />
<DamageFallOffModifier value="0.380000" />
<HeadShotDamageModifierPlayer value="2.200000" />
<MaxHeadShotDistancePlayer value="80.000000" />
<TimeBetweenShots value="0.075000" />  <!-- ~800 RPM -->
<ClipSize value="30" />
<Penetration value="0.450000" />
<RecoilShakeAmplitude value="0.200000" />
<WeaponRange value="800.000000" />
```

### 7.62mm rifles (AK-47, AKM)
```xml
<Damage value="58.000000" />
<Speed value="715.000000" />
<DamageFallOffRangeMin value="100.000000" />
<DamageFallOffRangeMax value="300.000000" />
<DamageFallOffModifier value="0.400000" />
<HeadShotDamageModifierPlayer value="2.000000" />
<MaxHeadShotDistancePlayer value="60.000000" />
<TimeBetweenShots value="0.100000" />  <!-- 600 RPM -->
<ClipSize value="30" />
<Penetration value="0.550000" />
<RecoilShakeAmplitude value="0.380000" />
<WeaponRange value="600.000000" />
```

### 12 gauge shotgun (slug vs buckshot)

**Slug configuration:**
```xml
<Damage value="120.000000" />
<BulletsInBatch value="1" />
<Speed value="475.000000" />
<DamageFallOffRangeMin value="25.000000" />
<DamageFallOffRangeMax value="80.000000" />
<DamageFallOffModifier value="0.350000" />
<HeadShotDamageModifierPlayer value="1.200000" />
<Penetration value="0.300000" />
<RecoilShakeAmplitude value="0.700000" />
```

**Buckshot configuration (00 buck, 8 pellets):**
```xml
<Damage value="22.000000" />  <!-- Per pellet -->
<BulletsInBatch value="8" />
<BatchSpread value="4.500000" />
<Speed value="366.000000" />
<DamageFallOffRangeMin value="8.000000" />
<DamageFallOffRangeMax value="30.000000" />
<DamageFallOffModifier value="0.200000" />
<HeadShotDamageModifierPlayer value="1.500000" />
<Penetration value="0.100000" />
<RecoilShakeAmplitude value="0.650000" />
```

### 9mm SMGs (MP5, UMP9)
```xml
<Damage value="30.000000" />
<Speed value="400.000000" />
<DamageFallOffRangeMin value="20.000000" />
<DamageFallOffRangeMax value="60.000000" />
<DamageFallOffModifier value="0.350000" />
<HeadShotDamageModifierPlayer value="2.800000" />
<MaxHeadShotDistancePlayer value="15.000000" />
<TimeBetweenShots value="0.075000" />  <!-- 800 RPM -->
<ClipSize value="30" />
<Penetration value="0.200000" />
<RecoilShakeAmplitude value="0.180000" />
```

## FiveM resource file structures

### cl_weaponNames.lua structure

This client-side script registers display names using the `AddTextEntry` function. The first parameter matches the `HumanNameHash` from weapons.meta:

```lua
-- cl_weaponNames.lua
Citizen.CreateThread(function()
    -- Pistols
    AddTextEntry('WT_GLOCK17', 'Glock 17')
    AddTextEntry('WT_GLOCK21', 'Glock 21')
    AddTextEntry('WT_BERETTA', 'Beretta M9A3')
    AddTextEntry('WT_1911', 'Colt M1911A1')
    AddTextEntry('WT_FIVESEVEN', 'FN Five-seveN')
    AddTextEntry('WT_SIGP22', 'Sig Sauer P22')
    
    -- Revolvers
    AddTextEntry('WT_PYTHON', 'Colt Python .357')
    AddTextEntry('WT_500SW', 'S&W Model 500')
    
    -- Rifles
    AddTextEntry('WT_M4A1', 'Colt M4A1')
    AddTextEntry('WT_AK47', 'AK-47')
    AddTextEntry('WT_SCARH', 'FN SCAR-H')
    
    -- Shotguns
    AddTextEntry('WT_MOSSBERG', 'Mossberg 590')
    
    -- SMGs
    AddTextEntry('WT_MP5', 'H&K MP5A3')
end)
```

### fxmanifest.lua template

```lua
-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'Your Name'
description 'Realistic Weapon Pack - Caliber-Based Balancing'
version '1.0.0'

-- Client script for weapon names
client_script 'cl_weaponNames.lua'

-- Meta files to load
files {
    'meta/weapons.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/weaponcomponents.meta',
    'meta/pedpersonality.meta',
}

-- Data file type declarations
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'WEAPONCOMPONENTSINFO_FILE' 'meta/weaponcomponents.meta'
data_file 'PED_PERSONALITY_FILE' 'meta/pedpersonality.meta'
```

### Recommended folder structure

```
resources/
└── [weapons]/
    └── realistic_weapons/
        ├── stream/
        │   ├── w_pi_glock17.ydr
        │   ├── w_pi_glock17.ytd
        │   ├── w_ar_m4a1.ydr
        │   └── w_ar_m4a1.ytd
        ├── meta/
        │   ├── weapons.meta
        │   ├── weaponarchetypes.meta
        │   ├── weaponanimations.meta
        │   ├── weaponcomponents.meta
        │   └── pedpersonality.meta
        ├── cl_weaponNames.lua
        └── fxmanifest.lua
```

## Damage verification calculations

To verify your weapon meta values produce intended shots-to-kill, use this calculation template:

**Close range (within FallOffRangeMin):**
```
Shots to Kill = ceil(100 ÷ Damage)
Headshot STK = ceil(100 ÷ (Damage × HeadShotModifier))
```

**Maximum range (at or beyond FallOffRangeMax):**
```
Shots to Kill = ceil(100 ÷ (Damage × DamageFallOffModifier))
```

**Example: 9mm verification (Damage=34, Falloff=0.38, Headshot=3.0)**
- Close body: ceil(100÷34) = 3 shots ✓
- Far body: ceil(100÷(34×0.38)) = ceil(100÷12.9) = 8 shots ✓
- Close headshot: ceil(100÷(34×3.0)) = ceil(100÷102) = 1 shot ✓

## Conclusion

Building realistic FiveM weapon metas requires balancing three interconnected systems: the damage calculation engine with its distance-based falloff, body part multipliers that reward shot placement, and real-world ballistics data that grounds weapon behavior in physical reality. The caliber baseline values provided translate actual muzzle energy and velocity specifications into gameplay mechanics where a .22 LR feels distinctly different from a .500 Magnum, and tactical positioning at appropriate engagement distances becomes meaningful.

The key insight is that **damage falloff and headshot distance limits** are the primary tools for achieving nuanced weapon behavior. By setting `MaxHeadShotDistancePlayer` to limit one-shot headshot range, and carefully calibrating `DamageFallOffModifier` to control long-range lethality, you can create weapons that reward accuracy and positioning while maintaining distinct performance profiles across caliber categories.