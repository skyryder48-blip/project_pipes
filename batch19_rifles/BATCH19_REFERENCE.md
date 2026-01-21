# Batch 19: Precision Rifle and Anti-Materiel Development Reference

## Overview

Eight rifle platforms spanning from precision bolt-actions to semi-automatic anti-materiel systems. This batch covers four caliber tiers with muzzle energies ranging from **1,300 ft-lbs (5.56 NATO) to 13,200 ft-lbs (.50 BMG)**—a 10x energy spread requiring careful damage scaling with diminishing returns.

---

## Weapon Comparison Matrix

| Weapon | Caliber | Action | Damage | Range | Mag | Fire Rate | Recoil |
|--------|---------|--------|--------|-------|-----|-----------|--------|
| **SIG 550** | 5.56 NATO | Semi/Auto | 45 | 450m | 20 | 700 RPM | 18% |
| **Remington 700** | .308 Win | Bolt | 78 | 750m | 4 | ~55 RPM | 38% |
| **Sauer 101** | .308 Win | Bolt | 80 | 800m | 5 | ~63 RPM | 32% |
| **Remington M24** | .308 Win | Bolt | 85 | 850m | 5 | ~50 RPM | 35% |
| **NEMO Watchman** | .300 WM | Semi | 92 | 1000m | 14 | ~171 RPM | 42% |
| **Victus XMR** | .50 BMG | Bolt | 135 | 1500m | 5 | ~27 RPM | 65% |
| **Barrett M82A1** | .50 BMG | Semi | 150 | 1800m | 10 | ~75 RPM | 75% |
| **Barrett M107A1** | .50 BMG | Semi | 150 | 1800m | 10 | ~80 RPM | 70% |

---

## Caliber Energy Hierarchy

| Caliber | Muzzle Energy | vs 9mm Baseline | Damage Tier |
|---------|---------------|-----------------|-------------|
| 9mm Luger (baseline) | 360 ft-lbs | 1.0x | 34 |
| 5.56×45mm NATO | 1,300 ft-lbs | 3.6x | 45 |
| .308 Win / 7.62 NATO | 2,627 ft-lbs | 7.3x | 78-85 |
| .300 Win Magnum | 3,700 ft-lbs | 10.3x | 92 |
| .50 BMG | 13,200 ft-lbs | 36.7x | 135-150 |

---

## Detailed Weapon Specifications

### SIG 550 (Stgw 90) - Swiss Assault Rifle
- **Real-World Basis**: Swiss standard infantry rifle since 1990
- **Caliber**: 5.56×45mm NATO / GP90 (63gr)
- **Barrel**: 20.8" cold hammer-forged
- **Magazine**: 20 rounds (30 available)
- **Action**: Gas-operated, long-stroke piston
- **Accuracy**: 0.72 MOA (exceptional for service rifle)
- **Rate of Fire**: 700 RPM cyclic
- **Special**: 5.56mm fragments reliably above 2,700 fps (~150-200m)

**FiveM Implementation:**
- Damage: 45 | Close STK: 2-3 | Mid STK: 3-4 | Long STK: 5-6
- Full damage to 50m (fragmentation range), minimum at 400m (45%)
- TimeBetweenShots: 0.086s (700 RPM)

---

### Remington 700 - Civilian Bolt-Action
- **Real-World Basis**: America's most popular bolt-action rifle
- **Caliber**: .308 Winchester
- **Barrel**: 22-24" carbon steel
- **Magazine**: 4 rounds internal
- **Action**: Bolt-action, short/long action
- **Accuracy**: 1.0 MOA (production), 0.5 MOA (5R model)
- **Variants**: ADL ($450), SPS ($650), 5R Gen 2 ($1,200)

**FiveM Implementation:**
- Damage: 78 | Close STK: 2 | Mid STK: 2-3 | Long STK: 3-4
- Full damage to 80m, minimum at 750m (38%)
- TimeBetweenShots: 1.1s (lighter, faster cycle)

---

### Sauer 101 - German Precision Rifle
- **Real-World Basis**: J.P. Sauer & Sohn (est. 1751)
- **Caliber**: .308 Winchester
- **Barrel**: 22" cold hammer-forged
- **Magazine**: 5 rounds detachable
- **Action**: Bolt-action, 60° throw, 6-lug
- **Accuracy**: Sub-MOA factory guarantee
- **Special**: EVER REST bedding, DURA SAFE silent safety

**FiveM Implementation:**
- Damage: 80 | Close STK: 2 | Mid STK: 2-3 | Long STK: 3-4
- Full damage to 90m, minimum at 780m (36%)
- TimeBetweenShots: 0.95s (60° bolt = fastest .308)

---

### Remington M24 SWS - Military Sniper
- **Real-World Basis**: U.S. Army sniper rifle 1988-2014
- **Caliber**: 7.62×51mm NATO
- **Barrel**: 24" 416R stainless, 5-R rifling
- **Magazine**: 5 rounds internal
- **Action**: Bolt-action, long-action 700 receiver
- **Accuracy**: ≤0.35 MOA (machine rest)
- **Weight**: 16 lbs with optic/bipod

**FiveM Implementation:**
- Damage: 85 | Close STK: 1-2 | Mid STK: 2 | Long STK: 3-4
- Full damage to 100m, minimum at 800m (35%)
- TimeBetweenShots: 1.2s (heavy, deliberate)

---

### NEMO Omen Watchman - .300 WM Semi-Auto
- **Real-World Basis**: World's first reliable .300 WM AR
- **Caliber**: .300 Winchester Magnum
- **Barrel**: 24" PROOF Research carbon fiber
- **Magazine**: 14 rounds (high capacity!)
- **Action**: Gas-operated semi-auto
- **Accuracy**: 0.5-1.0 MOA
- **MSRP**: $6,499-6,999
- **Special**: Dual-stage recoil-reduction BCG

**FiveM Implementation:**
- Damage: 92 | Close STK: 1-2 | Mid STK: 2 | Long STK: 2-3
- Full damage to 120m, minimum at 1000m (40%)
- TimeBetweenShots: 0.35s (semi-auto precision)

---

### Victus XMR - .50 BMG Precision Bolt
- **Real-World Basis**: Accuracy International AW50
- **Caliber**: .50 BMG (12.7×99mm NATO)
- **Barrel**: 27" fluted stainless
- **Magazine**: 5 rounds
- **Action**: Bolt-action, 6-lug, 60° throw
- **Accuracy**: Sub-MOA with match ammo
- **Weight**: 30-33 lbs

**FiveM Implementation:**
- Damage: 135 | STK: 1 at all ranges
- Full damage to 300m, minimum at 1500m (55%)
- TimeBetweenShots: 2.2s (heavy bolt cycle)
- Maximum penetration (1.0)

---

### Barrett M82A1 - .50 BMG Semi-Auto (Original)
- **Real-World Basis**: Original Barrett .50 cal
- **Caliber**: .50 BMG
- **Barrel**: 29" (20" CQ option)
- **Magazine**: 10 rounds
- **Action**: Short-recoil semi-automatic
- **Accuracy**: 1.5-2.0 MOA
- **Weight**: 32.7 lbs
- **Recoil**: 82.7 ft-lbs free recoil (70% brake reduction)

**FiveM Implementation:**
- Damage: 150 | STK: 1 (guaranteed)
- Full damage to 400m, minimum at 1800m (60%)
- TimeBetweenShots: 0.8s (semi-auto with recovery)
- Maximum penetration (1.0)

---

### Barrett M107A1 - .50 BMG Semi-Auto (Upgraded)
- **Real-World Basis**: Improved M82A1
- **Caliber**: .50 BMG
- **Barrel**: 29" (20" CQ option)
- **Magazine**: 10 rounds
- **Action**: Short-recoil semi-automatic
- **Accuracy**: 1.0-1.5 MOA (improved)
- **Weight**: 28.7 lbs (4-5 lbs lighter)

**M107A1 Improvements:**
- Aluminum upper receiver (weight reduction)
- Hydraulic buffer system (smoother recoil)
- Fully chrome-lined bore
- Suppressor-ready for Barrett QDL
- Titanium barrel key

**FiveM Implementation:**
- Damage: 150 | STK: 1 (guaranteed)
- Full damage to 420m, minimum at 1800m (62%)
- TimeBetweenShots: 0.75s (faster follow-up)
- Better accuracy (0.10 vs 0.12 spread)
- Reduced recoil (70% vs 75%)

---

## Shots to Kill Analysis (100 HP Target)

### Body Shots by Range

| Weapon | 0-50m | 100m | 300m | 500m | 800m+ |
|--------|-------|------|------|------|-------|
| SIG 550 | 2-3 | 3 | 4 | 5-6 | 6+ |
| Remington 700 | 2 | 2 | 2-3 | 3 | 4 |
| Sauer 101 | 2 | 2 | 2-3 | 3 | 3-4 |
| Remington M24 | 1-2 | 2 | 2 | 2-3 | 3-4 |
| NEMO Watchman | 1-2 | 2 | 2 | 2 | 2-3 |
| Victus XMR | 1 | 1 | 1 | 1 | 1-2 |
| Barrett M82A1 | 1 | 1 | 1 | 1 | 1 |
| Barrett M107A1 | 1 | 1 | 1 | 1 | 1 |

### Headshot Effectiveness

| Weapon | HS Multiplier | Max HS Range | 1-Shot HS Range |
|--------|---------------|--------------|-----------------|
| SIG 550 | 2.40x | 300m | ~200m |
| Remington 700 | 2.10x | 450m | Full range |
| Sauer 101 | 2.15x | 480m | Full range |
| Remington M24 | 2.20x | 500m | Full range |
| NEMO Watchman | 1.80x | 600m | Full range |
| Victus XMR | 1.50x | 1000m | Full range |
| Barrett M82A1 | 1.40x | 800m | Full range |
| Barrett M107A1 | 1.45x | 850m | Full range |

---

## Fire Rate Comparison

| Weapon | TimeBetweenShots | Effective RPM | Shots in 5 Seconds |
|--------|------------------|---------------|-------------------|
| SIG 550 | 0.086s | 700 | 58 |
| NEMO Watchman | 0.350s | 171 | 14 |
| Barrett M107A1 | 0.750s | 80 | 7 |
| Barrett M82A1 | 0.800s | 75 | 6 |
| Sauer 101 | 0.950s | 63 | 5 |
| Remington 700 | 1.100s | 55 | 5 |
| Remington M24 | 1.200s | 50 | 4 |
| Victus XMR | 2.200s | 27 | 2 |

---

## Penetration & Anti-Materiel Capability

| Weapon | Penetration | Vehicle Damage | Material Defeat |
|--------|-------------|----------------|-----------------|
| SIG 550 | 0.45 | Standard | Light cover |
| Remington 700 | 0.60 | Standard | Medium cover |
| Sauer 101 | 0.62 | Standard | Medium cover |
| Remington M24 | 0.65 | Standard | Medium cover |
| NEMO Watchman | 0.75 | Enhanced | Heavy cover |
| Victus XMR | 1.00 | Maximum | 1" armor plate |
| Barrett M82A1 | 1.00 | Maximum | 9" concrete |
| Barrett M107A1 | 1.00 | Maximum | 9" concrete |

---

## Platform Role Differentiation

| Weapon | Primary Role | Mobility | Best Use Case |
|--------|-------------|----------|---------------|
| **SIG 550** | Infantry assault | High | CQB to medium range, suppressive fire |
| **Remington 700** | Hunting/Sport | Medium | Budget precision, civilian use |
| **Sauer 101** | Premium hunting | Medium-High | Fast follow-up, European craftsmanship |
| **Remington M24** | Military sniper | Low | Long-range precision, military ops |
| **NEMO Watchman** | DMR/Marksman | Medium | High-volume magnum fire, 14-rd capacity |
| **Victus XMR** | Precision AMR | Very Low | Extreme range precision, sub-MOA |
| **Barrett M82A1** | Anti-materiel | Very Low | Vehicle/equipment destruction |
| **Barrett M107A1** | Anti-materiel | Very Low | Same as M82A1, faster/lighter |

---

## .50 BMG Platform Comparison

| Specification | Victus XMR | Barrett M82A1 | Barrett M107A1 |
|---------------|------------|---------------|----------------|
| **Action** | Bolt | Semi-auto | Semi-auto |
| **Magazine** | 5 | 10 | 10 |
| **Weight** | 30-33 lbs | 32.7 lbs | 28.7 lbs |
| **Accuracy** | Sub-MOA | 1.5-2.0 MOA | 1.0-1.5 MOA |
| **Fire Rate** | 27 RPM | 75 RPM | 80 RPM |
| **Damage** | 135 | 150 | 150 |
| **Recoil** | 65% | 75% | 70% |
| **Best For** | Precision | Volume | Best overall |

---

## Installation Notes

1. Add stream files (.ydr, .ytd) to each weapon's `stream/` folder

2. Ensure resources in server.cfg:
```
ensure remington_m24
ensure remington_700
ensure sauer_101
ensure victus_xmr
ensure nemo_omen_watchman
ensure sig_550
ensure barrett_m82a1
ensure barrett_m107a1
```

3. Load order: Weapon resources should load **BEFORE** ox_inventory

---

## Weapon Hash Names

| Display Name | Weapon Hash | Model Hash |
|--------------|-------------|------------|
| Remington M24 | WEAPON_REMINGTONM24 | w_sr_remingtonm24 |
| Remington 700 | WEAPON_REMINGTON700 | w_sr_remington700 |
| Sauer 101 | WEAPON_SAUER101 | w_sr_sauer101 |
| Victus XMR | WEAPON_VICTUSXMR | w_sr_victusxmr |
| NEMO Omen Watchman | WEAPON_NEMOWATCHMAN | w_sr_nemowatchman |
| SIG 550 | WEAPON_SIG550 | w_ar_sig550 |
| Barrett M82A1 | WEAPON_BARRETTM82A1 | w_sr_barrettm82a1 |
| Barrett M107A1 | WEAPON_BARRETTM107A1 | w_sr_barrettm107a1 |

---

## Balance Philosophy

This batch implements a **three-tier damage system**:

1. **Assault Rifle Tier** (45 damage): SIG 550
   - High fire rate, moderate damage
   - 2-3 shot kills close, 5-6 at range
   - Volume of fire compensates for lower per-shot damage

2. **Precision Rifle Tier** (78-92 damage): .308 and .300 WM platforms
   - Remington 700/Sauer 101/M24 differentiated by accuracy and handling
   - NEMO Watchman bridges to magnum territory with 14-rd semi-auto
   - 1-2 shot kills, emphasizing shot placement

3. **Anti-Materiel Tier** (135-150 damage): .50 BMG platforms
   - Guaranteed one-shot kills on personnel
   - Extreme range effectiveness
   - Vehicle/structure damage capability
   - Balanced by weight, recoil, fire rate limitations

**Key Differentiators:**
- Victus XMR: Precision over volume (sub-MOA, 5 rounds, slow)
- Barrett M82A1: Original .50 semi-auto (10 rounds, proven)
- Barrett M107A1: Best overall (lighter, more accurate, faster)

---

## Ammo Type Reference

| Weapon | AmmoInfo Reference | Pickup Type |
|--------|-------------------|-------------|
| SIG 550 | AMMO_RIFLE | AMMO_RIFLE |
| Remington 700 | AMMO_SNIPER | AMMO_SNIPER |
| Sauer 101 | AMMO_SNIPER | AMMO_SNIPER |
| Remington M24 | AMMO_SNIPER | AMMO_SNIPER |
| NEMO Watchman | AMMO_SNIPER | AMMO_SNIPER |
| Victus XMR | AMMO_SNIPER_REMOTE | AMMO_SNIPER_REMOTE |
| Barrett M82A1 | AMMO_SNIPER_REMOTE | AMMO_SNIPER_REMOTE |
| Barrett M107A1 | AMMO_SNIPER_REMOTE | AMMO_SNIPER_REMOTE |

---

*Batch 19 Reference Document - Precision Rifle and Anti-Materiel Platforms*
*FiveM Weapon Meta Development Project*
