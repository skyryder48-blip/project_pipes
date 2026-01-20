# Batch 16: .45 ACP SMGs - MAC Platform Variants - FiveM Weapon Meta Reference

## Overview

Batch 16 continues Phase 3 (SMGs) with two .45 ACP MAC-platform weapons representing opposite ends of the controllability spectrum. The classic **Ingram MAC-10** delivers devastating firepower at an extraordinary 1,100 RPM but with severe accuracy penalties, while the modernized **MAC-4A1** (based on Lage Manufacturing slow-fire uppers) trades raw cyclic rate for controllability and precision.

**Caliber:** .45 ACP (both weapons)
**Design Philosophy:** Same cartridge, opposite roles - chaos vs. control

---

## Quick Reference Table

| Weapon | Real-World Basis | Barrel | Damage | Fire Rate | RPM | Recoil | Accuracy | Range |
|--------|------------------|--------|--------|-----------|-----|--------|----------|-------|
| MAC-10 | Ingram MAC-10 | 5.75" | 40 | 0.055s | **1,100** | **0.38** | **2.80** | 70m |
| MAC-4A1 | Lage MAX-10/45 mk2 | 9" | 42 | 0.092s | 650 | 0.22 | 1.45 | 110m |

---

## .45 ACP from SMG Barrels

### Velocity by Barrel Length

| Barrel Length | Velocity (230gr) | Energy | % of Maximum |
|---------------|------------------|--------|--------------|
| 4" (pistol baseline) | ~830 fps | 352 ft-lbs | 76% |
| 5" (Government 1911) | ~860 fps | 378 ft-lbs | 82% |
| **5.75" (MAC-10)** | **~890 fps** | **405 ft-lbs** | **87%** |
| **9" (MAC-4A1)** | **~920 fps** | **432 ft-lbs** | **93%** |
| 14-15" (maximum) | ~989 fps | 500 ft-lbs | 100% |

**Key Finding:** .45 ACP reaches maximum velocity around 14-15" barrel length, after which bore friction exceeds remaining gas pressure. The practical SMG sweet spot is 8-10 inches.

### .45 ACP vs 9mm SMG Comparison

| Parameter | .45 ACP (9" barrel) | 9mm (8" barrel) |
|-----------|---------------------|-----------------|
| Velocity | 920 fps | 1,280 fps |
| Energy | 432 ft-lbs | 451 ft-lbs |
| Momentum | 0.925 lb-s | 0.621 lb-s |
| **Supersonic?** | **No (always subsonic)** | Yes (sonic crack) |
| Projectile diameter | .452" | .355" |
| Recoil energy | ~3.5 ft-lbs | ~1.7 ft-lbs |

**.45 ACP Advantages:**
- 49% more momentum = superior "stopping power"
- 27% larger wound channel
- Permanently subsonic = no sonic crack with suppressor
- Heavier bullet retains energy better at range

---

## Detailed Weapon Profiles

### 1. Ingram MAC-10 (WEAPON_MAC10)

**The Iconic Bullet Hose**

Gordon Ingram's 1964 design became the defining "machine pistol" of action cinema despite limited military adoption. Its extraordinary cyclic rate empties a 30-round magazine in under 1.7 seconds, making controlled fire nearly impossible without extensive training or aftermarket modifications.

**Real-World Specifications:**
- Caliber: .45 ACP
- Barrel: 5.75" (146mm)
- Weight: 6.26 lbs empty
- Overall Length: 11.6" collapsed / 21.6" extended
- Muzzle Velocity: ~890 fps (230gr FMJ)
- Muzzle Energy: ~405 ft-lbs
- Fire Rate: ~1,090-1,100 RPM
- Operating System: Open-bolt blowback
- Magazine: 30 round (M3 Grease Gun compatible)
- Origin: Military Armament Corporation (1964)

**Why Limited Military Adoption:**
David Steele (1970s IACP researcher) described the MAC series as "fit only for combat in a phone booth." The British SAS evaluated it for the 1980 Iranian Embassy siege but selected the MP5 instead—a pattern repeated by military organizations globally.

**Game Statistics:**
- Damage: 40
- Falloff: 18-55m, 0.25 modifier (STEEP)
- Accuracy Spread: 2.80 (VERY POOR)
- Recoil: 0.38 (EXTREME)
- Recoil Recovery: 0.32 (SLOW)
- Fire Rate: 0.055s TBS (~1,100 RPM)
- ADS Time: 0.26s (fast - compact)
- Effective Range: 70m

**Unique Characteristics:**
- **HIGHEST FIRE RATE** of any SMG (~1,100 RPM)
- Empties 30-round magazine in **1.65 seconds**
- Severe muzzle climb makes sustained accuracy impossible
- Devastating in CQB ambush scenarios
- Useless beyond 20-25 meters
- Criminal/action movie aesthetic
- Suppressor-ready (subsonic .45 ACP)

**Theoretical vs Practical DPS:**
- Theoretical: 40 × 18.3 rps = **733 DPS**
- Practical: Severe accuracy penalties mean actual damage plummets beyond contact distance

---

### 2. MAC-4A1 (WEAPON_MAC4A1)

**The Professional's Upgrade**

Based on Lage Manufacturing's MAX-10/45 mk2 upper receiver, the MAC-4A1 represents what the MAC-10 could have been with modern engineering. The slow-fire upper reduces cyclic rate from ~1,100 RPM to ~650 RPM through heavier bolt assemblies with extended travel, transforming an uncontrollable bullet hose into a competitive submachine gun.

**Real-World Basis (Lage MAX-10/45 mk2):**
- Caliber: .45 ACP
- Barrel: 9" threaded (5/8-24)
- Weight: ~5.5 lbs empty (aluminum upper)
- Overall Length: ~15" collapsed / ~22" extended
- Muzzle Velocity: ~920 fps (230gr FMJ)
- Muzzle Energy: ~432 ft-lbs
- Fire Rate: ~650-700 RPM (slow-fire upper)
- Features: Full-length Picatinny rail, improved sights
- Upper MSRP: ~$985

**Lage Manufacturing Achievement:**
Richard Lage won the 2004 Arizona State Subgun Match using his products, demonstrating that upgraded MACs can compete with Uzis and MP5s in practical shooting competitions.

**Game Statistics:**
- Damage: 42 (longer barrel advantage)
- Falloff: 30-85m, 0.35 modifier
- Accuracy Spread: 1.45 (GOOD)
- Recoil: 0.22 (MODERATE)
- Recoil Recovery: 0.55 (GOOD)
- Fire Rate: 0.092s TBS (~650 RPM)
- ADS Time: 0.30s
- Effective Range: 110m

**Unique Characteristics:**
- **CONTROLLED FIRE RATE** (~650 RPM vs 1,100)
- Dramatically improved accuracy over stock MAC-10
- Extended barrel = +2 damage
- Full Picatinny rail for optics/accessories
- Rewards trigger discipline and aimed fire
- Professional tactical tool vs. gangster spray weapon
- Still suppressor-optimized (subsonic .45 ACP)

**Theoretical vs Practical DPS:**
- Theoretical: 42 × 10.9 rps = **458 DPS**
- Practical: Consistent hit probability delivers superior real-world damage

---

## Platform Comparison

### MAC-10 vs MAC-4A1: Same Caliber, Different Roles

| Attribute | MAC-10 | MAC-4A1 | Winner |
|-----------|--------|---------|--------|
| Damage | 40 | 42 | MAC-4A1 |
| Fire Rate | 1,100 RPM | 650 RPM | MAC-10 (raw) |
| Accuracy | 2.80 (poor) | 1.45 (good) | MAC-4A1 |
| Recoil | 0.38 (extreme) | 0.22 (moderate) | MAC-4A1 |
| Effective Range | 70m | 110m | MAC-4A1 |
| CQB Burst DPS | 733 theoretical | 458 theoretical | MAC-10 |
| Practical DPS | Low (misses) | Higher (hits) | MAC-4A1 |
| Controllability | Nearly impossible | Manageable | MAC-4A1 |
| Aesthetic | Criminal/chaotic | Professional/tactical | Preference |

### Use Case Recommendations

**Choose MAC-10 when:**
- Engaging at point-blank range (<10m)
- Ambush/surprise attack scenarios
- Suppressive fire (volume over accuracy)
- Criminal roleplay aesthetic
- Accepting high risk/high reward playstyle

**Choose MAC-4A1 when:**
- Engaging at typical SMG ranges (15-50m)
- Accuracy matters
- Ammunition conservation important
- Professional/tactical roleplay
- Consistent performance preferred

---

## Comparison to 9mm SMGs (Batch 15)

### .45 ACP MAC vs 9mm Alternatives

| Weapon | Caliber | Damage | RPM | Recoil | Accuracy | Role |
|--------|---------|--------|-----|--------|----------|------|
| **MAC-10** | .45 ACP | 40 | 1,100 | 0.38 | 2.80 | CQB spray |
| **MAC-4A1** | .45 ACP | 42 | 650 | 0.22 | 1.45 | Tactical .45 |
| MP5K | 9mm | 37 | 900 | 0.14 | 1.20 | Premium compact |
| SIG MPX | 9mm | 37 | 850 | 0.12 | 1.15 | Smoothest recoil |
| CZ Scorpion | 9mm | 42 | 1,150 | 0.20 | 1.35 | High-RPM 9mm |

**Key Observations:**
- MAC-10 has higher damage than 9mm compacts but FAR worse accuracy
- MAC-4A1 matches Scorpion damage with better accuracy but lower RPM
- 9mm platforms generally offer better controllability
- .45 ACP platforms offer suppressor advantage (always subsonic)

---

## Shots-to-Kill Analysis (100 HP Target)

### Close Range (Full Damage)

| Weapon | Body Shots | Headshots |
|--------|------------|-----------|
| MAC-10 (40 dmg) | 3 shots | 1 shot |
| MAC-4A1 (42 dmg) | 3 shots | 1 shot |

### Maximum Range (With Falloff)

| Weapon | Min Damage | Body Shots | Headshots |
|--------|------------|------------|-----------|
| MAC-10 (40 × 0.25) | 10.0 | 10 shots | 4 shots |
| MAC-4A1 (42 × 0.35) | 14.7 | 7 shots | 3 shots |

**Critical Difference:** At range, MAC-4A1's better accuracy AND damage retention means dramatically higher practical TTK despite lower fire rate.

---

## Stat Rankings (Updated with Batch 16)

### Damage (SMGs - Highest to Lowest)
1. RAM 9 Desert: 43
2. **MAC-4A1: 42** (NEW)
3. CZ Scorpion: 42
4. SUB-2000: 41
5. **MAC-10: 40** (NEW)
6. MP5K / SIG MPX / MPA30: 37
7. TEC-9: 36

### Fire Rate (Fastest to Slowest)
1. **MAC-10: 0.055s (1,100 RPM)** (NEW - FASTEST)
2. CZ Scorpion: 0.052s (1,150 RPM)
3. MP5K: 0.067s (900 RPM)
4. SIG MPX: 0.071s (850 RPM)
5. **MAC-4A1: 0.092s (650 RPM)** (NEW)

### Recoil (Lowest to Highest)
1. SIG MPX: 0.12
2. MP5K: 0.14
3. RAM 9 Desert: 0.18
4. Scorpion / MPA30 / SUB-2000: 0.20-0.22
5. **MAC-4A1: 0.22** (NEW)
6. TEC-9: 0.28
7. **MAC-10: 0.38** (NEW - HIGHEST)

### Accuracy (Best to Worst)
1. RAM 9 Desert: 1.05
2. SIG MPX: 1.15
3. MP5K: 1.20
4. SUB-2000: 1.25
5. Scorpion: 1.35
6. **MAC-4A1: 1.45** (NEW)
7. MPA30: 1.65
8. TEC-9: 2.80
9. **MAC-10: 2.80** (NEW - tied worst)

---

## Ammunition

Both weapons use .45 ACP ammunition.

### .45 ACP Ammunition Types

| Type | Damage Mod | Armor Pen | Notes |
|------|------------|-----------|-------|
| FMJ (Ball) | 1.0x | 0.20 | Standard, reliable |
| JHP (Hollow Point) | 1.15x soft | 0.12 | Maximum expansion |
| +P (Overpressure) | 1.08x | 0.24 | Higher velocity |
| Subsonic Match | 0.95x | 0.18 | Quietest suppressed |

**Note:** Standard .45 ACP is already subsonic (~830-920 fps), making it inherently suppressor-optimized without the damage penalty of dedicated subsonic loads.

---

## Suppressor Synergy

The .45 ACP's permanent subsonic nature makes both MAC platforms excellent suppressor hosts:

| Configuration | Sound Level | Detection | Sonic Crack? |
|--------------|-------------|-----------|--------------|
| Unsuppressed | ~162 dB | 100% | No (subsonic) |
| Suppressed | ~130-135 dB | 40-50% | **No** |

Compare to 9mm supersonic:
| Configuration | Sound Level | Detection | Sonic Crack? |
|--------------|-------------|-----------|--------------|
| Unsuppressed | ~160 dB | 100% | Yes |
| Suppressed | ~135-140 dB | 50-60% | **Yes (audible)** |

**.45 ACP Suppressor Advantage:** No supersonic crack means the only sound is mechanical action and muffled report - true "Hollywood quiet" capability.

---

## Historical Context

### Gordon Ingram's Design Philosophy
The MAC-10 emerged from a simple concept: maximum firepower in minimum package for covert operations. Military Armament Corporation paired Ingram's compact firearm with Mitchell WerBell III's Sionics two-stage suppressor as an integrated weapons system for special operations.

### Why It Became Iconic Despite Flaws
Despite limited military adoption, the MAC-10 achieved legendary status through:
- Compact size perfect for concealment
- Menacing appearance
- Prominent film appearances (countless action movies)
- Availability on civilian market (semi-auto clones)
- Association with criminal underworld

### The Lage Renaissance
Richard Lage's slow-fire uppers proved that the MAC-10's fundamental design could perform competitively when cyclic rate dropped to controllable levels. His 2004 Arizona State Subgun Match victory demonstrated the platform's potential when properly modernized.

---

## Installation

1. Extract each weapon folder to your server's `resources` directory
2. Add 3D model files (.ydr, .ytd) to each weapon's `stream/` folder
3. Add to `server.cfg`:
```
ensure weapon_mac10
ensure weapon_mac4a1
```
4. Register weapons with ox_inventory or your inventory system
5. Create .45 ACP ammunition items

---

## Caliber Hierarchy Position (Updated)

| Caliber | Baseline Damage | Role |
|---------|-----------------|------|
| 9mm Luger (pistol) | 34 | Pistol standard |
| 9mm Luger (SMG) | 36-43 | SMG baseline |
| .45 ACP (pistol) | 38 | Heavy pistol |
| **.45 ACP (SMG)** | **40-42** | **Heavy SMG** |
| 5.56 NATO | 42 | Light rifle |
| 7.62x39mm | 48 | Intermediate rifle |
| 6.8x51mm | 55-57 | Advanced rifle |

---

## Version History

- **v1.0.0** - Initial release with 2 MAC platform variants
  - Ingram MAC-10 (classic 1,100 RPM spray weapon)
  - MAC-4A1 (modernized 650 RPM tactical variant)
