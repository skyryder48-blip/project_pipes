# Batch 6: Large Caliber Magnum Revolvers

## Overview
4 heavy magnum revolvers representing the pinnacle of handgun power.
These weapons trade capacity and fire rate for devastating per-shot damage.

---

## Weapon Specifications Summary

| Weapon | Hash | Caliber | Damage | Barrel | Capacity | Recoil | Fire Rate |
|--------|------|---------|--------|--------|----------|--------|-----------|
| **S&W Model 29** | `weapon_sw_model29` | .44 Mag | 100 | 6.5" | 6 | 0.560 | 0.650 TBS |
| **S&W 657** | `weapon_sw657` | .41 Mag* | 68 | 6" | 6 | 0.420 | 0.500 TBS |
| **Taurus Raging Bull** | `weapon_ragingbull` | .44 Mag | 95 | 6.5" ported | 6 | 0.480 | 0.600 TBS |
| **S&W Model 500** | `weapon_sw500` | .500 S&W | 185 | 6.5" | 5 | 0.950 | 1.200 TBS |

*S&W 657 is configured with .41 Magnum characteristics but fires .357 ammo

---

## Detailed Weapon Profiles

### S&W Model 29 (.44 Magnum)
**"The most powerful handgun in the world" - Dirty Harry**
- Iconic N-frame carbon steel construction
- 6.5" barrel with 8" sight radius
- Weight: 47.7 oz
- Muzzle Energy: 1,000-1,100 ft-lbs
- Role: High-power precision revolver

**Key Stats:**
- Damage: 100 (1-2 shots close, 3-4 at range)
- High recoil but excellent accuracy
- Longest effective range of .44 Mag options

---

### S&W 657 (.41 Magnum → fires .357)
**"The Forgotten Magnum" - Ballistic sweet spot**
- N-frame stainless steel (discontinued 1986-2005)
- 6" barrel, considered most accurate N-frame
- Weight: 48-52 oz
- Configured for +P service loads
- Muzzle Energy: 850-1,050 ft-lbs
- Role: Balanced power/controllability

**Key Stats:**
- Damage: 68 (2 shots close, 4-5 at range)
- Best accuracy of the batch
- 20-30% less recoil than .44 Mag
- Uses .357 Magnum ammunition

---

### Taurus Raging Bull (.44 Magnum Ported)
**Heavy-frame revolver with recoil compensation**
- Large frame (heavier than N-frame)
- 6.5" ported barrel reduces muzzle rise 30-32%
- Weight: 53-55 oz
- Soft rubber grips with cushioned backstrap
- Muzzle Energy: 900-1,000 ft-lbs (velocity loss from porting)
- Role: Controllable .44 Magnum platform

**Key Stats:**
- Damage: 95 (2 shots close, 3-4 at range)
- Fastest follow-up shots of .44 Mag options
- Trade-off: louder, more visible flash
- Best choice for rapid engagement

---

### S&W Model 500 (.500 S&W Magnum)
**THE MOST POWERFUL PRODUCTION REVOLVER**
- X-Frame stainless steel construction
- 6.5" barrel with dual-port compensator
- Weight: 60.7 oz
- Hogue Sorbothane rubber grips
- 350gr XTP Hunting Loads
- Muzzle Energy: 2,200-2,800 ft-lbs (equivalent to .308 Winchester)
- Role: Maximum stopping power at any cost

**Key Stats:**
- Damage: 185 (approaching one-shot territory)
- EXTREME recoil - slowest fire rate
- 5-round capacity
- Requires deliberate, aimed fire
- Not for rapid engagement

---

## Caliber Damage Hierarchy

| Caliber | Base Damage | Energy (ft-lbs) | vs 9mm |
|---------|-------------|-----------------|--------|
| 9mm | 34 | 350-400 | 1.00x |
| .357 Magnum | 56-60 | 540-625 | 1.65x |
| .41 Magnum (+P) | 68 | 850-1,050 | 2.00x |
| .44 Magnum | 95-100 | 900-1,100 | 2.85x |
| .500 S&W Magnum | 185 | 2,200-2,800 | 5.45x |

---

## Recoil Comparison

| Weapon | Amplitude | Recovery | Character |
|--------|-----------|----------|-----------|
| S&W 657 (.41 Mag) | 0.420 | 0.320 | Heavy but controllable |
| Raging Bull (ported) | 0.480 | 0.350 | Moderate, porting helps |
| S&W Model 29 | 0.560 | 0.280 | Heavy, slower recovery |
| **S&W Model 500** | **0.950** | **0.180** | **EXTREME** |

---

## Fire Rate Comparison

| Weapon | TBS (seconds) | RPM Equivalent | Notes |
|--------|---------------|----------------|-------|
| S&W 657 | 0.500 | ~120 | Fastest of batch |
| Raging Bull | 0.600 | ~100 | Good follow-up |
| S&W Model 29 | 0.650 | ~92 | Deliberate pace |
| **S&W Model 500** | **1.200** | **~50** | **Must reset between shots** |

---

## Folder Structure

```
batch6_magnums/
├── weapon_sw_model29/
│   ├── meta/
│   │   └── weapons.meta
│   ├── stream/              (add your models here)
│   ├── cl_weaponNames.lua
│   └── fxmanifest.lua
├── weapon_sw_657/
│   └── (same structure)
├── weapon_ragingbull/
│   └── (same structure)
├── weapon_sw500/
│   └── (same structure)
└── BATCH6_REFERENCE.md
```

---

## Installation

1. Add stream assets to each weapon's `/stream/` folder
2. Add to server.cfg:
```cfg
# Ammunition resources (load BEFORE weapons)
ensure ammo_44mag          # (when developed)
ensure ammo_500sw          # (when developed)

# Batch 6 Weapons
ensure weapon_sw_model29
ensure weapon_sw_657
ensure weapon_ragingbull
ensure weapon_sw500
```

3. Register with ox_inventory

---

## Balance Notes

### Shots to Kill (100 HP target)

| Weapon | Close Range | Max Range | Headshot Close | Headshot Far |
|--------|-------------|-----------|----------------|--------------|
| S&W Model 29 | 1-2 | 3-4 | 1 | 1-2 |
| S&W 657 | 2 | 4-5 | 1 | 1-2 |
| Raging Bull | 2 | 3-4 | 1 | 1-2 |
| S&W Model 500 | **1** | **2** | **1** | **1** |

### Engagement Philosophy

- **S&W Model 29**: Classic magnum - high power, high skill ceiling
- **S&W 657**: Best accuracy, moderate power, good for precision
- **Raging Bull**: Best for rapid .44 Mag work, controlled recoil
- **S&W Model 500**: Nuclear option - one shot, make it count

---

## Ammo System Notes

- S&W Model 29 and Raging Bull share .44 Magnum ammunition
- S&W 657 uses .357 Magnum ammunition (configured for .41 Mag handling)
- S&W Model 500 requires dedicated .500 S&W Magnum ammunition

---

*Document Version: 1.0*
*Batch 6: Large Caliber Magnum Revolvers*
*4 Weapons: Model 29, 657, Raging Bull, Model 500*
