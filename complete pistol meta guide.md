# FiveM addon weapon meta files: Complete pistol reference

Custom FiveM pistol weapons require **three essential meta files** (weapons.meta, weaponarchetypes.meta, weaponanimations.meta) plus the 3D model files, while weaponcomponents.meta and pedpersonality.meta are optional but enable attachments and proper NPC behavior. The data_file declarations in fxmanifest.lua must follow a specific load order, with weaponcomponents first and weapons.meta last.

## Required vs optional files for pistol addons

A functioning pistol addon needs these **absolutely required** files: weapons.meta (defines all weapon behavior), weaponarchetypes.meta (links models and textures), the .ydr model file, and the .ytd texture file. The weaponanimations.meta file is technically optional but **highly recommended**—without it, the weapon may have broken or missing animations.

Optional files include weaponcomponents.meta (only needed if adding custom magazines, suppressors, or other attachments), pedpersonality.meta (controls NPC holster/unholster behavior), loadouts.meta (for NPC spawn loadouts), and pickups.meta (for world pickups). For a minimal working pistol using base game animations, you can omit weaponcomponents.meta and pedpersonality.meta entirely.

| File | Status | Can Use Base Game References? |
|------|--------|------------------------------|
| weapons.meta | Required | No—must define new weapon |
| weaponarchetypes.meta | Required | No—must define archetype |
| weaponanimations.meta | Highly recommended | Yes—copy animation refs from WEAPON_PISTOL |
| weaponcomponents.meta | Optional | Yes—can reference COMPONENT_AT_PI_SUPP_02 etc. |
| pedpersonality.meta | Optional | Yes—copy entries from similar weapon |

## weaponarchetypes.meta links models to textures

The weaponarchetypes.meta file registers weapon model archetypes with the game engine, connecting 3D models (.ydr) to their texture dictionaries (.ytd). For most addon weapons where textures are embedded in the .ytd file shipped with the model, this file can use an **empty InitDatas element**:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CWeaponModelInfo__InitDataList>
    <InitDatas/>
</CWeaponModelInfo__InitDataList>
```

This minimal structure works because the texture dictionary is already embedded in the weapon's .ytd file. The weaponarchetypes.meta becomes essential when you need to link external texture dictionaries for component variants or Mk II-style weapon customization with multiple skins.

The relationship between weaponarchetypes.meta and weapons.meta is complementary: **weapons.meta defines behavior** (damage, fire rate, ammo type, audio), while **weaponarchetypes.meta defines visual linkage** (model-to-texture associations). The `Model` field in weapons.meta must match the archetype name registered in weaponarchetypes.meta.

## weaponanimations.meta structure for pistols

The weaponanimations.meta file defines all animation clips and clipsets for weapon handling. Animation dictionaries use the `@` symbol as path separators (e.g., `weapons@pistol@pistol`). Here's the complete structure for a pistol using base game animations:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CWeaponAnimationsSets>
  <WeaponAnimationsSets>
    <Item key="Default">
      <WeaponAnimations>
        <Item key="WEAPON_MYPISTOL">
          <CoverMovementClipSetHash />
          <CoverMovementExtraClipSetHash />
          <CoverAlternateMovementClipSetHash>cover@move@ai@base@1h</CoverAlternateMovementClipSetHash>
          <CoverWeaponClipSetHash>Cover_Wpn_Pistol</CoverWeaponClipSetHash>
          <MotionClipSetHash>weapons@pistol@pistol</MotionClipSetHash>
          <MotionFilterHash>BothArms_filter</MotionFilterHash>
          <MotionCrouchClipSetHash />
          <MotionStrafingClipSetHash />
          <MotionStrafingStealthClipSetHash />
          <MotionStrafingUpperBodyClipSetHash />
          <WeaponClipSetHash>weapons@pistol@pistol</WeaponClipSetHash>
          <WeaponClipSetStreamedHash>weapons@pistol@pistol_str</WeaponClipSetStreamedHash>
          <WeaponClipSetHashInjured>weapons@pistol@pistol_injured</WeaponClipSetHashInjured>
          <WeaponClipSetHashStealth>weapons@pistol@pistol@stealth</WeaponClipSetHashStealth>
          <WeaponClipSetHashHiCover />
          <AlternativeClipSetWhenBlocked />
          <ScopeWeaponClipSet />
          <AlternateAimingStandingClipSetHash />
          <AlternateAimingCrouchingClipSetHash />
          <FiringVariationsStandingClipSetHash>combat_fire_variations_pistol</FiringVariationsStandingClipSetHash>
          <FiringVariationsCrouchingClipSetHash />
          <AimTurnStandingClipSetHash>combat_aim_turns_pistol</AimTurnStandingClipSetHash>
          <AimTurnCrouchingClipSetHash />
          <MeleeClipSetHash />
          <MeleeVariationClipSetHash />
          <MeleeTauntClipSetHash />
          <MeleeSupportTauntClipSetHash />
          <MeleeStealthClipSetHash />
          <ShellShockedClipSetHash>reaction@shellshock@unarmed</ShellShockedClipSetHash>
          <JumpUpperbodyClipSetHash />
          <FallUpperbodyClipSetHash />
          <FromStrafeTransitionUpperBodyClipSetHash>weapons@pistol@</FromStrafeTransitionUpperBodyClipSetHash>
          <SwapWeaponFilterHash>RightArm_NoSpine_filter</SwapWeaponFilterHash>
          <SwapWeaponInLowCoverFilterHash>RightArm_NoSpine_filter</SwapWeaponInLowCoverFilterHash>
          <AnimFireRateModifier value="1.000000" />
          <AnimBlindFireRateModifier value="1.000000" />
          <AnimWantingToShootFireRateModifier value="3.000000" />
          <UseFromStrafeUpperBodyAimNetwork value="true" />
        </Item>
      </WeaponAnimations>
    </Item>
  </WeaponAnimationsSets>
</CWeaponAnimationsSets>
```

Key animation dictionaries for pistols include `weapons@pistol@pistol` (standard), `weapons@pistol@pistol_str` (streamed), `weapons@pistol@ap_pistol` (AP Pistol), and `weapons@pistol_1h@gang` (one-handed gang style). The cover clipsets like `Cover_Wpn_Pistol` and `cover@move@ai@base@1h` handle cover mechanics.

## weaponcomponents.meta for magazines and attachments

The weaponcomponents.meta file uses specific class types for different component categories. The root structure wraps all components:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CWeaponComponentDataFileMgr>
  <Infos>
    <!-- Standard Magazine (12 rounds) -->
    <Item type="CWeaponComponentClipInfo">
      <Name>COMPONENT_MYPISTOL_CLIP_01</Name>
      <Model>w_pi_mypistol_mag1</Model>
      <LocName>WCT_CLIP1</LocName>
      <LocDesc>WCD_CLIP1</LocDesc>
      <ClipSize value="12" />
      <AmmoInfo ref="AMMO_PISTOL" />
    </Item>
    
    <!-- Extended Magazine (18 rounds) -->
    <Item type="CWeaponComponentClipInfo">
      <Name>COMPONENT_MYPISTOL_CLIP_02</Name>
      <Model>w_pi_mypistol_mag2</Model>
      <LocName>WCT_CLIP2</LocName>
      <LocDesc>WCD_CLIP2</LocDesc>
      <ClipSize value="18" />
      <AmmoInfo ref="AMMO_PISTOL" />
    </Item>
    
    <!-- Suppressor -->
    <Item type="CWeaponComponentSuppressorInfo">
      <Name>COMPONENT_MYPISTOL_SUPP</Name>
      <Model>w_pi_mypistol_supp</Model>
      <LocName>WCT_SUPP</LocName>
      <LocDesc>WCD_PI_SUPP</LocDesc>
      <DamageModifier value="0.90" />
      <RangeModifier value="1.05" />
      <RangeDamageModifier value="1.00" />
      <RecoilModifier value="0.90" />
    </Item>
    
    <!-- Flashlight -->
    <Item type="CWeaponComponentFlashLightInfo">
      <Name>COMPONENT_MYPISTOL_FLSH</Name>
      <Model>w_pi_mypistol_flsh</Model>
      <LocName>WCT_FLASH</LocName>
      <LocDesc>WCD_FLASH</LocDesc>
      <IlluminationRange value="30.0" />
    </Item>
  </Infos>
</CWeaponComponentDataFileMgr>
```

Component types include **CWeaponComponentClipInfo** (magazines), **CWeaponComponentSuppressorInfo** (suppressors with damage/recoil modifiers), **CWeaponComponentFlashLightInfo** (flashlights), **CWeaponComponentScopeInfo** (sights/scopes), and **CWeaponComponentVariantModelInfo** (cosmetic variants like luxury finishes).

For different ammo types, the `AmmoInfo ref` attribute references ammo definitions: `AMMO_PISTOL` (standard), `AMMO_PISTOL_TRACER`, `AMMO_PISTOL_INCENDIARY`, `AMMO_PISTOL_HOLLOWPOINT`, and `AMMO_PISTOL_FMJ`. These are defined in weapons.meta using `CAmmoInfo` items with `AmmoSpecialType` set accordingly.

**Important limitation**: FiveM has a pool size limit of approximately **6-7 custom components** per resource before crashes occur. Use base game components (like `COMPONENT_AT_PI_SUPP_02`) as workarounds when possible.

## Linking components to weapons via AttachPoints

Components defined in weaponcomponents.meta must be attached to weapons through the `AttachPoints` section in weapons.meta. Each attachment point uses specific bone names:

```xml
<AttachPoints>
  <!-- Magazine -->
  <Item>
    <AttachBone>WAPClip</AttachBone>
    <Components>
      <Item>
        <Name>COMPONENT_MYPISTOL_CLIP_01</Name>
        <Default value="true" />
      </Item>
      <Item>
        <Name>COMPONENT_MYPISTOL_CLIP_02</Name>
        <Default value="false" />
      </Item>
    </Components>
  </Item>
  
  <!-- Suppressor -->
  <Item>
    <AttachBone>WAPMuzzle</AttachBone>
    <Components>
      <Item>
        <Name>COMPONENT_MYPISTOL_SUPP</Name>
        <Default value="false" />
      </Item>
    </Components>
  </Item>
  
  <!-- Flashlight -->
  <Item>
    <AttachBone>WAPFlash</AttachBone>
    <Components>
      <Item>
        <Name>COMPONENT_MYPISTOL_FLSH</Name>
        <Default value="false" />
      </Item>
    </Components>
  </Item>
</AttachPoints>
```

Standard attachment bone names are: **WAPClip** (magazine), **WAPMuzzle** (suppressor), **WAPFlash** (flashlight), **WAPScope** (optics), **WAPGrip** (grip), and **WAPBase** (cosmetic variants).

## pedpersonality.meta controls NPC weapon behavior

This file defines how NPCs animate when equipping and using weapons. It categorizes weapons into unholster groups: **UNHOLSTER_UNARMED** (melee), **UNHOLSTER_1H** (pistols/SMGs), **UNHOLSTER_2H** (rifles/shotguns), and **MINIGUN**. A minimal pedpersonality.meta for a pistol:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CPedModelInfo__PersonalityDataList>
  <MovementModeUnholsterData>
    <Item>
      <Name>UNHOLSTER_1H</Name>
      <UnholsterClips>
        <Item>
          <Weapons>
            <Item>WEAPON_MYPISTOL</Item>
          </Weapons>
          <Clip>1h_holster_1h</Clip>
        </Item>
      </UnholsterClips>
    </Item>
  </MovementModeUnholsterData>
</CPedModelInfo__PersonalityDataList>
```

This file is **optional**—pistols will function without it but may exhibit incorrect NPC holstering animations.

## Complete weapons.meta example for custom pistol

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CWeaponInfoBlob>
  <Infos>
    <Item type="CWeaponInfo">
      <Name>WEAPON_MYPISTOL</Name>
      <Model>w_pi_mypistol</Model>
      <Audio>AUDIO_ITEM_PISTOL</Audio>
      <Slot>SLOT_PISTOL</Slot>
      <DamageType>BULLET</DamageType>
      <Explosion>
        <Default>GRENADE</Default>
        <HitCar>DONTCARE</HitCar>
        <HitTruck>DONTCARE</HitTruck>
        <HitBike>DONTCARE</HitBike>
        <HitBoat>DONTCARE</HitBoat>
        <HitPlane>DONTCARE</HitPlane>
      </Explosion>
      <FireType>INSTANT_HIT</FireType>
      <WheelSlot>WHEEL_PISTOL</WheelSlot>
      <Group>GROUP_PISTOL</Group>
      <AmmoInfo ref="AMMO_PISTOL" />
      <AimingInfo ref="PISTOL_2H_BASE_STRAFE" />
      <ClipSize value="12" />
      <AccuracySpread value="2.50" />
      <AccurateModeAccuracyModifier value="0.50" />
      <RunAndGunAccuracyModifier value="2.00" />
      <RecoilAccuracyMax value="1.50" />
      <RecoilErrorTime value="0.35" />
      <RecoilRecoveryRate value="0.30" />
      <Damage value="26.00" />
      <Force value="50.00" />
      <NetworkPlayerDamageModifier value="1.00" />
      <NetworkPedDamageModifier value="1.00" />
      <WeaponRange value="50.00" />
      <LockOnRange value="50.00" />
      <TimeBetweenShots value="200.00" />
      <ReloadTimeMP value="800.00" />
      <ReloadTimeSP value="800.00" />
      <HudDamage value="30" />
      <HudSpeed value="65" />
      <HudCapacity value="20" />
      <HudAccuracy value="30" />
      <HudRange value="25" />
      <WeaponFlags>Gun Thrown CarriedInHand TwoHanded AnimReload AnimCrouchFire</WeaponFlags>
      
      <AttachPoints>
        <Item>
          <AttachBone>WAPClip</AttachBone>
          <Components>
            <Item>
              <Name>COMPONENT_MYPISTOL_CLIP_01</Name>
              <Default value="true" />
            </Item>
          </Components>
        </Item>
      </AttachPoints>
    </Item>
  </Infos>
</CWeaponInfoBlob>
```

## fxmanifest.lua with proper data_file declarations

Load order matters—weaponcomponents must load before weapons.meta:

```lua
fx_version 'cerulean'
game 'gta5'

author 'YourName'
description 'Custom Pistol Addon'
version '1.0.0'

files {
    'data/weapons.meta',
    'data/weaponarchetypes.meta',
    'data/weaponanimations.meta',
    'data/weaponcomponents.meta',
    'data/pedpersonality.meta',
}

-- Load order: components → archetypes → animations → personality → weapons
data_file 'WEAPONCOMPONENTSINFO_FILE' 'data/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' 'data/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'data/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' 'data/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' 'data/weapons.meta'
```

The recommended folder structure places meta files in a `data/` subfolder and streaming assets (.ydr, .ytd) in `stream/`:

```
my_pistol_addon/
├── stream/
│   ├── w_pi_mypistol.ydr
│   ├── w_pi_mypistol.ytd
│   └── w_pi_mypistol_mag1.ydr
├── data/
│   ├── weapons.meta
│   ├── weaponarchetypes.meta
│   ├── weaponanimations.meta
│   ├── weaponcomponents.meta
│   └── pedpersonality.meta
└── fxmanifest.lua
```

## Conclusion

Building a FiveM pistol addon requires understanding the interplay between meta files: weapons.meta defines behavior, weaponarchetypes.meta handles visual binding, weaponanimations.meta controls movement and action clips, and weaponcomponents.meta enables attachments. For a minimal working pistol, you need only weapons.meta, weaponarchetypes.meta (can be empty InitDatas), weaponanimations.meta (copying base game pistol animations), and the model files. Referencing base game animation dictionaries like `weapons@pistol@pistol` eliminates the need for custom animation work, while using existing component names like `COMPONENT_AT_PI_SUPP_02` can bypass the **6-7 custom component limit** per resource.