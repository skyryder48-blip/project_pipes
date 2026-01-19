# Batch 10: 10mm Auto Pistols

## Overview
1 full-power 10mm semi-automatic pistol delivering .357 Magnum energy with semi-auto capacity and reloading advantages. The 10mm Auto occupies a unique position—**FBI-spec "lite" loads match .40 S&W**, while **full-power loads equal or exceed .357 Magnum**. This implementation uses full-power ballistics.

---

## 10mm Auto Caliber Specifications

### Cartridge Data
| Specification | Value |
|--------------|-------|
| Case Length | 25.20mm / 0.992" |
| Overall Length | 32.00mm / 1.260" |
| Bullet Diameter | 10.17mm / 0.400" |
| SAAMI Max Pressure | **37,500 PSI** |
| Common Weights | 135gr, 155gr, 180gr, 200gr, 220gr |

### The FBI Download Story

The original **1983 Norma specification** loaded 200gr bullets at **1,200-1,260 fps** producing **639-704 ft-lbs**. After the FBI adopted 10mm following the 1986 Miami shootout, agents struggled with recoil in the S&W 1076. The bureau developed a reduced "FBI-spec" load: **180gr at 950 fps (361 ft-lbs)**—essentially creating .40 S&W performance in a longer case.

This led directly to the .40 S&W's development in 1990—the same FBI-spec ballistics in a shorter case that fit 9mm-frame pistols.

### FBI-Spec vs Full-Power Loads

| Load Type | Velocity | Energy | Equivalent To |
|-----------|----------|--------|---------------|
| **FBI-Spec** | 950-1,030 fps | 360-420 ft-lbs | .40 S&W |
| **Full-Power** | 1,250-1,350 fps | 575-730 ft-lbs | .357 Magnum |

**This implementation uses full-power ballistics.**

### Full-Power Load Examples

| Manufacturer | Load | Velocity | Energy |
|--------------|------|----------|--------|
| Underwood | 135gr JHP | 1,600 fps | **768 ft-lbs** |
| Buffalo Bore | 180gr JHP | 1,350 fps | **728 ft-lbs** |
| Underwood | 155gr XTP | 1,400 fps | 675 ft-lbs |
| Sig Sauer | 180gr V-Crown | 1,250 fps | 624 ft-lbs |
| Hornady | 180gr XTP Custom | 1,275 fps | 650 ft-lbs |
| Buffalo Bore | 220gr Hard Cast | 1,200 fps | **703 ft-lbs** |

---

## Weapon Specifications Summary

| Weapon | Hash | Caliber | Damage | Barrel | Capacity | Recoil | Accuracy |
|--------|------|---------|--------|--------|----------|--------|----------|
| **Glock 20 Gen 4** | `weapon_glock20` | 10mm Auto | 50 | 4.61" | 16 | 0.350 | 1.20 |

---

## Glock 20 Gen 4 Detailed Profile

**The Premier 10mm Platform**

| Specification | Value |
|--------------|-------|
| Barrel Length | 4.61" / 117mm |
| Overall Length | 8.03" / 204mm |
| Height | 5.47" / 139mm |
| Weight (empty) | 27.51 oz / 780g |
| Weight (loaded, 15+1) | 39.54 oz / 1,120g |
| Trigger Pull | ~5.5 lbs (Safe Action) |
| Sight Radius | 6.77" / 172mm |
| Recoil Spring | 17 lb (stock), 20-22 lb recommended for hot loads |

**Game Stats:**
- Damage: 50 (2 shots close, 5 at range)
- Fire Rate: ~180 RPM (0.333 TBS)
- Heavy recoil (0.350 amplitude)
- Good accuracy for the power level
- High penetration capability

**Characteristics:**
- Full-size "large frame" platform (same as Glock 21 .45 ACP)
- Polygonal rifling, 1:9.84" twist
- Dual captive recoil spring (Gen 4+)
- Modular backstraps for grip adjustment
- Converts to .40 S&W with barrel swap

**Real-World Applications:**
- Woods/bear defense (Denmark's Sirius Patrol uses G20 for polar bears)
- Hunting (feral hogs, deer within 75 yards)
- FBI HRT and select SWAT teams
- Backcountry carry alternative to revolvers

---

## Shots to Kill (100 HP Target)

| Weapon | Caliber | Close | Range | Headshot Close | Headshot Far |
|--------|---------|-------|-------|----------------|--------------|
| **Glock 20** | 10mm | 2 | 5 | 1 | 1-2 |
| *Glock 22 (.40 S&W)* | *.40 S&W* | *3* | *7* | *1* | *2* |
| *King Cobra (.357)* | *.357 Mag* | *2* | *4-5* | *1* | *2* |
| *9mm Reference* | *9mm* | *3* | *8* | *1* | *2* |

---

## Key Meta Parameters

### Damage Calculation

| Caliber | Energy (ft-lbs) | Damage | % of 9mm |
|---------|-----------------|--------|----------|
| 9mm | ~350 | 34 | 100% |
| .40 S&W | ~420 | 36 | 106% |
| **.45 ACP** | ~400 | 38 | 112% |
| **10mm Full-Power** | **~625** | **50** | **147%** |
| .357 Mag (4") | ~580 | 56 | 165% |

### Damage Falloff

| Parameter | Value | Notes |
|-----------|-------|-------|
| FalloffMin | 18m | Full damage to 18 meters |
| FalloffMax | 60m | Minimum damage at 60+ meters |
| FalloffModifier | 0.40 | 40% damage at max range |
| WeaponRange | 120m | Maximum bullet travel |

### Recoil Comparison

| Caliber | Recoil Energy | Game Amplitude | Character |
|---------|---------------|----------------|-----------|
| 9mm | 5.2 ft-lbs | 0.200 | Light |
| .40 S&W | 10.4 ft-lbs | 0.280 | Snappy |
| .45 ACP | 7.9 ft-lbs | 0.250 | Push |
| **10mm Full-Power** | **11.4 ft-lbs** | **0.350** | **Heavy, snappy** |
| .357 Magnum | 8.7 ft-lbs | 0.400-0.450 | Sharp |

**Note:** 10mm has approximately **44% more recoil energy** than .45 ACP despite similar platform weight. The high-velocity impulse creates a "snappy" sensation versus .45's slower "push."

---

## 10mm vs Other Calibers

### 10mm vs .40 S&W
| Attribute | 10mm (Full-Power) | .40 S&W | Difference |
|-----------|-------------------|---------|------------|
| Velocity (180gr) | 1,300 fps | 1,000 fps | +30% |
| Energy | 625 ft-lbs | 420 ft-lbs | **+49%** |
| Case Length | 25.2mm | 21.6mm | +17% |
| Capacity (G20 vs G22) | 15+1 | 15+1 | Same |
| Recoil | High | Moderate | +40% |

**.40 S&W is literally "10mm Short"**—developed to replicate FBI-spec 10mm in a 9mm-sized frame.

### 10mm vs .357 Magnum
| Attribute | 10mm (Full-Power) | .357 Mag (4") | Advantage |
|-----------|-------------------|---------------|-----------|
| Energy | 625 ft-lbs | 540-625 ft-lbs | Similar |
| Capacity | 15+1 | 6 | **10mm (+10 rounds)** |
| Reload Speed | Fast (magazine) | Slow (speedloader) | **10mm** |
| Recoil | High | Very High | 10mm (lower) |
| Trajectory | Flatter | Similar | 10mm (slightly) |

Full-power 10mm matches standard .357 Magnum with **2.5x the capacity** and faster reloads.

### 10mm vs .45 ACP
| Attribute | 10mm (Full-Power) | .45 ACP | Difference |
|-----------|-------------------|---------|------------|
| Velocity (180gr) | 1,300 fps | 950 fps | +37% |
| Energy | 625 ft-lbs | 400 ft-lbs | **+56%** |
| Bullet Diameter | .400" | .452" | .45 larger |
| Recoil Character | Snappy | Push | Different feel |
| Capacity (G20 vs G21) | 15+1 | 13+1 | +2 rounds |

---

## Ballistic Gel Testing (Lucky Gunner Labs)

Testing from Glock 20 (4.61" barrel) through 4-layer heavy clothing:

| Load | Penetration | Expansion | Velocity | FBI 12-18"? |
|------|-------------|-----------|----------|-------------|
| **Barnes 155gr VOR-TX** | 12.48" | **0.806"** | 1,079 fps | ✅ **Best** |
| Hornady 155gr XTP | 14.0" | 0.676" | 1,343 fps | ✅ Pass |
| Federal 180gr Hydra-Shok | 15.88" | 0.612" | 1,002 fps | ✅ Pass |
| Winchester 175gr Silvertip | 16.24" | 0.676" | 1,143 fps | ✅ Pass |
| Sig Sauer 180gr V-Crown | 19.36" | 0.764" | 1,138 fps | ❌ Over-pen |
| Buffalo Bore 220gr Hard Cast | 32"+ | N/A | 1,200 fps | N/A (hunting) |

**Key Finding:** Full-power 10mm can push JHP bullets beyond their design envelope. Optimal velocity for .40 caliber JHP is **1,000-1,200 fps**.

---

## Related 10mm Variants (Future Additions)

| Model | Barrel | Capacity | Weight | Purpose |
|-------|--------|----------|--------|---------|
| **Glock 20** | 4.61" | 15+1 | 39.5 oz | Duty/woods carry |
| Glock 29 | 3.78" | 10+1 | 32.8 oz | Concealed carry |
| Glock 40 MOS | 6.02" | 15+1 | 32.3 oz | Hunting/competition |

---

## Caliber Hierarchy Position

| Caliber | Damage | Capacity | Recoil | Role |
|---------|--------|----------|--------|------|
| .22 LR | 14 | 10-15 | Minimal | Training |
| .380 ACP | 18-20 | 7 | Light | Pocket |
| 9mm | 34 | 15-17 | Low | Standard service |
| .40 S&W | 36 | 13-15 | Moderate | LE duty |
| .45 ACP | 38 | 7-13 | Moderate | Heavy semi-auto |
| **10mm Auto** | **50** | **15** | **High** | **Magnum semi-auto** |
| .357 Magnum | 48-60 | 6 | High-Very High | Power revolver |

**10mm fills the gap between service calibers and magnum revolvers**—delivering revolver-class stopping power with semi-auto capacity and handling.

---

## Folder Structure

```
batch10_10mm/
├── weapon_glock20/
│   ├── meta/
│   │   └── weapons.meta
│   ├── stream/              (add your .ydr/.ytd models here)
│   ├── cl_weaponNames.lua
│   └── fxmanifest.lua
└── BATCH10_REFERENCE.md
```

---

## Installation Notes

1. Add stream assets to `/stream/` folder
2. Add to server.cfg:
```cfg
# Batch 10 - 10mm Pistols
ensure weapon_glock20
```

3. Register with ox_inventory

---

## Ammunition Implementation Notes

If implementing separate ammunition types:

| Ammo Type | Velocity | Damage Modifier | Notes |
|-----------|----------|-----------------|-------|
| 10mm FMJ (FBI-Spec) | 1,000 fps | 0.72x (36 dmg) | Budget/practice |
| 10mm JHP (Standard) | 1,150 fps | 0.85x (42 dmg) | Mid-tier defense |
| 10mm JHP (Full-Power) | 1,300 fps | 1.00x (50 dmg) | Premium defense |
| 10mm Hard Cast | 1,200 fps | 1.10x (55 dmg) | Maximum penetration |

FBI-spec ammunition essentially delivers .40 S&W performance. Only full-power loads achieve the 10mm's advertised potential.

---

## Balance Philosophy

The Glock 20 represents the **maximum semi-automatic handgun power** available outside of specialty hunting/magnum platforms. Its high damage (50) is balanced by:

1. **Heavy recoil** (0.350) - slower follow-up shots than lighter calibers
2. **Significant muzzle rise** - requires skill to control
3. **Cost** - 10mm ammunition is expensive ($0.40-1.50/round)
4. **Availability** - full-power ammo requires specialty ordering

Players choosing the Glock 20 commit to a high-risk, high-reward platform: devastating two-shot kills reward accuracy, but missed shots are heavily penalized by recovery time.

---

*Document Version: 1.0*
*Batch 10: 10mm Auto Pistols*
*1 Weapon: Glock 20 Gen 4*
