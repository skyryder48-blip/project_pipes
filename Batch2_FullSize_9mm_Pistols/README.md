# Batch 2: Full-Size 9mm Pistols

## Overview
15 full-size 9mm pistols with realistic ballistics and unique weapon characteristics.

## Installation

### Load Order (CRITICAL!)
In your `server.cfg`, load the ammo resource FIRST:

```cfg
# 9mm Ammo System (MUST load first)
ensure ammo_9mm

# Then load weapons in any order
ensure weapon_g17
ensure weapon_g17_gen5
ensure weapon_g17_blk
ensure weapon_g19
ensure weapon_g19x
ensure weapon_g19xd
ensure weapon_g19x_switch
ensure weapon_g45
ensure weapon_g45_tan
ensure weapon_m9
ensure weapon_m9a3
ensure weapon_px4
ensure weapon_p320
ensure weapon_tp9sf
ensure weapon_fn509
```

### Folder Structure
```
resources/
├── [ammo_9mm]/          ← Centralized ammo (load first!)
│   ├── meta/
│   │   ├── ammo_9mm.meta
│   │   └── weaponcomponents_9mm.meta
│   ├── cl_ammoNames.lua
│   └── fxmanifest.lua
│
├── [weapon_g17]/        ← Individual weapon folders
│   ├── meta/weapon_g17.meta
│   ├── stream/          ← Add your .ydr/.ytd files here
│   ├── cl_weaponNames.lua
│   └── fxmanifest.lua
│
└── ... (repeat for each weapon)
```

---

## Ammunition System (Centralized)

All 9mm weapons share standardized ammo effects:

| Ammo Type | Damage | Penetration | Special Effect | Capacity |
|-----------|--------|-------------|----------------|----------|
| **FMJ** | 34 (baseline) | 0.15 | Standard | Standard |
| **Hollow Point** | 37.4 (+10%) | 0.05 | More soft tissue damage, reduced vs armor | Standard |
| **Armor Piercing** | 30.6 (-10%) | 0.30 | Bypasses body armor | -2 rounds |

### Component Names (for scripting)
Each weapon has 3 magazine components:
- `COMPONENT_[WEAPON]_CLIP_FMJ` (default)
- `COMPONENT_[WEAPON]_CLIP_HP`
- `COMPONENT_[WEAPON]_CLIP_AP`

Example for Glock 17:
- `COMPONENT_G17_CLIP_FMJ`
- `COMPONENT_G17_CLIP_HP`
- `COMPONENT_G17_CLIP_AP`

---

## Weapon Specifications

### Glock Models

| Weapon | Barrel | Capacity | Fire Rate | Unique Trait |
|--------|--------|----------|-----------|--------------|
| **G17 Gen 4** | 4.49" | 17+1 | 0.170s | Baseline full-size |
| **G17 Gen 5** | 4.49" GMB | 17+1 | 0.160s | **Best accuracy** (Marksman Barrel) |
| **G17 Blackout** | 4.49" | 17+1 | 0.170s | Cosmetic variant |
| **G19 Gen 4** | 4.02" | 15+1 | 0.170s | Compact, faster handling |
| **G19X** | 4.02" | 17+1 | 0.165s | Hybrid frame, better recoil |
| **G19X Deluxe** | 4.02" | 17+1 | 0.165s | Premium variant |
| **G19X Switch** | 4.02" | 17+1 | **0.055s** | **FULL-AUTO** (~1100 RPM) |
| **G45** | 4.02" | 17+1 | 0.158s | Best hybrid, improved trigger |
| **G45 Tan** | 4.02" | 17+1 | 0.158s | FDE cosmetic variant |

### Beretta Models

| Weapon | Barrel | Capacity | Fire Rate | Unique Trait |
|--------|--------|----------|-----------|--------------|
| **M9** | 4.9" | 15+1 | 0.190s | **Heaviest** (944g), best recoil control, DA/SA |
| **M9A3** | 5.1" | 17+1 | 0.185s | Threaded barrel, suppressor-ready |
| **PX4 Storm** | 4.0" | 17+1 | 0.155s | **Rotating barrel** = exceptional recoil |

### Other Models

| Weapon | Barrel | Capacity | Fire Rate | Unique Trait |
|--------|--------|----------|-----------|--------------|
| **Sig P320** | 4.7" | 17+1 | 0.155s | **Highest accuracy**, military modular |
| **Canik TP9SF** | 4.46" | **18+1** | **0.140s** | **Best trigger**, highest capacity |
| **FN 509** | 4.0" | 17+1 | 0.175s | **Lightest** (763g), fastest handling |

---

## Detailed Weapon Characteristics

### Premium Tier (Best Performance)
1. **Sig P320** - Military-grade accuracy, longest barrel (4.7"), low bore axis
2. **G17 Gen 5** - Glock Marksman Barrel for improved accuracy
3. **M9A3** - Upgraded Beretta with threaded barrel, extended range

### Speed Tier (Fastest Fire Rate)
1. **Canik TP9SF** - Competition trigger (3.5-4.5 lb), 0.140s between shots
2. **PX4 Storm** - Rotating barrel reduces muzzle flip, fast follow-ups
3. **G19X Switch** - Full-auto (~1100 RPM) but SEVERE recoil penalty

### Stability Tier (Best Recoil Control)
1. **M9** - Heaviest pistol (944g), exceptional stability
2. **PX4 Storm** - Rotating barrel converts recoil to rotation
3. **P320** - Low bore axis design

### Mobility Tier (Fastest Handling)
1. **FN 509** - Lightest full-size (763g)
2. **G19** - Compact frame
3. **G45/G19X** - Compact slide on full frame

---

## Balance Notes

### 9mm Baseline (all weapons)
- **Body shots**: 3 to kill close, 8 at range
- **Headshots**: 1 shot point-blank, 2+ beyond 7 units
- **Falloff starts**: 14-22 units (varies by barrel length)
- **Falloff max**: 45-65 units (varies by barrel length)

### Switch Weapon Warning
The G19X Switch has realistic full-auto drawbacks:
- **AccuracySpread**: 2.40 (vs 1.50 baseline)
- **RecoilAmplitude**: 0.38 (vs 0.16 baseline)
- **Effective range**: Drastically reduced
- Burns through 17 rounds in under 1 second

---

## Stream Files Required

Each weapon folder has an empty `stream/` directory. You must add:
- `w_pi_[weapon].ydr` - Weapon model
- `w_pi_[weapon].ytd` - Weapon textures
- `w_pi_[weapon]_hi.ydr` - High-detail model (optional)

---

## Scripting Reference

### Give weapon with specific ammo
```lua
-- Give Glock 17 with Hollow Point ammo
GiveWeaponToPed(ped, GetHashKey('WEAPON_G17'), 100, false, true)
GiveWeaponComponentToPed(ped, GetHashKey('WEAPON_G17'), GetHashKey('COMPONENT_G17_CLIP_HP'))
```

### Switch ammo type
```lua
-- Remove current magazine, add AP
RemoveWeaponComponentFromPed(ped, GetHashKey('WEAPON_G17'), GetHashKey('COMPONENT_G17_CLIP_FMJ'))
GiveWeaponComponentToPed(ped, GetHashKey('WEAPON_G17'), GetHashKey('COMPONENT_G17_CLIP_AP'))
```

---

## Version History
- **1.0.0** - Initial release with 15 full-size 9mm pistols
