# Batch 4: .40 S&W Pistols - Complete Reference

## Overview
3 weapons created featuring the .40 S&W caliber, including a full-auto converted Glock.
The .40 S&W sits between 9mm (34 damage) and .45 ACP (38 damage) with notable "snappy" recoil.

---

## Ammunition Types (Future ammo_40sw Resource)

| Type | Base Damage | Effect |
|------|-------------|--------|
| **FMJ** | 36 | Standard performance, good penetration |
| **JHP** | 42 | +16.7% damage, reduced penetration |

---

## Weapon Specifications Summary

| Weapon | Hash | Damage | Capacity | Fire Mode | Speed | Recoil | Accuracy |
|--------|------|--------|----------|-----------|-------|--------|----------|
| **Glock 22 Gen 4** | `weapon_g22_gen4` | 36 | 15+1 | Semi | 320 | 0.295 | 1.05 |
| **Glock 22 Gen 5** | `weapon_g22_gen5` | 36 | 15+1 | Semi | 320 | 0.290 | 0.95 |
| **Glock Demon** | `weapon_glock_demon` | 35 | 13+1 | **FULL AUTO** | 310 | 0.420 | 1.80 |

---

## Detailed Weapon Profiles

### Glock 22 Gen 4
**The Law Enforcement Standard**
- 4.49" barrel, 22.75 oz polymer frame
- Captured 65-70% of U.S. law enforcement market
- Dual recoil spring system (Gen 4 feature)
- Interchangeable backstraps
- Known for "snappy" .40 S&W recoil
- Role: Reliable duty pistol, baseline .40 S&W performance

**Key Stats:**
- Damage: 36
- Capacity: 15+1
- Fire Rate: ~240 RPM (0.250 TBS)
- Recoil: 0.295 (higher than 9mm Glocks)

### Glock 22 Gen 5
**Enhanced Duty Pistol**
- 4.49" Glock Marksman Barrel (GMB)
- Improved polygonal rifling, tighter tolerances
- Enhanced trigger with shorter reset
- nDLC finish for durability
- Flared magwell for faster reloads
- No finger grooves, ambidextrous controls
- Role: Premium .40 S&W option with better accuracy

**Key Stats:**
- Damage: 36
- Capacity: 15+1
- Fire Rate: ~260 RPM (0.231 TBS) - improved trigger
- Accuracy: 0.95 (better than Gen 4's 1.05)
- Reload: 10% faster due to flared magwell

### Glock Demon
**Full-Auto Street Weapon**
- Based on Glock 23 Gen 4 (compact frame)
- 4.02" barrel, 21.16 oz
- Illegal auto-sear conversion ("switch")
- .40 S&W + FULL AUTO = EXTREME RECOIL
- Devastating close-range, uncontrollable at distance
- Magazine dump in ~0.87 seconds
- Role: High-risk/high-reward illegal weapon

**Key Stats:**
- Damage: 35 (velocity loss from compact barrel)
- Capacity: 13+1
- Fire Rate: **~900 RPM** (0.067 TBS) - FULL AUTO
- Recoil: 0.420 (EXTREME)
- Accuracy: 1.80 (poor, worsens rapidly in full auto)

---

## Shots to Kill (100 HP Target)

| Weapon | Close (FMJ) | Range (FMJ) | Close (JHP) | Range (JHP) |
|--------|-------------|-------------|-------------|-------------|
| G22 Gen 4/5 (36 dmg) | 3 | 7 | 3 | 6 |
| Glock Demon (35 dmg) | 3 | 7-8 | 3 | 6-7 |
| 9mm Reference (34) | 3 | 8 | - | - |
| .45 ACP Reference (38) | 3 | 7 | - | - |

---

## Key Meta Parameters Comparison

### Damage Falloff

| Weapon | FalloffMin | FalloffMax | Modifier |
|--------|------------|------------|----------|
| G22 Gen 4 | 12m | 42m | 0.37 |
| G22 Gen 5 | 12m | 42m | 0.37 |
| Glock Demon | 8m | 32m | 0.34 |

### Fire Rate Comparison

| Weapon | TBS | Effective RPM | Fire Mode |
|--------|-----|---------------|-----------|
| G22 Gen 4 | 0.250 | ~240 | Semi-Auto |
| G22 Gen 5 | 0.231 | ~260 | Semi-Auto |
| **Glock Demon** | **0.067** | **~900** | **FULL AUTO** |

### Recoil Comparison

| Weapon | Amplitude | Recovery Rate | Notes |
|--------|-----------|---------------|-------|
| G22 Gen 4 | 0.295 | 0.900 | Snappy .40 S&W |
| G22 Gen 5 | 0.290 | 0.920 | Slightly improved |
| Glock Demon | 0.420 | 0.650 | EXTREME - nearly uncontrollable |

---

## .40 S&W Caliber Characteristics

**Why .40 S&W is "Snappy":**
- 35,000 psi chamber pressure (same as 9mm)
- Pushes 40% heavier bullets than 9mm
- Rapid pressure spike creates abrupt recoil impulse
- Feels sharper than .45 ACP despite less total energy
- 25-40% more felt recoil than equivalent 9mm

**Historical Context:**
- Developed 1990 after FBI Miami shootout
- FBI adopted 1997, switched back to 9mm 2015-2016
- Modern 9mm JHP equals .40 terminal performance
- Agencies cite recoil affecting qualification scores

---

## Glock Demon - Full Auto Notes

**Realistic Behavior:**
- ~900 RPM (slower than 9mm G18's 1200 RPM)
- Heavier .40 slide cycles slower than 9mm
- 13 rounds = ~0.87 second magazine dump
- First 2-3 shots controllable, then severe climb
- Effective only at point-blank range

**Recommended Gameplay Use:**
- Drive-by situations
- Building clearing (close quarters)
- Ambush weapon
- NOT for ranged engagements

**Balance Considerations:**
- High damage output but burns ammo fast
- Poor accuracy means wasted rounds
- Reload frequency is a vulnerability
- Expensive ammo cost for .40 S&W

---

## Folder Structure

```
batch4_40sw/
├── weapon_g22_gen4/
│   ├── meta/
│   │   └── weapons.meta
│   ├── stream/           (add visual assets)
│   ├── cl_weaponNames.lua
│   └── fxmanifest.lua
├── weapon_g22_gen5/
│   └── (same structure)
└── weapon_glock_demon/
    └── (same structure)
```

---

## Installation Notes

1. Add stream assets (.ydr, .ytd, .yft) to each weapon's `/stream/` folder
2. Ensure resource names match weapon hash names
3. Add to server.cfg:
```cfg
ensure ammo_40sw          # (when developed)
ensure weapon_g22_gen4
ensure weapon_g22_gen5
ensure weapon_glock_demon
```

---

## Caliber Comparison Reference

| Caliber | Damage | Velocity | Recoil | Capacity |
|---------|--------|----------|--------|----------|
| 9mm | 34 | 365 m/s | Low | 15-17 |
| **.40 S&W** | **36** | **320 m/s** | **Medium-High** | **13-15** |
| .45 ACP | 38 | 255 m/s | Medium | 7-13 |

---

*Document Version: 1.0*
*Batch 4: .40 S&W Pistols*
*3 Weapons: G22 Gen 4, G22 Gen 5, Glock Demon (Full-Auto)*
