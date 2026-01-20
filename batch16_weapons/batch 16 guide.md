# Batch 16 SMG specifications: MAC-10 and MAC-4A1 in .45 ACP

The Ingram MAC-10 delivers devastating .45 ACP firepower at an extraordinary **1,090 RPM cyclic rate** from a compact 5.75" barrel—producing approximately **405 ft-lbs of muzzle energy**—while remaining notoriously difficult to control without extensive training or aftermarket modifications. For FiveM implementation, the MAC-10 should serve as a high-damage/high-recoil "spray and pray" option, while the hypothetical MAC-4A1 with Lage-style slow-fire upper offers a controlled **~650-750 RPM** alternative with identical stopping power but superior accuracy. Based on the user-provided baselines (9mm pistol = 34, .45 pistol = 38), both platforms warrant **40-42 damage** values to reflect the velocity gains from SMG barrel lengths.

---

## Gordon Ingram's revolutionary compact killer

Gordon Bailey Ingram designed the Model 10 in 1964 while working at Erquiaga Arms Company, creating what would become the defining "machine pistol" of the late 20th century. The weapon emerged from a straightforward design philosophy: maximum firepower in minimum package for covert operations and close-quarters combat. Military Armament Corporation officially formed in December 1970 when Sionics reorganized, pairing Ingram's compact firearm with Mitchell WerBell III's legendary two-stage suppressor as an integrated weapons system.

Despite generating enormous interest from special operations units worldwide, the MAC-10 saw limited military adoption for one damning reason: its **~1,090 RPM cyclic rate** empties a 30-round magazine in under 1.7 seconds, making controlled fire nearly impossible without the suppressor serving as a forward grip. David Steele, a 1970s IACP weapons researcher, famously described the MAC series as "fit only for combat in a phone booth." The British SAS evaluated the MAC-10 for the 1980 Iranian Embassy siege but selected the MP5 instead—a pattern repeated by military organizations globally.

Production passed through multiple manufacturers after MAC's 1975 bankruptcy: RPB Industries (1976-1982), SWD Inc./Cobray (1982-1994), Texas Military Armament Corporation (1980-1993), and currently Masterpiece Arms, which produces significantly improved semi-automatic clones with CNC machining and eliminated trigger slap. Transferable pre-1986 machine guns command **$3,000-$6,000+** on the collector market, while new MPA semi-autos retail for $400-$550.

---

## MAC-10 technical specifications for weapon meta

The MAC-10's dimensions and operating characteristics directly inform game implementation parameters:

| Specification | Value | Implementation Note |
|---------------|-------|---------------------|
| **Barrel length** | 5.75" (146mm) | Shorter than most SMGs |
| **Overall length (stock collapsed)** | 11.6" (295mm) | Extremely compact |
| **Overall length (stock extended)** | 21.6" (548mm) | Proper shouldering |
| **Weight (empty)** | 6.26 lbs (2.84 kg) | Light for SMG class |
| **Weight (loaded, 30-rd)** | ~7.7 lbs (3.5 kg) | Combat configuration |
| **Cyclic rate (.45 ACP)** | ~1,090 RPM | Empties mag in 1.65 seconds |
| **Magazine capacity** | 30 rounds | M3 Grease Gun compatible |
| **Muzzle velocity** | ~900 fps | With 230gr FMJ |
| **Effective range** | 50 meters | Limited by crude sights |

The extraordinarily high cyclic rate results from three factors: minimal bolt mass, extremely short bolt travel within the compact receiver, and simple blowback operation with no locking delay. The 9mm variant cycles even faster at **~1,200-1,250 RPM**, making the .45 ACP version marginally more controllable despite heavier recoil per shot.

**Sighting is primitive**—fixed blade front and pinhole rear aperture welded directly to the stamped steel receiver, producing a sight radius under 6 inches. The wire folding stock offers minimal cheek weld and requires deliberate manipulation to deploy. Without the Sionics suppressor (11.44" long, 1.2 lbs) providing a forward grip point, sustained automatic fire produces severe muzzle climb that defeats any attempt at accurate target engagement beyond contact distance.

---

## Lage Manufacturing transforms the platform

Lage Manufacturing's MAX-10 series upper receivers represent the definitive modernization path for registered MAC-10 machine guns, converting an uncontrollable bullet hose into a competitive submachine gun.

The **MAX-10/45 mk2** upper ($985) reduces cyclic rate from ~1,000 RPM to approximately **750 RPM**—a 25-30% reduction achieved through heavier bolt assemblies with extended travel. This allows controllable 2-3 round bursts and makes single-shot trigger manipulation practical. The 9mm **MAX-10/9 mk2** achieves similar results, dropping from ~1,100 RPM to ~750 RPM. The **MAX-10/31k** variant with Variable Buffer System achieves even lower rates: **~631 RPM** base configuration, adjustable up to ~820 RPM with spacers.

Key modernization features across Lage uppers include:

- **Extended barrels**: 8.5" (9mm) or 9" (.45 ACP) threaded for modern suppressors
- **Full-length Picatinny rail**: 11.75" to 14.25" depending on model
- **Aluminum construction**: 6061-T6 with hard coat anodize, saving ~1 lb 5 oz over original steel Mk1 uppers
- **Side charging handle**: Non-reciprocating, left-side mounted
- **Multiple thread options**: 1/2-28 and 5/8-24 modern patterns alongside legacy MAC threads

Richard Lage won the 2004 Arizona State Subgun Match using his products, demonstrating that upgraded MACs can compete with Uzis and MP5s in practical shooting competitions. The longer bolt travel and reduced cyclic rate dramatically decrease muzzle rise, while the extended sight radius and optic-ready rails enable actual precision shooting.

---

## Hypothetical MAC-4A1 configuration

Based on available aftermarket components, a realistic "modernized tactical MAC" specification emerges:

| Attribute | MAC-4A1 Specification | Rationale |
|-----------|----------------------|-----------|
| **Caliber** | .45 ACP | Maintains subsonic suppression advantage |
| **Barrel length** | 8-9" threaded (5/8-24) | Lage MAX-10/45 mk2 standard |
| **Cyclic rate** | ~650-750 RPM | Slow-fire upper; controllable bursts |
| **Overall length (collapsed)** | ~15" | Compact for CQB |
| **Overall length (extended)** | ~22" | Proper stock deployment |
| **Weight (empty)** | ~5.5 lbs | Aluminum upper advantage |
| **Weight (loaded)** | ~6.4 lbs | 30-round magazine |
| **Rail system** | 12"+ top Picatinny, 3" bottom, optional sides | Full accessory compatibility |
| **Stock** | Side-folding polymer | Folds left to clear extended upper |

Combat-ready weight with micro red dot, compact suppressor, and weapon light reaches approximately **7.5 lbs**—heavier than stock but delivering a controllable, accurate platform suitable for professional use rather than panic room-clearing.

---

## .45 ACP velocity gains from SMG barrels

The .45 ACP cartridge exhibits moderate velocity gains from extended barrels, with diminishing returns appearing earlier than 9mm:

| Barrel Length | Velocity (230gr FMJ) | Energy | % of Maximum |
|---------------|---------------------|--------|--------------|
| 4" (pistol baseline) | ~830 fps | 352 ft-lbs | 76% |
| 5" (Government 1911) | ~860 fps | 378 ft-lbs | 82% |
| **5.75" (MAC-10)** | **~890 fps** | **405 ft-lbs** | **87%** |
| 8" (M3 Grease Gun) | ~920 fps | 432 ft-lbs | 93% |
| 10-11" | ~950 fps | 461 ft-lbs | 99% |
| 14-15" (maximum) | ~989 fps | 500 ft-lbs | 100% |
| 16" (carbine) | ~960 fps | 471 ft-lbs | 94% |

**Critical finding**: .45 ACP reaches maximum velocity around 14-15" barrel length, after which bore friction exceeds remaining gas pressure and velocity actually decreases. The practical SMG sweet spot falls between **8-10 inches**, achieving 93-99% of maximum velocity with optimal handling characteristics. The MAC-10's 5.75" barrel captures 87% of maximum potential—a reasonable compromise for extreme compactness.

Velocity gain per inch follows a declining curve: approximately **30-35 fps/inch** from 3-5", dropping to **15-25 fps/inch** from 5-10", then collapsing to **5-10 fps/inch** beyond 10 inches. This behavior differs markedly from 9mm, which continues gaining velocity to longer barrel lengths.

---

## .45 ACP versus 9mm from SMG platforms

The caliber comparison reveals important trade-offs for game balance:

| Parameter | .45 ACP 230gr (8" barrel) | 9mm 124gr (8" barrel) |
|-----------|--------------------------|----------------------|
| **Velocity** | 920 fps | 1,280 fps |
| **Energy** | 432 ft-lbs | 451 ft-lbs |
| **Momentum** | 0.925 lb-s | 0.621 lb-s |
| **Supersonic?** | No (always subsonic) | Yes (sonic crack) |
| **Projectile diameter** | .452" | .355" |
| **Recoil energy** | ~3.5 ft-lbs | ~1.7 ft-lbs |

The 9mm achieves marginally higher energy at SMG velocities, but .45 ACP delivers **49% more momentum**—the physics underlying its reputation for "stopping power." The .452" diameter creates a **27% larger wound channel** even without expansion. Most critically for suppressed applications, standard .45 ACP loads remain **permanently subsonic**, eliminating the supersonic crack that reveals shooter position regardless of suppressor quality.

Energy retention at distance favors the faster 9mm for trajectory, but .45 ACP maintains 73% of muzzle energy at 100 yards (303 ft-lbs)—sufficient for lethal effect well beyond typical SMG engagement ranges. The 100-yard drop of **16.4 inches** versus 9mm's 9.3 inches reflects the subsonic ballistic penalty.

---

## Damage scaling for FiveM implementation

Using the provided baselines (9mm pistol = 34, .45 ACP pistol = 38), energy-based scaling yields MAC platform damage values:

### Calculation methodology

The .45 ACP pistol baseline (38 damage) assumes approximately 352 ft-lbs from a 4" barrel. The MAC-10's 5.75" barrel produces ~405 ft-lbs—a **15% energy increase**. Applying this modifier:

**MAC-10 damage = 38 × 1.15 = ~44 damage** (theoretical maximum)

However, game balance considerations warrant adjustment. Comparing to the stated 9mm SMG range (36-43 damage) and accounting for the MAC-10's severe accuracy penalties, a **40-42 damage** value maintains appropriate role differentiation:

| Weapon | Barrel | Recommended Damage | Fire Rate | Role |
|--------|--------|-------------------|-----------|------|
| **MAC-10** | 5.75" | **40** | 1,100 RPM | CQB spray, high risk/reward |
| **MAC-4A1** | 8-9" | **42** | 650-700 RPM | Controlled tactical, accuracy focus |
| 9mm SMG (MP5 type) | 8-9" | 38-40 | 800 RPM | Balanced baseline |

The MAC-4A1's longer barrel justifies slightly higher damage (42) despite identical caliber, reflecting the ~6% energy gain from 5.75" to 8-9" barrel length.

---

## Game balance implementation parameters

The MAC-10 and MAC-4A1 occupy distinct gameplay niches despite shared caliber:

### MAC-10: Spray-and-pray archetype

```
Damage: 40
Fire Rate: 1,100 RPM (TimeBetweenShots: 0.0545)
Magazine: 30 rounds
AccuracySpread: 4.5 (very poor)
RecoilAccuracyMax: 2.5 (severe bloom)
RecoilRecoveryRate: 0.6 (slow)
RecoilShakeAmplitude: 0.35 (heavy camera shake)
Effective Range: 80m (damage drops to 25% at max)
```

The MAC-10 delivers **theoretical DPS of ~733** (40 damage × 18.3 rounds/second), but severe accuracy penalties ensure actual damage output plummets beyond 15-20 meters. This creates a high-risk weapon devastating in ambush scenarios but wasteful of ammunition at any distance. The criminal/action movie aesthetic pairs naturally with drive-by capability.

### MAC-4A1: Controlled professional upgrade

```
Damage: 42
Fire Rate: 650 RPM (TimeBetweenShots: 0.0923)
Magazine: 30 rounds
AccuracySpread: 2.5 (good)
RecoilAccuracyMax: 1.2 (moderate bloom)
RecoilRecoveryRate: 0.9 (fast)
RecoilShakeAmplitude: 0.2 (manageable)
Effective Range: 100m (damage drops to 35% at max)
```

The MAC-4A1's **theoretical DPS of ~455** falls below the MAC-10, but consistent hit probability at medium range delivers superior practical damage. The weapon rewards trigger discipline and aimed fire—the tactical professional's choice over the gangster's room-clearer.

---

## Conclusion: Differentiating two faces of the same platform

The MAC-10 and MAC-4A1 represent opposite philosophies applied to identical ballistics. The original Ingram design prioritized compactness and suppressed firepower for covert operations, accepting accuracy limitations that proved fatal to military adoption. Lage Manufacturing's slow-fire uppers rehabilitate the platform for practical competition use, demonstrating that the fundamental design can perform when cyclic rate drops to controllable levels.

For FiveM implementation, this creates natural gameplay tension: the MAC-10's **1,100 RPM** cyclic rate and **40 damage** per round generate extraordinary close-range lethality offset by punishing recoil and accuracy penalties that make medium-range engagement genuinely difficult. The MAC-4A1's **650-700 RPM** rate with **42 damage** sacrifices burst potential for consistency, rewarding players who maintain accuracy under fire rather than relying on volume.

Both weapons share the .45 ACP's permanent subsonic advantage for suppressed operations and the characteristic **30-round magazine** that empties disturbingly fast in automatic fire. The key differentiator isn't damage—it's controllability, creating distinct roles without arbitrary stat manipulation. The stock MAC-10 belongs to action movies and panic situations; the MAC-4A1 belongs to professionals who transformed a flawed classic into a functional tool.