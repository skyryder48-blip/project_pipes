# Batch 15: 9mm SMGs & Pistol-Caliber Carbines - FiveM Weapon Meta Reference

## Overview

Batch 15 marks the beginning of Phase 3 (SMGs), introducing seven 9mm submachine gun and pistol-caliber carbine platforms. These weapons share the same caliber as the pistol baseline (9mm = 34 damage) but gain advantages from longer barrels, stocks/braces for stability, and in some cases automatic fire capability.

**Caliber:** 9x19mm Parabellum (all weapons)
**Damage Range:** 36-43 (barrel length dependent)
**Key Advantages Over Pistols:** Accuracy, controllability, effective range, fire rate (select weapons)

---

## Quick Reference Table

| Weapon | Real-World Model | Barrel | Damage | Fire Mode | RPM | Recoil | Accuracy | Range |
|--------|------------------|--------|--------|-----------|-----|--------|----------|-------|
| Micro MP5 | H&K MP5K | 4.53" | 37 | Full-Auto | 900 | 0.14 | 1.20 | 80m |
| SIG MPX | SIG MPX K | 4.5" | 37 | Full-Auto | 850 | 0.12 | 1.15 | 95m |
| Scorpion | CZ Scorpion EVO 3 | 7.72" | 42 | Full-Auto | **1,150** | 0.20 | 1.35 | 120m |
| TEC-9 | Intratec TEC-9 | 5" | 36 | Semi-Only | - | 0.28 | **2.80** | 60m |
| MPA30 | MasterPiece Arms MPA30 | 5.5" | 37 | Semi-Only | - | 0.22 | 1.65 | 75m |
| RAM 9 Desert | AR-9 Platform | 8" | 43 | Semi-Only | - | 0.18 | **1.05** | 140m |
| SUB-2000 | Kel-Tec SUB-2000 | 16.25" | 41* | Semi-Only | - | 0.22 | 1.25 | 175m |

*SUB-2000 damage reduced 12% per request (47 → 41)

---

## Operating System Comparison

The operating system significantly affects felt recoil and shooting characteristics:

| System | Weapons | Recoil Feel | Advantages |
|--------|---------|-------------|------------|
| **Gas Piston** | SIG MPX | Smoothest | Lighter bolt, suppressor-optimized |
| **Roller-Delayed** | MP5K | Very Smooth | Spreads impulse over time |
| **Simple Blowback** | Scorpion, TEC-9, MPA30, AR-9, SUB-2000 | Snappy | Simple, reliable, economical |

**Recoil Hierarchy (Best to Worst):**
1. SIG MPX (0.12) - Gas piston
2. MP5K (0.14) - Roller-delayed
3. RAM 9 Desert (0.18) - Stable AR platform
4. Scorpion EVO 3 (0.20) - High RPM blowback
5. MPA30 / SUB-2000 (0.22) - Standard blowback
6. TEC-9 (0.28) - Light weight, crude design

---

## Detailed Weapon Profiles

### 1. H&K MP5K (WEAPON_MICRO_MP5)

**The Premium Compact SMG Standard**

The MP5K represents the gold standard for compact submachine guns. Its roller-delayed blowback system spreads the recoil impulse over a longer period, creating the legendary "soft push" that makes controlled automatic fire possible even from a tiny 4.5" barrel package.

**Real-World Specifications:**
- Barrel: 4.53" (115mm)
- Weight: 4.4 lbs empty
- Overall Length: 12.60"
- Muzzle Velocity: ~1,150-1,200 fps
- Fire Rate: 900 RPM
- Operating System: Roller-delayed blowback
- Origin: Germany (1976)

**Game Statistics:**
- Damage: 37
- Falloff: 25-70m, 0.35 modifier
- Accuracy Spread: 1.20
- Recoil: 0.14 (LOW - roller-delayed)
- Fire Rate: 0.067s TBS (900 RPM)
- ADS Time: 0.28s
- Effective Range: 80m

**Unique Characteristics:**
- Premium quality - best controllability of compact SMGs
- Fires from closed bolt (better first-shot accuracy)
- Smooth automatic fire even at 900 RPM
- VIP protection / special operations weapon

---

### 2. SIG MPX (WEAPON_SIG_MPX)

**Gas Piston Innovation for 9mm**

The SIG MPX is the only 9mm SMG using a short-stroke gas piston system - the same operating principle as rifle-caliber platforms. This allows a 42% lighter bolt while maintaining reliability, producing the smoothest shooting experience in the entire batch.

**Real-World Specifications:**
- Barrel: 4.5" (MPX K configuration)
- Weight: 5.0 lbs empty
- Overall Length: 22.25" / 14.5" folded
- Muzzle Velocity: ~1,200-1,250 fps
- Fire Rate: 850 RPM
- Operating System: Short-stroke gas piston
- MSRP: $1,800-2,200

**Game Statistics:**
- Damage: 37
- Falloff: 28-75m, 0.34 modifier
- Accuracy Spread: 1.15
- Recoil: 0.12 (LOWEST)
- Fire Rate: 0.071s TBS (850 RPM)
- ADS Time: 0.28s
- Effective Range: 95m

**Unique Characteristics:**
- Smoothest recoil of ANY 9mm platform
- Best suppressor compatibility (gas doesn't cycle through action)
- Fires while folded (no buffer tube)
- AR-familiar controls
- Rotating bolt like a rifle

---

### 3. CZ Scorpion EVO 3 (WEAPON_SCORPION)

**High-RPM Budget Performer**

The Scorpion EVO 3 delivers impressive capability at one-third the cost of premium competitors. Its defining characteristic is the exceptionally high 1,150 RPM cyclic rate - nearly double the Uzi despite similar bolt weights. This creates devastating close-range firepower but challenges controllability.

**Real-World Specifications:**
- Barrel: 7.72" (S1 pistol variant)
- Weight: 5.0 lbs empty
- Overall Length: 16.35" / 26.1" extended
- Muzzle Velocity: ~1,180-1,234 fps
- Fire Rate: 1,150 RPM (HIGHEST!)
- Operating System: Simple blowback
- MSRP: $850-1,000

**Game Statistics:**
- Damage: 42 (longer barrel advantage)
- Falloff: 35-95m, 0.32 modifier
- Accuracy Spread: 1.35
- Recoil: 0.20 (moderate)
- Fire Rate: 0.052s TBS (1,150 RPM - FASTEST)
- ADS Time: 0.30s
- Effective Range: 120m

**Unique Characteristics:**
- HIGHEST fire rate in batch
- Budget-friendly price point
- Longer barrel = higher damage than compact SMGs
- Czech military adopted
- Heavy factory trigger (needs upgrade)

---

### 4. Intratec TEC-9 (WEAPON_TEC9)

**Notorious for All the Wrong Reasons**

The TEC-9 became a cultural icon despite being genuinely unreliable and inaccurate. Its aggressive appearance belies crude manufacturing - shallow rifling, welded-in-place sights, and feeding issues make it a "spray and pray" weapon at best.

**Real-World Specifications:**
- Barrel: 5" (threaded)
- Weight: 3.1 lbs empty
- Overall Length: 12.5"
- Muzzle Velocity: ~1,181 fps
- Fire Rate: Semi-auto only (civilian)
- Operating System: Closed-bolt blowback
- Historical Price: $150-350 (budget tier)

**Game Statistics:**
- Damage: 36 (poor quality penalty)
- Falloff: 18-55m, 0.28 modifier (STEEP)
- Accuracy Spread: 2.80 (WORST)
- Recoil: 0.28 (HIGH)
- Fire Rate: 0.095s TBS (semi-auto)
- ADS Time: 0.32s
- Effective Range: 60m (SHORTEST)

**Unique Characteristics:**
- WORST accuracy in batch
- Notorious unreliability (feeds FMJ better than HP)
- Large magazine capacity (32 rounds)
- Light weight enables fast movement
- "Spray and pray" only realistic option
- Criminal/street association

---

### 5. MasterPiece Arms MPA30 (WEAPON_MPA30)

**The TEC-9 Done Right**

MasterPiece Arms built its reputation as "the company that fixed the MAC-10," and the MPA30 applies that philosophy to 9mm. Where the TEC-9 used stamped steel and molded polymer, MPA employs CNC-machined aluminum with consistent tolerances.

**Real-World Specifications:**
- Barrel: 5.5" (threaded)
- Weight: 3.44 lbs (55 oz) empty
- Overall Length: ~12"
- Muzzle Velocity: ~1,175-1,200 fps
- Fire Rate: Semi-auto only
- Operating System: Blowback
- MSRP: $540-750

**Game Statistics:**
- Damage: 37
- Falloff: 22-65m, 0.32 modifier
- Accuracy Spread: 1.65 (much better than TEC-9)
- Recoil: 0.22 (moderate)
- Fire Rate: 0.100s TBS (semi-auto)
- ADS Time: 0.30s
- Effective Range: 75m

**Unique Characteristics:**
- Significantly better than TEC-9 in all aspects
- CNC-machined aluminum construction
- Adjustable sights (vs TEC-9's fixed crude sights)
- Proper trigger with disconnect
- Accessory-ready (rails, threaded barrel)
- Multi-caliber options available

---

### 6. AR-9 Platform / RAM 9 Desert (WEAPON_RAM9_DESERT)

**Precision 9mm with AR Ergonomics**

The AR-9 adapts the proven AR-15 platform to 9mm, leveraging the rifle's excellent ergonomics, trigger options, and accuracy potential. This creates the most accurate 9mm platform in the batch despite the heavier bolt required for blowback operation.

**Real-World Specifications:**
- Barrel: 8" (typical SBR/pistol configuration)
- Weight: 5.2 lbs empty
- Overall Length: ~28"
- Muzzle Velocity: ~1,230-1,250 fps
- Fire Rate: Semi-auto only (civilian)
- Operating System: Direct blowback
- Price: $500-1,500 (varies by tier)

**Game Statistics:**
- Damage: 43 (8" barrel advantage)
- Falloff: 40-110m, 0.34 modifier
- Accuracy Spread: 1.05 (BEST)
- Recoil: 0.18 (low - stable platform)
- Fire Rate: 0.095s TBS (semi-auto)
- ADS Time: 0.32s
- Effective Range: 140m

**Unique Characteristics:**
- BEST ACCURACY in batch
- Familiar AR-15 controls
- Longest sight radius
- Highly customizable
- Accepts AR triggers, furniture, accessories
- Glock magazine compatibility (33 rounds)

---

### 7. Kel-Tec SUB-2000 (WEAPON_SUB2000)

**Maximum Portability, Maximum Velocity**

The SUB-2000's signature feature is folding completely in half to 16.25" × 7" - fitting in backpacks or vehicle compartments. Its 16.25" barrel extracts maximum velocity from 9mm, though the heavy trigger and budget construction limit its potential.

**Real-World Specifications:**
- Barrel: 16.25" (carbine length)
- Weight: 4.25 lbs empty (LIGHTEST!)
- Overall Length: 30.5" / FOLDED: 16.25" × 7"
- Muzzle Velocity: ~1,270-1,317 fps (HIGHEST)
- Fire Rate: Semi-auto only
- Operating System: Simple blowback
- MSRP: $578-621 (budget tier)

**Game Statistics:**
- Damage: 41 (47 reduced 12% per request)
- Falloff: 50-140m, 0.36 modifier
- Accuracy Spread: 1.25
- Recoil: 0.22 (moderate-high)
- Fire Rate: 0.105s TBS (heavy trigger)
- ADS Time: 0.34s
- Effective Range: 175m (LONGEST)

**Unique Characteristics:**
- FOLDS IN HALF for concealment/transport
- Lightest weight in batch
- Highest velocity (16.25" barrel)
- Shares magazines with Glock sidearm
- Heavy trigger (9.5 lbs factory)
- Budget construction
- Extended effective range

---

## Barrel Length vs Damage Scaling

| Barrel Length | Velocity (124gr) | Energy | Damage |
|---------------|------------------|--------|--------|
| 4" (pistol baseline) | ~1,061 fps | ~333 ft-lbs | 34 |
| 4.5" (MP5K/MPX) | ~1,150 fps | ~364 ft-lbs | 37 |
| 5" (TEC-9) | ~1,115 fps | ~342 ft-lbs | 36* |
| 5.5" (MPA30) | ~1,130 fps | ~352 ft-lbs | 37 |
| 7.72" (Scorpion) | ~1,180 fps | ~383 ft-lbs | 42 |
| 8" (AR-9) | ~1,200 fps | ~396 ft-lbs | 43 |
| 16.25" (SUB-2000) | ~1,270 fps | ~444 ft-lbs | 41** |

*TEC-9 reduced due to poor quality
**SUB-2000 reduced 12% per balance request

---

## Shots-to-Kill Analysis (100 HP Target)

### Close Range (Full Damage)

| Weapon | Body Shots | Headshots |
|--------|------------|-----------|
| All SMGs (36-43 dmg) | 3 shots | 1-2 shots |

### Maximum Range (With Falloff)

| Weapon | Min Damage | Body Shots | Headshots |
|--------|------------|------------|-----------|
| TEC-9 (36 × 0.28) | 10.1 | 10 shots | 4 shots |
| MP5K (37 × 0.35) | 13.0 | 8 shots | 3 shots |
| Scorpion (42 × 0.32) | 13.4 | 8 shots | 3 shots |
| RAM 9 (43 × 0.34) | 14.6 | 7 shots | 3 shots |
| SUB-2000 (41 × 0.36) | 14.8 | 7 shots | 3 shots |

---

## Platform Comparison Matrix

### Automatic Fire Weapons

| Weapon | RPM | Time to Empty (30rd) | Damage per Second |
|--------|-----|----------------------|-------------------|
| **Scorpion EVO 3** | 1,150 | 1.56s | **808 DPS** |
| MP5K | 900 | 2.01s | 552 DPS |
| SIG MPX | 850 | 2.13s | 521 DPS |

### Semi-Auto Weapons (Practical Fire Rate)

| Weapon | Practical RPM | Accuracy | Best Role |
|--------|---------------|----------|-----------|
| RAM 9 Desert | ~180 | Best | Mid-range precision |
| SUB-2000 | ~170 | Good | Extended range |
| MPA30 | ~180 | Moderate | CQB budget option |
| TEC-9 | ~190 | Poor | Spray suppression |

---

## Stat Rankings

### Damage (Highest to Lowest)
1. RAM 9 Desert: 43
2. Scorpion EVO 3: 42
3. SUB-2000: 41
4. MP5K / SIG MPX / MPA30: 37
5. TEC-9: 36

### Recoil (Lowest to Highest)
1. **SIG MPX: 0.12** (gas piston)
2. MP5K: 0.14 (roller-delayed)
3. RAM 9 Desert: 0.18
4. Scorpion EVO 3: 0.20
5. MPA30 / SUB-2000: 0.22
6. **TEC-9: 0.28** (worst)

### Accuracy (Best to Worst)
1. **RAM 9 Desert: 1.05**
2. SIG MPX: 1.15
3. MP5K: 1.20
4. SUB-2000: 1.25
5. Scorpion EVO 3: 1.35
6. MPA30: 1.65
7. **TEC-9: 2.80** (worst)

### Fire Rate (Automatic Weapons)
1. **Scorpion EVO 3: 0.052s** (1,150 RPM)
2. MP5K: 0.067s (900 RPM)
3. SIG MPX: 0.071s (850 RPM)

### Effective Range
1. **SUB-2000: 175m**
2. RAM 9 Desert: 140m
3. Scorpion EVO 3: 120m
4. SIG MPX: 95m
5. MP5K: 80m
6. MPA30: 75m
7. **TEC-9: 60m**

---

## Ammunition

All weapons in Batch 15 share 9x19mm Parabellum ammunition, simplifying inventory management.

### Ammunition Types

| Type | Damage Mod | Armor Pen | Notes |
|------|------------|-----------|-------|
| FMJ (Standard) | 1.0x | 0.18 | Reliable feeding |
| JHP (Hollow Point) | 1.15x soft target | 0.10 | May cause issues in TEC-9 |
| +P (Overpressure) | 1.08x | 0.22 | Higher velocity |
| Subsonic | 0.85x | 0.15 | Suppressor-optimized |

---

## Quality Tier Summary

| Tier | Weapons | Characteristics |
|------|---------|-----------------|
| **Premium** | MP5K, SIG MPX | Best recoil control, reliable, expensive |
| **Mid** | Scorpion, RAM 9, MPA30 | Good value, solid performance |
| **Budget** | TEC-9, SUB-2000 | Compromises for price, unique features |

---

## Installation

1. Extract each weapon folder to your server's `resources` directory
2. Add 3D model files (.ydr, .ytd) to each weapon's `stream/` folder
3. Add to `server.cfg`:
```
ensure weapon_micro_mp5
ensure weapon_sig_mpx
ensure weapon_scorpion
ensure weapon_tec9
ensure weapon_mpa30
ensure weapon_ram9_desert
ensure weapon_sub2000
```
4. Register weapons with ox_inventory or your inventory system
5. All weapons share 9mm ammunition items

---

## Version History

- **v1.0.0** - Initial release with 7 SMG/PCC platforms
  - H&K MP5K (premium compact SMG)
  - SIG MPX (gas piston SMG)
  - CZ Scorpion EVO 3 (high-RPM SMG)
  - Intratec TEC-9 (budget machine pistol)
  - MasterPiece Arms MPA30 (improved MAC-style)
  - AR-9 Platform / RAM 9 Desert (precision PCC)
  - Kel-Tec SUB-2000 (folding carbine, -12% damage)
