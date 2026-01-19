# Glock 20 Gen 4 and 10mm Auto: Complete Technical Reference for FiveM Weapon Meta

The 10mm Auto represents a critical mid-point in the handgun damage hierarchy—**FBI-spec loads (~400 ft-lbs) match .40 S&W performance**, while **full-power loads (600-730 ft-lbs) equal or exceed .357 Magnum**. This unique dual-personality characteristic makes proper implementation essential for realistic game ballistics. The Glock 20's 4.61" barrel delivers approximately **50-100 fps less** than advertised velocities (typically tested from longer barrels), placing real-world full-power 180gr loads at **1,250-1,300 fps** producing **575-680 ft-lbs** of muzzle energy.

---

## Glock 20 Gen 4 complete specifications

The Glock 20 uses Glock's full-size "large frame" platform, sharing dimensions with the Glock 21 (.45 ACP). This frame is noticeably larger than standard 9mm/.40 S&W Glocks and was developed specifically to handle 10mm Auto pressures.

| Specification | Metric | Imperial |
|--------------|--------|----------|
| **Barrel Length** | 117mm | 4.61" |
| **Overall Length** | 204mm | 8.03" |
| **Height (with magazine)** | 139mm | 5.47" |
| **Width** | 32.5mm | 1.27" |
| **Slide Width** | ~28.5mm | ~1.12" |
| **Sight Radius** | 172mm | 6.77" |
| **Trigger Pull** | 28N | ~5.5 lbs |
| **Weight (unloaded, no mag)** | 780g | 27.51 oz |
| **Weight (empty magazine)** | 865g | 30.51 oz |
| **Weight (loaded, 15+1)** | 1,120g | 39.54 oz |
| **Magazine Capacity** | 15+1 standard | 10-round compliant available |

**Barrel specifications** include hexagonal (polygonal) rifling with a **1:9.84" right-hand twist**. The slide features gas-nitrate finish with an extractor serving as a loaded chamber indicator. The Gen 4 introduced a **dual captive recoil spring assembly** with a factory weight of approximately **17 lbs**—considered light for full-power 10mm, with many shooters upgrading to **20-24 lb springs** for hot loads from Underwood and Buffalo Bore.

### Gen 3 versus Gen 4 versus Gen 5 MOS differences

| Feature | Gen 3 | Gen 4 | Gen 5 MOS |
|---------|-------|-------|-----------|
| Recoil Spring | Single spring | Dual captive | Dual captive (improved) |
| Backstraps | Fixed (SF model available) | Modular (2 included) | Modular |
| Magazine Release | Fixed left side | Reversible, enlarged | Reversible |
| Finger Grooves | Yes | Yes | **No** (removed) |
| Slide Finish | Gas-nitrate | Gas-nitrate | **nDLC** (superior) |
| Optics Ready | No | No | **Yes (MOS)** |
| Slide Stop | Left only | Left only | **Ambidextrous** |
| Barrel | Standard | Standard | **Glock Marksman Barrel** |

The **Glock 20 SF (Short Frame)** reduces trigger reach by **2.5mm** and heel circumference by **4mm**, addressing the most common complaint that the standard grip is "like gripping a 2x4." Gen 4's smallest backstrap matches SF dimensions.

### Related Glock 10mm variants for future additions

| Model | Barrel | Overall Length | Weight (loaded) | Capacity | Purpose |
|-------|--------|----------------|-----------------|----------|---------|
| **Glock 20** | 4.61" | 8.03" | 39.5 oz | 15+1 | Duty/woods carry |
| **Glock 29** | 3.78" | 6.97" | 32.8 oz | 10+1 | Concealed carry |
| **Glock 40 MOS** | 6.02" | 9.49" | 32.3 oz (empty) | 15+1 | Hunting/competition |

---

## Handling characteristics and recoil profile

The Glock 20's recoil character differs significantly from other full-size Glocks. 10mm Auto 180gr full-power loads generate approximately **11.4 ft-lbs of recoil energy** with an **18.1 fps recoil velocity**—compared to .45 ACP's 7.9 ft-lbs and 15.0 fps. This higher velocity impulse creates a "snappy" sensation rather than .45 ACP's slower "push."

**Comparative recoil data (normalized to 2.25 lb pistol):**

| Caliber | Load | Recoil Energy | Recoil Velocity | Character |
|---------|------|---------------|-----------------|-----------|
| 9mm | 115gr @ 1,155 fps | 5.2 ft-lbs | 15.0 fps | Light, controllable |
| .40 S&W | 180gr @ 1,027 fps | 10.4 ft-lbs | 21.2 fps | Snappy |
| **.45 ACP** | 230gr @ 850 fps | 7.9 ft-lbs | 15.0 fps | Push, manageable |
| **10mm (FBI-spec)** | 180gr @ 1,000 fps | ~8 ft-lbs | ~16 fps | Moderate |
| **10mm (full-power)** | 180gr @ 1,295 fps | 11.4 ft-lbs | 18.1 fps | Heavy, snappy |
| .357 Magnum | 158gr @ 1,250 fps | 8.7 ft-lbs | 14.3 fps | Sharp |

The FBI abandoned 10mm not primarily due to recoil (they never issued full-power ammunition), but because the Smith & Wesson 1076 had mechanical defects and the large frame was difficult for agents with smaller hands. This led directly to the .40 S&W's development—essentially FBI-spec 10mm ballistics in a shorter case that fit 9mm-frame pistols.

**Common shooter complaints** include grip size issues for smaller hands (addressed by SF/Gen 4 backstraps), trigger feel with high round counts, standard polymer sights requiring replacement, and erratic brass ejection patterns.

---

## 10mm Auto cartridge specifications

| Specification | Value |
|--------------|-------|
| **Case Length** | 25.20mm / 0.992" |
| **Overall Cartridge Length** | 32.00mm / 1.260" |
| **Bullet Diameter** | 10.17mm / 0.400" |
| **Neck Diameter** | 10.74mm / 0.423" |
| **Base/Rim Diameter** | 10.80mm / 0.425" |
| **SAAMI Maximum Pressure** | **37,500 PSI** |
| **CIP Maximum Pressure** | 33,000 PSI |
| **Case Type** | Rimless, straight-walled |
| **Primer** | Large Pistol |

The original **Norma specification** (1983) loaded 200gr bullets at **1,200-1,260 fps** producing **639-704 ft-lbs**—this remains the benchmark for "true" 10mm performance. Most major manufacturers now load conservatively to FBI-spec levels (**180gr @ 950-1,030 fps**), essentially duplicating .40 S&W ballistics.

### Common bullet weights and applications

| Weight | Typical Velocity | Energy Range | Primary Application |
|--------|------------------|--------------|---------------------|
| 100-115gr | 1,700-1,825 fps | 650-740 ft-lbs | Extreme velocity loads |
| 135gr | 1,500-1,600 fps | 710-768 ft-lbs | Self-defense, flat trajectory |
| 155gr | 1,265-1,400 fps | 551-675 ft-lbs | All-around, competition |
| 165gr | 1,350-1,400 fps | 668-718 ft-lbs | Balanced performance |
| **180gr** | 1,030-1,350 fps | 400-728 ft-lbs | **Most common weight** |
| 200gr | 1,150-1,300 fps | 580-750 ft-lbs | Hunting, woods defense |
| 220gr | 1,100-1,200 fps | 590-703 ft-lbs | Bear defense, maximum penetration |

---

## FBI-spec versus full-power ammunition data

This distinction is critical for game implementation—10mm essentially spans two damage tiers depending on loading.

### FBI-spec "lite" loads (~360-450 ft-lbs)

These loads essentially duplicate .40 S&W ballistics:

| Manufacturer | Product | Velocity | Energy |
|--------------|---------|----------|--------|
| Federal | Hydra-Shok 180gr JHP | 1,030 fps | ~400 ft-lbs |
| Federal | American Eagle 180gr FMJ | 1,030 fps | ~400 ft-lbs |
| Winchester | USA White Box 180gr FMJ | ~1,000 fps | ~400 ft-lbs |
| Remington | UMC 180gr FMJ | ~1,000 fps | ~400 ft-lbs |
| PMC | Bronze 180gr FMJ | ~985 fps | ~388 ft-lbs |

### Full-power loads (550-750+ ft-lbs)

These loads match or exceed .357 Magnum:

| Manufacturer | Load | Velocity | Energy |
|--------------|------|----------|--------|
| **Underwood** | 135gr JHP | 1,600 fps | **768 ft-lbs** |
| **Buffalo Bore** | 180gr JHP (21A) | 1,350 fps | **728 ft-lbs** |
| Underwood | 155gr XTP JHP | 1,400 fps | 675 ft-lbs |
| DoubleTap | 180gr CE JHP | 1,300 fps | 676 ft-lbs |
| Sig Sauer | 180gr V-Crown JHP | 1,250 fps | 624 ft-lbs |
| Hornady | 180gr XTP Custom | 1,275 fps | 650 ft-lbs |
| **Buffalo Bore** | 220gr Hard Cast | 1,200 fps | **703 ft-lbs** |
| Underwood | 200gr XTP JHP | 1,250 fps | 694 ft-lbs |

**Buffalo Bore** is notable for testing from real firearms rather than optimistic test barrels—their velocities are typically achievable from Glock 20.

---

## Chronograph data from Glock 20 barrels

Real-world testing reveals significant velocity loss from advertised specifications:

| Load | Advertised | Actual (4.61") | Variance | Actual Energy |
|------|------------|----------------|----------|---------------|
| Buffalo Bore 180gr JHP | 1,350 fps | 1,297 fps | -4% | 672 ft-lbs |
| Sig Sauer 180gr V-Crown | 1,250 fps | 1,080 fps | **-15%** | 517 ft-lbs |
| Underwood 200gr XTP | 1,250 fps | 1,147 fps | -8% | 584 ft-lbs |
| Hornady 180gr XTP | 1,275 fps | 1,158 fps | -9% | 536 ft-lbs |
| Federal 180gr Hydra-Shok | 1,030 fps | 1,002 fps | -3% | 401 ft-lbs |

**Velocity by barrel length formula:** Approximately **50 fps per inch** of barrel length change. A Glock 29 (3.78") loses 40-75 fps compared to Glock 20; a Glock 40 (6.02") gains 70-100 fps.

---

## Ballistic gel testing results from Lucky Gunner Labs

Testing conducted with Glock 20 Gen 4 (4.61" barrel) through 4-layer heavy clothing barrier:

| Load | Penetration | Expansion | Velocity | FBI 12-18"? |
|------|-------------|-----------|----------|-------------|
| **Barnes 155gr VOR-TX** | 12.48" | **0.806"** | 1,079 fps | ✅ **Best** |
| Hornady 155gr XTP | 14.0" | 0.676" | 1,343 fps | ✅ Pass |
| Federal 180gr Hydra-Shok | 15.88" | 0.612" | 1,002 fps | ✅ Pass |
| Winchester 175gr Silvertip | 16.24" | 0.676" | 1,143 fps | ✅ Pass |
| Hornady 180gr XTP | 16.88" | 0.638" | 1,158 fps | ✅ Pass |
| Sig Sauer 180gr V-Crown | 19.36" | 0.764" | 1,138 fps | ❌ Over-pen |
| Speer 200gr Gold Dot | 19.74" | 0.678" | 1,029 fps | ❌ Over-pen |
| Hornady 175gr Critical Duty | 20.5" | 0.556" | 1,070 fps | ❌ Over-pen |
| Buffalo Bore 200gr FMJ-FN | 32+" | 0.40" | 1,109 fps | N/A |

**Key finding:** Full-power 10mm loads (**1,300+ fps**) can push JHP bullets beyond their design envelope, resulting in over-penetration or erratic expansion. The optimal velocity window for .40 caliber JHP bullets is **1,000-1,200 fps**.

### Hard cast penetration for bear defense

| Load | Velocity | Penetration | Application |
|------|----------|-------------|-------------|
| Buffalo Bore 220gr Hard Cast | 1,200 fps | 32"+ (exited gel) | Bear defense |
| Underwood 220gr Hard Cast | 1,139 fps | 32"+ | Maximum penetration |
| Underwood 200gr Hard Cast | 1,191 fps | 25"+ | Woods carry |
| Underwood 140gr Xtreme Penetrator | 1,507 fps | 25.9" | Solid copper deep pen |

---

## 10mm versus other calibers for damage hierarchy

### Complete energy hierarchy for positioning

| Caliber | Load Type | Typical Energy | Game Position |
|---------|-----------|----------------|---------------|
| 9mm | Standard | 310-365 ft-lbs | Baseline |
| 9mm +P | Hot | 374-400 ft-lbs | +10-15% |
| .45 ACP | Standard | 355-400 ft-lbs | Similar to 9mm+P |
| .45 ACP +P | Hot | 450-485 ft-lbs | +25-30% |
| **.40 S&W** | Standard | 400-470 ft-lbs | Reference point |
| **10mm FBI-spec** | Downloaded | 400-450 ft-lbs | **= .40 S&W** |
| .357 Magnum | Standard (4") | 500-600 ft-lbs | +40-50% |
| **10mm Full-power** | Premium | 575-730 ft-lbs | **= .357 Mag** |
| .357 Magnum | Hot (6") | 700-900 ft-lbs | Maximum |

**Recommended game implementation:** Position 10mm damage between .40 S&W and .357 Magnum. If implementing ammunition types, FBI-spec should deal .40 S&W-equivalent damage while full-power loads should deal .357 Magnum-equivalent damage.

### Direct comparisons

**10mm vs .40 S&W:** The .40 S&W is literally "10mm Short"—developed to replicate FBI-spec 10mm in a shorter case. FBI-spec 10mm (180gr @ 1,000 fps / ~400 ft-lbs) and .40 S&W (180gr @ 1,000 fps / ~400 ft-lbs) are ballistically identical. Full-power 10mm exceeds .40 S&W by **50-75%** in energy.

**10mm vs .357 Magnum:** Full-power 10mm matches standard .357 Magnum from 4" barrels. Buffalo Bore 180gr 10mm (1,350 fps / 728 ft-lbs) competes directly with .357 Mag 158gr (1,250 fps / 549 ft-lbs). The 10mm advantage: **15+1 capacity versus 6 rounds**, faster reloads, and flatter trajectory.

**10mm vs .45 ACP:** Despite similar frame sizes, 10mm delivers approximately **44% more energy** at the same bullet weight (180gr 10mm @ 1,300 fps vs 185gr .45 ACP @ 1,000 fps). The .45 ACP's slower velocity (subsonic) creates a "push" recoil versus 10mm's "snap."

---

## Aftermarket support and conversion options

The Glock 20 enjoys extensive aftermarket support:

**Barrels:** Lone Wolf (AlphaWolf), KKM Precision, Bar-Sto, Storm Lake, Faxon. KKM offers fully-supported match chambers that reduce brass bulging with hot loads. **Conversion barrels** to .40 S&W are drop-in replacements (~$100-125), using standard G20 magazines with minor feeding considerations.

**Compensators:** KKM, Carver Custom, and Strike Industries Mass Driver reduce felt recoil by **30-50%** with proper loads. Requires threaded barrel (5/8x24 or 9/16x24 thread pitch common).

**Recoil springs:** Wolff Gunsprings and ISMI offer 17-24 lb options. Stock 17 lb spring is adequate for FBI-spec; **20-22 lb recommended for full-power loads**, and **24 lb for consistent hot load use** (Buffalo Bore, Underwood).

---

## Pricing and market position

### Glock 20 MSRP and street prices

| Model | MSRP | Street Price | Used |
|-------|------|--------------|------|
| Glock 20 Gen 4 | ~$745 | $550-660 | $200-400 |
| Glock 20 Gen 5 MOS | ~$745 | $649-700 | N/A |
| Glock 40 MOS | ~$700-800 | $590-630 | $512-547 |

10mm Glocks carry approximately **$100-150 premium** over 9mm models (Glock 17/19 street price: $499-549).

### Ammunition costs

| Type | Per Round | Notes |
|------|-----------|-------|
| 10mm FMJ Range | $0.40-0.52 | Blazer, Sellier & Bellot |
| 10mm FBI-spec JHP | $0.70-1.00 | Federal, Winchester |
| 10mm Full-power JHP | $0.90-1.50 | Underwood, Hornady |
| 10mm Hard Cast | $0.95-2.00 | Underwood cheaper, Buffalo Bore premium |
| **Comparison: 9mm FMJ** | $0.20-0.35 | 50-70% cheaper |
| Comparison: .45 ACP FMJ | $0.40-0.55 | Similar to 10mm |

Full-power 10mm ammunition is **less available** at retail than major calibers—online ordering from Underwood, Buffalo Bore, or DoubleTap is typically necessary for specialty loads.

---

## Real-world applications summary

**Bear defense:** The 10mm has become the preferred semi-auto for Alaska/backcountry carry, offering 15+1 capacity in a lighter package than .44 Magnum revolvers. Hard cast 200-220gr loads at 1,200 fps provide adequate penetration for black bear and serve as a defensive option against grizzly. Denmark's Sirius Sledge Patrol issues Glock 20 for polar bear defense in Greenland.

**Law enforcement:** Currently rare. FBI HRT and SWAT teams maintain 10mm capability. Most agencies transitioned to .40 S&W (now trending back to 9mm). BART Police and several smaller departments still issue 10mm.

**Hunting:** Appropriate for feral hogs, white-tailed deer (within 75 yards), black bear, and medium game with proper bullet selection (Hornady XTP, hard cast for penetration).

---

## Summary data for FiveM implementation

**Recommended damage positioning:** 10mm should deal damage between .40 S&W baseline and .357 Magnum ceiling. For single-tier implementation, set damage at approximately **120-130%** of .40 S&W values or **85-90%** of .357 Magnum values.

**Key stats for game translation:**
- Muzzle velocity: 1,200-1,300 fps (realistic full-power)
- Muzzle energy: 575-680 ft-lbs (median full-power)
- Magazine capacity: 15+1
- Recoil modifier: High (approximately 50% greater than .45 ACP)
- Effective range: Similar to other service pistols
- Penetration: Higher than .45 ACP, similar to .357 Magnum

The 10mm Auto's dual nature—spanning from .40 S&W to .357 Magnum depending on ammunition—makes it uniquely versatile for game mechanics that differentiate ammunition types.