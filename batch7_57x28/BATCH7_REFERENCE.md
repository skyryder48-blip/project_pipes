# Batch 7: 5.7x28mm Pistols

## Overview
2 high-velocity pistols chambered in the unique 5.7x28mm cartridge.
Originally designed for PDW applications alongside the FN P90.
Characterized by minimal recoil, high capacity, and flat trajectory.

---

## Weapon Specifications Summary

| Weapon | Hash | Damage | Barrel | Capacity | Recoil | Accuracy | Fire Rate |
|--------|------|--------|--------|----------|--------|----------|-----------|
| **FN Five-seveN** | `weapon_fn57` | 28 | 4.8" | 20 | 0.100 | 0.80 | 0.150 TBS |
| **Ruger-57** | `weapon_ruger57` | 30 | 4.94" | 20 | 0.085 | 0.65 | 0.140 TBS |

---

## Detailed Weapon Comparison

### FN Five-seveN
**The Original - Premium Belgian Engineering**

| Specification | Value |
|--------------|-------|
| Barrel Length | 4.8" |
| Weight (empty) | 21 oz |
| Trigger | SAO, 6.2 lbs |
| Sight Radius | 7.0" |
| MSRP | $1,409 |

**Game Stats:**
- Damage: 28
- Accuracy Spread: 0.80
- Recoil Amplitude: 0.100
- Fire Rate: 0.150 TBS (~400 RPM)
- Headshot Modifier: 3.6x
- Damage Falloff: Full to 30m, 45% at 90m

**Characteristics:**
- Lightweight polymer = fastest handling
- Slightly higher recoil than Ruger (lighter frame)
- Premium quality, iconic design
- Delayed blowback system

---

### Ruger-57
**American Value - Superior Accuracy**

| Specification | Value |
|--------------|-------|
| Barrel Length | 4.94" (+0.14") |
| Weight (empty) | 24.5 oz (+3.5 oz) |
| Trigger | Striker, 4.75 lbs |
| Controls | 1911-style safety |
| MSRP | $549 |

**Game Stats:**
- Damage: 30 (+2)
- Accuracy Spread: 0.65 (better)
- Recoil Amplitude: 0.085 (lower)
- Fire Rate: 0.140 TBS (~428 RPM)
- Headshot Modifier: 3.4x
- Damage Falloff: Full to 35m, 48% at 95m

**Characteristics:**
- Heavier frame = more stable platform
- Best accuracy of 5.7mm pistols
- Longer barrel = higher velocity
- Budget-friendly at 1/3 the price
- Steel magazines (more durable)

---

## Key Differences at a Glance

| Attribute | FN Five-seveN | Ruger-57 | Winner |
|-----------|---------------|----------|--------|
| **Damage** | 28 | 30 | Ruger |
| **Accuracy** | Good | Excellent | Ruger |
| **Recoil** | Very Low | Lowest | Ruger |
| **Handling Speed** | Fastest | Fast | FN |
| **Fire Rate** | Fast | Slightly Faster | Ruger |
| **Range** | 90m effective | 95m effective | Ruger |
| **Weight** | 21 oz | 24.5 oz | FN (lighter) |

**Summary:** The Ruger-57 is objectively better in raw stats due to longer barrel and heavier frame, but the FN Five-seveN offers faster handling for close-quarters work.

---

## 5.7x28mm Caliber Characteristics

| Property | Value | vs 9mm |
|----------|-------|--------|
| Muzzle Velocity | 1,650-1,850 fps | +50-70% faster |
| Muzzle Energy | 240-290 ft-lbs | -30-40% less |
| Recoil | ~2.5 ft-lbs | -30% less |
| Magazine Capacity | 20 rounds | +3-5 more |
| Effective Range | 50-100 yards | +100% further |
| Penetration | High velocity | Better vs soft armor |

### Ammunition Notes
- High velocity, light bullet design
- Tumbles/fragments rather than expands
- Extended effective range due to flat trajectory
- Higher penetration modifier than 9mm
- Lower base damage compensated by capacity and accuracy

---

## Shots to Kill (100 HP Target)

| Weapon | Close Range | Max Range | Headshot Close | Headshot Far |
|--------|-------------|-----------|----------------|--------------|
| FN Five-seveN | 4 | 8-9 | 1 | 2-3 |
| Ruger-57 | 4 | 7-8 | 1 | 2 |

*Note: High headshot multipliers (3.4-3.6x) compensate for lower base damage*

---

## Engagement Philosophy

### FN Five-seveN
- Best for: Fast-paced CQB, run-and-gun
- Lightest weight = quickest draw/transitions
- Iconic looks, premium feel
- Choose when mobility matters most

### Ruger-57
- Best for: Precision shooting, longer engagements
- Superior accuracy at all ranges
- Most stable platform in caliber
- Choose when accuracy matters most

---

## Folder Structure

```
batch7_57x28/
├── weapon_fn57/
│   ├── meta/
│   │   └── weapons.meta
│   ├── stream/              (add your models here)
│   ├── cl_weaponNames.lua
│   └── fxmanifest.lua
├── weapon_ruger57/
│   └── (same structure)
└── BATCH7_REFERENCE.md
```

---

## Installation

1. Add stream assets to each weapon's `/stream/` folder
2. Add to server.cfg:
```cfg
# Ammunition resource (when developed)
ensure ammo_57x28

# Batch 7 Weapons
ensure weapon_fn57
ensure weapon_ruger57
```

3. Register with ox_inventory

---

## Caliber Hierarchy Position

| Caliber | Damage | Capacity | Recoil | Role |
|---------|--------|----------|--------|------|
| .22 LR | 14 | 10 | Minimal | Training |
| **5.7x28mm** | **28-30** | **20** | **Very Low** | **High-Cap PDW** |
| 9mm | 34 | 15-17 | Low | Standard |
| .40 S&W | 36 | 13-15 | Moderate | LE Duty |
| .45 ACP | 38 | 7-13 | Moderate | Heavy |

The 5.7x28mm slots between .22 LR and 9mm in damage, but offers the highest capacity and lowest recoil of any centerfire pistol caliber. It excels in situations where volume of accurate fire matters more than per-shot stopping power.

---

## Balance Notes

The 5.7x28mm is intentionally positioned as a **high-skill caliber**:
- Lower damage rewards accuracy over spray
- High capacity enables sustained engagements
- Minimal recoil allows rapid aimed fire
- Extended range rewards positioning
- High headshot multiplier rewards precision

Players who can consistently land headshots will find these weapons extremely effective. Players who rely on body shots will find them underpowered compared to 9mm.

---

*Document Version: 1.0*
*Batch 7: 5.7x28mm Pistols*
*2 Weapons: FN Five-seveN, Ruger-57*
