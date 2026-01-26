# Ammunition Damage Formula - Real-World Ballistics Research

## Research Sources

### FBI Protocol & Terminal Ballistics
- [Lucky Gunner Labs - Self-Defense Ammo Testing](https://www.luckygunner.com/labs/self-defense-ammo-ballistic-tests/)
- [Brass Fetcher - FBI Ammunition Protocol](https://www.brassfetcher.com/FBI%20Ammunition%20Protocol/FBI%20Ammunition%20Protocol.html)
- [Hornady LE - FBI Test Protocol](https://www.hornadyle.com/resources/fbi-test-protocol)
- [Shooting Illustrated - FBI Testing Protocol](https://www.shootingillustrated.com/content/understanding-the-fbi-s-ammo-testing-protocol/)

### Armor Penetration & NIJ Standards
- [RMA Defense - Body Armor Ammunition Guide](https://rmadefense.com/body-armor-ammunition-guide/)
- [The Gun Zone - AP vs FMJ](https://thegunzone.com/is-fmj-ammo-armor-piercing/)

### Hollow Point vs FMJ Terminal Performance
- [Berry's MFG - FMJ vs Hollow Point Guide](https://www.berrysmfg.com/fmj-vs-hollow-point/)
- [Ammo.com - Hollow Point vs FMJ](https://ammo.com/bullet-type/hollow-point-vs-fmj)
- [American Firearms - HP vs FMJ Comparison](https://www.americanfirearms.org/hollow-point-vs-fmj-comparison/)

---

## FBI Ammunition Protocol Standards

### Penetration Requirements
| Penetration Depth | FBI Score | Game Interpretation |
|-------------------|-----------|---------------------|
| 0 - 11.99" | 1 point | Under-penetration (HP failure) |
| 12.0 - 13.99" | 8 points | Acceptable minimum |
| **14.0 - 15.99"** | **10 points** | **Ideal range** |
| 16.0 - 18.0" | 9 points | Acceptable maximum |
| > 18" | 5 points | Over-penetration risk |

### FBI Scoring Weights
- **Penetration**: 70% of total score
- **Expansion**: 20% of total score
- **Weight Retention**: 10% of total score

### Expansion Standard
- Bullet must expand to **≥1.5x original diameter**
- 9mm (.355") should expand to ≥0.53"
- .45 ACP (.452") should expand to ≥0.68"

---

## Composite Damage Formula

### Base Formula
```
Game Damage Modifier = (Energy Factor × Wound Factor × Penetration Factor) / Baseline

Where:
- Energy Factor = Muzzle Energy / Baseline Energy (350 ft-lbs for 9mm)
- Wound Factor = Permanent Cavity multiplier (1.0 for FMJ, 1.15-1.25 for HP)
- Penetration Factor = Optimal Penetration Score (0.8-1.0 range)
- Baseline = 1.0 (FMJ performance = 1.0x modifier)
```

### Energy-to-Damage Scaling
Using 9mm FMJ 124gr @ 350 ft-lbs as baseline (1.0x):

| Muzzle Energy | Relative Power | Damage Multiplier |
|---------------|----------------|-------------------|
| 100 ft-lbs | 0.29x (22 LR) | 0.35x |
| 200 ft-lbs | 0.57x (.38 Spl) | 0.59x |
| 350 ft-lbs | 1.00x (9mm) | 1.00x |
| 420 ft-lbs | 1.20x (.40 S&W) | 1.20x |
| 500 ft-lbs | 1.43x (.45 ACP) | 1.12x* |
| 650 ft-lbs | 1.86x (10mm Full) | 1.53x |
| 710 ft-lbs | 2.03x (.357 Mag) | 1.71x |
| 1,000 ft-lbs | 2.86x (.44 Mag) | 2.41x |
| 1,300 ft-lbs | 3.71x (5.56 NATO) | Game balanced |
| 2,600 ft-lbs | 7.43x (7.62 NATO) | Game balanced |
| 13,200 ft-lbs | 37.7x (.50 BMG) | Game balanced |

*Note: .45 ACP has diminishing returns due to subsonic velocity limiting hydrostatic shock

### Wound Channel Multipliers

#### Permanent Cavity (Tissue Destruction)
| Ammo Type | Expansion | Permanent Cavity | Wound Multiplier |
|-----------|-----------|------------------|------------------|
| FMJ | None (1.0x) | Narrow track | 1.00 |
| HP/JHP | 1.5-2.0x | Wide mushroom | 1.15-1.25 |
| SP (Soft Point) | 1.3-1.5x | Moderate expansion | 1.08-1.15 |
| Match | None (1.0x) | Clean track | 1.03 (precision) |
| AP | None (1.0x) | Narrow track | 0.90-0.95 |

#### Temporary Cavity (Hydrostatic Shock)
- **Handguns (< 1,200 fps)**: Minimal temporary cavity contribution
- **Rifles (> 2,000 fps)**: Significant temporary cavity damage
- **Magnum handguns (> 1,400 fps)**: Moderate temporary cavity

---

## Ammo Type Modifier Calculations

### Universal Ammo Types

#### FMJ (Full Metal Jacket) - BASELINE
```
Damage Mult: 1.00 (baseline)
Armor Mult: 1.00 (normal interaction)
Penetration: 0.70-0.85 (deep, through-and-through risk)

Real-world characteristics:
- Maintains shape on impact
- 18-24" gel penetration typical
- Over-penetration risk (exits target)
- Barrier blind (performs consistently)
```

#### HP/JHP (Hollow Point / Jacketed Hollow Point)
```
Damage Mult: 1.15-1.25 (+15-25% unarmored)
Armor Mult: 0.45-0.55 (-45-55% vs armor)
Penetration: 0.40-0.55 (12-16" ideal range)

Real-world characteristics:
- Expands to 1.5-2.0x diameter
- Transfers all energy to target
- Reduced over-penetration
- Defeated by heavy clothing/armor
- Wound channel 2-3x larger than FMJ

Calculation:
- Expansion bonus: +15% base
- Large caliber (.40+): additional +5% (bigger mushroom)
- Small caliber (.22, 5.7): -5% (unreliable expansion)
```

#### AP (Armor Piercing)
```
Damage Mult: 0.90-0.95 (-5-10% base damage)
Armor Mult: 1.50-2.00 (+50-100% vs armor) OR armorBypass: true
Penetration: 0.85-0.96 (deep, barrier defeating)

Real-world characteristics:
- Hardened steel/tungsten core
- Does NOT expand (ice-pick wound)
- Defeats soft armor (Level IIIA)
- Rifle AP defeats hard plates (Level III+)
- Reduced soft tissue damage

Calculation:
- Penetration bonus: +30-50% vs armor
- Tissue damage penalty: -8-10%
- Vehicle/barrier damage: +20%
```

#### SP (Soft Point)
```
Damage Mult: 1.08-1.12 (+8-12% unarmored)
Armor Mult: 0.70-0.80 (-20-30% vs armor)
Penetration: 0.55-0.65 (moderate, hunting use)

Real-world characteristics:
- Exposed lead tip, partial jacket
- Controlled expansion
- Hunting/defense crossover
- Better than FMJ, less than JHP
```

#### Match Grade
```
Damage Mult: 1.03-1.05 (+3-5% from precision)
Armor Mult: 1.00 (normal)
Penetration: 0.75 (same as FMJ)
Accuracy Bonus: -10% spread (0.90 multiplier)

Real-world characteristics:
- Consistent weight, balance
- Sub-MOA capable
- Premium components
- No expansion (HPBT is NOT hollow point)
```

---

### Specialty Ammo Calculations

#### Tracer
```
Damage Mult: 1.00 (no change)
Armor Mult: 1.00 (no change)
Visual Effect: Visible trail to all players

Real-world: Incendiary compound in base,
slight weight difference, marking rounds
```

#### Incendiary / Dragon's Breath
```
Damage Mult: 0.85-0.95 (impact damage reduced)
Armor Mult: 0.70-0.80 (soft, burns on surface)
Fire DOT: 3-5 damage/second for 3-5 seconds
Ignition Chance: 80% on hit

Real-world: Magnesium/thermite compound,
spectacular visual, reduced penetration
```

#### Subsonic
```
Damage Mult: 0.85-0.92 (reduced velocity = less energy)
Armor Mult: 0.90 (slightly reduced)
Penetration: 0.65-0.70
Sound Reduction: 40-60% quieter (suppressor optimized)

Real-world: Below 1,125 fps (speed of sound),
no supersonic crack, heavier bullet required
```

#### Less-Lethal (Beanbag, Pepperball)
```
Damage Mult: 0.02-0.08 (near-zero lethal damage)
Armor Mult: 0.80-1.00 (blunt trauma)
Special Effect: Ragdoll/Vision blur

Beanbag: 40-joule impact, knockdown
Pepperball: OC irritant, 5-8 second effect
```

#### Explosive (BOOM, API)
```
Damage Mult: 1.05-1.15 (slight increase)
Armor Mult: 1.50 (penetrate then detonate)
Explosion: Small radius (1-2m), high damage
Vehicle Modifier: 2.0-3.0x vs vehicles

Real-world: Raufoss Mk 211 (tungsten penetrator +
explosive charge + incendiary)
```

#### Tranquilizer
```
Damage Mult: 0.02 (negligible)
Armor Mult: 0.00 (blocked by armor)
Incapacitation: Progressive over 10-30 seconds
  - Phase 1 (0-5s): Stumbling
  - Phase 2 (5-10s): Falling
  - Phase 3 (10-30s): Unconscious
```

---

## Caliber-Specific Ballistic Data

### Handgun Calibers

| Caliber | Load | Velocity | Energy | Base Dmg | Penetration |
|---------|------|----------|--------|----------|-------------|
| **.22 LR** | FMJ 40gr | 1,000 fps | 90 ft-lbs | 1.00 | 0.50 |
| | JHP 36gr | 1,200 fps | 115 ft-lbs | 1.15 | 0.35 |
| **.38 Spl** | FMJ 130gr | 755 fps | 165 ft-lbs | 1.00 | 0.65 |
| | +P JHP 125gr | 945 fps | 250 ft-lbs | 1.35 | 0.50 |
| **9mm** | FMJ 124gr | 1,150 fps | 350 ft-lbs | 1.00 | 0.75 |
| | JHP 124gr | 1,150 fps | 350 ft-lbs | 1.15 | 0.48 |
| | AP 100gr | 1,400 fps | 435 ft-lbs | 0.92 | 0.88 |
| **.40 S&W** | FMJ 180gr | 990 fps | 390 ft-lbs | 1.00 | 0.72 |
| | JHP 180gr | 990 fps | 390 ft-lbs | 1.20 | 0.55 |
| **.45 ACP** | FMJ 230gr | 830 fps | 352 ft-lbs | 1.00 | 0.70 |
| | JHP 230gr | 830 fps | 352 ft-lbs | 1.18 | 0.52 |
| **10mm FBI** | FMJ 180gr | 1,000 fps | 400 ft-lbs | 1.00 | 0.72 |
| **10mm Full** | FMJ 180gr | 1,300 fps | 676 ft-lbs | 1.24 | 0.65 |
| **10mm Bear** | HC 220gr | 1,200 fps | 703 ft-lbs | 1.19 | 0.95 |
| **.357 Mag** | FMJ 158gr | 1,235 fps | 535 ft-lbs | 1.00 | 0.85 |
| | JHP 125gr | 1,450 fps | 583 ft-lbs | 1.20 | 0.55 |
| **.44 Mag** | FMJ 240gr | 1,350 fps | 971 ft-lbs | 1.00 | 0.85 |
| | JHP 240gr | 1,350 fps | 971 ft-lbs | 1.20 | 0.70 |
| **.500 S&W** | FMJ 400gr | 1,650 fps | 2,418 ft-lbs | 1.00 | 0.90 |
| | JHP 350gr | 1,800 fps | 2,519 ft-lbs | 1.20 | 0.75 |
| **5.7x28mm** | FMJ 40gr | 1,700 fps | 256 ft-lbs | 1.00 | 0.70 |
| | JHP 35gr | 1,800 fps | 252 ft-lbs | 1.18 | 0.55 |
| | AP 27gr | 2,100 fps | 264 ft-lbs | 0.92 | 0.96 |

### Rifle Calibers

| Caliber | Load | Velocity | Energy | Base Dmg | Penetration |
|---------|------|----------|--------|----------|-------------|
| **5.56 NATO** | FMJ M193 | 3,150 fps | 1,282 ft-lbs | 1.00 | 0.72 |
| | SP 62gr | 3,000 fps | 1,240 ft-lbs | 1.12 | 0.58 |
| | AP M855A1 | 3,100 fps | 1,312 ft-lbs | 0.92 | 0.90 |
| **6.8x51mm** | FMJ | 3,000 fps | 2,680 ft-lbs | 1.00 | 0.85 |
| | AP | 3,000 fps | 2,680 ft-lbs | 0.95 | 0.98 |
| **.300 BLK** | Super 110gr | 2,350 fps | 1,349 ft-lbs | 1.00 | 0.70 |
| | Sub 220gr | 1,010 fps | 498 ft-lbs | 0.88 | 0.68 |
| **7.62x39mm** | FMJ M43 | 2,350 fps | 1,508 ft-lbs | 1.00 | 0.72 |
| | SP 154gr | 2,200 fps | 1,330 ft-lbs | 1.12 | 0.58 |
| | AP 7N23 | 2,400 fps | 1,550 ft-lbs | 0.92 | 0.92 |
| **7.62x51mm** | FMJ M80 | 2,800 fps | 2,559 ft-lbs | 1.00 | 0.78 |
| | Match 168gr | 2,650 fps | 2,619 ft-lbs | 1.05 | 0.76 |
| | AP M993 | 2,750 fps | 2,472 ft-lbs | 0.95 | 0.95 |
| **.300 Win Mag** | FMJ 180gr | 2,960 fps | 3,501 ft-lbs | 1.00 | 0.82 |
| | Match 190gr | 2,900 fps | 3,547 ft-lbs | 1.03 | 0.80 |
| **.50 BMG** | Ball M33 | 2,910 fps | 12,140 ft-lbs | 1.00 | 0.95 |
| | API M8 | 2,810 fps | 11,090 ft-lbs | 0.95 | 1.00 |
| | BOOM Mk211 | 2,900 fps | 12,000 ft-lbs | 1.10 | 0.98 |

### Shotgun Loads

| Load | Pellets | Dmg/Pellet | Max Damage | Spread | Penetration |
|------|---------|------------|------------|--------|-------------|
| **00 Buck** | 8 | 1.00 | 8.0x | 0.12 | 0.65 |
| **#1 Buck** | 12 | 0.70 | 8.4x | 0.15 | 0.55 |
| **Slug** | 1 | 6.00 | 6.0x | 0.01 | 0.80 |
| **Birdshot** | 19 | 0.40 | 7.6x | 0.25 | 0.30 |
| **Dragon's Breath** | 8 | 0.75 | 6.0x | 0.14 | 0.30 |
| **Beanbag** | 1 | 0.05 | 0.05x | 0.02 | 0.00 |
| **Pepperball** | 6 | 0.02 | 0.12x | 0.10 | 0.00 |
| **Breach** | 1 | 0.30 | 0.30x | 0.01 | 0.00 |

---

## Final Modifier Values for Implementation

### `shared/modifiers.lua` Values

```lua
Config.AmmoModifiers = {
    -- UNIVERSAL TYPES --
    ['fmj'] = {
        damageMult = 1.00,
        armorMult = 1.00,
        penetration = 0.75,
        effects = {},
    },
    ['hp'] = {
        damageMult = 1.15,
        armorMult = 0.50,
        penetration = 0.48,
        effects = {},
    },
    ['jhp'] = {
        damageMult = 1.20,
        armorMult = 0.45,
        penetration = 0.45,
        effects = {},
    },
    ['ap'] = {
        damageMult = 0.92,
        armorMult = 1.80,
        penetration = 0.90,
        armorBypass = true,
        effects = {},
    },
    ['sp'] = {
        damageMult = 1.10,
        armorMult = 0.70,
        penetration = 0.58,
        effects = {},
    },
    ['match'] = {
        damageMult = 1.05,
        armorMult = 1.00,
        penetration = 0.76,
        effects = { accuracy = 0.90 },
    },
    ['tracer'] = {
        damageMult = 1.00,
        armorMult = 1.00,
        penetration = 0.75,
        effects = { tracer = true },
    },

    -- 10MM SPECIALTY --
    ['fbi'] = {
        damageMult = 1.00,
        armorMult = 1.00,
        penetration = 0.72,
        effects = {},
    },
    ['fullpower'] = {
        damageMult = 1.24,
        armorMult = 0.95,
        penetration = 0.65,
        effects = {},
    },
    ['bear'] = {
        damageMult = 1.19,
        armorMult = 1.10,
        penetration = 0.95,
        effects = {},
    },

    -- .300 BLK SPECIALTY --
    ['supersonic'] = {
        damageMult = 1.00,
        armorMult = 1.00,
        penetration = 0.70,
        effects = {},
    },
    ['subsonic'] = {
        damageMult = 0.88,
        armorMult = 0.90,
        penetration = 0.68,
        effects = { suppressed = true, soundReduction = 0.50 },
    },

    -- SHOTGUN LOADS --
    ['00buck'] = {
        damageMult = 1.00,
        armorMult = 0.60,
        penetration = 0.65,
        pellets = 8,
        effects = {},
    },
    ['1buck'] = {
        damageMult = 0.70,
        armorMult = 0.50,
        penetration = 0.55,
        pellets = 12,
        effects = {},
    },
    ['slug'] = {
        damageMult = 6.00,
        armorMult = 1.00,
        penetration = 0.80,
        pellets = 1,
        effects = {},
    },
    ['birdshot'] = {
        damageMult = 0.40,
        armorMult = 0.30,
        penetration = 0.30,
        pellets = 19,
        effects = {},
    },
    ['dragonsbreath'] = {
        damageMult = 0.75,
        armorMult = 0.50,
        penetration = 0.30,
        pellets = 8,
        effects = { fire = true, fireTrail = true, fireDuration = 3000, fireDamage = 4 },
    },
    ['beanbag'] = {
        damageMult = 0.05,
        armorMult = 0.80,
        penetration = 0.00,
        pellets = 1,
        effects = { ragdoll = true, ragdollForce = 500 },
    },
    ['pepperball'] = {
        damageMult = 0.02,
        armorMult = 1.00,
        penetration = 0.00,
        pellets = 6,
        effects = { blind = true, blindDuration = 8000, cough = true },
    },
    ['breach'] = {
        damageMult = 0.30,
        armorMult = 0.50,
        penetration = 0.00,
        pellets = 1,
        effects = { envDamage = 5.0 },
    },

    -- .50 BMG SPECIALTY --
    ['ball'] = {
        damageMult = 1.00,
        armorMult = 1.50,
        penetration = 0.95,
        armorBypass = true,
        effects = {},
    },
    ['api'] = {
        damageMult = 0.95,
        armorMult = 2.00,
        penetration = 1.00,
        armorBypass = true,
        effects = { fire = true, vehicleFire = true },
    },
    ['boom'] = {
        damageMult = 1.10,
        armorMult = 1.50,
        penetration = 0.98,
        armorBypass = true,
        effects = { explosive = true, vehicleExplosion = true },
    },

    -- TRANQUILIZER --
    ['tranq'] = {
        damageMult = 0.02,
        armorMult = 0.00,
        penetration = 0.00,
        effects = { incapacitate = true, incapDuration = 30000 },
    },
}
```

---

## Summary

### Damage Multiplier Ranges by Type
| Ammo Category | Damage Range | Armor Range | Key Characteristic |
|---------------|--------------|-------------|-------------------|
| FMJ/Ball | 1.00 | 1.00 | Baseline performance |
| HP/JHP | 1.15-1.20 | 0.45-0.50 | Expansion = +damage, -armor |
| AP | 0.92-0.95 | 1.50-2.00 | Penetration = -damage, +armor |
| SP | 1.08-1.12 | 0.70 | Hunting compromise |
| Match | 1.03-1.05 | 1.00 | Precision bonus |
| Specialty | Varies | Varies | Effects-based |

### Key Principles
1. **FMJ is always baseline (1.0x)** - other types are relative
2. **Hollow point trades armor performance for unarmored damage**
3. **AP trades tissue damage for armor penetration**
4. **Energy matters** - .50 BMG Ball is equivalent to .45 HP in relative terms
5. **Shotgun pellet count × per-pellet damage = total potential**
