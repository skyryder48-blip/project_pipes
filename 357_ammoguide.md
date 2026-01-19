# Real-World Ballistics to FiveM Weapon Meta Framework

Four pistol and revolver calibers deliver dramatically different terminal performance in the real world. This analysis translates manufacturer specifications and FBI protocol gel tests into game-balanced values, using **9mm Luger at 34 base damage** as the reference standard.

---

## .40 S&W: The "snappy" FBI cartridge

The .40 S&W emerged in 1990 as a shortened 10mm Auto, designed to fit 9mm-sized pistol frames while delivering more energy. It operates at **35,000 PSI** maximum pressure—higher than .45 ACP's 21,000 PSI—creating its characteristic sharp recoil impulse.

### FMJ specifications (standard + rare +P averaged)

| Weight | Standard Velocity | +P/Heavy Velocity | Average Energy |
|--------|------------------|-------------------|----------------|
| **155gr** | 1,160 fps | 1,300 fps | 523 ft-lbs |
| **165gr** | 1,100 fps | 1,200 fps | 470 ft-lbs |
| **180gr** | 990 fps | 1,100 fps | 433 ft-lbs |

FMJ rounds penetrate **25-32+ inches** in ballistic gel—excessive for defensive use. Standard 180gr loads travel subsonic at approximately 990 fps from typical 4-inch barrels.

### JHP premium defensive loads

**Federal HST 180gr** delivers the most consistent performance: **964 fps velocity**, **408 ft-lbs energy**, expanding to **0.72 inches** with **14.5-18.5 inch penetration**. The bullet retains nearly 100% of its weight through barriers.

**Speer Gold Dot 180gr** performs reliably at 955 fps with 0.65-inch expansion and 14.5-inch penetration. However, the 165gr variant fails to expand from compact barrels—requiring 4+ inch barrels to achieve necessary velocity.

**Hornady Critical Duty 175gr** prioritizes barrier penetration over expansion, achieving only 0.42-inch expansion but penetrating consistently through auto glass, drywall, and heavy clothing at 970 fps.

### Energy comparisons establish the damage baseline

Against 9mm Luger (124gr at 364 ft-lbs average), .40 S&W delivers **18-33% more muzzle energy**. The 165gr load at 484 ft-lbs represents the high end; 180gr at 408 ft-lbs the conservative estimate.

Against .45 ACP (230gr at 400 ft-lbs), .40 S&W matches or slightly exceeds energy—approximately **5-17% advantage** depending on load selection.

The "snappy" reputation stems from high chamber pressure forcing rapid slide velocity in frames designed for 9mm. Shooters describe .45 ACP recoil as a "push" versus .40's sharp "snap." Felt recoil runs approximately **25% higher than 9mm**.

**Effective range**: 25-50 yards practical accuracy, 50-100 yards maximum. The cartridge retains 84% of muzzle energy at 100 yards.

---

## 10mm Auto: The downloaded legend returns to full power

The 10mm Auto occupies a unique position—capable of matching .357 Magnum from a semi-automatic platform with 15+ round capacity. Understanding its dual personality is critical: **FBI-spec "lite" loads** perform identically to .40 S&W, while **full-power loads** deliver 60% more energy.

### The FBI download story shapes modern loadings

The original 1983 Norma specification called for **200gr at 1,200 fps** producing **640 ft-lbs**. After the FBI adopted 10mm following the 1986 Miami shootout, agents struggled with recoil. The bureau developed a reduced "FBI-spec" load: **180gr at 950 fps (361 ft-lbs)**—essentially creating .40 S&W performance in a longer case.

### FMJ specifications by load type

| Weight | FBI-Spec | Full-Power | Full-Power Energy |
|--------|----------|------------|-------------------|
| **155gr** | — | 1,300-1,400 fps | 580-675 ft-lbs |
| **180gr** | 950 fps (361 ft-lbs) | 1,300 fps (676 ft-lbs) | **676 ft-lbs** |
| **200gr** | 1,030 fps (424 ft-lbs) | 1,250 fps (693 ft-lbs) | **693 ft-lbs** |
| **220gr** | — | 1,200 fps | **703 ft-lbs** |

### Full-power JHP loads dominate the market

**Underwood Ammo** produces the benchmark full-power loads. Their 180gr XTP JHP achieves **1,300 fps** and **676 ft-lbs**—nearly double FBI-spec energy. The 135gr Sporting JHP reaches **1,600 fps** and an impressive **768 ft-lbs**.

**Buffalo Bore** pushes further: 180gr JHP at **1,350 fps** producing **728 ft-lbs**, and 220gr hard cast at **1,200 fps** for **703 ft-lbs** with 3+ feet of tissue penetration.

**Federal** represents the moderate approach with 200gr HST at 1,130 fps (567 ft-lbs)—strong but not maximum pressure.

In gel testing (Lucky Gunner, Glock 20), the best performers meeting FBI 12-18" standards include **Barnes 155gr VOR-TX** (12.5" penetration, 0.81" expansion) and **Hornady 155gr XTP** (14" penetration, 0.68" expansion, 1,344 fps).

### 10mm vs .40 S&W: The parent outperforms the child

Full-power 10mm delivers **31-56% more energy** than .40 S&W with identical bullet weights. Velocity advantage runs **150-300 fps** faster. The longer case (25mm vs 22mm) and higher pressure ceiling (37,500 vs 35,000 PSI) enable this performance gap.

### 10mm vs .357 Magnum: Ballistic twins

Both cartridges produce approximately **530-550 ft-lbs average energy**. The .357 Magnum achieves slightly higher velocity with light bullets from long barrels, while 10mm offers higher capacity (15+ vs 6-8 rounds), faster reloads, and heavier bullet options. Hot 10mm loads (Underwood 135gr at 768 ft-lbs) can exceed typical .357 Magnum.

**Effective range**: 50-75 yards—approximately **25-50% greater** than .40 S&W due to flatter trajectory. Legal for deer hunting in many states; effective on hogs and black bear with proper loads.

---

## .357 Magnum: The legendary 125-grain man-stopper

No handgun cartridge carries more historical weight than the .357 Magnum 125gr JHP. Introduced in 1935, it dominated law enforcement for decades. Barrel length affects performance more dramatically than any other common cartridge—a critical factor for game implementation.

### FMJ specifications by barrel length

| Weight | 6" Barrel | 4" Barrel | 2" Snubnose |
|--------|-----------|-----------|-------------|
| **125gr** | 1,700 fps / 800 ft-lbs | 1,510 fps / 630 ft-lbs | 950 fps / 250 ft-lbs |
| **158gr** | 1,465 fps / 750 ft-lbs | 1,293 fps / 590 ft-lbs | 860 fps / 260 ft-lbs |

The **2-inch snubnose loses 40-45% velocity** compared to a 6-inch barrel—transforming a powerhouse into a moderate performer.

### The famous 125gr JHP earned its reputation

The Federal 125gr JHP from a 4-inch barrel produces **1,440-1,510 fps** and **575-630 ft-lbs**. Marshall & Sanow's controversial study credited it with 96% one-shot stop ratings. The combination of 1,400+ fps velocity with violent hollow point expansion created dramatic wound channels unmatched by other service calibers of the era.

Modern perspective acknowledges limitations: classic 125gr loads often penetrate only **10 inches**—below the FBI's 12-inch minimum. Excessive recoil and muzzle blast, along with reports of cracked forcing cones in K-frame revolvers, prompted development of optimized alternatives.

### Best modern JHP performers

**From 4-inch barrels** (FBI protocol gel testing):
- **Winchester 125gr PDX1**: 15.5" penetration, 0.65" expansion, 1,215 fps
- **Federal 130gr Hydra-Shok**: 13.3" penetration, 0.67" expansion, 1,407 fps
- **Hornady 125gr Critical Defense**: 14.5" penetration, 0.57" expansion, 1,350 fps

**From 2-inch barrels** (critical for snubnose carry):
- **Speer 135gr Gold Dot Short Barrel**: 13.0" penetration, 0.55" expansion, 1,069 fps
- **Barnes 125gr TAC-XPD**: 14.2" penetration, **0.75" expansion**, 1,251 fps
- **Buffalo Bore 125gr Barnes XPB**: 13.9" penetration, 0.64" expansion, 1,144 fps

### Barrel length creates three distinct performance tiers

| Barrel | Average Velocity (125gr) | Average Energy | Character |
|--------|-------------------------|----------------|-----------|
| **6"** | 1,600 fps | **710 ft-lbs** | Full magnum power |
| **4"** | 1,400 fps | **545 ft-lbs** | Standard duty |
| **2"** | 1,050 fps | **305 ft-lbs** | Compromised |

No "+P" .357 Magnum exists—the cartridge already operates at maximum 35,000 PSI. "Hot" loads from Buffalo Bore simply maximize SAAMI specifications.

---

## .38 Special: The snubnose expansion problem

The .38 Special's 1898 black-powder heritage limits it to just **17,000 PSI**—half the pressure of .357 Magnum despite sharing identical bullet diameter. This creates fundamental terminal performance limitations, especially from short barrels.

### FMJ/LRN specifications

| Weight | Standard Pressure | +P Load | +P Energy |
|--------|------------------|---------|-----------|
| **110gr** | 770 fps / 145 ft-lbs | 1,040 fps / 265 ft-lbs | 265 ft-lbs |
| **125gr** | 775 fps / 167 ft-lbs | 930 fps / 240 ft-lbs | 240 ft-lbs |
| **130gr** | 760 fps / 167 ft-lbs | 890 fps / 229 ft-lbs | 229 ft-lbs |
| **158gr** | 755 fps / 200 ft-lbs | 890 fps / 280 ft-lbs | **280 ft-lbs** |

The classic 158gr lead round nose "police load" at 755 fps and 200 ft-lbs represents the baseline. **+P loads provide approximately 20% more energy** but still fall well below 9mm performance.

### Energy comparison reveals the gap

Standard .38 Special at **200 ft-lbs** delivers only **57% of 9mm energy** (350 ft-lbs average). Even +P at 280 ft-lbs reaches only **80% of 9mm**. Wikipedia notes: ".38 Special +P falls between .380 ACP and 9mm Parabellum."

### Short barrel expansion is the critical weakness

Lucky Gunner tested 18 .38 Special loads from 2-inch barrels. Results were concerning: **12 of 18 loads** had at least one bullet fail to expand; **5 loads showed zero expansion** across all test rounds.

**Velocity loss from barrel length:**
| Load | 4" Barrel | 2" Barrel | Loss |
|------|-----------|-----------|------|
| Speer Gold Dot 135gr +P | 890 fps | 821 fps | -69 fps |
| Hornady CD 110gr +P | 1,058 fps | 945 fps | -113 fps |

### The top snubnose performers

**Federal HST Micro 130gr +P** stands alone as the best performer: approximately **800 fps** from 2-inch barrels producing **0.73-inch expansion**—matching premium 9mm performance. The "pre-expanded" wide hollow cavity enables reliable expansion at lower velocities.

**Speer Gold Dot Short Barrel 135gr +P** disappoints despite its marketing: only **0.44-inch expansion** from snubnose testing—barely expanding at all.

**Winchester PDX1 130gr +P** performs reliably with 0.60-0.63" expansion and consistent penetration.

For budget-conscious users, **148gr wadcutters** (non-expanding) provide reliable 15-16" penetration without expansion concerns.

### The .38 vs .357 relationship

Both use **.357-inch diameter bullets**, but .357 Magnum's case is **1/8-inch longer** and operates at **double the pressure** (35,000 vs 17,000 PSI). Standard .38 Special produces only **37% of .357 Magnum energy**; +P reaches **52%**.

The longer .357 case physically prevents chambering in .38-only revolvers—a deliberate safety feature. Conversely, .38 Special fires safely in .357 Magnum revolvers, commonly used for reduced-recoil practice.

---

## FiveM weapon meta framework values

Using **9mm Luger = 34 base damage** and approximately **350 ft-lbs muzzle energy** as the reference standard, real-world energy ratios translate to these game values:

### .40 S&W framework

| Parameter | FMJ Value | JHP Value | Notes |
|-----------|-----------|-----------|-------|
| **Base Damage** | **41** | **49** | ~420 ft-lbs average = 1.20× 9mm |
| **JHP Damage Modifier** | — | **+20%** | Expansion improves energy transfer |
| **Penetration (FMJ)** | **0.72** | — | Over-penetrates gel; good barrier perf |
| **Penetration (JHP)** | — | **0.55** | 14-18" gel; designed to stop in target |
| **Armor Effectiveness** | **0.65** | **0.40** | Moderate; higher pressure than .45 |
| **Speed (Muzzle Velocity)** | **990** | **970** | 180gr standard loads |
| **Effective Range** | **50m** | **45m** | Practical accuracy limit |

### 10mm Auto framework

| Parameter | FBI-Spec | Full-Power FMJ | Full-Power JHP | Notes |
|-----------|----------|----------------|----------------|-------|
| **Base Damage** | **37** | **53** | **64** | FBI: 360 ft-lbs; Full: 650 ft-lbs avg |
| **JHP Damage Modifier** | — | — | **+20%** | Enhanced energy transfer |
| **Penetration (FBI FMJ)** | **0.70** | — | — | Downloaded = .40 S&W equivalent |
| **Penetration (Full FMJ)** | — | **0.85** | — | Extreme penetration; hunting use |
| **Penetration (Full JHP)** | — | — | **0.58** | Controlled expansion |
| **Armor Effectiveness** | **0.60** | **0.75** | **0.50** | High velocity defeats soft armor |
| **Speed** | **950** | **1,300** | **1,275** | Dramatic velocity difference |
| **Effective Range** | **50m** | **75m** | **70m** | Extended range vs .40 S&W |

### .357 Magnum framework (barrel-dependent)

| Parameter | 6" FMJ | 6" JHP | 4" FMJ | 4" JHP | 2" JHP |
|-----------|--------|--------|--------|--------|--------|
| **Base Damage** | **58** | **70** | **49** | **59** | **35** |
| **JHP Modifier** | — | +20% | — | +20% | +15% |
| **Penetration (FMJ)** | 0.90 | — | 0.82 | — | — |
| **Penetration (JHP)** | — | 0.55 | — | 0.52 | 0.48 |
| **Armor Effect.** | 0.70 | 0.45 | 0.62 | 0.42 | 0.35 |
| **Speed** | 1,650 | 1,600 | 1,400 | 1,350 | 1,050 |
| **Effective Range** | 75m | 70m | 60m | 55m | 30m |

**Note**: 2" snubnose loses 40-45% velocity, dramatically reducing damage output. The legendary 125gr JHP reputation applies primarily to 4"+ barrels.

### .38 Special framework (barrel-dependent)

| Parameter | 4" Standard FMJ | 4" +P JHP | 2" +P JHP | Notes |
|-----------|-----------------|-----------|-----------|-------|
| **Base Damage** | **20** | **27** | **22** | 200 ft-lbs std; 280 ft-lbs +P |
| **JHP Modifier** | — | +15% | +10% | Reduced; expansion unreliable |
| **Penetration (FMJ)** | **0.65** | — | — | Deep but controlled |
| **Penetration (JHP)** | — | **0.50** | **0.45** | Lower velocity = less expansion |
| **Armor Effectiveness** | **0.30** | **0.25** | **0.20** | Low pressure; minimal AP |
| **Speed** | **755** | **890** | **820** | Slow; black-powder heritage |
| **Effective Range** | **35m** | **40m** | **25m** | Limited by velocity/trajectory |

**Critical note for .38 Special JHP**: Use **+10% damage modifier for 2" barrels** instead of +15% to reflect real-world expansion failures. Standard pressure JHP from snubnose should receive **no damage bonus**—the bullets don't expand reliably.

---

## Quick reference damage hierarchy (relative to 9mm = 34)

| Caliber | FMJ Damage | JHP Damage | Energy (ft-lbs) |
|---------|------------|------------|-----------------|
| .38 Special (Std) | 20 | 22 | 200 |
| .38 Special +P | 23 | 27 | 280 |
| **9mm Luger** | **34** | **41** | **350** |
| .40 S&W | 41 | 49 | 420 |
| .357 Mag (4") | 49 | 59 | 545 |
| 10mm FBI-Spec | 37 | 44 | 360 |
| 10mm Full-Power | 53 | 64 | 650 |
| .357 Mag (6") | 58 | 70 | 710 |

---

## Implementation recommendations

**Penetration scale interpretation (0.00-1.00)**:
- **0.90-1.00**: Extreme penetration (rifle rounds, hard cast hunting)
- **0.70-0.85**: High penetration (FMJ, barrier-blind duty loads)
- **0.50-0.65**: Moderate penetration (standard FMJ, controlled JHP)
- **0.40-0.50**: Optimal defensive (modern JHP, 12-18" gel standard)
- **Below 0.40**: Under-penetration risk (lightweight/frangible)

**Armor effectiveness modifier**: Represents ability to defeat soft body armor. High-velocity rounds (.357 Mag, 10mm) at 0.60+ can stress Level II armor; low-pressure rounds (.38 Special) below 0.35 are reliably stopped.

**JHP damage bonus rationale**: The 15-20% increase reflects real-world energy transfer improvement when bullets expand properly. Reduce this modifier for low-velocity scenarios (snubnose .38) where expansion is unreliable.

**Barrel length as damage variable**: For revolvers, implementing barrel-length damage scaling creates authentic ballistic behavior. A .357 Magnum from a 2" barrel should deal approximately **60% of the damage** from a 6" barrel—reflecting the dramatic real-world velocity loss.