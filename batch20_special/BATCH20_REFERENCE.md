# Batch 20: .38 Special Revolvers & Tranquilizer Dart Gun Reference

## Overview

The final batch includes six .38 Special revolvers spanning premium service to budget concealed carry, plus a unique tranquilizer dart gun with special incapacitation effects. All revolvers are configured for **+P ammunition performance**, providing ~64-93% of 9mm energy depending on barrel length.

---

## Weapon Comparison Matrix

| Weapon | Barrel | Weight | Capacity | Trigger | Damage | Frame |
|--------|--------|--------|----------|---------|--------|-------|
| **S&W Model 60** | 3" | 24.5 oz | 5 | DA/SA | 26 | Steel J-frame |
| **S&W Model 10** | 4" | 34.4 oz | 6 | DA/SA | 28 | Steel K-frame |
| **S&W Model 442** | 1.875" | 14.7 oz | 5 | DAO | 22 | Aluminum J-frame |
| **S&W Model 642** | 1.875" | 14.6 oz | 5 | DAO | 22 | Aluminum J-frame |
| **Ruger LCR** | 1.87" | 13.5 oz | 5 | DAO | 22 | Polymer/Aluminum |
| **Taurus 856** | 3" | 23.5 oz | 6 | DA/SA | 26 | Steel |
| **Dart Gun** | N/A | ~7 lbs | 3 | Single | 2 | Special |

---

## .38 Special +P Ballistics by Barrel Length

| Barrel Length | Velocity | Energy | vs 9mm | Damage |
|---------------|----------|--------|--------|--------|
| 1.875" (snub) | ~910 fps | ~230 ft-lbs | 64% | 22 |
| 3" (compact) | ~1,000 fps | ~278 ft-lbs | 77% | 26 |
| 4" (service) | ~1,100 fps | ~336 ft-lbs | 93% | 28 |

**Reference**: 9mm baseline = 360 ft-lbs = 34 damage

---

## Detailed Weapon Specifications

### S&W Model 60 - Premium 3" J-Frame
- **Real-World**: First all-stainless revolver (1965)
- **Caliber**: .38 Special +P (also .357 Magnum rated)
- **Barrel**: 3.0" full underlug
- **Weight**: 24.0-25.0 oz
- **Capacity**: 5 rounds
- **Trigger**: DA/SA (11.7-12 lbs DA / 3-4 lbs SA)
- **Sights**: Adjustable rear, pinned ramp front
- **MSRP**: $763-$779

**FiveM Implementation:**
- Damage: 26 | AccuracySpread: 0.28 | Recoil: 28%
- Range: 60m | Fire Rate: 0.45s | Reload: 2.8s

---

### S&W Model 10 - Police Service Revolver
- **Real-World**: Most produced S&W revolver (6+ million)
- **Caliber**: .38 Special +P
- **Barrel**: 4.0" heavy barrel
- **Weight**: 34.4 oz
- **Capacity**: 6 rounds (K-frame)
- **Trigger**: DA/SA (9-11 lbs DA / 3-3.5 lbs SA)
- **Service History**: US Navy (1900), WWII Victory Model, worldwide police standard

**FiveM Implementation:**
- Damage: 28 | AccuracySpread: 0.22 | Recoil: 22%
- Range: 75m | Fire Rate: 0.40s | Reload: 2.6s

---

### S&W Model 442 Airweight - Black DAO Snub
- **Real-World**: "Centennial" internal hammer design
- **Caliber**: .38 Special +P
- **Barrel**: 1.875"
- **Weight**: 14.7 oz (66% lighter than steel)
- **Capacity**: 5 rounds
- **Trigger**: DAO only (11.7-12 lbs)
- **Finish**: Matte black
- **MSRP**: $539-$569

**FiveM Implementation:**
- Damage: 22 | AccuracySpread: 0.38 | Recoil: 38%
- Range: 40m | Fire Rate: 0.50s | Reload: 2.9s

---

### S&W Model 642 Airweight - Stainless DAO Snub
- **Real-World**: S&W's best-selling J-frame
- **Caliber**: .38 Special +P
- **Barrel**: 1.875"
- **Weight**: 14.6 oz
- **Capacity**: 5 rounds
- **Trigger**: DAO only (11.8 lbs)
- **Finish**: Matte silver/stainless
- **MSRP**: $449-$519

**FiveM Implementation:**
- Damage: 22 | AccuracySpread: 0.38 | Recoil: 38%
- Range: 40m | Fire Rate: 0.50s | Reload: 2.9s

---

### Ruger LCR - Modern Polymer Snub
- **Real-World**: Revolutionary 2009 design
- **Caliber**: .38 Special +P
- **Barrel**: 1.87"
- **Weight**: 13.5 oz (LIGHTEST in class)
- **Capacity**: 5 rounds
- **Trigger**: DAO with friction-reducing cam (9-10 lbs, feels lighter)
- **Frame**: 7000-series aluminum + glass-filled polymer
- **MSRP**: $759

**FiveM Implementation:**
- Damage: 22 | AccuracySpread: 0.36 | Recoil: 35%
- Range: 42m | Fire Rate: 0.45s | Reload: 2.9s

---

### Taurus Defender 856 - Budget 6-Shot
- **Real-World**: Value alternative with extra capacity
- **Caliber**: .38 Special +P
- **Barrel**: 3.0"
- **Weight**: 23.5 oz
- **Capacity**: 6 rounds (vs 5 for J-frames)
- **Trigger**: DA/SA
- **Sights**: Tritium night sights standard
- **MSRP**: $425-$460 (street: $300-$350)

**FiveM Implementation:**
- Damage: 26 | AccuracySpread: 0.30 | Recoil: 29%
- Range: 55m | Fire Rate: 0.45s | Reload: 2.7s

---

## Tranquilizer Dart Gun - Special Weapon

### Specifications
- **Damage**: 2 (minimal physical damage)
- **Magazine**: 3 darts
- **Fire Rate**: 2.0s between shots
- **Reload**: 3.5s
- **Effective Range**: 40m
- **Projectile Velocity**: 76 m/s (visible, slow-moving)
- **Sound**: Very quiet (15m AI detection range)

### Special Effects
| Effect | Description | Duration |
|--------|-------------|----------|
| **Stumble** | Target loses balance on initial hit | Immediate |
| **Ragdoll** | Target collapses after 0.5s delay | 30 seconds |
| **Freeze** | Target position locked | 30 seconds |

### Effect Mechanics
1. On hit, target immediately stumbles
2. After 0.5 second delay, full ragdoll activates
3. After 1 second, position freezes for remaining 29 seconds
4. Target remains incapacitated for full 30-second duration
5. Effects automatically clear after duration expires

### Client Script Exports
```lua
-- Check if ped is currently tranquilized
exports['dart_gun']:IsPedTranquilized(ped)

-- Manually clear tranquilizer effect
exports['dart_gun']:ClearTranquilizerEffect(ped)

-- Get remaining effect time in milliseconds
exports['dart_gun']:GetTranquilizerTimeRemaining(ped)
```

### Limitations
- Ineffective against armored targets (0.1 armor modifier)
- No penetration capability
- Slow projectile with arcing trajectory
- Cannot be suppressed (already quiet)

---

## Shots to Kill Analysis (100 HP Target)

### Body Shots by Range

| Weapon | Point Blank | 15m | 30m | Max Range |
|--------|-------------|-----|-----|-----------|
| S&W Model 60 | 4 | 4 | 5 | 7 |
| S&W Model 10 | 4 | 4 | 4-5 | 6 |
| S&W Model 442 | 5 | 5 | 6 | 8 |
| S&W Model 642 | 5 | 5 | 6 | 8 |
| Ruger LCR | 5 | 5 | 6 | 7-8 |
| Taurus 856 | 4 | 4 | 5 | 7 |

### Headshot Multipliers

| Weapon | HS Multiplier | 1-Shot HS Range |
|--------|---------------|-----------------|
| S&W Model 60 | 2.40x | ~20m |
| S&W Model 10 | 2.50x | ~25m |
| S&W Model 442 | 2.20x | ~15m |
| S&W Model 642 | 2.20x | ~15m |
| Ruger LCR | 2.25x | ~18m |
| Taurus 856 | 2.35x | ~20m |

---

## Revolver Category Comparison

### By Role

| Role | Best Choice | Reason |
|------|-------------|--------|
| **Duty/Service** | S&W Model 10 | 6-round capacity, maximum damage, best accuracy |
| **Premium Carry** | S&W Model 60 | Adjustable sights, steel frame, .357 capability |
| **Budget Carry** | Taurus 856 | 6 rounds, night sights, half the price |
| **Deep Concealment** | S&W 442/642 | Lightest, snag-free, pocket-size |
| **Modern Design** | Ruger LCR | Smoothest trigger, lightest weight |

### By Damage Tier

| Tier | Damage | Weapons |
|------|--------|---------|
| **High** | 28 | S&W Model 10 (4" barrel) |
| **Medium** | 26 | S&W Model 60, Taurus 856 (3" barrel) |
| **Low** | 22 | S&W 442, S&W 642, Ruger LCR (2" barrel) |

---

## Installation Notes

1. Add stream files (.ydr, .ytd) to each weapon's `stream/` folder

2. Ensure resources in server.cfg:
```
ensure sw_model60
ensure sw_model10
ensure sw_model442
ensure sw_model642
ensure ruger_lcr
ensure taurus_defender856
ensure dart_gun
```

3. Load order: Weapon resources should load **BEFORE** ox_inventory

4. **Dart Gun Note**: The dart gun includes a client-side effects script (`cl_dartgun_effects.lua`) that handles the freeze/ragdoll/stumble mechanics. For multiplayer sync, consider implementing server-side event handlers.

---

## Weapon Hash Names

| Display Name | Weapon Hash | Model Hash |
|--------------|-------------|------------|
| S&W Model 60 | WEAPON_SWMODEL60 | w_pi_swmodel60 |
| S&W Model 10 | WEAPON_SWMODEL10 | w_pi_swmodel10 |
| S&W Model 442 | WEAPON_SWMODEL442 | w_pi_swmodel442 |
| S&W Model 642 | WEAPON_SWMODEL642 | w_pi_swmodel642 |
| Ruger LCR | WEAPON_RUGERLCR | w_pi_rugerlcr |
| Taurus Defender 856 | WEAPON_TAURUS856 | w_pi_taurus856 |
| Dart Gun | WEAPON_DARTGUN | w_pi_dartgun |

---

## Balance Philosophy

### .38 Special Positioning
The .38 Special occupies a unique niche below 9mm:
- **Less damage** than 9mm semi-autos (22-28 vs 34)
- **Lower capacity** (5-6 vs 15-17)
- **Slower fire rate** (0.40-0.50s vs 0.12s)
- **Advantages**: Reliability, concealability, single/double action flexibility

### Barrel Length Hierarchy
Longer barrels = more velocity = more damage:
- 2" snub-nose: -35% vs 4" barrel
- 3" compact: -17% vs 4" barrel
- 4" service: Maximum .38 Special performance

### Dart Gun Role
Non-lethal incapacitation weapon for:
- Law enforcement roleplay
- Wildlife management scenarios
- Stealth/tactical situations
- 30-second effect window creates meaningful tactical decisions

---

*Batch 20 Reference Document - .38 Special Revolvers & Tranquilizer Dart Gun*
*FiveM Weapon Meta Development Project - FINAL BATCH*
