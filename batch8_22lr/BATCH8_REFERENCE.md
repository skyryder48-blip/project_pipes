# Batch 8: Rimfire Pistols (.22 LR)

## Overview
3 rimfire pistols spanning budget trainer to high-capacity combat.
All chambered in .22 LR for ammunition simplicity.
The PMR-30 is configured with .22 WMR ballistic characteristics.

---

## Weapon Specifications Summary

| Weapon | Hash | Damage | Barrel | Capacity | Weight | Recoil | Fire Rate |
|--------|------|--------|--------|----------|--------|--------|-----------|
| **SIG P22** | `weapon_sig_p22` | 12 | 3.42" | 10 | 16 oz | 0.055 | 0.160 TBS |
| **FN 502 Tactical** | `weapon_fn502` | 15 | 4.6" | 15 | 23.7 oz | 0.045 | 0.135 TBS |
| **Kel-Tec PMR-30** | `weapon_pmr30` | 20 | 4.3" | 30 | 14 oz | 0.095 | 0.120 TBS |

---

## Detailed Weapon Comparison

### SIG P22 (Walther P22)
**Budget Trainer - Entry-Level Rimfire**

| Specification | Value |
|--------------|-------|
| Barrel Length | 3.42" |
| Weight (empty) | 16 oz |
| Trigger | DA/SA (11 lbs / 5 lbs) |
| Capacity | 10+1 |
| Velocity | ~967 fps |
| Energy | ~85 ft-lbs |
| MSRP | $329 |

**Game Stats:**
- Damage: 12 (lowest)
- Accuracy Spread: 1.20 (widest)
- Recoil Amplitude: 0.055
- Fire Rate: 0.160 TBS (~375 RPM)
- Headshot Modifier: 6.0x
- Damage Falloff: Full to 8m, 30% at 35m

**Role:** Budget option, suppressor host, training

---

### FN 502 Tactical
**Premium Precision - Best .22 LR Performance**

| Specification | Value |
|--------------|-------|
| Barrel Length | 4.6" (threaded 1/2x28) |
| Weight (empty) | 23.7 oz |
| Trigger | SAO (3-5 lbs) |
| Capacity | 15+1 |
| Velocity | ~1,100-1,150 fps |
| Energy | ~110 ft-lbs |
| MSRP | $559 |

**Game Stats:**
- Damage: 15 (highest .22 LR)
- Accuracy Spread: 0.85 (best .22 LR)
- Recoil Amplitude: 0.045 (lowest)
- Fire Rate: 0.135 TBS (~444 RPM)
- Headshot Modifier: 5.5x
- Damage Falloff: Full to 12m, 35% at 45m

**Role:** Premium suppressor host, precision shooting, optics platform

---

### Kel-Tec PMR-30
**High-Capacity Magnum - Combat Rimfire**

| Specification | Value |
|--------------|-------|
| Barrel Length | 4.3" |
| Weight (empty) | 14 oz (ultra-light) |
| Trigger | SAO (3-5 lbs) |
| Capacity | 30+1 (HIGHEST) |
| Velocity | ~1,350 fps (.22 WMR equivalent) |
| Energy | ~160 ft-lbs (.22 WMR equivalent) |
| MSRP | $480 |

**Game Stats:**
- Damage: 20 (highest - magnum characteristics)
- Accuracy Spread: 1.00
- Recoil Amplitude: 0.095 (highest - magnum + light frame)
- Fire Rate: 0.120 TBS (~500 RPM - fastest)
- Headshot Modifier: 4.2x
- Damage Falloff: Full to 15m, 40% at 55m
- Muzzle Flash: 0.95 (largest - fireball effect)

**Role:** Volume of fire, combat use, capacity advantage

---

## Key Differentiators

| Attribute | SIG P22 | FN 502 | PMR-30 | Winner |
|-----------|---------|--------|--------|--------|
| **Damage** | 12 | 15 | 20 | PMR-30 |
| **Capacity** | 10 | 15 | 30 | PMR-30 |
| **Accuracy** | 1.20 | 0.85 | 1.00 | FN 502 |
| **Recoil** | 0.055 | 0.045 | 0.095 | FN 502 |
| **Fire Rate** | 375 RPM | 444 RPM | 500 RPM | PMR-30 |
| **Weight** | 16 oz | 23.7 oz | 14 oz | PMR-30 |
| **Range** | 35m | 45m | 55m | PMR-30 |
| **Suppressor** | Good | Best | Poor (flash) | FN 502 |
| **Price** | Budget | Premium | Mid | SIG P22 |

---

## Caliber Characteristics

### .22 LR (SIG P22, FN 502)
- Muzzle Energy: 85-110 ft-lbs (from pistol barrels)
- Recoil: Essentially none
- Noise: Quiet, excellent suppressed
- Muzzle Flash: Minimal

### .22 WMR Characteristics (PMR-30)
- Muzzle Energy: 150-165 ft-lbs (1.5-1.7x .22 LR)
- Recoil: Light but noticeable
- Noise: Louder than .22 LR
- Muzzle Flash: SIGNIFICANT (fireball from unburned powder)

---

## Shots to Kill (100 HP Target)

| Weapon | Close Range | Max Range | Headshot Close | Headshot Far |
|--------|-------------|-----------|----------------|--------------|
| SIG P22 | 9 | 28+ | 2 | 5-6 |
| FN 502 | 7 | 19 | 2 | 4 |
| PMR-30 | 5 | 13 | 2 | 3 |

*Note: Rimfire calibers require high shot counts - compensated by minimal recoil and high capacity*

---

## Engagement Philosophy

### SIG P22
- Best for: Suppressed work, training, budget builds
- Lowest damage but quietest option
- DA/SA provides second-strike capability
- Choose when stealth matters most

### FN 502 Tactical
- Best for: Precision shooting, optics use, premium suppressed
- Best accuracy and lowest recoil
- Ideal platform for red dot sights
- Choose when accuracy matters most

### PMR-30
- Best for: Combat use, sustained fire, capacity advantage
- Highest damage and capacity by far
- More muzzle flash = less stealth
- Choose when firepower matters most

---

## Caliber Hierarchy Position

| Caliber | Damage | Energy | Role |
|---------|--------|--------|------|
| **.22 LR** | **12-15** | **85-110 ft-lbs** | **Training/Suppressed** |
| **.22 LR (PMR-30)** | **20** | **~160 ft-lbs** | **High-Cap Combat** |
| 5.7x28mm | 28-30 | 240-290 ft-lbs | PDW |
| 9mm | 34 | 350-400 ft-lbs | Standard |

---

## Folder Structure

```
batch8_22lr/
├── weapon_sig_p22/
│   ├── meta/
│   │   └── weapons.meta
│   ├── stream/              (add your models here)
│   ├── cl_weaponNames.lua
│   └── fxmanifest.lua
├── weapon_fn502/
│   └── (same structure)
├── weapon_pmr30/
│   └── (same structure)
└── BATCH8_REFERENCE.md
```

---

## Installation

1. Add stream assets to each weapon's `/stream/` folder
2. Add to server.cfg:
```cfg
# Ammunition resource
ensure ammo_22lr

# Batch 8 Weapons
ensure weapon_sig_p22
ensure weapon_fn502
ensure weapon_pmr30
```

3. Register with ox_inventory

---

## Balance Notes

Rimfire pistols occupy a unique niche:
- **Lowest damage** of any centerfire alternative
- **Minimal recoil** allows extremely fast follow-up
- **High capacity** (especially PMR-30) enables sustained fire
- **High headshot multipliers** reward precision
- **Extended magazine dumps** possible without losing accuracy

The PMR-30's .22 WMR characteristics make it competitive with entry-level centerfire pistols while maintaining rimfire handling. Its 30-round capacity and 500 RPM fire rate allow for aggressive volume-of-fire tactics.

The FN 502 represents the "precision rimfire" approach - lower damage per shot but laser-accurate with the best suppressed performance.

The SIG P22 is the budget entry point - serviceable but outclassed by the other options in every metric except price and suppressor compatibility.

---

*Document Version: 1.0*
*Batch 8: Rimfire Pistols*
*3 Weapons: SIG P22, FN 502 Tactical, Kel-Tec PMR-30*
*All chambered in .22 LR*
