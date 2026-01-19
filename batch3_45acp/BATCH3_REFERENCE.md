# Batch 3: .45 ACP Pistols - Complete Reference

## Overview
7 weapons created with unique characteristics based on real-world specifications.
All damage values reduced by 5% from original calculations.

---

## Ammunition Types

| Type | Base Damage | Effect |
|------|-------------|--------|
| **FMJ** | 38 (quality) / 36 (G30) / 34 (junk) | Standard performance |
| **JHP** | 44 (quality) / 42 (G30) / 40 (junk) | +15.8% damage, combined standard/+P ballistics |

---

## Weapon Specifications Summary

### 1911-Pattern Pistols (Steel Frame)

| Weapon | Hash | Damage | Capacity | Speed | Recoil | Accuracy | Notes |
|--------|------|--------|----------|-------|--------|----------|-------|
| **Colt M45A1** | `weapon_m45a1` | 38 | 8+1 | 255 | 0.265 | 0.80 | Military-spec, best accuracy |
| **Kimber 1911** | `weapon_kimber1911` | 38 | 7+1 | 255 | 0.265 | 0.85 | Premium civilian |
| **Kimber Eclipse** | `weapon_kimber_eclipse` | 38 | 8+1 | 255 | 0.258 | 0.78 | Target-grade, tritium sights |
| **Junk 1911** | `weapon_junk1911` | 34 | 7+1 | 220 | 0.322 | 2.20 | Degraded, severe penalties |

### Glock Pistols (Polymer Frame)

| Weapon | Hash | Damage | Capacity | Speed | Recoil | Accuracy | Notes |
|--------|------|--------|----------|-------|--------|----------|-------|
| **Glock 21** | `weapon_g21` | 38 | 13+1 | 258 | 0.310 | 1.10 | Full-size, high capacity |
| **Glock 30** | `weapon_g30` | 36 | 10+1 | 240 | 0.345 | 1.40 | Subcompact, worst recoil |
| **Glock 41** | `weapon_g41` | 38 | 13+1 | 270 | 0.288 | 0.92 | Competition longslide |

---

## Detailed Weapon Profiles

### Colt M45A1 CQBP
**The Military Standard**
- 5.0" National Match barrel, 40 oz steel frame
- Dual recoil spring, Novak tritium sights
- Best accuracy among .45s (1.48" groups at 25 yards)
- Role: Precision duty pistol

### Kimber Custom II
**Premium Civilian Option**
- 5.0" match-grade barrel, 38 oz steel frame
- Aluminum match trigger with 0.1" reset
- 2-3" groups at 25 yards typical
- Role: Quality home defense/range pistol

### Kimber Eclipse Custom II
**Target-Enhanced 1911**
- All Custom II features plus:
- Meprolight tritium 3-dot sights
- 30 LPI front strap checkering
- 8-round magazine (vs 7)
- Role: Premium defensive/competition pistol

### Glock 21 Gen 4
**High Capacity Workhorse**
- 4.61" barrel, 26.28 oz polymer frame
- 13+1 capacity (nearly double 1911)
- Dual recoil spring, 22-degree grip angle
- Higher recoil due to lighter weight
- Role: Duty/home defense with capacity advantage

### Glock 30 Gen 4
**Subcompact Trade-offs**
- 3.78" barrel, 23.81 oz polymer frame
- 10+1 capacity
- Reduced damage (36) due to velocity loss
- Highest recoil, worst accuracy
- Role: Concealment at cost of performance

### Glock 41 Gen 4 MOS
**Competition Optimized**
- 5.31" longslide barrel, 23.63 oz
- Highest velocity (270 m/s) among .45s
- 7.64" sight radius (best Glock accuracy)
- MOS optic-ready slide
- Role: Competition/precision Glock option

### Junk 1911
**The Cheap Option**
- Worn/degraded Government 1911
- Pitted barrel, loose tolerances
- Weak springs, unpredictable trigger
- Performs at 9mm damage levels
- Role: Starter weapon, encourages upgrading

---

## Shots to Kill (100 HP Target)

| Weapon | FMJ Close | FMJ Range | JHP Close | JHP Range |
|--------|-----------|-----------|-----------|-----------|
| Quality .45s (38 dmg) | 3 | 7 | 3 | 6 |
| Glock 30 (36 dmg) | 3 | 7-8 | 3 | 6-7 |
| Junk 1911 (34 dmg) | 3 | 8 | 3 | 7 |
| 9mm Reference | 3 | 8 | - | - |

---

## Key Meta Parameters by Weapon

### Damage Falloff

| Weapon | FalloffMin | FalloffMax | Modifier |
|--------|------------|------------|----------|
| M45A1 | 12m | 40m | 0.36 |
| Kimber 1911 | 12m | 40m | 0.36 |
| Kimber Eclipse | 12m | 40m | 0.36 |
| Glock 21 | 12m | 38m | 0.36 |
| Glock 30 | 8m | 30m | 0.34 |
| Glock 41 | 14m | 45m | 0.38 |
| Junk 1911 | 8m | 25m | 0.32 |

### Headshot Modifiers

| Weapon | Modifier | Max Distance |
|--------|----------|--------------|
| All Quality | 2.90x | 8m |
| Glock 41 | 2.90x | 9m |
| Glock 30 | 2.90x | 7m |
| Junk 1911 | 2.60x | 6m |

### Fire Rate (TimeBetweenShots)

| Weapon | TBS | Effective RPM |
|--------|-----|---------------|
| Kimber Eclipse | 0.207 | ~290 |
| M45A1 | 0.214 | ~280 |
| Kimber 1911 | 0.214 | ~280 |
| Glock 41 | 0.226 | ~265 |
| Glock 21 | 0.240 | ~250 |
| Glock 30 | 0.273 | ~220 |
| Junk 1911 | 0.300 | ~200 |

---

## Folder Structure

```
batch3_45acp/
├── weapon_m45a1/
│   ├── meta/
│   │   └── weapons.meta
│   ├── stream/           (add visual assets)
│   ├── cl_weaponNames.lua
│   └── fxmanifest.lua
├── weapon_kimber1911/
│   └── (same structure)
├── weapon_kimber_eclipse/
│   └── (same structure)
├── weapon_g21/
│   └── (same structure)
├── weapon_g30/
│   └── (same structure)
├── weapon_g41/
│   └── (same structure)
└── weapon_junk1911/
    └── (same structure)
```

---

## Installation Notes

1. Add stream assets (.ydr, .ytd, .yft) to each weapon's `/stream/` folder
2. Ensure resource names match weapon hash names
3. Add to server.cfg after ammo_45acp resource:
```cfg
ensure ammo_45acp
ensure weapon_m45a1
ensure weapon_kimber1911
ensure weapon_kimber_eclipse
ensure weapon_g21
ensure weapon_g30
ensure weapon_g41
ensure weapon_junk1911
```

---

## Next Steps

1. Create `ammo_45acp` centralized resource (similar to `ammo_9mm`)
2. Define FMJ and JHP ammunition components
3. Test weapons in-game for damage verification
4. Adjust values based on gameplay testing
