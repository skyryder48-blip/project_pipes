# Batch 18: 12-Gauge Shotgun Development Reference

## Overview

Five 12-gauge shotguns configured for **00 buckshot** operation with realistic ballistic characteristics. All weapons feature multi-pellet damage modeling with severe damage falloff beyond effective range. Includes one illegal sawn-off variant.

---

## Weapon Comparison Matrix

| Weapon | Action | Pellets | Damage/Pellet | Total Close | Fire Rate | Effective Range | Recoil |
|--------|--------|---------|---------------|-------------|-----------|-----------------|--------|
| **Mini Shotty** | Pump (Sawn-Off) | 9 | 38 | 342 | 40 RPM | 15m | 98% |
| Model 680 | Pump | 8 | 40 | 320 | 50 RPM | 32m | 78% |
| Remington 870 | Pump | 9 | 42 | 378 | 55 RPM | 35m | 75% |
| Mossberg 500 | Pump | 9 | 44 | 396 | 58 RPM | 38m | 72% |
| Browning Auto-5 | Semi | 9 | 45 | 405 | 110 RPM | 40m | 60% |

---

## Detailed Specifications

### Mini Shotty (Illegal Sawn-Off)
- **Type**: Illegal short barreled shotgun (SBS)
- **Magazine**: 3+1 (4 rounds - shortened tube)
- **Pellets**: 9 × 38 damage = 342 max
- **Velocity**: 320 m/s (1,050 fps - severe loss)
- **Spread**: 0.095 (extreme - nearly double standard)
- **Fall-off**: Full damage 0-5m, minimum at 15m (12%)
- **Recoil**: 98% (brutal - no stock)
- **Special**: Hip-fire only, cannot effectively ADS
- **Notes**: Concealable, devastating point-blank, useless at range

### Model 680 (Budget Pump)
- **Type**: Entry-level pump-action
- **Magazine**: 4+1 (5 rounds)
- **Pellets**: 8 × 40 damage = 320 max
- **Velocity**: 350 m/s (1,150 fps)
- **Spread**: 0.065 (widest)
- **Fall-off**: Full damage 0-8m, minimum at 32m (16%)
- **Notes**: Single action bar, prone to binding, budget ammunition

### Remington 870 Express (Standard Pump)
- **Type**: Classic pump-action
- **Magazine**: 4+1 (5 rounds)
- **Pellets**: 9 × 42 damage = 378 max
- **Velocity**: 366 m/s (1,200 fps)
- **Spread**: 0.055
- **Fall-off**: Full damage 0-10m, minimum at 35m (18%)
- **Notes**: Most-produced pump shotgun (13M+ units), dual action bars

### Mossberg 500 (MIL-SPEC Pump)
- **Type**: Military-certified pump-action
- **Magazine**: 5+1 (6 rounds)
- **Pellets**: 9 × 44 damage = 396 max
- **Velocity**: 381 m/s (1,250 fps)
- **Spread**: 0.050
- **Fall-off**: Full damage 0-12m, minimum at 38m (20%)
- **Notes**: MIL-SPEC 3443E certified, tang-mounted ambidextrous safety

### Browning Auto-5 (Classic Semi-Auto)
- **Type**: Long-recoil semi-automatic
- **Magazine**: 4+1 (5 rounds)
- **Pellets**: 9 × 45 damage = 405 max
- **Velocity**: 396 m/s (1,300 fps)
- **Spread**: 0.048 (tightest)
- **Fall-off**: Full damage 0-14m, minimum at 40m (22%)
- **Notes**: John Browning's 1898 design, legendary WWI-Vietnam service

---

## Damage Calculations

### Expected Kills by Range (Body Shots)

| Range | Mini Shotty | Model 680 | Rem 870 | Moss 500 | Auto-5 |
|-------|-------------|-----------|---------|----------|--------|
| 5m | 1 shot | 1 shot | 1 shot | 1 shot | 1 shot |
| 10m | 1-2 shots | 1 shot | 1 shot | 1 shot | 1 shot |
| 15m | 2-3 shots | 1 shot | 1 shot | 1 shot | 1 shot |
| 25m | 4+ shots | 1-2 shots | 1-2 shots | 1 shot | 1 shot |
| 35m | Ineffective | 2-3 shots | 2-3 shots | 2 shots | 1-2 shots |

### Headshot Effectiveness

| Weapon | Headshot Mult | Max HS Range | 1-Shot HS Range |
|--------|---------------|--------------|-----------------|
| Mini Shotty | 1.50x | 8m | ~5m |
| Model 680 | 1.70x | 22m | ~15m |
| Remington 870 | 1.80x | 25m | ~18m |
| Mossberg 500 | 1.85x | 28m | ~20m |
| Browning Auto-5 | 1.90x | 30m | ~22m |

---

## Time Between Shots Comparison

| Weapon | TimeBetweenShots | Effective RPM | Shots in 5 Seconds |
|--------|------------------|---------------|-------------------|
| Mini Shotty | 1.500s | 40 | 3 |
| Model 680 | 1.200s | 50 | 4 |
| Remington 870 | 1.090s | 55 | 5 |
| Mossberg 500 | 1.030s | 58 | 5 |
| Browning Auto-5 | 0.545s | 110 | 9 |

---

## Slug Ammunition Reference

If implementing slug switching via ammo script, here are the recommended values:

| Parameter | Buckshot | Slug |
|-----------|----------|------|
| Damage | 40-45 | 120-135 |
| BulletsInBatch | 8-9 | 1 |
| BatchSpread | 0.048-0.065 | 0.000 |
| Speed | 350-396 | 475-500 |
| DamageFallOffRangeMin | 8-14 | 25-30 |
| DamageFallOffRangeMax | 32-40 | 75-85 |
| DamageFallOffModifier | 0.16-0.22 | 0.35 |
| Penetration | 0.10-0.15 | 0.30 |

---

## Installation Notes

1. Each weapon folder contains:
   - `meta/weapons.meta` - Weapon configuration
   - `meta/weaponarchetypes.meta` - Model registration
   - `cl_weaponNames.lua` - Display name script
   - `fxmanifest.lua` - Resource manifest
   - `stream/` - Add your .ydr and .ytd files here

2. Ensure resources in server.cfg:
```
ensure mini_shotty
ensure model_680
ensure remington_870
ensure mossberg_500
ensure browning_auto5
```

3. Load order: Weapon resources should load **BEFORE** ox_inventory

---

## Weapon Hash Names

| Display Name | Weapon Hash | Model Hash |
|--------------|-------------|------------|
| Mini Shotty | WEAPON_MINISHOTTY | w_sg_minishotty |
| Model 680 | WEAPON_MODEL680 | w_sg_model680 |
| Remington 870 | WEAPON_REMINGTON870 | w_sg_rem870 |
| Mossberg 500 | WEAPON_MOSSBERG500 | w_sg_mossberg500 |
| Browning Auto-5 | WEAPON_BROWNINGAUTO5 | w_sg_browningauto5 |

---

## Balance Philosophy

These shotguns follow the project's realistic balance approach:

1. **Devastating close range** (0-15m): One-shot kill potential when most pellets connect
2. **Rapid falloff** (15-40m): Effectiveness degrades sharply as pellets spread
3. **Ineffective at range** (40m+): Minimal damage, random pellet hits
4. **Magazine limitations**: 4-6 rounds with individual shell reloading
5. **Fire rate differentiation**: Pumps cycle slowly (40-58 RPM), semi-auto nearly doubles output (110 RPM)

The **Browning Auto-5** commands premium status through:
- Highest pellet damage (45)
- Tightest spread (0.048)
- Lowest recoil (60% via long-recoil absorption)
- Double the fire rate of pumps
- Longest effective range (40m)

The **Mini Shotty** represents the criminal tier:
- Illegal sawn-off with extreme trade-offs
- Devastating within 5m (one-shot kill guaranteed)
- Practically useless beyond 15m
- Brutal 98% recoil (no stock absorption)
- Slowest fire rate (40 RPM - needs recovery time)
- Hip-fire only operation
- Concealable but heavily penalized
