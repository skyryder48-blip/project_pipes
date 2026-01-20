# Batch 12: 5.56/.223 Rifle Platforms - FiveM Weapon Meta Reference

## Overview

Batch 12 marks the transition from pistols to rifles, covering six 5.56×45mm NATO rifle platforms spanning conventional AR-15 designs, military-grade rifles, and modern bullpup configurations. All weapons use the unified "5.56" ammunition type combining both 5.56 NATO and .223 Remington specifications.

**Baseline Damage:** 42 (20" barrel reference)
**Target TTK:** 3 shots close range, 6-7 shots at maximum range (100 HP)

---

## Quick Reference Table

| Weapon | Real-World Model | Barrel | Damage | Velocity | Fire Rate | Recoil | Range |
|--------|------------------|--------|--------|----------|-----------|--------|-------|
| M16 | Colt M16A4 | 20" | 42 | 990 m/s | 0.075 | 0.20 | 600m |
| PSA AR-15 | PSA PA-15 | 16" | 39 | 915 m/s | 0.100 | 0.26 | 450m |
| Desert AR-15 | Mid-Tier AR-15 FDE | 16" | 39 | 915 m/s | 0.095 | 0.23 | 460m |
| Red AUG | Steyr AUG A3 | 20" | 42 | 990 m/s | 0.085 | 0.18 | 580m |
| CZ BREN | CZ BREN 2 | 14" | 38 | 870 m/s | 0.070 | 0.16 | 400m |
| RAM 7 Knight | IWI Tavor | 16.5" | 40 | 922 m/s | 0.078 | 0.21 | 500m |

---

## Barrel Length Damage Scaling

The 5.56 NATO cartridge was optimized for 20" barrels. Shorter barrels lose velocity and terminal effectiveness:

| Barrel Length | Velocity (M193) | Damage % | Applied Damage |
|---------------|-----------------|----------|----------------|
| 20" (M16/AUG) | 3,200-3,280 fps | 100% | 42 |
| 18" (TAR-21) | 3,080-3,130 fps | 97% | 41 |
| 16.5" (Tavor SAR) | 3,000-3,050 fps | 95% | 40 |
| 16" (Civilian AR) | 2,950-3,000 fps | 93% | 39 |
| 14" (BREN 2) | 2,850-2,920 fps | 90% | 38 |

---

## Detailed Weapon Profiles

### 1. Colt M16A4 (WEAPON_M16)

**The Benchmark Military Rifle**

The M16A4 represents the pinnacle of the M16 family with its 20" cold hammer-forged barrel and rifle-length direct impingement gas system. Adopted by the USMC in 2003, it served as standard issue until the M4 transition completed in 2016.

**Real-World Specifications:**
- Barrel: 20" cold hammer-forged, rifle-length gas
- Weight: 7.5 lbs empty / 8.79 lbs loaded
- Overall Length: 39.63"
- Muzzle Velocity: 3,200-3,280 fps (M193)
- Rate of Fire: 700-950 RPM cyclic (3-round burst)
- Effective Range: 550m point / 800m area
- Sight Radius: 19.75" (longest of all platforms)
- Recoil Energy: 3.9 ft-lbs

**Game Statistics:**
- Damage: 42 (baseline)
- Falloff: 80-250m, 0.38 modifier
- Accuracy Spread: 0.80 (best of conventional rifles)
- Recoil: 0.20 (smooth rifle-length gas)
- Fire Rate: 0.075s TBS (~800 RPM)
- ADS Time: 0.45s (slowest - longest weapon)

**Unique Characteristics:**
- Best accuracy due to longest sight radius
- Smoothest recoil from rifle-length gas system
- Longest effective range (600m)
- Slowest handling due to 39.63" overall length

---

### 2. PSA AR-15 (WEAPON_PSA_AR15)

**Budget Civilian Entry Point**

Palmetto State Armory's AR-15 represents the entry-level market at $499-549, delivering mil-spec internals with 99% reliability after break-in. The 16" carbine-length configuration produces snappier recoil and reduced ballistic performance compared to the M16A4.

**Real-World Specifications:**
- Barrel: 16" nitride, carbine-length gas
- Weight: 6.5-6.8 lbs empty
- Overall Length: 32-33"
- Muzzle Velocity: 2,968-3,100 fps (M193)
- Fire Mode: Semi-auto only
- Accuracy: 3-3.5 MOA standard
- Trigger Pull: 6.5-8.5 lbs mil-spec
- Price: $499-549 MSRP

**Game Statistics:**
- Damage: 39 (93% of baseline)
- Falloff: 65-200m, 0.36 modifier
- Accuracy Spread: 1.20 (lowest of batch)
- Recoil: 0.26 (highest - budget quality + carbine gas)
- Fire Rate: 0.100s TBS (semi-auto limitation)
- ADS Time: 0.38s

**Unique Characteristics:**
- Budget tier = worst accuracy and recoil
- Semi-auto only = slowest effective fire rate
- Lightest weight = faster handling
- Most accessible/common civilian variant

---

### 3. Desert AR-15 (WEAPON_DESERT_AR15)

**Mid-Tier FDE Quality**

Representing mid-tier manufacturers like Aero Precision or BCM, this Flat Dark Earth AR-15 offers improved quality over budget options with better triggers, tighter tolerances, and mid-length gas systems for smoother operation.

**Real-World Specifications:**
- Barrel: 16" mid-length gas system
- Weight: 6.8-7.0 lbs empty
- Overall Length: 32-34"
- Muzzle Velocity: 2,968-3,100 fps (M193)
- Accuracy: 2-2.5 MOA (improved quality)
- Price: $800-1,200 range

**Game Statistics:**
- Damage: 39 (93% of baseline)
- Falloff: 68-210m, 0.37 modifier
- Accuracy Spread: 1.05 (improved over PSA)
- Recoil: 0.23 (better quality components)
- Fire Rate: 0.095s TBS
- ADS Time: 0.36s

**Unique Characteristics:**
- Improved accuracy over budget AR-15
- Mid-length gas = smoother than carbine
- Better trigger response
- Tactical desert/FDE aesthetic

---

### 4. Steyr AUG A3 (WEAPON_RED_AUG)

**Austrian Bullpup - Full Power, Compact Package**

The AUG A3 demonstrates bullpup efficiency: its 20" barrel delivers full rifle ballistics in a package measuring just 31.1" overall—8.4" shorter than the M16A4 with identical barrel length. The short-stroke gas piston runs cleaner than direct impingement, and the integrated Swarovski optic provides exceptional glass quality.

**Real-World Specifications:**
- Barrel: 20" in bullpup configuration
- Weight: 7.9 lbs empty / 9.0 lbs loaded
- Overall Length: 31.1" (vs M16's 39.63")
- Muzzle Velocity: 3,200-3,250 fps (M193)
- Rate of Fire: 680-750 RPM
- Operating System: Short-stroke gas piston
- Integrated Optic: 1.5x/3x Swarovski
- Stock Trigger: 9-10 lbs (heavy linkage)

**Game Statistics:**
- Damage: 42 (full 20" barrel performance)
- Falloff: 78-245m, 0.38 modifier
- Accuracy Spread: 0.90 (excellent)
- Recoil: 0.18 (second lowest - piston + bullpup balance)
- Fire Rate: 0.085s TBS (~700 RPM)
- ADS Time: 0.32s (fastest rifle ADS)

**Unique Characteristics:**
- 20" ballistics in 31" package
- Fastest ADS time (compact bullpup handling)
- Second-lowest recoil (piston + rear weight)
- Full effective range despite compact size

---

### 5. CZ BREN 2 (WEAPON_CZ_BREN)

**Czech Modular - Fastest Fire Rate, Lowest Recoil**

The BREN 2 offers unmatched modularity with barrel options from 8" to 16.5" and caliber conversion capability. Its short-stroke gas piston delivers recoil described as "almost comically light"—softer than comparable AR-15s. The Czech Army adopted it in 2016 as the CZ 805 replacement.

**Real-World Specifications:**
- Barrel: 14" (standard military config)
- Weight: 5.86 lbs empty (lightest rifle)
- Overall Length: 35.6" extended / 25.8" folded
- Muzzle Velocity: 2,800-2,900 fps (M193)
- Rate of Fire: 850 RPM ±100 (highest of batch)
- Operating System: Short-stroke gas piston
- Two-Stage Trigger: 3.0-4.5 lbs
- Folding Stock: Yes

**Game Statistics:**
- Damage: 38 (90% of baseline - 14" barrel)
- Falloff: 60-180m, 0.35 modifier
- Accuracy Spread: 1.00 (good)
- Recoil: 0.16 (LOWEST - competition-tuned piston)
- Fire Rate: 0.070s TBS (FASTEST - 850 RPM)
- ADS Time: 0.32s

**Unique Characteristics:**
- HIGHEST fire rate (850 RPM)
- LOWEST recoil of all rifles
- Lightest weight = excellent handling
- Shortest effective range due to 14" barrel
- Folding stock capability

---

### 6. IWI Tavor (WEAPON_RAM7KNIGHT)

**Battle-Proven Israeli Bullpup**

The Tavor family is the IDF's standard infantry weapon, proven in Operation Cast Lead (2008-2009) where it "functioned flawlessly." The long-stroke gas piston (similar to AK-47/Galil) provides extreme reliability in desert conditions at the cost of slightly more reciprocating mass.

**Real-World Specifications:**
- Barrel: 16.5" (civilian SAR/X95 variant)
- Weight: 7.9 lbs (SAR) / 7.0 lbs (X95)
- Overall Length: 26-26.125"
- Muzzle Velocity: 3,000-3,050 fps (M193)
- Rate of Fire: 750-900 RPM
- Operating System: Long-stroke gas piston
- Height Over Bore: ~4" (higher than AR-15's 2.5")
- IDF Service: Since 2006

**Game Statistics:**
- Damage: 40 (95% of baseline - 16.5" barrel)
- Falloff: 70-220m, 0.37 modifier
- Accuracy Spread: 1.05 (good)
- Recoil: 0.21 (moderate - long-stroke mass)
- Fire Rate: 0.078s TBS (~800 RPM)
- ADS Time: 0.33s

**Unique Characteristics:**
- Combat-proven extreme reliability
- Bullpup handling advantage
- Long-stroke = slightly more recoil than AUG
- Most compact overall length (26")
- 20+ countries field Tavor variants

---

## Ammunition System: 5.56 NATO

All rifles use unified "5.56" ammunition combining both 5.56 NATO and .223 Remington specifications for inventory simplicity.

### Ammunition Types

| Type | Game Name | Base Modifier | Armor Pen | Notes |
|------|-----------|---------------|-----------|-------|
| Civilian/Hunting | 5.56 SP | +30% vs unarmored, -80% vs armor | 0.05 | V-MAX, Fusion, Ballistic Tip |
| Military Standard | 5.56 FMJ | Baseline (1.0x) | 0.30 | M193/M855 equivalent |
| Armor Piercing | 5.56 AP | -25% vs unarmored, +150% vs armor | 0.75 | M995 Black Tip equivalent |

### Ammunition Performance Details

**Civilian Expanding (Soft Point / Hunting)**
- Hornady V-MAX, Federal Fusion, Nosler Ballistic Tip
- Maximum expansion for soft tissue damage
- Poor barrier and armor penetration
- Effective on unarmored targets to 200 yards
- Penetration depth: 6-10" (limited by fragmentation)

**Military Standard (FMJ - M855 Baseline)**
- M193 (55gr): 3,250 fps, fragments above 2,500 fps
- M855 (62gr): 3,000 fps, steel penetrator core
- Fragmentation range: ~150-200 yards from 20" barrel
- Consistent performance against most targets

**Armor Piercing (M995 Black Tip)**
- 52gr tungsten carbide penetrator
- Defeats Level III body armor
- Penetrates 12mm RHA at 100m
- Reduced soft tissue performance (no expansion)
- Extremely rare ($20-70+ per round)

---

## Shots-to-Kill Analysis (100 HP Target)

### Close Range (Full Damage)

| Weapon | Body Shots | Headshots |
|--------|------------|-----------|
| M16 (42 dmg) | 3 shots | 1 shot |
| Red AUG (42 dmg) | 3 shots | 1 shot |
| RAM 7 Knight (40 dmg) | 3 shots | 1 shot |
| PSA AR-15 (39 dmg) | 3 shots | 1 shot |
| Desert AR-15 (39 dmg) | 3 shots | 1 shot |
| CZ BREN (38 dmg) | 3 shots | 1 shot |

### Maximum Range (With Falloff)

| Weapon | Min Damage | Body Shots | Headshots |
|--------|------------|------------|-----------|
| M16 | 15.96 | 7 shots | 2-3 shots |
| Red AUG | 15.96 | 7 shots | 2-3 shots |
| RAM 7 Knight | 14.80 | 7 shots | 2-3 shots |
| PSA AR-15 | 14.04 | 8 shots | 3 shots |
| Desert AR-15 | 14.43 | 7 shots | 3 shots |
| CZ BREN | 13.30 | 8 shots | 3 shots |

---

## Stat Rankings

### Damage (Barrel Length Dependent)
1. M16 / Red AUG: 42 (20" barrels)
2. RAM 7 Knight: 40 (16.5" barrel)
3. PSA AR-15 / Desert AR-15: 39 (16" barrels)
4. CZ BREN: 38 (14" barrel)

### Fire Rate (Fastest to Slowest)
1. CZ BREN: 0.070s (850 RPM) - FASTEST
2. M16: 0.075s (800 RPM)
3. RAM 7 Knight: 0.078s (770 RPM)
4. Red AUG: 0.085s (705 RPM)
5. Desert AR-15: 0.095s (630 RPM)
6. PSA AR-15: 0.100s (600 RPM) - SLOWEST

### Recoil (Lowest to Highest)
1. CZ BREN: 0.16 - LOWEST (competition piston)
2. Red AUG: 0.18 (bullpup + short-stroke)
3. M16: 0.20 (rifle-length DI)
4. RAM 7 Knight: 0.21 (long-stroke)
5. Desert AR-15: 0.23 (mid-tier quality)
6. PSA AR-15: 0.26 - HIGHEST (budget + carbine gas)

### Accuracy (Best to Worst)
1. M16: 0.80 (longest sight radius)
2. Red AUG: 0.90 (integrated optic)
3. CZ BREN: 1.00 (quality trigger)
4. Desert AR-15: 1.05 (mid-tier)
5. RAM 7 Knight: 1.05 (bullpup linkage)
6. PSA AR-15: 1.20 (budget quality)

### Effective Range
1. M16: 600m (20" optimal)
2. Red AUG: 580m (20" bullpup)
3. RAM 7 Knight: 500m (16.5" bullpup)
4. Desert AR-15: 460m (16" mid-tier)
5. PSA AR-15: 450m (16" budget)
6. CZ BREN: 400m (14" compact)

### ADS Time (Fastest to Slowest)
1. Red AUG / CZ BREN: 0.32s (compact/bullpup)
2. RAM 7 Knight: 0.33s (bullpup)
3. Desert AR-15: 0.36s
4. PSA AR-15: 0.38s
5. M16: 0.45s (longest weapon)

---

## Platform Comparison: Conventional vs Bullpup

### Conventional (M16, PSA AR-15, Desert AR-15)

**Advantages:**
- Better trigger characteristics (direct linkage)
- Easier magazine changes (closer to hands)
- Lower learning curve
- More aftermarket support

**Disadvantages:**
- Longer overall length for same barrel
- Weight distributed forward
- Slower handling in CQB

### Bullpup (AUG, Tavor)

**Advantages:**
- Compact package with full-length barrel
- Better balance (weight over shoulder)
- Superior CQB handling
- Faster ADS time

**Disadvantages:**
- Heavier/longer trigger pull due to linkage
- Ejection port near face (training consideration)
- Slower magazine changes
- Higher height-over-bore

### Piston vs Direct Impingement

| Feature | Direct Impingement (M16, AR-15) | Short-Stroke Piston (AUG, BREN) | Long-Stroke Piston (Tavor) |
|---------|-------------------------------|--------------------------------|---------------------------|
| Recoil | Smooth, predictable | Softest impulse | Slightly heavier |
| Reliability | Good (requires maintenance) | Excellent (runs cleaner) | Extreme (AK-level) |
| Weight | Lightest | Moderate | Heaviest |
| Complexity | Simplest | Moderate | Moderate |
| Heat | Receiver heats up | Receiver stays cool | Receiver stays cool |

---

## Installation

1. Extract each weapon folder to your server's `resources` directory
2. Add 3D model files (.ydr, .ytd) to each weapon's `stream/` folder
3. Add to `server.cfg`:
```
ensure weapon_m16
ensure weapon_psa_ar15
ensure weapon_desert_ar15
ensure weapon_red_aug
ensure weapon_cz_bren
ensure weapon_ram7knight
```
4. Register weapons with ox_inventory or your inventory system
5. Create ammunition items for 5.56 variants

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
| **5.56 NATO** | **42** | **Rifle standard** |
| .357 Magnum | 44 | Magnum revolver |
| 10mm Auto | 46 | Power pistol |
| .44 Magnum | 52 | Heavy magnum |
| 7.62 NATO | 55+ | Battle rifle (future) |

---

## Version History

- **v1.0.0** - Initial release with 6 rifle platforms
  - M16A4 (benchmark military)
  - PSA AR-15 (budget civilian)
  - Desert AR-15 (mid-tier civilian)
  - Steyr AUG A3 (Austrian bullpup)
  - CZ BREN 2 (Czech modular)
  - IWI Tavor (Israeli bullpup)
