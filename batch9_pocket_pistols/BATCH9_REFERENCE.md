# Batch 9: Pocket Pistols (.25 ACP / .380 ACP / 9mm)

## Overview
4 concealment-focused pistols spanning the complete pocket pistol spectrum from marginal .25 ACP deep-concealment to full-size 9mm service. This batch demonstrates how caliber selection dominates terminal performance—the Walther P88 delivers **5x the energy** of the Colt Junior despite similar form factors.

---

## Caliber Specifications

### .25 ACP (6.35×16mm Browning)
| Property | Value |
|----------|-------|
| Muzzle Energy | 63-65 ft-lbs |
| vs 9mm | **~1/5 energy (20%)** |
| FBI Gel Penetration | 11-12" (marginal) |
| Expansion | None (insufficient velocity) |
| Failure to Incapacitate | **35% (highest)** |
| Role | "Better than nothing" |

### .380 ACP (9×17mm Kurz)
| Property | Value |
|----------|-------|
| Muzzle Energy | 170-220 ft-lbs |
| vs 9mm | **~60% energy** |
| FBI Gel Penetration | 12-14" (adequate) |
| Expansion | Variable (load-dependent) |
| Failure to Incapacitate | 16% |
| Role | Minimum defensive caliber |

### 9mm Luger (9×19mm Parabellum)
| Property | Value |
|----------|-------|
| Muzzle Energy | 350-400 ft-lbs |
| FBI Gel Penetration | 12-18" (ideal) |
| Expansion | Reliable with quality JHP |
| Role | Standard service caliber |

---

## Weapon Specifications Summary

| Weapon | Hash | Caliber | Damage | Barrel | Capacity | Recoil | Accuracy |
|--------|------|---------|--------|--------|----------|--------|----------|
| **Colt Junior** | `weapon_coltjunior` | .25 ACP | 8 | 2.25" | 7 | 0.030 | 2.20 |
| **Walther PPK** | `weapon_waltherppk` | .380 ACP | 20 | 3.3" | 7 | 0.180 | 1.40 |
| **SIG P238** | `weapon_sigp238` | .380 ACP | 18 | 2.7" | 7 | 0.140 | 1.10 |
| **Walther P88** | `weapon_waltherp88` | 9mm | 34 | 4.0" | 16 | 0.180 | 0.90 |

---

## Detailed Weapon Profiles

### Colt Junior .25 ACP
**The Ultimate Deep-Concealment "Gentleman's Gun"**

| Specification | Value |
|--------------|-------|
| Barrel Length | 2.25" |
| Weight (empty) | 12-13 oz |
| Trigger | SA, exposed hammer |
| Muzzle Velocity | 753-780 fps |
| Muzzle Energy | 63-65 ft-lbs |
| Production | 1958-1973 (~160,000 units) |
| Value | $300-600 (collector) |

**Game Stats:**
- Damage: 8 (requires 13 body shots close)
- Fire Rate: ~200 RPM (0.300 TBS)
- Negligible recoil (0.030)
- Very poor accuracy at range
- High headshot multiplier (8.0x) to compensate

**Role:** Absolute last-ditch backup where any gun is better than none. The .25 ACP's 35% failure rate in real shootings translates to extreme unreliability in-game. Players must land headshots or accept diminished effectiveness.

---

### Walther PPK .380 ACP
**Cinema's Most Iconic Concealment Pistol**

| Specification | Value |
|--------------|-------|
| Barrel Length | 3.3" |
| Weight (empty) | 19 oz |
| Trigger | DA/SA (13.4 lb DA, 6.1 lb SA) |
| Muzzle Velocity | 880-950 fps |
| Muzzle Energy | 170-220 ft-lbs |
| Production | 1931-present |
| MSRP | $969 |

**Game Stats:**
- Damage: 20 (5 shots close, 10 at range)
- Fire Rate: ~160 RPM (0.375 TBS)
- Moderate recoil (straight blowback)
- Heavy first DA pull affects accuracy

**Characteristics:**
- James Bond's signature pistol ("delivery like a brick through plate glass")
- Straight blowback = more felt recoil than locked-breech designs
- Notorious for slide bite on older models
- November 2025 production pause for re-engineering

**Role:** Classic concealment with genuine defensive capability. The .380 ACP represents the minimum viable defensive caliber—adequate but not ideal.

---

### SIG Sauer P238 .380 ACP
**1911 Handling in Pocket-Pistol Form**

| Specification | Value |
|--------------|-------|
| Barrel Length | 2.7" (0.6" shorter than PPK) |
| Weight (empty) | 15.2 oz (3.8 oz lighter) |
| Trigger | SAO (7-8 lb crisp break) |
| Muzzle Velocity | 850-950 fps |
| Muzzle Energy | 170-200 ft-lbs |
| Production | 2009-discontinued |
| Value | $300-700 |

**Game Stats:**
- Damage: 18 (6 shots close, 11-12 at range)
- Fire Rate: ~180 RPM (0.333 TBS)
- Light recoil (locked breech)
- Better accuracy than PPK (SAO trigger)

**Characteristics:**
- Scaled-down 1911 platform
- Every shot has identical trigger feel (no heavy DA)
- Requires cocked-and-locked carry (manual safety)
- Aluminum frame with stainless slide

**Role:** For players who prioritize accuracy over raw power. The P238's superior trigger and lower recoil allow faster accurate follow-up shots than the PPK.

---

### Walther P88 9mm
**1980s German Engineering Excess**

| Specification | Value |
|--------------|-------|
| Barrel Length | 4.0" |
| Weight (empty) | 31.5 oz |
| Trigger | DA/SA (10-12 lb DA, 4.5-5 lb SA) |
| Capacity | 15+1 |
| Muzzle Velocity | 1,100-1,200 fps |
| Muzzle Energy | 350-400 ft-lbs |
| Production | 1987-1996 (~10,000 units) |
| Value | $1,000-1,500 |

**Game Stats:**
- Damage: 34 (3 shots close, 8 at range)
- Fire Rate: ~200 RPM (0.300 TBS)
- Best accuracy of any 9mm (0.90 spread)
- Heavy frame absorbs recoil excellently

**Characteristics:**
- Developed for US Army XM9 trials
- Frame cracking after 7,000 rounds led to rejection
- Cost 1,800 DM (2x competitors like USP)
- Exceptional fixed-barrel accuracy

**Role:** Premium 9mm for accuracy-focused players. The P88's heavy weight and excellent trigger make it one of the most controllable 9mm pistols available, at the cost of bulk.

---

## Shots to Kill (100 HP Target)

| Weapon | Caliber | Close | Range | Headshot Close | Headshot Far |
|--------|---------|-------|-------|----------------|--------------|
| **Colt Junior** | .25 ACP | 13 | 26+ | 2 | 4+ |
| **Walther PPK** | .380 ACP | 5 | 10 | 1 | 2-3 |
| **SIG P238** | .380 ACP | 6 | 11-12 | 1 | 2-3 |
| **Walther P88** | 9mm | 3 | 8 | 1 | 2 |
| *9mm Reference* | *9mm* | *3* | *8* | *1* | *2* |

---

## Key Meta Parameters Comparison

### Damage by Caliber/Barrel

| Weapon | Caliber | Barrel | Energy | Damage | % of 9mm |
|--------|---------|--------|--------|--------|----------|
| Colt Junior | .25 ACP | 2.25" | 65 ft-lbs | 8 | 24% |
| SIG P238 | .380 ACP | 2.7" | 180 ft-lbs | 18 | 53% |
| Walther PPK | .380 ACP | 3.3" | 200 ft-lbs | 20 | 59% |
| Walther P88 | 9mm | 4.0" | 380 ft-lbs | 34 | 100% |

### Damage Falloff

| Weapon | FalloffMin | FalloffMax | Modifier | WeaponRange |
|--------|------------|------------|----------|-------------|
| Colt Junior | 5m | 25m | 0.50 | 50m |
| SIG P238 | 7m | 30m | 0.48 | 65m |
| Walther PPK | 8m | 35m | 0.50 | 70m |
| Walther P88 | 15m | 50m | 0.38 | 100m |

### Fire Rate

| Weapon | TBS | RPM | Trigger Type |
|--------|-----|-----|--------------|
| Walther P88 | 0.300 | ~200 | DA/SA |
| Colt Junior | 0.300 | ~200 | SA only |
| SIG P238 | 0.333 | ~180 | SAO |
| Walther PPK | 0.375 | ~160 | DA/SA (heavy DA) |

### Recoil Comparison

| Weapon | Amplitude | Character |
|--------|-----------|-----------|
| Colt Junior | 0.030 | Negligible |
| SIG P238 | 0.140 | Light (locked breech) |
| Walther PPK | 0.180 | Moderate (blowback) |
| Walther P88 | 0.180 | Moderate (heavy frame) |

---

## Caliber Hierarchy Position

| Caliber | Damage | Capacity | Recoil | Role |
|---------|--------|----------|--------|------|
| .22 LR | 14 | 10-15 | Minimal | Training |
| **.25 ACP** | **8** | **7** | **Negligible** | **Emergency backup** |
| .32 ACP | 12 | 7-8 | Very light | (Not in batch) |
| **.380 ACP** | **18-20** | **7** | **Light** | **Pocket defensive** |
| 5.7×28mm | 28-30 | 20 | Very low | PDW |
| **9mm** | **34** | **15-17** | **Low** | **Service standard** |
| .40 S&W | 36 | 13-15 | Moderate | LE duty |
| .45 ACP | 38 | 7-13 | Moderate | Heavy |

---

## P238 vs PPK: Direct Comparison

| Attribute | SIG P238 | Walther PPK | Advantage |
|-----------|----------|-------------|-----------|
| **Damage** | 18 | 20 | PPK (+11%) |
| **Barrel** | 2.7" | 3.3" | PPK |
| **Weight** | 15.2 oz | 19 oz | P238 (lighter) |
| **Capacity** | 6+1 | 6+1 | Tie |
| **Trigger** | SAO 7-8 lb | DA/SA 13.4/6.1 lb | P238 (consistent) |
| **Recoil** | 0.140 | 0.180 | P238 (lower) |
| **Accuracy** | 1.10 | 1.40 | P238 (better) |
| **Fire Rate** | 180 RPM | 160 RPM | P238 (faster) |

**Summary:** The P238 trades raw damage for superior handling—better trigger, lower recoil, faster follow-ups. The PPK wins on paper damage but the P238's consistency rewards skilled shooters.

---

## Folder Structure

```
batch9_pocket_pistols/
├── weapon_coltjunior/
│   ├── meta/
│   │   └── weapons.meta
│   ├── stream/              (add your .ydr/.ytd models here)
│   ├── cl_weaponNames.lua
│   └── fxmanifest.lua
├── weapon_waltherppk/
│   └── (same structure)
├── weapon_sigp238/
│   └── (same structure)
├── weapon_waltherp88/       (9mm - move to 9mm batch as needed)
│   └── (same structure)
└── BATCH9_REFERENCE.md
```

---

## Installation Notes

1. Add stream assets to each weapon's `/stream/` folder
2. Add to server.cfg:
```cfg
# Batch 9 Pocket Pistols
ensure weapon_coltjunior
ensure weapon_waltherppk
ensure weapon_sigp238
ensure weapon_waltherp88    # Or move to 9mm batch
```

3. Register with ox_inventory

**Note:** The Walther P88 is a full-size 9mm service pistol included here for organizational purposes. It can be moved to the 9mm batch (Batch 1/2/11) as appropriate for your server structure.

---

## Ammunition Notes

### .25 ACP
- Standard load: 50gr FMJ at 750-780 fps
- Best defensive: Buffalo Bore 60gr hardcast (96 ft-lbs max)
- No JHP expansion at these velocities—penetration is the only mechanism

### .380 ACP  
- Standard load: 90gr FMJ at 950 fps
- Best defensive: Hornady Critical Defense 90gr (reliable expansion)
- Load selection matters significantly—cheap FMJ vs premium JHP can mean 30% performance difference

### 9mm
- Standard load: 115gr FMJ at 1,150 fps or 147gr subsonic at 950 fps
- Best defensive: Federal HST 147gr or Speer Gold Dot 124gr+P
- The P88's 4" barrel achieves full 9mm potential

---

## Balance Philosophy

This batch demonstrates the **caliber-first principle**: weapon platform matters far less than cartridge selection. A $600 PPK and a $700 P238 firing the same .380 ACP ammunition will produce nearly identical terminal effects, differing only in ergonomics and controllability.

The extreme spread from 8 damage (.25 ACP) to 34 damage (9mm) creates meaningful player choices:
- **Colt Junior:** Maximum concealment, minimum effectiveness—roleplay/desperation weapon
- **PPK/P238:** Viable defensive carry with genuine stopping power
- **P88:** Full combat capability in a concealable (but not pocket) size

---

*Document Version: 1.0*
*Batch 9: Pocket Pistols*
*4 Weapons: Colt Junior (.25 ACP), Walther PPK (.380), SIG P238 (.380), Walther P88 (9mm)*
