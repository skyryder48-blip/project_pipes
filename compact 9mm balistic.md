# Compact 9mm pistol specifications for FiveM weapon meta files

These four micro-compact 9mm pistols share remarkably similar ballistic performance despite design differences, with muzzle velocities clustering around **1,050-1,100 fps for 115gr** and **990-1,070 fps for 124gr** ammunition from their 3.0–3.43" barrels. The primary differentiators for FiveM implementation are capacity, weight (affecting recoil modeling), and barrel length (affecting damage falloff calculations).

## Glock 26 Gen 5: The double-stack benchmark

The G26 Gen 5 represents Glock's "Baby Glock" subcompact with a **3.43" (87mm) barrel**—the longest in this comparison, yielding slightly higher velocities and a meaningful advantage in accuracy spread calculations.

| Specification | Value |
|---------------|-------|
| Barrel length | 3.43" / 87mm |
| Muzzle velocity (115gr FMJ) | 1,029–1,100 fps / 314–335 m/s |
| Muzzle velocity (124gr FMJ) | 988–1,061 fps / 301–323 m/s |
| Standard magazine | 10 rounds |
| Extended magazines | 15, 17, 19, 33 rounds (G17/G19 compatible) |
| Weight empty | 19.40 oz / 550g |
| Weight loaded (10+1) | 25.75 oz / 730g |
| Effective range | 25–50 yards practical |

**Handling characteristics for meta files:** The Gen 5's dual captive recoil spring system significantly reduces muzzle flip compared to single-spring designs. The **6.3 lb trigger pull** (factory spec 28N, tested at 5.25–5.5 lbs) provides consistent break. The removable finger grooves and modular backstraps accommodate varied grip sizes. The Glock Marksman Barrel with improved crown enhances inherent accuracy—model this as a slight accuracy bonus versus competitors.

**Unique FiveM consideration:** Magazine interchangeability with full-size Glocks means players could realistically extend to 33-round magazines, justifying extended clip options up to that capacity.

---

## Glock 43X: Slimline single-stack with extended grip

The G43X trades the G26's thickness for a **slimmer 1.10" width** (vs 1.30") while adding grip length for improved control. The **3.41" (87mm) barrel** produces nearly identical ballistics to the G26.

| Specification | Value |
|---------------|-------|
| Barrel length | 3.41" / 87mm |
| Muzzle velocity (115gr FMJ) | 1,050–1,100 fps / 320–335 m/s |
| Muzzle velocity (124gr FMJ) | 1,000–1,050 fps / 305–320 m/s |
| Standard magazine | 10 rounds |
| Extended (Shield Arms S15) | 15 rounds (flush-fit), 17–25 with extensions |
| Weight empty | 16.40 oz / 465g |
| Weight loaded (10+1) | 23.07 oz / 654g |
| Effective range | 25–50 yards practical |

**Key differences from the Glock 26:**
- **3 oz lighter** (impacts recoil impulse—model as slightly snappier)
- **Single 17 lb recoil spring** vs dual spring (more muzzle flip)
- **0.87" taller grip** (better control, slower concealment draw)
- **No magazine cross-compatibility** with standard Glocks
- **Slightly lighter trigger** at 5.4 lbs vs 6.3 lbs

**Handling for meta files:** The lighter weight and single recoil spring create a snappier recoil impulse. The extended grip length partially compensates by providing better purchase. Model recoil amplitude approximately **10-15% higher** than the G26 but with faster recovery due to the longer grip leverage.

---

## Springfield Hellcat: Micro-compact capacity king

The Hellcat pioneered the high-capacity micro-compact category with **11+1 rounds** in a package barely larger than a Glock 43. Its **3.0" (76mm) barrel** is the shortest here, affecting velocity and damage falloff calculations.

| Specification | Value |
|---------------|-------|
| Barrel length | 3.0" / 76mm |
| Muzzle velocity (115gr FMJ) | 1,050–1,100 fps / 320–335 m/s |
| Muzzle velocity (124gr FMJ) | 1,050–1,094 fps / 320–333 m/s |
| Standard magazine (flush) | 11 rounds |
| Extended magazines | 13, 15, 17 rounds |
| Weight empty | 18.3 oz / 519g |
| Weight loaded (11+1) | ~21.5 oz / 610g |
| Effective range | 15–25 yards practical |

**Notable features affecting handling characteristics:**

The **Adaptive Grip Texture** uses pressure-activated pyramids—flat-topped for comfort, pointed tips that engage aggressively under recoil. This should translate to slightly better recoil control than weight alone suggests. The **dual captive recoil spring** (similar to G26) manages muzzle flip well despite the compact frame.

The **standoff device** (guide rod extending past muzzle) allows contact shots without pushing the slide out of battery—relevant for melee-range combat accuracy. The **U-Dot tritium sights** provide faster target acquisition than standard three-dot systems.

**FiveM implementation notes:** The shortest barrel justifies the fastest damage falloff curve. However, the Hellcat's tested accuracy of **0.75–0.80" groups at 15 yards** indicates excellent mechanical precision—model accuracy spread as competitive with longer-barreled pistols at close range, degrading faster beyond 25 yards. The 11-round standard capacity is a genuine advantage over the Glocks' 10-round base.

---

## Taurus GX4: Budget alternative with competitive specs

The GX4 directly competes with the Hellcat at **40-50% lower street price** ($200-300 vs $450-530) while matching core specifications. Its **3.06" (78mm) barrel** slots between the Hellcat and Glocks.

| Specification | Value |
|---------------|-------|
| Barrel length | 3.06" / 78mm |
| Muzzle velocity (115gr FMJ) | 1,029–1,100 fps / 314–335 m/s |
| Muzzle velocity (124gr FMJ) | 988–1,070 fps / 301–326 m/s |
| Standard magazine | 11 rounds |
| Extended magazines | 13 rounds (15 on GX4 Carry) |
| Weight empty | 18.5 oz / 524g |
| Weight loaded (11+1) | ~23.5 oz / 666g |
| Effective range | 25–50 yards practical |

**Comparison matrix for FiveM balancing:**

| Factor | GX4 | Hellcat | G43X |
|--------|-----|---------|------|
| Weight (empty) | 18.5 oz | 18.3 oz | 16.4 oz |
| Barrel length | 3.06" | 3.0" | 3.41" |
| Capacity | 11+1 | 11+1 | 10+1 |
| Trigger pull | 6.5 lbs | 5.5 lbs | 5.4 lbs |
| Width | 1.08" | 1.00" | 1.10" |

**Unique characteristics:** The **stainless steel internal chassis** with full-length slide rails (similar to Sig P365 FCU design) provides durability. The **aggressive 360° grip texture** rivals the Hellcat's Adaptive Grip. The GX4 uses a **dual-spring recoil assembly** optimized for micro-compacts. Trigger pull averages **6.5 lbs** (heavier than competitors), which could translate to slightly slower accurate fire rates.

**No re-strike capability**—unlike older Taurus designs, this is a true striker-fired system identical in function to Glock/Springfield designs.

---

## Consolidated specifications for FiveM weapon meta implementation

### Ballistic parameters (standardized for meta files)

| Weapon | Bullet Speed (m/s) | Damage Base | Falloff Start (m) | Falloff End (m) |
|--------|-------------------|-------------|-------------------|-----------------|
| Glock 26 Gen 5 | 320 | 1.00 | 25 | 75 |
| Glock 43X | 318 | 0.98 | 25 | 75 |
| Springfield Hellcat | 325 | 0.95 | 20 | 65 |
| Taurus GX4 | 315 | 0.97 | 22 | 70 |

*Note: Damage base normalized to G26 = 1.00; slight variations reflect barrel length effects on velocity and energy transfer.*

### Recoil and accuracy parameters

| Weapon | Recoil Amplitude | Recovery Rate | Accuracy Spread | Trigger Factor |
|--------|-----------------|---------------|-----------------|----------------|
| Glock 26 Gen 5 | 0.85 | 0.90 | 0.92 | 0.95 |
| Glock 43X | 0.95 | 0.85 | 0.90 | 1.00 |
| Springfield Hellcat | 0.92 | 0.88 | 0.88 | 1.00 |
| Taurus GX4 | 0.90 | 0.86 | 0.90 | 0.90 |

*Lower recoil amplitude = less kick; higher recovery = faster sight return; higher accuracy = tighter spread; higher trigger factor = faster accurate shots.*

### Magazine configurations

| Weapon | Standard | Extended 1 | Extended 2 | Max Extended |
|--------|----------|------------|------------|--------------|
| Glock 26 Gen 5 | 10 | 15 | 17 | 33 |
| Glock 43X | 10 | 15 | 17 | 25 |
| Springfield Hellcat | 11 | 13 | 15 | 17 |
| Taurus GX4 | 11 | 13 | 15 | 15 |

### Weight classes (affects handling speed)

| Weapon | Empty (g) | Loaded (g) | Handling Class |
|--------|-----------|------------|----------------|
| Glock 43X | 465 | 654 | Ultralight |
| Springfield Hellcat | 519 | 610 | Light |
| Taurus GX4 | 524 | 666 | Light |
| Glock 26 Gen 5 | 550 | 730 | Standard Compact |

## Implementation recommendations for balanced gameplay

The **Glock 26 Gen 5** should serve as the baseline "reliable all-rounder"—best recoil control due to dual spring and heavier weight, longest barrel for accuracy, but slowest handling. Its magazine cross-compatibility justifies unique extended magazine options.

The **Glock 43X** offers the fastest draw/handling (lightest weight) at the cost of snappier recoil. The Shield Arms S15 magazines provide a meaningful capacity upgrade path.

The **Springfield Hellcat** balances capacity advantage (11+1 base) against the shortest barrel and fastest damage falloff. The standoff device could justify a unique close-quarters accuracy bonus.

The **Taurus GX4** should be positioned as the "budget pick"—slightly slower trigger response (heavier pull modeled as reduced fire rate ceiling) but otherwise competitive. Consider implementing it as a lower-tier unlock with stats 5-10% below the premium options.