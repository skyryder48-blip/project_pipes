# Batch Weapon Fix Template

This document outlines the 8 known structural issues and enhancement recommendations for fixing all weapon batches in the project.

---

## Part 1: Structural XML Fixes (Required for Weapons to Function)

These 8 issues must be fixed for weapons to be pullable from inventory and function properly.

### Issue 1: Root Name Tag
**Problem:** Using `<n>` instead of `<Name>` for weapon name
```xml
<!-- WRONG -->
<n>WEAPON_G26</n>

<!-- CORRECT -->
<Name>WEAPON_G26</Name>
```

### Issue 2: Component Name Tags
**Problem:** Using `<n>` instead of `<Name>` for component references
```xml
<!-- WRONG -->
<Item>
  <n>COMPONENT_G26_CLIP_FMJ</n>
</Item>

<!-- CORRECT -->
<Item>
  <Name>COMPONENT_G26_CLIP_FMJ</Name>
</Item>
```

### Issue 3: Infos Nesting Structure
**Problem:** Extra empty `<Item><Infos /></Item>` blocks creating invalid structure
```xml
<!-- WRONG -->
<Infos>
  <Item>
    <Infos>
      <Item type="CWeaponInfo">
        <!-- weapon data -->
      </Item>
    </Infos>
  </Item>
</Infos>

<!-- CORRECT -->
<Infos>
  <Item type="CWeaponInfo">
    <!-- weapon data -->
  </Item>
</Infos>
```

### Issue 4: Missing Fx Block
**Problem:** Missing effects for muzzle flash, shell ejection, and tracers
```xml
<!-- ADD THIS SECTION -->
<Fx>
  <FlashFx>muz_pistol_fp</FlashFx>
  <FlashFxAlt>muz_pistol</FlashFxAlt>
  <FlashFxFP />
  <FlashFxAltFP />
  <SmokeFx />
  <SmokeFxFP />
  <SmokeFxIsBeingUsed value="false" />
  <TracerFx>proj_tracer_youforyou</TracerFx>
  <TracerFxFP />
  <ShellFx>eject_pistol</ShellFx>
  <ShellFxFP />
  <MuzzleSmokeFx>muz_pistol_smoke</MuzzleSmokeFx>
  <MuzzleSmokeFxFP />
  <MuzzleSmokeFxMinLevel value="0.200000" />
  <MuzzleSmokeFxIncPerShot value="0.050000" />
  <MuzzleSmokeFxDecPerSec value="0.300000" />
  <GroundDisturbFx />
  <GroundDisturbFxAlt />
  <GroundDisturbFxFP />
  <GroundDisturbFxAltFP />
</Fx>
```

### Issue 5: Missing Camera Hashes
**Problem:** No camera definitions for aiming and cover
```xml
<!-- ADD THESE FIELDS -->
<DefaultCameraHash>DEFAULT_THIRD_PERSON_CAMERA</DefaultCameraHash>
<CoverCameraHash>DEFAULT_DVARCAM</CoverCameraHash>
<RunAndGunCameraHash>DEFAULT_RUN_AND_GUN_CAMERA</RunAndGunCameraHash>
<CinematicShootingCameraHash>DEFAULT_DVARCAM</CinematicShootingCameraHash>
<CinematicShootingCameraFPHash>DEFAULT_DVARCAM</CinematicShootingCameraFPHash>
<ZoomedCameraHash />
<PoVCameraHash>DEFAULT_DVARCAM</PoVCameraHash>
<FirstPersonScopeCameraHash />
<FirstPersonScopeGunsightCameraHash />
```

### Issue 6: HumanNameHash Prefix
**Problem:** Using `WT_` prefix instead of `WEAPON_` prefix
```xml
<!-- WRONG -->
<HumanNameHash>WT_G26</HumanNameHash>

<!-- CORRECT -->
<HumanNameHash>WEAPON_G26</HumanNameHash>
```

### Issue 7: PickupHash Reference
**Problem:** Referencing non-existent custom pickups
```xml
<!-- WRONG -->
<PickupHash>PICKUP_WEAPON_G26</PickupHash>

<!-- CORRECT -->
<PickupHash>PICKUP_WEAPON_COMBATPISTOL</PickupHash>
```

### Issue 8: NmShotTuningSet Capitalization
**Problem:** Using lowercase "normal" instead of proper case "Normal"
```xml
<!-- WRONG -->
<NmShotTuningSet>normal</NmShotTuningSet>

<!-- CORRECT -->
<NmShotTuningSet>Normal</NmShotTuningSet>
```

---

## Part 2: Full-Auto Weapon Configuration

For weapons with a "switch" or select-fire capability that should fire full-auto:

```xml
<!-- Set this value to -1.0 to enable full-auto firing -->
<TimeLeftBetweenShotsWhereShouldFireIsCached value="-1.000000" />

<!-- Adjust TimeBetweenShots for desired fire rate (lower = faster) -->
<!-- Example: 0.052 = ~1150 RPM for full-auto pistol -->
<TimeBetweenShots value="0.052000" />
```

---

## Part 3: Weapon Differentiation Enhancements

To make each weapon feel unique based on real-world characteristics, adjust these parameters:

### Parameter Ranges (Compact 9mm Pistols)

| Parameter | Minimum | Maximum | Description |
|-----------|---------|---------|-------------|
| AccuracySpread | 1.35 | 2.40 | Lower = more accurate |
| RecoilShakeAmplitude | 0.14 | 0.42 | Lower = less felt recoil |
| RecoilRecoveryRate | 0.20 | 0.34 | Higher = faster recovery |
| TimeBetweenShots | 0.16 | 0.22 | Lower = faster fire rate |
| DamageFallOffRangeMin | 14.0 | 18.0 | Barrel length affects range |
| DamageFallOffRangeMax | 50.0 | 55.0 | Barrel length affects range |

### Differentiation Guidelines

#### Based on Barrel Length
- **Longer barrel** → Better accuracy, longer damage falloff range
- **Shorter barrel** → Worse accuracy, shorter damage falloff range

#### Based on Trigger Weight
- **Lighter trigger** (4-5 lbs) → Faster TimeBetweenShots (0.16-0.17)
- **Heavier trigger** (6+ lbs) → Slower TimeBetweenShots (0.20-0.22)

#### Based on Build Quality/Price
- **Premium weapons** → Better recoil recovery, lower shake amplitude
- **Budget weapons** → Slower recovery, slightly higher shake

#### Based on Grip Design
- **Aggressive/adaptive grip** → Better recoil recovery rate
- **Standard grip** → Baseline recoil recovery

### Batch 1 Reference Values

| Weapon | Accuracy | Recoil Amp | Recovery | Fire Rate | Notes |
|--------|----------|------------|----------|-----------|-------|
| G26 | 1.35 | 0.14 | 0.34 | 0.185 | Best accuracy, lightest recoil |
| G26 Switch | 2.40 | 0.42 | 0.20 | 0.052 | Full-auto, high recoil |
| G43X | 1.50 | 0.28 | 0.25 | 0.16 | Snappiest, lightest feel |
| GX4 | 1.70 | 0.18 | 0.30 | 0.22 | Budget, heavy trigger |
| Hellcat | 1.90 | 0.195 | 0.31 | 0.17 | Shortest barrel, adaptive grip |

---

## Part 4: Magazine Capacity Guidelines

**Important:** Magazine capacities are limited by available 3D models, not real-world values.

Before setting magazine capacities:
1. Check what magazine models exist for the weapon
2. Use the standard capacity from research documents for the base magazine
3. Only add extended/alternate magazines if 3D models exist

### WeaponComponents.meta Structure

```xml
<CWeaponComponentInfoBlob>
  <Infos>
    <!-- Standard Magazine -->
    <Item type="CWeaponComponentClipInfo">
      <Name>COMPONENT_WEAPONNAME_CLIP_FMJ</Name>
      <Model />
      <LocName>WCT_CLIP_FMJ</LocName>
      <LocDesc>WCD_CLIP_FMJ</LocDesc>
      <ClipSize value="XX" />
      <AmmoInfo ref="AMMO_PISTOL" />
    </Item>

    <!-- Repeat for HP and AP variants -->

    <!-- Extended Magazine (only if mag2 model exists) -->
    <Item type="CWeaponComponentClipInfo">
      <Name>COMPONENT_WEAPONNAME_EXTCLIP_FMJ</Name>
      <Model />
      <LocName>WCT_EXTCLIP_FMJ</LocName>
      <LocDesc>WCD_EXTCLIP_FMJ</LocDesc>
      <ClipSize value="YY" />
      <AmmoInfo ref="AMMO_PISTOL" />
    </Item>
  </Infos>
</CWeaponComponentInfoBlob>
```

---

## Part 5: Fix Checklist

Use this checklist when fixing each weapon:

### Structural Fixes
- [ ] Root `<Name>` tag (not `<n>`)
- [ ] Component `<Name>` tags (not `<n>`)
- [ ] Proper Infos nesting (no extra Item wrappers)
- [ ] Fx block present with all effects
- [ ] Camera hashes defined
- [ ] HumanNameHash uses WEAPON_ prefix
- [ ] PickupHash references existing pickup (PICKUP_WEAPON_COMBATPISTOL)
- [ ] NmShotTuningSet capitalized correctly ("Normal")

### Enhancement Adjustments
- [ ] AccuracySpread adjusted for barrel/quality
- [ ] RecoilShakeAmplitude adjusted for weight/design
- [ ] RecoilRecoveryRate adjusted for grip/quality
- [ ] TimeBetweenShots adjusted for trigger weight
- [ ] DamageFallOffRangeMin/Max adjusted for barrel length
- [ ] ClipSize matches available 3D models

### For Full-Auto Weapons Only
- [ ] TimeLeftBetweenShotsWhereShouldFireIsCached = -1.0
- [ ] TimeBetweenShots adjusted for desired RPM

---

## Reference: Working Weapon Template

Use this as a reference structure when rebuilding weapon files:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CWeaponInfoBlob>
  <Infos>
    <Item type="CWeaponInfo">
      <Name>WEAPON_WEAPONNAME</Name>
      <Model>w_pi_weaponname</Model>
      <Audio>AUDIO_ITEM_WEAPONNAME</Audio>
      <HudDamage value="XX" />
      <HudSpeed value="XX" />
      <HudCapacity value="XX" />
      <HudAccuracy value="XX" />
      <HudRange value="XX" />
      <Slot>YOURSLOT</Slot>
      <DamageType>YOURTYPE</DamageType>
      <FireType>YOURTYPE</FireType>
      <WheelSlot>YOURSLOT</WheelSlot>
      <Group>YOURGROUP</Group>
      <ClipSize value="XX" />
      <AccuracySpread value="X.XX" />
      <RecoilShakeAmplitude value="X.XX" />
      <RecoilRecoveryRate value="X.XX" />
      <TimeBetweenShots value="X.XX" />
      <DamageFallOffRangeMin value="XX.XX" />
      <DamageFallOffRangeMax value="XX.XX" />
      <TimeLeftBetweenShotsWhereShouldFireIsCached value="0.000000" /> <!-- or -1.0 for full-auto -->
      <NmShotTuningSet>Normal</NmShotTuningSet>
      <HumanNameHash>WEAPON_WEAPONNAME</HumanNameHash>
      <PickupHash>PICKUP_WEAPON_COMBATPISTOL</PickupHash>
      <DefaultCameraHash>DEFAULT_THIRD_PERSON_CAMERA</DefaultCameraHash>
      <CoverCameraHash>DEFAULT_DVARCAM</CoverCameraHash>
      <RunAndGunCameraHash>DEFAULT_RUN_AND_GUN_CAMERA</RunAndGunCameraHash>
      <CinematicShootingCameraHash>DEFAULT_DVARCAM</CinematicShootingCameraHash>
      <CinematicShootingCameraFPHash>DEFAULT_DVARCAM</CinematicShootingCameraFPHash>
      <ZoomedCameraHash />
      <PoVCameraHash>DEFAULT_DVARCAM</PoVCameraHash>
      <FirstPersonScopeCameraHash />
      <FirstPersonScopeGunsightCameraHash />
      <Fx>
        <FlashFx>muz_pistol_fp</FlashFx>
        <FlashFxAlt>muz_pistol</FlashFxAlt>
        <FlashFxFP />
        <FlashFxAltFP />
        <SmokeFx />
        <SmokeFxFP />
        <SmokeFxIsBeingUsed value="false" />
        <TracerFx>proj_tracer_youforyou</TracerFx>
        <TracerFxFP />
        <ShellFx>eject_pistol</ShellFx>
        <ShellFxFP />
        <MuzzleSmokeFx>muz_pistol_smoke</MuzzleSmokeFx>
        <MuzzleSmokeFxFP />
        <MuzzleSmokeFxMinLevel value="0.200000" />
        <MuzzleSmokeFxIncPerShot value="0.050000" />
        <MuzzleSmokeFxDecPerSec value="0.300000" />
        <GroundDisturbFx />
        <GroundDisturbFxAlt />
        <GroundDisturbFxFP />
        <GroundDisturbFxAltFP />
      </Fx>
      <!-- Additional weapon properties... -->
    </Item>
  </Infos>
</CWeaponInfoBlob>
```

---

*Generated from Batch 1 fixes - Use as reference for all subsequent batches*
