# Weapon Handling Differentiation Reference

## Formula Overview

### Caliber Multipliers
| Caliber | Multiplier | Notes |
|---------|------------|-------|
| .22 LR | 0.25 | Minimal recoil, easy control |
| 9mm | 1.00 | Baseline |
| .380 ACP | 0.70 | Pocket pistol caliber |
| .40 S&W | 1.20 | Snappy recoil |
| .45 ACP | 1.40 | Heavier round, more push |
| 10mm | 1.35 | Hot round, significant recoil |
| 5.7x28 | 0.60 | Low recoil, high velocity |
| .357 Mag | 2.20 | Sharp, snappy revolver recoil |
| .44 Mag | 2.80 | Heavy magnum |
| .500 S&W | 5.00 | Punishing hand cannon |

### Quality/Condition Tier Multipliers
| Tier | Multiplier | Description |
|------|------------|-------------|
| Worn | 1.80 | Junk, neglected, worn weapons - worst handling |
| Standard | 1.00 | Most service pistols - baseline |
| Quality | 0.70 | Premium brands, well-maintained |
| Match | 0.55 | Competition/military grade precision - best handling |

### Switch/Full-Auto Modifier
| Type | Multiplier | Notes |
|------|------------|-------|
| Semi-Auto | 1.00 | Normal operation |
| Switch/Full-Auto | 2.50 | Exponential recoil buildup |

---

## Batch 1 - Compact 9mm Pistols

| Weapon | Caliber | Tier | Switch | Shake | Flip | Recovery | FireRate | Spread | AccMax |
|--------|---------|------|--------|-------|------|----------|----------|--------|--------|
| g26 | 9mm | standard | - | 0.23 | 0.0256 | 0.81 | 0.197 | 1.16 | 1.56 |
| g26_switch | 9mm | standard | YES | 0.75 | 0.0850 | 0.15 | 0.052 | 2.80 | 2.80 |
| g43x | 9mm | quality | - | 0.19 | 0.0227 | 0.85 | 0.166 | 0.92 | 1.32 |
| gx4 | 9mm | standard | - | 0.28 | 0.0303 | 0.68 | 0.197 | 1.16 | 1.56 |
| hellcat | 9mm | quality | - | 0.25 | 0.0290 | 0.67 | 0.166 | 0.92 | 1.32 |

### Batch 1 Notes:
- **g26**: Standard Glock 26 subcompact (26oz)
- **g26_switch**: Full-auto modified - dramatically increased recoil, muzzle flip
- **g43x**: Quality tier, slim profile (23oz)
- **gx4**: Budget Taurus, lighter weight creates more felt recoil (22oz)
- **hellcat**: Quality Springfield, very light (18oz) - weight factor increases felt recoil

---

## Batch 3 - .45 ACP Pistols

| Weapon | Caliber | Tier | Switch | Shake | Flip | Recovery | FireRate | Spread | AccMax |
|--------|---------|------|--------|-------|------|----------|----------|--------|--------|
| g21 | .45 ACP | standard | - | 0.26 | 0.0283 | 1.05 | 0.259 | 1.14 | 1.97 |
| g30 | .45 ACP | standard | - | 0.29 | 0.0316 | 0.94 | 0.259 | 1.14 | 1.97 |
| g41 | .45 ACP | quality | - | 0.20 | 0.0238 | 1.21 | 0.206 | 0.81 | 1.66 |
| junk1911 | .45 ACP | worn | - | 0.42 | 0.0423 | 0.45 | 0.400 | 2.00 | 2.80 |
| kimber1911 | .45 ACP | quality | - | 0.19 | 0.0226 | 1.28 | 0.206 | 0.81 | 1.66 |
| kimber_eclipse | .45 ACP | match | - | 0.16 | 0.0197 | 1.39 | 0.180 | 0.65 | 1.50 |
| m45a1 | .45 ACP | match | - | 0.15 | 0.0188 | 1.47 | 0.180 | 0.65 | 1.50 |

### Batch 3 Notes:
- **g21**: Full-size Glock 21, standard service pistol (38oz)
- **g30**: Compact Glock 30, lighter = more felt recoil (34oz)
- **g41**: Competition Glock 41, quality tier (36oz)
- **junk1911**: Worn/neglected - worst handling in batch, slow recovery, poor accuracy
- **kimber1911**: Quality Kimber Custom (38oz)
- **kimber_eclipse**: Match-grade competition, best accuracy
- **m45a1**: USMC M45A1 MEUSOC, match tier, heaviest = least felt recoil (40oz)

---

## Parameter Definitions

| Parameter | Description | Impact |
|-----------|-------------|--------|
| RecoilShakeAmplitude | Camera shake intensity | Higher = more screen shake on fire |
| IkRecoilDisplacement | Muzzle flip/rise | Higher = more visible weapon kick |
| RecoilRecoveryRate | Time to return to aim | Higher = faster follow-up shots |
| TimeBetweenShots | Minimum time between shots | Lower = faster fire rate |
| AccuracySpread | Bullet spread angle | Lower = tighter groupings |
| RecoilAccuracyMax | Max accuracy penalty | Lower = maintains accuracy under fire |

---

## Value Comparison: Old vs New

### Batch 1 - g26_switch (Full-Auto)
| Parameter | OLD | NEW | Change |
|-----------|-----|-----|--------|
| RecoilShakeAmplitude | 0.420 | 0.75 | +79% |
| IkRecoilDisplacement | 0.005 | 0.085 | +1600% |
| RecoilRecoveryRate | 0.20 | 0.15 | -25% |
| TimeBetweenShots | 0.052 | 0.052 | 0% |

### Batch 3 - junk1911 (Worn)
| Parameter | OLD | NEW | Change |
|-----------|-----|-----|--------|
| RecoilShakeAmplitude | 0.550 | 0.42 | -24% |
| IkRecoilDisplacement | 0.018 | 0.042 | +133% |
| RecoilRecoveryRate | 0.45 | 0.45 | 0% |
| TimeBetweenShots | 0.38 | 0.40 | +5% |

### Batch 3 - m45a1 (Match)
| Parameter | OLD | NEW | Change |
|-----------|-----|-----|--------|
| RecoilShakeAmplitude | 0.240 | 0.15 | -38% |
| IkRecoilDisplacement | 0.005 | 0.019 | +280% |
| RecoilRecoveryRate | 1.10 | 1.47 | +34% |
| TimeBetweenShots | 0.205 | 0.180 | -12% |

---

## Usage

Run the calculation script:
```bash
# Generate reference tables
python3 scripts/weapon_calc.py --reference

# Calculate values for specific weapon
python3 scripts/weapon_calc.py --weapon g26_switch

# Dry-run for a batch (shows changes without applying)
python3 scripts/weapon_calc.py --batch 1

# Apply changes to a batch
python3 scripts/weapon_calc.py --batch 1 --apply

# Apply changes to all configured batches
python3 scripts/weapon_calc.py --apply
```
