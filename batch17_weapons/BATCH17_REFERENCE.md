# Batch 17: AR Pistols & Short Barrel Rifles - FiveM Weapon Meta Reference

## Overview

Batch 17 concludes Phase 3 (SMGs) with three AR-15 short barrel variants in 5.56 NATO. These weapons represent the extreme compact end of the rifle spectrum, trading significant ballistic performance for portability. All three operate below the **2,700 fps fragmentation threshold** that gives 5.56 its devastating terminal effectiveness, resulting in reduced damage compared to full-length rifles.

**Caliber:** 5.56x45mm NATO (all weapons)
**Baseline Reference:** 16" rifle = 42 damage
**Key Theme:** Compact rifle power with meaningful tradeoffs

---

## Quick Reference Table

| Weapon | Configuration | Barrel | Damage | Fire Mode | Recoil | Accuracy | Range | Role |
|--------|---------------|--------|--------|-----------|--------|----------|-------|------|
| Mk18 CQBR | Military spec | 10.3" | 32 | Semi | 0.26 | 1.40 | 145m | Professional CQB |
| ARP Bumpstock | Ultra-short + bump | 7.5" | 25 | **Auto** | **0.42** | **3.20** | 90m | Spray chaos |
| Custom SBR | Illegal build | 9" | 29 | Semi | 0.30 | 1.55 | 125m | Street "hot rod" |

---

## 5.56 NATO Barrel Length Ballistics

### The Fragmentation Threshold Problem

The 5.56 NATO cartridge was designed for a 20" barrel, achieving approximately **3,100 fps** with M855 ammunition. Its terminal effectiveness relies on bullet **fragmentation** at impact velocities above **~2,700 fps** - the bullet yaws and breaks apart at the cannelure, creating devastating wound channels.

**Below 2,700 fps, bullets may simply "pencil through" targets** - creating wounds proportional to the .22 caliber diameter rather than fragmentation damage.

| Barrel Length | M855 Velocity | Energy | % of 16" | Fragmentation? |
|---------------|---------------|--------|----------|----------------|
| 20" (M16) | 3,071 fps | 1,300 ft-lbs | 112% | Yes, to ~200 yards |
| 16" (baseline) | 2,900 fps | 1,160 ft-lbs | 100% | Yes, to ~140 yards |
| 14.5" (M4) | 2,800 fps | 1,080 ft-lbs | 93% | Yes, to ~75 yards |
| 11.5" | 2,650 fps | 970 ft-lbs | 84% | Marginal, near-contact |
| **10.3" (Mk18)** | **2,520 fps** | **854 ft-lbs** | **74%** | **No** |
| **9" (Custom)** | **2,350 fps** | **760 ft-lbs** | **65%** | **No** |
| **7.5"** | **2,100 fps** | **607 ft-lbs** | **52%** | **No** |

### Velocity Loss Rate

Velocity loss accelerates dramatically as barrels shorten:
- 20" to 16": ~25-30 fps per inch
- 16" to 11": ~40-50 fps per inch  
- Below 11": **60-80 fps per inch**

---

## Detailed Weapon Profiles

### 1. Mk18 CQBR (WEAPON_MK18)

**The Military Minimum Standard**

The Mk18 Close Quarters Battle Receiver represents SOCOM's minimum acceptable barrel length for 5.56 NATO. Developed by Naval Surface Warfare Center Crane, it serves Navy SEALs, MARSOC, Army Special Forces, and Coast Guard tactical teams. The 10.3" configuration was chosen as the shortest length maintaining a carbine gas system with acceptable reliability.

**Real-World Specifications:**
- Caliber: 5.56x45mm NATO
- Barrel: 10.3" (262mm), 1:7 twist, chrome-lined
- Weight: 5.9-6.5 lbs depending on configuration
- Overall Length: 26.75" (stock collapsed)
- Muzzle Velocity: ~2,489-2,550 fps (M855)
- Muzzle Energy: ~854 ft-lbs
- Gas System: Carbine-length, 0.070" port (enlarged)
- Fire Control: Semi-automatic (civilian clone)
- Magazine: 30 round STANAG
- MSRP: $2,099-2,199 (Daniel Defense civilian clone)

**Technical Features:**
- Enlarged gas port (0.070" vs standard 0.062")
- One-piece McFarland gas ring
- 5-coil extractor spring for reliability
- RIS II rail system

**Game Statistics:**
- Damage: 32 (74% of 42 baseline)
- Falloff: 35-110m, 0.32 modifier
- Accuracy Spread: 1.40
- Recoil: 0.26 (elevated - over-gassed)
- Fire Rate: 0.100s TBS (semi-auto)
- ADS Time: 0.30s
- Effective Range: 145m

**Unique Characteristics:**
- Military-proven reliability
- Best accuracy of the three variants
- Moderate muzzle flash (significant but manageable)
- Professional/tactical aesthetic
- Balanced CQB performance

---

### 2. 7.5" AR Pistol with Bumpstock (WEAPON_ARP_BUMPSTOCK)

**Full-Auto Chaos Machine**

The ultimate "spray and pray" configuration combines the shortest practical AR barrel with bump-fire capability. The 7.5" barrel produces muzzle velocity **500+ fps below fragmentation threshold**, severely degrading terminal performance. The bump stock simulates automatic fire at ~650 RPM but destroys any hope of accuracy.

**Configuration:**
- Caliber: 5.56x45mm NATO
- Barrel: 7.5" (190mm), pistol-length gas
- Weight: ~5.0 lbs
- Overall Length: ~24" with brace
- Muzzle Velocity: ~2,100 fps (M855)
- Muzzle Energy: ~607 ft-lbs
- Fire Control: BUMP FIRE (~650 RPM)
- Magazine: 30 round STANAG

**The 7.5" Problem:**
- Velocity 500+ fps below fragmentation threshold
- **EXTREME muzzle flash** - "flashbang effect" with 3-foot fireballs
- Sound levels exceed 175 dB
- Massive concussion affects shooter and bystanders
- Reliability issues (pistol gas timing problems)

**Bump Fire Mechanics:**
Bump stocks use the rifle's recoil to reset the trigger, allowing the shooter's finger to re-engage automatically. This produces effective fire rates of **400-800 RPM** but eliminates any possibility of aimed fire - the entire weapon oscillates during operation.

**Game Statistics:**
- Damage: 25 (52% of 42 baseline)
- Falloff: 20-70m, 0.28 modifier (STEEP)
- Accuracy Spread: 3.20 (WORST)
- Recoil: 0.42 (EXTREME)
- Recoil Recovery: 0.30 (SLOW)
- Fire Rate: 0.092s TBS (~650 RPM auto)
- ADS Time: 0.26s (compact)
- Effective Range: 90m

**Unique Characteristics:**
- **FULL-AUTO** fire (bump stock simulation)
- Lowest damage in batch
- Worst accuracy - pure spray weapon
- Extreme muzzle signature
- Devastating at point-blank, useless at range
- High-risk/high-reward playstyle

---

### 3. 9" SBR Custom Build (WEAPON_SBR9)

**The Street "Hot Rod"**

An illegal civilian-built Short Barrel Rifle representing the underground gunsmith's art. Unregistered (no NFA tax stamp), this custom build features a quality match barrel, tuned adjustable gas block, and upgraded trigger - extracting maximum performance from the 9" configuration.

**Custom Build Specifications:**
- Caliber: 5.56x45mm NATO
- Barrel: 9" match-grade, 1:7 twist, custom
- Weight: ~5.5 lbs (lightweight build)
- Overall Length: ~26" (illegal SBR configuration)
- Muzzle Velocity: ~2,350 fps (M855)
- Muzzle Energy: ~760 ft-lbs
- Gas System: Tuned adjustable gas block
- Fire Control: Semi-automatic (quality trigger)
- Magazine: 30 round STANAG

**Custom Features:**
- Adjustable gas block for optimized cycling
- Match-grade barrel for improved accuracy
- Quality aftermarket trigger
- Lightweight components throughout
- Purpose-built for performance

**Game Statistics:**
- Damage: 29 (65% baseline + custom quality bonus)
- Falloff: 30-95m, 0.30 modifier
- Accuracy Spread: 1.55
- Recoil: 0.30 (high but tuned)
- Fire Rate: 0.095s TBS (semi-auto, quality trigger)
- ADS Time: 0.28s
- Effective Range: 125m

**Unique Characteristics:**
- Illegal status (RP implications)
- Better tuned than stock builds
- Balance between compactness and performance
- Custom "hot rod" aesthetic
- Street/criminal association

---

## Platform Comparison

### Damage Hierarchy

| Weapon | Barrel | Energy | Damage | vs 16" Rifle |
|--------|--------|--------|--------|--------------|
| 16" Rifle (baseline) | 16" | 1,160 ft-lbs | 42 | 100% |
| **Mk18 CQBR** | 10.3" | 854 ft-lbs | **32** | 76% |
| **Custom 9" SBR** | 9" | 760 ft-lbs | **29** | 69% |
| **ARP Bumpstock** | 7.5" | 607 ft-lbs | **25** | 60% |

### Fire Mode Comparison

| Weapon | Fire Mode | RPM | Time to Empty (30rd) | Theoretical DPS |
|--------|-----------|-----|----------------------|-----------------|
| Mk18 CQBR | Semi | ~180 practical | N/A | ~96 |
| **ARP Bumpstock** | **Auto** | **~650** | **2.77s** | **271** |
| Custom 9" SBR | Semi | ~190 practical | N/A | ~92 |

The bump stock configuration has dramatically higher theoretical DPS, but severe accuracy penalties mean most rounds miss beyond point-blank range.

### Accuracy vs Controllability

| Weapon | Accuracy Spread | Recoil | Recovery | Practical Accuracy |
|--------|-----------------|--------|----------|-------------------|
| Mk18 CQBR | 1.40 | 0.26 | 0.48 | Good |
| Custom 9" SBR | 1.55 | 0.30 | 0.45 | Moderate |
| ARP Bumpstock | **3.20** | **0.42** | **0.30** | **Terrible** |

---

## Shots-to-Kill Analysis (100 HP Target)

### Close Range (Full Damage)

| Weapon | Damage | Body Shots | Headshots |
|--------|--------|------------|-----------|
| Mk18 CQBR | 32 | 4 shots | 2 shots |
| Custom 9" SBR | 29 | 4 shots | 2 shots |
| ARP Bumpstock | 25 | 4 shots | 2 shots |

### Maximum Range (With Falloff)

| Weapon | Min Damage | Body Shots | Headshots |
|--------|------------|------------|-----------|
| Mk18 (32 × 0.32) | 10.2 | 10 shots | 4 shots |
| SBR9 (29 × 0.30) | 8.7 | 12 shots | 5 shots |
| ARP Bump (25 × 0.28) | 7.0 | 15 shots | 6 shots |

---

## Comparison to Previous Batches

### vs Full Rifles (Batch 12-14)

| Attribute | 16" 5.56 Rifle | 10.3" Mk18 | Difference |
|-----------|----------------|------------|------------|
| Damage | 42 | 32 | -24% |
| Effective Range | 200m | 145m | -28% |
| Accuracy | 1.0 | 1.40 | -40% |
| Recoil | 0.18 | 0.26 | +44% |
| ADS Time | 0.38s | 0.30s | +21% faster |

**Trade-off Summary:** AR pistols sacrifice ~25% damage and ~30% range for ~20% faster handling.

### vs SMGs (Batch 15-16)

| Attribute | MP5K (9mm) | Mk18 (5.56) | Advantage |
|-----------|------------|-------------|-----------|
| Damage | 37 | 32 | MP5K +16% |
| Fire Rate | 900 RPM auto | Semi-only | MP5K |
| Accuracy | 1.20 | 1.40 | MP5K +14% |
| Recoil | 0.14 | 0.26 | MP5K -46% |
| Range | 80m | 145m | Mk18 +81% |
| Penetration | 0.25 | 0.42 | Mk18 +68% |

**Role Differentiation:** 
- SMGs excel at CQB with controllability and fire rate
- AR pistols offer extended range and penetration at accuracy/recoil cost

---

## Muzzle Signature Effects

Short 5.56 barrels produce dramatic muzzle signatures due to unburned powder:

| Configuration | Flash Size | Sound Level | Game Effect |
|---------------|------------|-------------|-------------|
| 16" + flash hider | Moderate | ~165 dB | Standard |
| 10.3" Mk18 | Large fireball | ~170 dB | High flash |
| 9" Custom | Very large | ~172 dB | Very high flash |
| 7.5" Bumpstock | **EXTREME** | **~175+ dB** | **Blinding flash** |

Consider implementing visual muzzle flash effects that scale with barrel length - the 7.5" should produce a distinctive "flashbang" signature that reveals shooter position.

---

## Ammunition

All weapons share 5.56x45mm NATO ammunition.

### 5.56 Ammunition Types

| Type | Damage Mod | Armor Pen | Velocity | Notes |
|------|------------|-----------|----------|-------|
| M193 (55gr FMJ) | 1.0x | 0.35 | Highest | Better fragmentation potential |
| M855 (62gr SS109) | 0.95x | 0.42 | Standard | Steel penetrator, barrier blind |
| Mk262 (77gr OTM) | 1.10x | 0.32 | Lower | Match accuracy, terminal expansion |
| M855A1 (62gr EPR) | 1.05x | 0.50 | Standard | Enhanced penetration + terminal |

**Short Barrel Consideration:** M193's higher velocity makes it slightly better from short barrels, though still below fragmentation threshold.

---

## Stat Rankings (Updated with Batch 17)

### Damage (5.56 Platforms Only)

| Rank | Weapon | Barrel | Damage |
|------|--------|--------|--------|
| 1 | Full 5.56 Rifle | 16" | 42 |
| 2 | **Mk18 CQBR** | 10.3" | **32** |
| 3 | **Custom 9" SBR** | 9" | **29** |
| 4 | **ARP Bumpstock** | 7.5" | **25** |

### Recoil (Short Barrel 5.56)

| Rank | Weapon | Recoil | Notes |
|------|--------|--------|-------|
| 1 | Mk18 CQBR | 0.26 | Military spec |
| 2 | Custom 9" SBR | 0.30 | Tuned gas |
| 3 | **ARP Bumpstock** | **0.42** | Uncontrollable |

### Accuracy (Short Barrel 5.56)

| Rank | Weapon | Spread | Notes |
|------|--------|--------|-------|
| 1 | Mk18 CQBR | 1.40 | Best short-barrel accuracy |
| 2 | Custom 9" SBR | 1.55 | Custom barrel helps |
| 3 | **ARP Bumpstock** | **3.20** | Bump fire destroys accuracy |

---

## Role Recommendations

### Mk18 CQBR
**Best For:** Professional tactical operations, balanced CQB performance, reliable semi-auto fire
**Avoid For:** Long-range engagements, situations requiring maximum stopping power

### ARP Bumpstock  
**Best For:** Ambush attacks, room clearing, suppressive fire, chaos
**Avoid For:** Any engagement beyond 20 meters, accuracy-dependent situations

### Custom 9" SBR
**Best For:** Criminal roleplay, street operations, concealed carry rifle power
**Avoid For:** Professional/military roleplay, maximum performance needs

---

## Installation

1. Extract each weapon folder to your server's `resources` directory
2. Add 3D model files (.ydr, .ytd) to each weapon's `stream/` folder
3. Add to `server.cfg`:
```
ensure weapon_mk18
ensure weapon_arp_bumpstock
ensure weapon_sbr9
```
4. Register weapons with ox_inventory or your inventory system
5. Use existing 5.56 NATO ammunition items

---

## Legal/RP Notes

For roleplay servers, consider these distinctions:
- **Mk18 CQBR:** Legal civilian clone (semi-auto, pistol brace) or restricted military weapon
- **ARP Bumpstock:** Bump stocks federally banned 2019-2024, legal status complex after Supreme Court ruling
- **Custom 9" SBR:** Illegal without NFA registration - possession is federal felony

---

## Version History

- **v1.0.0** - Initial release with 3 AR pistol/SBR variants
  - Mk18 CQBR (military 10.3" spec)
  - 7.5" AR Pistol with Bumpstock (full-auto chaos)
  - 9" SBR Custom Build (illegal street build)
