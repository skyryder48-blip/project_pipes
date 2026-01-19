# Batch 5: .357 Magnum & .38 Special Revolvers

## Overview
5 revolvers featuring the powerful .357 Magnum cartridge and one .38 Special.
Revolvers trade capacity and fire rate for devastating per-shot damage.
Barrel length significantly affects .357 Magnum performance.

---

## Included Weapons

| Weapon | Hash | Caliber | Damage | Barrel | Capacity | Fire Rate |
|--------|------|---------|--------|--------|----------|-----------|
| **Colt King Cobra** | `weapon_kingcobra` | .357 Mag | 56 | 4.25" | 6 | ~150 RPM |
| **King Cobra Snub** | `weapon_kingcobra_snub` | .357 Mag | 48 | 2" | 6 | ~130 RPM |
| **King Cobra Target** | `weapon_kingcobra_target` | .357 Mag | 52 | 3" | 6 | ~140 RPM |
| **Colt Python** | `weapon_python` | .357 Mag | 60 | 6" | 6 | ~160 RPM |
| **S&W Model 15** | `weapon_sw_model15` | .38 Spl | 32 | 4" | 6 | ~170 RPM |

---

## Shots to Kill (100 HP Target)

| Weapon | Close | Range | Notes |
|--------|-------|-------|-------|
| **Python (60 dmg)** | 2 | 4 | Best .357 |
| **King Cobra (56 dmg)** | 2 | 4-5 | Standard .357 |
| **KC Target (52 dmg)** | 2 | 5 | 3" barrel |
| **KC Snub (48 dmg)** | 3 | 5-6 | Velocity loss |
| **Model 15 (32 dmg)** | 4 | 8-9 | .38 Special |
| 9mm Reference | 3 | 8 | Comparison |

---

## Installation

### 1. Add Stream Assets
Place your weapon model files (.ydr, .ytd) in each weapon's `/stream/` folder.

### 2. Add to server.cfg
```cfg
# Ammo resources (when developed)
ensure ammo_357mag
ensure ammo_38spl

# Batch 5 Revolvers
ensure weapon_kingcobra
ensure weapon_kingcobra_snub
ensure weapon_kingcobra_target
ensure weapon_python
ensure weapon_sw_model15
```

---

## Key Characteristics

### Colt Python (Premium)
- **The Rolls-Royce of revolvers**
- Highest damage (60) and best accuracy (0.55 spread)
- Longest range (85m falloff max)
- Smoothest trigger (0.375 TBS)
- Heavy weight reduces felt recoil

### Colt King Cobra (Standard)
- Modern production service revolver
- Balanced damage (56) and handling
- Good accuracy with manageable recoil
- DA/SA trigger system

### King Cobra Target (Compact)
- Middle ground between snub and full-size
- Better velocity than 2" snub
- Target sights for improved accuracy
- Good concealed carry option

### King Cobra Snub (Concealment)
- **SEVERE trade-offs for size**
- 37% velocity loss from 2" barrel
- Brutal recoil (0.580 amplitude)
- Poor accuracy (1.40 spread)
- DAO only - slower fire rate

### S&W Model 15 (Training/.38 Special)
- Classic police revolver
- **Lower damage (32) - weaker than 9mm**
- Excellent accuracy and very light recoil
- Fastest follow-up shots of all revolvers
- Training, backup, or period roleplay

---

## Revolver Mechanics

### Fire Rate Limitations
- All revolvers are slower than semi-autos
- DA trigger requires heavier pull
- Practical max: 2-3 shots/second

### Reload Times
- All revolvers: ~3.2-3.8 second reload
- Speedloader assumed (trained shooter)

### Accuracy Advantages
- Fixed barrel provides inherent accuracy
- No slide movement during firing
- Longer barrels = longer sight radius

---

## Caliber Damage Reference

| Caliber | Damage | Role |
|---------|--------|------|
| .22 LR | 14 | Training/Suppressed |
| .38 Special | 32 | Light Revolver |
| 9mm | 34 | Standard Semi-Auto |
| .40 S&W | 36 | LE Semi-Auto |
| .45 ACP | 38 | Heavy Semi-Auto |
| **.357 Magnum** | **48-60** | **Power Revolver** |

---

*Batch 5: .357 Magnum & .38 Special Revolvers*
*5 Weapons: King Cobra (3 variants), Python, Model 15*
