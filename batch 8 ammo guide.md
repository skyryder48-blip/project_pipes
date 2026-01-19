# Batch 8 rimfire pistol specifications for FiveM weapon meta

Three rimfire pistols span the tactical .22 spectrum from budget trainer to high-capacity magnum, with the **Walther P22** offering 10-round capacity at $329, the **FN 502 Tactical** delivering premium optics-ready features with 15 rounds at $559, and the **Kel-Tec PMR-30** dominating with 30 rounds of .22 WMR at $480. The critical distinction: two fire .22 LR generating **80-115 ft-lbs** from pistol barrels, while the PMR-30's .22 WMR produces **140-170 ft-lbs**—roughly 70% more energy. For FiveM implementation, the PMR-30 should deal approximately 1.5-1.7× the damage of the .22 LR pistols despite similar physical dimensions.

**Important correction:** The "SIG Sauer P22" does not exist—this firearm is the **Walther P22**, manufactured by Carl Walther GmbH. SIG Sauer produces the separate P322 model.

## Walther P22 delivers entry-level training at budget pricing

The Walther P22/P22Q represents the budget end of tactical rimfire pistols, using cost-effective construction to achieve a $329 MSRP. The standard **3.42-inch barrel** model measures 6.3-6.5 inches overall, weighs **16 oz empty** (~19.6 oz loaded), while the **5-inch target** variant extends to 7.83 inches and 17 oz. Both variants share identical 10-round single-stack magazines.

| Specification | Standard (3.42") | Target (5") |
|--------------|------------------|-------------|
| Overall length | 6.3-6.5" | 7.83" |
| Weight empty | 16 oz | 17 oz |
| Sight radius | ~4.8" | ~6.3" |
| Muzzle velocity (Mini-Mag) | 967 fps | ~1,100 fps |
| Muzzle energy | 85-100 ft-lbs | 95-115 ft-lbs |

Construction utilizes a **Zamak (zinc alloy) slide** over a polymer frame with steel barrel. The zinc slide choice enables cost reduction and appropriate mass for blowback operation with low-powered .22 LR, though durability concerns exist—slide cracking reports begin around 4,000-10,000 rounds. The **DA/SA trigger** pulls 11-12 lbs in double-action, dropping to 4-5 lbs single-action.

**Ammunition sensitivity** defines the P22's operational parameters. CCI Mini-Mag 40gr functions as the benchmark reliable load (967 fps actual). High-velocity ammunition (1,200+ fps advertised) cycles best. Standard velocity and subsonic loads typically fail to cycle reliably. Safety features include ambidextrous manual safety/decocker, magazine disconnect, and loaded chamber indicator.

## FN 502 Tactical commands premium pricing for optics-ready capability

FN's flagship rimfire positions itself as the tactical training companion to centerfire FN pistols, featuring the longest barrel (**4.6 inches threaded** at 1/2×28) and highest capacity among .22 LR tactical pistols at launch with **15+1 rounds**. Overall dimensions measure 7.6 inches long, 5.8 inches tall with suppressor-height sights, weighing **23.7 oz empty** (~26 oz loaded).

The optics-ready slide-mount system accepts RMR, Shield RMS, Docter, and Vortex Venom footprints via three included polymer adapter plates. Factory **suppressor-height polymer sights** provide co-witness capability, though reviewers note they appear designed primarily for optic use rather than iron-sight precision.

| Metric | FN 502 Tactical |
|--------|-----------------|
| Barrel | 4.6" threaded (1/2×28), cold-hammer-forged steel |
| Trigger | SAO, 3-5 lbs (tested 3 lbs 2 oz to 4 lbs) |
| Velocity (CCI Mini-Mag) | ~1,100-1,150 fps |
| Velocity (CCI Stinger) | ~1,300-1,350 fps |
| Muzzle energy | 100-130 ft-lbs |
| Accuracy | 1.17" best group, 2.7" average at 25 yards |
| MSRP | $559 |

Despite premium pricing, the FN 502 uses **zinc alloy components** in its slide construction—similar to budget competitors. FN's website notes restrictions in states limiting "materials with low melting points such as zinc alloy." The quality advantage comes from superior machining, fit/finish, and the cold-hammer-forged barrel rather than fundamentally different materials. Manufactured by Umarex in Germany for FN America, it represents their highest-quality rimfire offering.

Reliability proves excellent with high-velocity ammunition. The manual explicitly states **subsonic ammunition is NOT recommended**—expect cycling failures. Suppressed shooting accelerates fouling, requiring cleaning every 300-400 rounds.

## Kel-Tec PMR-30 achieves extreme capacity through .22 WMR chambering

The PMR-30 dominates rimfire capacity with **30+1 rounds** in a package weighing just **13.6-14 oz empty**—lighter than most compact 9mm pistols despite triple their capacity. This extreme weight reduction comes from hybrid construction: glass-reinforced nylon (Zytel) frame, **7075 aluminum receiver core**, and 4140 steel slide with polymer cover. Only the barrel and critical internal components use steel.

| Specification | Value |
|---------------|-------|
| Barrel | 4.3", 4140 steel, 1:11" twist, fluted |
| Overall length | 7.9" |
| Height | 5.8" |
| Weight empty | 13.6-14 oz |
| Weight loaded (31 rounds) | ~20 oz |
| Magazine | 30-round double-stack, Zytel polymer body |

The PMR-30 employs an innovative **hybrid blowback/locked-breech action** that self-adjusts to cartridge pressure. High-pressure loads cause brief barrel recoil with the slide (locked-breech behavior), while lower-pressure loads allow pure blowback operation. This eliminates the need for chamber fluting found in other .22 WMR designs.

**Fiber optic sights** feature a green front dot with dual red/orange rear dots, adjustable for windage. The slide comes pre-drilled for red dot mounting. The single-action trigger breaks at **3-5 lbs** with a crisp break but mushy reset.

**Muzzle flash is substantial**—one of the most notable characteristics. The .22 WMR's slow-burning rifle powder doesn't fully combust in the 4.3-inch barrel, creating visible fireballs as unburned powder ignites outside the muzzle. Kel-Tec offers an optional 5-inch threaded barrel with flash hider ($118) to address this.

| Load | Velocity | Energy |
|------|----------|--------|
| CCI Maxi-Mag 40gr JHP | 1,257-1,440 fps | 140-154 ft-lbs |
| Winchester 30gr JHP | 1,497 fps | 149 ft-lbs |
| Winchester FMJ 40gr | 1,317 fps | 154 ft-lbs |
| Hornady Critical Defense 45gr | ~1,000-1,231 fps | ~100-151 ft-lbs |

MSRP sits at **$479.99** with street prices around $320-400. Best reliability comes from high-quality American-made brass-cased ammunition in 40-grain weights—CCI Maxi-Mag and Winchester Super-X perform best. A 100-200 round break-in period improves function.

## .22 LR ballistics from pistol barrels differ dramatically from advertised specifications

Advertised .22 LR velocities come from **rifle-length barrels** (16-24 inches). From typical 4-inch pistol barrels, expect velocities **200-400 fps lower** than box claims. This fundamentally changes energy calculations for game development.

**Velocity by category from 4-inch barrel:**

| Category | Advertised (rifle) | Actual (4" pistol) | Energy |
|----------|-------------------|-------------------|--------|
| Subsonic | 950-1,050 fps | 700-950 fps | 50-80 ft-lbs |
| Standard | 1,070-1,235 fps | 900-1,020 fps | 80-95 ft-lbs |
| High velocity | 1,280-1,435 fps | 1,050-1,150 fps | 95-115 ft-lbs |
| Hyper velocity | 1,500-1,700 fps | 1,150-1,300 fps | 100-115 ft-lbs |

**Critical finding:** Light hyper-velocity bullets (29-32gr) don't outperform heavier 40gr high-velocity loads from pistol barrels. The **CCI Velocitor 40gr** (1,120 fps, 111 ft-lbs from 4" barrel) often exceeds the CCI Stinger 32gr (1,191 fps, 100 ft-lbs) in total energy despite lower velocity.

**Gel test results reveal hollow points rarely expand from pistol barrels.** Lucky Gunner testing through 4-layer denim from a 4.4-inch Ruger Mark IV showed only CCI Stinger expanding (0.322" from 0.22" original) while penetrating 9.62 inches. The CCI Velocitor achieved zero expansion but penetrated **15.58 inches**—meeting FBI's 12-18 inch standard.

| Load | Velocity | Penetration | Expansion |
|------|----------|-------------|-----------|
| CCI Stinger 32gr | 1,160 fps | 9.62" | 0.322" (expanded) |
| CCI Velocitor 40gr | 1,050 fps | 15.58" | None |
| CCI Mini-Mag 40gr | 1,017 fps | 12.4" | None |
| Federal Punch 29gr | 1,329 fps | 16-18" | None |

For FiveM implementation, model .22 LR pistol damage around **80-115 ft-lbs** effective energy with good penetration but minimal expansion effects.

## .22 WMR delivers 2× the energy but loses significant velocity from short barrels

The .22 Winchester Magnum Rimfire generates **substantially more power** than .22 LR, but advertised velocities assume 24-inch rifle barrels. From the PMR-30's 4.3-inch barrel, expect **400-600 fps velocity loss** (20-30% reduction).

**Velocity comparison by barrel length:**

| Barrel | CCI Maxi-Mag 40gr | 30gr V-Max |
|--------|-------------------|------------|
| 24" rifle | ~2,000 fps | ~2,350 fps |
| 18" rifle | 1,985 fps | 2,322 fps |
| 5" pistol | 1,474 fps | 1,723 fps |
| 4" pistol | 1,353 fps | 1,504 fps |
| 2" snubby | 946 fps | 1,085 fps |

**Energy comparison to .22 LR (40gr loads):**

| Metric | .22 LR | .22 WMR | Difference |
|--------|--------|---------|------------|
| Rifle muzzle velocity | 1,240 fps | 1,950 fps | +57% |
| Pistol (4") velocity | 1,014 fps | 1,350 fps | +33% |
| Rifle muzzle energy | 135 ft-lbs | 312 ft-lbs | **+131% (2.3×)** |
| Pistol (4") energy | 92 ft-lbs | 162 ft-lbs | **+76%** |
| Cost per round | $0.06-0.12 | $0.17-0.37 | ~3× more |

**Terminal ballistics differ significantly.** Standard .22 WMR hunting loads (CCI Maxi-Mag) achieve excellent 16.5-inch penetration but **fail to expand** from pistol-length barrels—insufficient velocity for reliable jacket separation. Purpose-built defensive loads perform better:

| Load | Velocity (4.3") | Penetration | Expansion |
|------|-----------------|-------------|-----------|
| CCI Maxi-Mag 40gr JHP | 1,313 fps | 16.54" | None |
| Speer Gold Dot 40gr | 1,312 fps | 14.72" | 0.418" (excellent) |
| Hornady Critical Defense 45gr | 1,231 fps | 13.62" | 0.402" (good) |

**Muzzle flash and noise increase dramatically.** The .22 WMR produces significant fireballs from short barrels as unburned rifle powder ignites outside the muzzle. Subjective noise levels approach .380 ACP—approximately 50% louder than .22 LR. Hornady Critical Defense uses low-flash powder to mitigate these effects.

## Comparative analysis supports differentiated game implementation

For accurate FiveM weapon meta, the three pistols occupy distinct niches with measurable performance differences:

**Damage scaling recommendations:**
- Walther P22 (3.4"): Base rimfire damage (~90 ft-lbs reference)
- Walther P22 (5"): 1.1× base damage (~100 ft-lbs)
- FN 502 Tactical: 1.15× base damage (~105 ft-lbs)
- Kel-Tec PMR-30: **1.6-1.7× base damage** (~155 ft-lbs)

| Attribute | Walther P22 | FN 502 Tactical | Kel-Tec PMR-30 |
|-----------|-------------|-----------------|----------------|
| Caliber | .22 LR | .22 LR | .22 WMR |
| Capacity | 10+1 | 15+1 | 30+1 |
| Weight empty | 16 oz | 23.7 oz | 14 oz |
| Barrel | 3.42"/5" | 4.6" | 4.3" |
| Velocity | 967/~1,100 fps | ~1,100 fps | ~1,350 fps |
| Energy | 85-100 ft-lbs | 100-110 ft-lbs | 150-165 ft-lbs |
| Trigger DA/SA | 11 lbs / 5 lbs | 3-5 lbs SAO | 3-5 lbs SAO |
| MSRP | $329 | $559 | $480 |
| Suppressor ready | Yes (adapter) | Yes (threaded) | Optional barrel |
| Optics ready | No | Yes | Yes |

**Recoil remains negligible across all three**—fastest follow-up shots of any caliber category. Model minimal muzzle rise with essentially instant sight recovery.

**Suppression characteristics differ markedly.** The .22 LR pistols excel as suppressor hosts with readily available subsonic ammunition. The PMR-30's .22 WMR remains supersonic even with heavy loads, limiting suppression effectiveness—plus the cartridge's muzzle flash persists even when suppressed.

**Reliability hierarchy:** FN 502 > PMR-30 > P22. The FN 502 offers best-in-class semi-auto reliability with high-velocity ammunition. The PMR-30 requires break-in and quality ammunition but proves reliable thereafter. The P22 shows higher sensitivity to ammunition quality and has documented durability concerns with the zinc slide.

## Conclusion

These three rimfire pistols span the training-to-tactical spectrum with distinct characteristics suitable for differentiated FiveM implementation. The **Walther P22** serves as an economical entry point with DA/SA operation and 10-round capacity, best modeled with lower damage and potential reliability mechanics. The **FN 502 Tactical** justifies premium positioning through optics-ready capability, 15-round capacity, and superior trigger—representing the refined .22 LR option with slightly higher damage potential from its longer barrel. The **Kel-Tec PMR-30** breaks from the group entirely with .22 WMR chambering delivering **70% more energy** and triple the capacity at just 14 ounces, though with pronounced muzzle flash that should be visually represented.

For ammunition modeling, the critical insight is that pistol barrel velocities run **20-35% below** advertised rifle specifications. Hollow points rarely expand from short barrels regardless of caliber—penetration rather than expansion drives terminal effect. The .22 WMR's advantage compounds at range: at 100 yards it retains more energy than .22 LR possesses at the muzzle.