# Batch 13: 7.62x39mm Rifle Platforms - FiveM Weapon Meta Reference

## Overview

Batch 13 introduces the 7.62x39mm Soviet intermediate cartridge through two contrasting platforms: the ultra-compact Micro Draco AK pistol and the precision-oriented CMMG Mk47 Mutant hybrid rifle. This caliber delivers significantly more damage per shot than 5.56 NATO while maintaining effectiveness from short barrels—a key advantage for the Draco platform.

**Baseline Damage:** 48 (16" barrel reference)
**Caliber Advantage:** 7.62x39mm deals +14% more damage than 5.56 NATO (48 vs 42)
**Target TTK:** 3 shots close range, 6-7 shots at maximum range (100 HP)

---

## Quick Reference Table

| Weapon | Real-World Model | Barrel | Damage | Velocity | Fire Rate | Recoil | Range | Accuracy |
|--------|------------------|--------|--------|----------|-----------|--------|-------|----------|
| Mini AK47 | Micro Draco | 6.25" | 45 | 580 m/s | 0.100 | 0.42 | 150m | 2.20 |
| MK47 | CMMG Mk47 Mutant | 16.1" | 48 | 715 m/s | 0.095 | 0.28 | 350m | 0.95 |

---

## 7.62x39mm Caliber Profile

### Cartridge Specifications
| Specification | Value |
|---------------|-------|
| Bullet Diameter | .310"-.312" |
| Case Length | 38.7mm (1.524") |
| Overall Length | 56.0mm (2.205") |
| Standard Weight | 122-124 grain |
| SAAMI Max Pressure | 45,000 psi |
| Origin | Soviet Union (1943) |

### Why 7.62x39 > 5.56 NATO in Damage

The 7.62x39mm cartridge delivers **16-25% more muzzle energy** than 5.56 NATO despite 30% lower velocity. The key factors:

1. **Heavier bullet:** 123gr vs 55-62gr (2x mass)
2. **Larger diameter:** .312" vs .224" (38% wider wound channel)
3. **Velocity-independent effectiveness:** Unlike 5.56, terminal performance doesn't collapse below fragmentation threshold
4. **Superior short-barrel performance:** Loses only 12-15 fps/inch vs 5.56's velocity-dependent degradation

### Barrel Length Velocity Reference

| Barrel Length | Velocity | Energy | Damage Modifier |
|---------------|----------|--------|-----------------|
| 6.25" (Micro Draco) | 1,900 fps | 985 ft-lbs | 0.94x (45) |
| 7.75" (Mini Draco) | 1,950 fps | 1,039 ft-lbs | 0.96x (46) |
| 10.5" (VSKA Draco) | 2,100 fps | 1,204 ft-lbs | 0.98x (47) |
| 12.25" (Standard Draco) | 2,180 fps | 1,298 ft-lbs | 0.98x (47) |
| 16" (Mk47/Standard AK) | 2,350 fps | 1,508 ft-lbs | 1.00x (48) |
| 20" (RPK) | 2,400 fps | 1,573 ft-lbs | 1.02x (49) |

---

## Detailed Weapon Profiles

### 1. Micro Draco (WEAPON_MINI_AK47)

**The Fire-Breathing Dragon**

The Micro Draco represents the most compact 7.62x39mm platform available—a Romanian AK pistol with just 6.25" of barrel delivering devastating rifle-caliber firepower in a package smaller than most SMGs. Originally designed for Soviet tank crews, this weapon trades accuracy and controllability for extreme portability and close-range lethality.

**Real-World Specifications:**
- Barrel: 6.25" (shortest production Draco)
- Weight: 4.85 lbs (lightest AK platform)
- Overall Length: 14.5"
- Muzzle Velocity: ~1,900 fps
- Muzzle Energy: ~985 ft-lbs
- Operating System: Long-stroke gas piston
- Accuracy: 6+ MOA (very poor)
- Sight Radius: ~6" (extremely short)
- Origin: Cugir Arms Factory, Romania

**Distinctive Characteristics:**
- **Massive muzzle flash:** Described as "fire-breathing dragon" - huge fireball from unburned powder
- **Extreme concussion:** "Flashbang effect" clears indoor ranges
- **Violent recoil:** Short gas system + light weight = harsh impulse
- **No stock:** Classified as pistol, two-handed control required

**Game Statistics:**
- Damage: 45 (94% of baseline - minimal loss from short barrel)
- Falloff: 40-120m, 0.32 modifier (steep falloff)
- Accuracy Spread: 2.20 (worst in batch - 6+ MOA)
- Recoil: 0.42 (HIGHEST - extreme muzzle rise)
- Fire Rate: 0.100s TBS (~600 RPM cyclic)
- ADS Time: 0.25s (FASTEST - ultra-compact)
- Effective Range: 150m

**Unique Mechanics:**
- Fastest ADS time of any rifle-caliber weapon
- Highest recoil in rifle category
- Worst accuracy but highest close-range DPS potential
- Excellent barrier penetration despite short barrel
- Should have exaggerated muzzle flash visual effect

---

### 2. CMMG Mk47 Mutant (WEAPON_MK47)

**Precision AK Firepower with AR Ergonomics**

The CMMG Mk47 Mutant represents the pinnacle of 7.62x39mm platform development—a hybrid rifle combining AR-15 ergonomics, modularity, and trigger quality with AK magazine compatibility and 7.62x39 ballistics. Documented sub-2 MOA accuracy makes it roughly twice as precise as standard AK platforms.

**Real-World Specifications:**
- Barrel: 16.1" 4140CM salt bath nitride
- Weight: 7.0 lbs unloaded
- Overall Length: 33" (stock collapsed)
- Muzzle Velocity: 2,350 fps
- Muzzle Energy: ~1,508 ft-lbs
- Operating System: Direct impingement
- Accuracy: 1.0-1.5 MOA (sub-2 MOA documented)
- Magazine: All standard AK magazines (steel, polymer, drums)
- MSRP: $1,949

**The Hybrid Innovation:**
- AR-15 lower: pistol grip, safety, trigger, buffer system
- AK magazine well: rock-in loading, bilateral paddle release
- Oversized bolt carrier (17.2 oz) with S7 tool steel extractor
- Neither AR-15 nor AR-10 parts interchange (proprietary mid-size)

**Why It Shoots Better Than AKs:**
1. Free-floated barrel (vs AK's fixed trunnion)
2. AR-style trigger with cleaner break
3. Tight billet receiver tolerances
4. Modern barrel manufacturing
5. Adjustable stock with consistent cheek weld

**Game Statistics:**
- Damage: 48 (full 7.62x39 performance)
- Falloff: 65-180m, 0.35 modifier
- Accuracy Spread: 0.95 (excellent - sub-2 MOA)
- Recoil: 0.28 (moderate - muzzle brake + buffer)
- Fire Rate: 0.095s TBS (semi-auto)
- ADS Time: 0.40s (standard rifle)
- Effective Range: 350m

**Unique Mechanics:**
- Best accuracy of any 7.62x39 weapon
- Moderate recoil despite powerful caliber
- Premium tier pricing justifies superior stats
- AR-style controls and handling characteristics
- Compatible with various finish options (black, FDE, ODG)

---

## Ammunition System: 7.62x39mm

All 7.62x39mm weapons use unified ammunition for inventory simplicity.

### Ammunition Types

| Type | Game Name | Base Modifier | Armor Pen | Notes |
|------|-----------|---------------|-----------|-------|
| Hunting/Expanding | 7.62x39 SP | +15% soft target, -40% barrier | 0.20 | Hornady SST, Federal Fusion |
| Military Standard | 7.62x39 FMJ | Baseline (1.0x) | 0.38 | M43/M67 equivalent |
| Armor Piercing | 7.62x39 AP | -10% soft target, +50% armor | 0.60 | 7N23 BP equivalent |

### Ammunition Performance Details

**Civilian Expanding (Soft Point)**
- Hornady SST, Federal Fusion, Winchester Deer Season
- Maximum expansion for soft tissue damage
- Poor barrier penetration (jacket separation)
- Effective for unarmored targets
- Damage: 1.15x vs soft targets, 0.60x through barriers

**Military Standard (FMJ - Baseline)**
- Soviet M43 (steel core): Stable penetration, minimal yaw
- Yugoslav M67 (lead core): Earlier yaw, better terminal effect
- Consistent performance across all ranges
- Good barrier penetration
- Baseline damage multiplier

**Armor Piercing (7N23 BP)**
- Tool steel penetrator core
- 3x penetration vs standard rounds
- Defeats soft body armor at range
- Reduced soft tissue damage (no expansion)
- Damage: 0.90x vs soft targets, 1.50x vs armor

---

## Shots-to-Kill Analysis (100 HP Target)

### Close Range (Full Damage)

| Weapon | Body Shots | Headshots |
|--------|------------|-----------|
| Micro Draco (45 dmg) | 3 shots | 1 shot |
| Mk47 Mutant (48 dmg) | 3 shots | 1 shot |

### Maximum Range (With Falloff)

| Weapon | Min Damage | Body Shots | Headshots |
|--------|------------|------------|-----------|
| Micro Draco | 14.4 | 7 shots | 3 shots |
| Mk47 Mutant | 16.8 | 6 shots | 2-3 shots |

---

## Platform Comparison

### Micro Draco vs Mk47 Mutant

| Attribute | Micro Draco | Mk47 Mutant | Winner |
|-----------|-------------|-------------|--------|
| **Damage** | 45 | 48 | Mk47 |
| **Accuracy** | 2.20 (6+ MOA) | 0.95 (sub-2 MOA) | Mk47 |
| **Recoil** | 0.42 (extreme) | 0.28 (moderate) | Mk47 |
| **ADS Time** | 0.25s | 0.40s | Draco |
| **Range** | 150m | 350m | Mk47 |
| **Mobility** | Excellent | Good | Draco |
| **CQB** | Dominant | Good | Draco |
| **Mid-Range** | Poor | Excellent | Mk47 |

### Use Case Recommendations

**Choose Micro Draco when:**
- Engaging at close range (<50m)
- Mobility is priority
- Ambush/surprise attacks
- Vehicle operations
- Maximum concealment needed

**Choose Mk47 Mutant when:**
- Engaging at medium range (50-200m)
- Accuracy matters
- Sustained firefights
- Barrier penetration required
- Premium loadout justified

---

## Stat Rankings

### Damage (7.62x39 vs 5.56)
1. Mk47 Mutant: 48 (7.62x39 full)
2. Micro Draco: 45 (7.62x39 short barrel)
3. M16A4: 42 (5.56 NATO full)
4. Steyr AUG: 42 (5.56 NATO full)
5. PSA AR-15: 39 (5.56 NATO 16")
6. CZ BREN: 38 (5.56 NATO 14")

### Recoil (Lowest to Highest - Rifles Only)
1. CZ BREN: 0.16
2. Steyr AUG: 0.18
3. M16A4: 0.20
4. IWI Tavor: 0.21
5. Desert AR-15: 0.23
6. PSA AR-15: 0.26
7. **Mk47 Mutant: 0.28**
8. **Micro Draco: 0.42** (HIGHEST)

### Accuracy (Best to Worst)
1. M16A4: 0.80
2. Steyr AUG: 0.90
3. **Mk47 Mutant: 0.95**
4. CZ BREN: 1.00
5. Desert AR-15: 1.05
6. IWI Tavor: 1.05
7. PSA AR-15: 1.20
8. **Micro Draco: 2.20** (WORST)

### ADS Time (Fastest to Slowest)
1. **Micro Draco: 0.25s** (FASTEST)
2. Red AUG / CZ BREN: 0.32s
3. RAM 7 Knight: 0.33s
4. Desert AR-15: 0.36s
5. PSA AR-15: 0.38s
6. **Mk47 Mutant: 0.40s**
7. M16: 0.45s

---

## Comparison: 7.62x39 vs 5.56 NATO

| Characteristic | 7.62x39mm | 5.56 NATO |
|----------------|-----------|-----------|
| **Base Damage** | 48 | 42 |
| **Bullet Weight** | 123gr | 55-62gr |
| **Muzzle Velocity** | 2,350 fps | 3,100 fps |
| **Muzzle Energy** | 1,508 ft-lbs | 1,282 ft-lbs |
| **Recoil** | Higher (+40%) | Lower |
| **Accuracy** | Lower (3-4 MOA typical) | Higher (1.5-2 MOA) |
| **Effective Range** | 300m | 500m+ |
| **Short Barrel Performance** | Excellent | Poor |
| **Barrier Penetration** | Superior | Moderate |

### Why 7.62x39 Should Deal More Damage

1. **Energy advantage:** 16-25% more muzzle energy
2. **Mass advantage:** 2x heavier bullet = more momentum
3. **Diameter advantage:** 38% wider = larger wound channel
4. **Consistency:** Doesn't rely on fragmentation velocity threshold
5. **Historical context:** Designed for close-medium combat effectiveness

---

## Audio/Visual Implementation Notes

### Micro Draco
- **Muzzle Flash:** MASSIVE - implement exaggerated fireball effect
- **Sound:** Sharp crack with heavy bass concussion, echo
- **Reload:** AK rock-and-lock magazine motion
- **Recoil Animation:** Significant muzzle rise, recovery delay
- **Idle:** Compact stance, one or two-handed options

### Mk47 Mutant
- **Muzzle Flash:** Moderate - muzzle brake vents gas sideways
- **Sound:** Deep, controlled report with brake signature
- **Reload:** AR charging handle + AK magazine paddle release hybrid
- **Recoil Animation:** Controlled rise, quick recovery
- **Finish Options:** Black, Charcoal Green, Coyote Tan, Midnight Bronze, Tungsten

---

## Installation

1. Extract each weapon folder to your server's `resources` directory
2. Add 3D model files (.ydr, .ytd) to each weapon's `stream/` folder
3. Add to `server.cfg`:
```
ensure weapon_mini_ak47
ensure weapon_mk47
```
4. Register weapons with ox_inventory or your inventory system
5. Create ammunition items for 7.62x39mm variants

---

## Caliber Hierarchy Position

| Caliber | Baseline Damage | Role |
|---------|-----------------|------|
| .22 LR | 18 | Training/Pest control |
| .32 ACP | 22 | Pocket pistols |
| .380 ACP | 26 | Compact backup |
| 9mm Luger | 34 | Pistol standard |
| .40 S&W | 36 | Enhanced pistol |
| .45 ACP | 38 | Heavy pistol |
| 5.56 NATO | 42 | Light rifle standard |
| .357 Magnum | 44 | Magnum revolver |
| 10mm Auto | 46 | Power pistol |
| **7.62x39mm** | **48** | **Intermediate rifle** |
| .44 Magnum | 52 | Heavy magnum |
| 7.62 NATO/.308 | 55+ | Battle rifle (future) |

---

## Version History

- **v1.0.0** - Initial release with 2 rifle platforms
  - Micro Draco (6.25" compact AK pistol)
  - CMMG Mk47 Mutant (16" precision hybrid)
