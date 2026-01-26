#!/usr/bin/env python3
"""
Comprehensive Rifle Fix Script (Batches 12, 13, 14)

Fixes ALL structural issues to match proper weapons.meta template:
1. SlotNavigateOrder/SlotBestOrder nested structure
2. AimingInfos with CAimingInfo item
3. Proper Infos double-nesting
4. Explosion block
5. AmmoInfo and AimingInfo references
6. All offset blocks
7. Camera hashes
8. Hud block
9. AmmoPickup blocks
10. Complete FX blocks (FireFx, MuzzleFx, ShellFx, TracerFx)
11. FlashFxLight settings
12. <n> → <Name> and WT_* → WEAPON_* fixes
"""

import os
import re
from pathlib import Path

BASE_PATH = "/home/user/project_pipes"

# Weapon configurations
RIFLE_CONFIGS = {
    # Batch 12 - Assault Rifles (5.56 NATO)
    "weapon_cz_bren": {
        "name": "WEAPON_CZ_BREN",
        "display": "CZ Bren 2",
        "model": "w_ar_cz_bren",
        "slot": "SLOT_CZ_BREN",
        "order_nav": 300,
        "order_best": 150,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_CARBINERIFLE",
    },
    "weapon_desert_ar15": {
        "name": "WEAPON_DESERT_AR15",
        "display": "Desert AR-15",
        "model": "w_ar_desert_ar15",
        "slot": "SLOT_DESERT_AR15",
        "order_nav": 301,
        "order_best": 151,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_CARBINERIFLE",
    },
    "weapon_m16": {
        "name": "WEAPON_M16",
        "display": "M16A4",
        "model": "w_ar_m16",
        "slot": "SLOT_M16",
        "order_nav": 302,
        "order_best": 152,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_CARBINERIFLE",
    },
    "weapon_psa_ar15": {
        "name": "WEAPON_PSA_AR15",
        "display": "PSA AR-15",
        "model": "w_ar_psa_ar15",
        "slot": "SLOT_PSA_AR15",
        "order_nav": 303,
        "order_best": 153,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_CARBINERIFLE",
    },
    "weapon_ram7knight": {
        "name": "WEAPON_RAM7KNIGHT",
        "display": "RAM-7 Knight",
        "model": "w_ar_ram7knight",
        "slot": "SLOT_RAM7KNIGHT",
        "order_nav": 304,
        "order_best": 154,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_CARBINERIFLE",
    },
    "weapon_red_aug": {
        "name": "WEAPON_RED_AUG",
        "display": "Steyr AUG",
        "model": "w_ar_red_aug",
        "slot": "SLOT_RED_AUG",
        "order_nav": 305,
        "order_best": 155,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_CARBINERIFLE",
    },
    # Batch 13 - AK Variants (7.62x39)
    "weapon_mini_ak47": {
        "name": "WEAPON_MINI_AK47",
        "display": "Mini AK-47",
        "model": "w_ar_mini_ak47",
        "slot": "SLOT_MINI_AK47",
        "order_nav": 310,
        "order_best": 160,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_ASSAULTRIFLE",
    },
    "weapon_mk47": {
        "name": "WEAPON_MK47",
        "display": "MK47 Mutant",
        "model": "w_ar_mk47",
        "slot": "SLOT_MK47",
        "order_nav": 311,
        "order_best": 161,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_ASSAULTRIFLE",
    },
    # Batch 14 - Battle Rifles (.308/6.8mm)
    "weapon_m7": {
        "name": "WEAPON_M7",
        "display": "M7",
        "model": "w_ar_m7",
        "slot": "SLOT_M7",
        "order_nav": 320,
        "order_best": 170,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_ASSAULTRIFLE",
    },
    "weapon_mcx300": {
        "name": "WEAPON_MCX300",
        "display": "SIG MCX .300",
        "model": "w_ar_mcx300",
        "slot": "SLOT_MCX300",
        "order_nav": 321,
        "order_best": 171,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_ASSAULTRIFLE",
    },
    "weapon_sig_spear": {
        "name": "WEAPON_SIG_SPEAR",
        "display": "SIG Spear",
        "model": "w_ar_sig_spear",
        "slot": "SLOT_SIG_SPEAR",
        "order_nav": 322,
        "order_best": 172,
        "ammo": "AMMO_RIFLE",
        "group": "GROUP_RIFLE",
        "wheel_slot": "WHEEL_RIFLE",
        "audio": "AUDIO_ITEM_ASSAULTRIFLE",
    },
}

# Template for complete weapons.meta structure
WEAPONS_META_TEMPLATE = '''<?xml version="1.0" encoding="UTF-8"?>
<CWeaponInfoBlob>
  <SlotNavigateOrder>
    <Item>
      <WeaponSlots>
        <Item>
          <OrderNumber value="{order_nav}" />
          <Entry>{slot}</Entry>
        </Item>
      </WeaponSlots>
    </Item>
    <Item>
      <WeaponSlots>
        <Item>
          <OrderNumber value="{order_nav}" />
          <Entry>{slot}</Entry>
        </Item>
      </WeaponSlots>
    </Item>
  </SlotNavigateOrder>
  <SlotBestOrder>
    <WeaponSlots>
      <Item>
        <OrderNumber value="{order_best}" />
        <Entry>{slot}</Entry>
      </Item>
    </WeaponSlots>
  </SlotBestOrder>
  <TintSpecValues />
  <FiringPatternAliases />
  <UpperBodyFixupExpressionData />
  <AimingInfos>
    <Item type="CAimingInfo">
      <Name>{aiming_info_name}</Name>
      <HeadingLimit value="90.000000" />
      <SweepPitchMin value="-45.000000" />
      <SweepPitchMax value="45.000000" />
    </Item>
  </AimingInfos>
  <Infos>
    <Item>
      <Infos />
    </Item>
    <Item>
      <Infos>
        <Item type="CWeaponInfo">
{weapon_info_content}
        </Item>
      </Infos>
    </Item>
  </Infos>
</CWeaponInfoBlob>
'''

# FX block template for assault rifles
RIFLE_FX_BLOCK = '''          <AimOffset>
            <X value="0.000000" />
            <Y value="0.020000" />
            <Z value="0.000000" />
          </AimOffset>
          <FirstPersonAimOffset>
            <X value="0.000000" />
            <Y value="0.000000" />
            <Z value="0.000000" />
          </FirstPersonAimOffset>
          <FirstPersonScopeOffset>
            <X value="0.000000" />
            <Y value="0.000000" />
            <Z value="0.000000" />
          </FirstPersonScopeOffset>
          <CrouchAimOffset>
            <X value="0.000000" />
            <Y value="0.000000" />
            <Z value="0.000000" />
          </CrouchAimOffset>
          <FirstPersonCrouchAimOffset>
            <X value="0.000000" />
            <Y value="0.000000" />
            <Z value="0.000000" />
          </FirstPersonCrouchAimOffset>
          <ZoomFactorForAccurateMode value="1.000000" />
          <ReticuleMinSizeStanding value="0.000000" />
          <ReticuleMinSizeDucked value="0.000000" />
          <ReticuleScale value="0.400000" />
          <IronSightCameraZoomFactor value="1.000000" />
          <WeaponSoundBoneTag />
          <Hud>
            <FlashColor value="0xFFFFFFFF" />
            <ScrollSelect>true</ScrollSelect>
          </Hud>
          <AmmoPickup>
            <AmmoType>{ammo}</AmmoType>
            <Amount value="30" />
          </AmmoPickup>
          <AmmoPickup2>
            <AmmoType>{ammo}</AmmoType>
            <Amount value="60" />
          </AmmoPickup2>
          <FireFx>
            <Direction>
              <X value="0.000000" />
              <Y value="5.000000" />
              <Z value="0.000000" />
            </Direction>
            <Rotation>
              <X value="0.000000" />
              <Y value="0.000000" />
              <Z value="0.000000" />
            </Rotation>
            <Scale value="1.000000" />
            <EffectName>muz_assault_rifle_fp</EffectName>
            <FxBone>Gun_Muzzle</FxBone>
          </FireFx>
          <MuzzleFx>
            <Direction>
              <X value="0.000000" />
              <Y value="5.000000" />
              <Z value="0.000000" />
            </Direction>
            <Rotation>
              <X value="0.000000" />
              <Y value="0.000000" />
              <Z value="0.000000" />
            </Rotation>
            <Scale value="1.200000" />
            <EffectName>muz_assault_rifle</EffectName>
            <FxBone>Gun_Muzzle</FxBone>
          </MuzzleFx>
          <ShellFx>
            <Direction>
              <X value="0.000000" />
              <Y value="0.000000" />
              <Z value="0.000000" />
            </Direction>
            <Rotation>
              <X value="0.000000" />
              <Y value="0.000000" />
              <Z value="0.000000" />
            </Rotation>
            <Scale value="1.000000" />
            <EffectName>weap_sh_ar</EffectName>
            <FxBone>Gun_Shell</FxBone>
          </ShellFx>
          <TracerFx>
            <Direction>
              <X value="0.000000" />
              <Y value="0.000000" />
              <Z value="0.000000" />
            </Direction>
            <Rotation>
              <X value="0.000000" />
              <Y value="0.000000" />
              <Z value="0.000000" />
            </Rotation>
            <Scale value="1.000000" />
            <EffectName>proj_tracer</EffectName>
            <FxBone />
          </TracerFx>
          <FlashFxLightEnabled value="true" />
          <FlashFxLightCastsShadows value="false" />
          <FlashFxLightOffsetDistance value="4.000000" />
          <FlashFxLightRGBAMax value="0xFFFFE4C9" />
          <FlashFxLightIntensityMax value="1.500000" />
          <FlashFxLightFallOffMax value="8.000000" />
          <FlashFxFadeOutTime value="0.050000" />
          <FlashFxAltBone />
          <ReloadUpperBodyFixupExpression></ReloadUpperBodyFixupExpression>'''


def extract_weapon_info_content(content: str) -> str:
    """Extract the core weapon info content from CWeaponInfo item"""
    # Try to find content between <Item type="CWeaponInfo"> and </Item>
    pattern = r'<Item type="CWeaponInfo">\s*(.*?)\s*</Item>'
    match = re.search(pattern, content, re.DOTALL)
    if match:
        return match.group(1)
    return None


def extract_existing_values(content: str) -> dict:
    """Extract key values from existing weapons.meta"""
    values = {}

    # Extract common weapon attributes
    patterns = {
        'damage': r'<Damage value="([^"]+)"',
        'clip_size': r'<ClipSize value="([^"]+)"',
        'accuracy_spread': r'<AccuracySpread value="([^"]+)"',
        'recoil_accuracy_max': r'<RecoilAccuracyMax value="([^"]+)"',
        'recoil_recovery_rate': r'<RecoilRecoveryRate value="([^"]+)"',
        'time_between_shots': r'<TimeBetweenShots value="([^"]+)"',
        'weapon_range': r'<WeaponRange value="([^"]+)"',
        'speed': r'<Speed value="([^"]+)"',
        'force': r'<Force value="([^"]+)"',
        'penetration': r'<Penetration value="([^"]+)"',
        'damage_falloff_min': r'<DamageFallOffRangeMin value="([^"]+)"',
        'damage_falloff_max': r'<DamageFallOffRangeMax value="([^"]+)"',
        'damage_falloff_modifier': r'<DamageFallOffModifier value="([^"]+)"',
        'recoil_shake_amplitude': r'<RecoilShakeAmplitude value="([^"]+)"',
        'recoil_shake_frequency': r'<RecoilShakeFrequency value="([^"]+)"',
    }

    for key, pattern in patterns.items():
        match = re.search(pattern, content)
        if match:
            values[key] = match.group(1)

    # Extract comment block if present
    comment_pattern = r'(<!--.*?-->)'
    comments = re.findall(comment_pattern, content, re.DOTALL)
    if comments:
        values['comment'] = comments[0]

    return values


def build_weapon_info_content(config: dict, existing_values: dict) -> str:
    """Build the weapon info content block"""

    comment = existing_values.get('comment', f'''          <!-- {config["display"]} -->''')

    # Get values with defaults
    damage = existing_values.get('damage', '42.0')
    clip_size = existing_values.get('clip_size', '30')
    accuracy_spread = existing_values.get('accuracy_spread', '0.80')
    recoil_accuracy_max = existing_values.get('recoil_accuracy_max', '1.80')
    recoil_recovery_rate = existing_values.get('recoil_recovery_rate', '0.55')
    time_between_shots = existing_values.get('time_between_shots', '0.085')
    weapon_range = existing_values.get('weapon_range', '400.0')
    speed = existing_values.get('speed', '900.0')
    force = existing_values.get('force', '120.0')
    penetration = existing_values.get('penetration', '0.40')
    damage_falloff_min = existing_values.get('damage_falloff_min', '70.0')
    damage_falloff_max = existing_values.get('damage_falloff_max', '200.0')
    damage_falloff_modifier = existing_values.get('damage_falloff_modifier', '0.40')
    recoil_shake_amplitude = existing_values.get('recoil_shake_amplitude', '0.25')
    recoil_shake_frequency = existing_values.get('recoil_shake_frequency', '0.50')

    aiming_info_name = f"AI_{config['name'].replace('WEAPON_', '')}"

    content = f'''{comment}
          <Name>{config["name"]}</Name>
          <Model>{config["model"]}</Model>
          <Audio>{config["audio"]}</Audio>
          <Slot>{config["slot"]}</Slot>
          <HumanNameHash>{config["name"]}</HumanNameHash>
          <DamageType>BULLET</DamageType>
          <Explosion>
            <Default>DONTCARE</Default>
            <HitCar>DONTCARE</HitCar>
            <HitTruck>DONTCARE</HitTruck>
            <HitBike>DONTCARE</HitBike>
            <HitBoat>DONTCARE</HitBoat>
            <HitPlane>DONTCARE</HitPlane>
          </Explosion>
          <FireType>INSTANT_HIT</FireType>
          <EffectGroup>WEAPON_EFFECT_GROUP_RIFLE</EffectGroup>
          <PedDamageHash>BulletLarge</PedDamageHash>
          <WheelSlot>{config["wheel_slot"]}</WheelSlot>
          <Group>{config["group"]}</Group>
          <AmmoInfo ref="{config["ammo"]}" />
          <AimingInfo ref="{aiming_info_name}" />

          <ClipSize value="{clip_size}" />

          <AccuracySpread value="{accuracy_spread}" />
          <AccurateModeAccuracyModifier value="0.150000" />
          <RunAndGunAccuracyModifier value="0.550000" />
          <RunAndGunAccuracyMinOverride value="-1.000000" />
          <RecoilAccuracyMax value="{recoil_accuracy_max}" />
          <RecoilErrorTime value="0.400000" />
          <RecoilRecoveryRate value="{recoil_recovery_rate}" />

          <RecoilAccuracyToAllowHeadShotAI value="0.450000" />
          <MinHeadShotDistanceAI value="5.000000" />
          <MaxHeadShotDistanceAI value="200.000000" />
          <HeadShotDamageModifierAI value="4.000000" />
          <RecoilAccuracyToAllowHeadShotPlayer value="0.450000" />
          <MinHeadShotDistancePlayer value="0.000000" />
          <MaxHeadShotDistancePlayer value="200.000000" />
          <HeadShotDamageModifierPlayer value="2.500000" />

          <Damage value="{damage}" />
          <DamageTime value="0.000000" />
          <DamageTimeInVehicle value="0.000000" />
          <DamageTimeInVehicleHeadShot value="0.000000" />
          <HitLimbsDamageModifier value="0.500000" />
          <NetworkHitLimbsDamageModifier value="0.800000" />
          <LightlyArmouredDamageModifier value="0.700000" />

          <Force value="{force}" />
          <ForceHitPed value="100.000000" />
          <ForceHitVehicle value="50.000000" />
          <ForceHitFlyingHeli value="35.000000" />
          <OverrideForces />
          <ForceMaxStrengthMult value="1.000000" />
          <ForceFalloffRangeStart value="0.000000" />
          <ForceFalloffRangeEnd value="200.000000" />
          <ForceFalloffMin value="0.400000" />
          <ProjectileForce value="0.000000" />
          <FragImpulse value="350.000000" />

          <Penetration value="{penetration}" />
          <VerticalLaunchAdjustment value="0.000000" />
          <DropForwardVelocity value="0.000000" />

          <Speed value="{speed}" />

          <BulletsInBatch value="1" />
          <BatchSpread value="0.000000" />

          <ReloadTimeMP value="2.500000" />
          <ReloadTimeSP value="2.500000" />

          <TimeBetweenShots value="{time_between_shots}" />

          <DamageFallOffRangeMin value="{damage_falloff_min}" />
          <DamageFallOffRangeMax value="{damage_falloff_max}" />
          <DamageFallOffModifier value="{damage_falloff_modifier}" />

          <NetworkPlayerDamageModifier value="1.000000" />
          <NetworkPedDamageModifier value="1.000000" />
          <NetworkHeadShotPlayerDamageModifier value="1.000000" />
          <LockOnRange value="0.000000" />
          <WeaponRange value="{weapon_range}" />

          <BulletDirectionOffsetInDegrees value="0.080000" />
          <RecoilShakeAmplitude value="{recoil_shake_amplitude}" />
          <RecoilShakeFrequency value="{recoil_shake_frequency}" />
          <RecoilShakeRollMagnitude value="0.150000" />
          <RecoilShakeDuration value="0.200000" />

          <AiSoundRange value="180.000000" />
          <AimingMod1 value="0.650000" />
          <AimingModTime1 value="0.200000" />
          <AimingMod2 value="0.400000" />
          <AimingModTime2 value="0.350000" />

          <Flags>WF_GUN, WF_GUN_2_HANDED, WF_NO_SHOOTING_BERSERK, WF_PED_GUN_2_HANDED, WF_WEAPON, WF_LOUDWEAPON, WF_TAKE_ARM_L_LONG_GUN_IMMEDIATE_DAMAGE_REACTIONS, WF_MAKE_PED_BACKUP</Flags>

          <AltWheelSlot>WHEEL_UNARMED</AltWheelSlot>
          <PickupGlowAsset />
          <PickupTextRep />
          <ModelHashKey>{config["model"]}</ModelHashKey>
          <DefaultCameraHash>DEFAULT_FOLLOW_CAMERA</DefaultCameraHash>
          <CoverCameraHash>DEFAULT_FOLLOW_CAMERA</CoverCameraHash>
          <RunAndGunCameraHash>DEFAULT_FOLLOW_CAMERA</RunAndGunCameraHash>
          <CinematicShootingCameraHash>DEFAULT_CINEMATIC_SHOOTING_CAMERA</CinematicShootingCameraHash>
          <PickupHash>PICKUP_WEAPON_ASSAULTRIFLE</PickupHash>
          <MPPickupHash>PICKUP_AMMO_BULLET_MP</MPPickupHash>
          <NmShotTuningSet>Normal</NmShotTuningSet>
'''

    # Add FX block
    content += RIFLE_FX_BLOCK.format(ammo=config["ammo"])

    return content


def process_weapon(folder_name: str, batch_path: str, dry_run: bool = True) -> bool:
    """Process a single weapon folder"""
    if folder_name not in RIFLE_CONFIGS:
        print(f"  Skipping {folder_name} - not in config")
        return False

    config = RIFLE_CONFIGS[folder_name]
    folder_path = os.path.join(batch_path, folder_name)
    meta_dir = os.path.join(folder_path, "meta")

    # Find existing weapons.meta
    weapons_meta = None
    for name in ["weapons.meta", f"{folder_name}.meta"]:
        candidate = os.path.join(meta_dir, name)
        if os.path.exists(candidate):
            weapons_meta = candidate
            break

    if not weapons_meta:
        print(f"  ERROR: No weapons.meta found for {folder_name}")
        return False

    # Read existing content
    with open(weapons_meta, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract existing values
    existing_values = extract_existing_values(content)

    # Build new weapon info content
    weapon_info_content = build_weapon_info_content(config, existing_values)

    # Generate aiming info name
    aiming_info_name = f"AI_{config['name'].replace('WEAPON_', '')}"

    # Build complete weapons.meta
    new_content = WEAPONS_META_TEMPLATE.format(
        slot=config["slot"],
        order_nav=config["order_nav"],
        order_best=config["order_best"],
        aiming_info_name=aiming_info_name,
        weapon_info_content=weapon_info_content
    )

    if dry_run:
        print(f"  Would rewrite: {os.path.basename(weapons_meta)}")
        return True
    else:
        # Write new content
        with open(weapons_meta, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"  Rewrote: {os.path.basename(weapons_meta)}")
        return True


def fix_other_meta(filepath: str, dry_run: bool = True) -> bool:
    """Fix <n> to <Name> in other meta files"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content
    content = re.sub(r'<n>', '<Name>', content)
    content = re.sub(r'</n>', '</Name>', content)

    if content != original:
        if dry_run:
            print(f"    Would fix: {os.path.basename(filepath)}")
            return True
        else:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"    Fixed: {os.path.basename(filepath)}")
            return True
    return False


def fix_weapon_names_lua(filepath: str, folder_name: str, dry_run: bool = True) -> bool:
    """Fix cl_weaponNames.lua format"""
    if folder_name not in RIFLE_CONFIGS:
        return False

    config = RIFLE_CONFIGS[folder_name]
    new_content = f'AddTextEntry("{config["name"]}", "{config["display"]}")\n'

    with open(filepath, 'r', encoding='utf-8') as f:
        original = f.read()

    if original.strip() != new_content.strip():
        if dry_run:
            print(f"    Would fix: cl_weaponNames.lua")
            return True
        else:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"    Fixed: cl_weaponNames.lua")
            return True
    return False


def process_batch(batch_name: str, dry_run: bool = True) -> dict:
    """Process all weapons in a batch"""
    batch_path = os.path.join(BASE_PATH, batch_name)

    print(f"\nProcessing {batch_name}...")
    print(f"Path: {batch_path}")
    print("=" * 60)

    results = {
        "weapons_meta": [],
        "other_meta": [],
        "lua_files": [],
    }

    if not os.path.isdir(batch_path):
        print(f"  ERROR: Batch directory not found")
        return results

    # Find all weapon folders
    weapon_folders = [d for d in os.listdir(batch_path)
                      if os.path.isdir(os.path.join(batch_path, d)) and d.startswith('weapon_')]

    for folder in sorted(weapon_folders):
        folder_path = os.path.join(batch_path, folder)
        print(f"\n  {folder}:")

        # Process weapons.meta
        if process_weapon(folder, batch_path, dry_run):
            results["weapons_meta"].append(folder)

        # Fix pedpersonality.meta
        ped_meta = os.path.join(folder_path, "meta", "pedpersonality.meta")
        if os.path.exists(ped_meta):
            if fix_other_meta(ped_meta, dry_run):
                results["other_meta"].append(ped_meta)

        # Fix weaponanimations.meta
        anim_meta = os.path.join(folder_path, "meta", "weaponanimations.meta")
        if os.path.exists(anim_meta):
            if fix_other_meta(anim_meta, dry_run):
                results["other_meta"].append(anim_meta)

        # Fix cl_weaponNames.lua
        lua_file = os.path.join(folder_path, "cl_weaponNames.lua")
        if os.path.exists(lua_file):
            if fix_weapon_names_lua(lua_file, folder, dry_run):
                results["lua_files"].append(lua_file)

    return results


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Complete rifle fix for batches 12-14")
    parser.add_argument("--apply", action="store_true", help="Apply changes (default is dry run)")
    parser.add_argument("--batch", type=int, help="Process only specific batch (12, 13, or 14)")
    args = parser.parse_args()

    dry_run = not args.apply

    print("Complete Rifle Fix Script")
    print("=" * 60)
    print(f"Mode: {'DRY RUN' if dry_run else 'APPLYING CHANGES'}")

    batches = ["batch12_weapons", "batch13_weapons", "batch14_weapons"]
    if args.batch:
        batch_key = f"batch{args.batch}_weapons"
        if batch_key in batches:
            batches = [batch_key]
        else:
            print(f"ERROR: Batch {args.batch} not found")
            return

    total_results = {
        "weapons_meta": 0,
        "other_meta": 0,
        "lua_files": 0,
    }

    for batch_name in batches:
        results = process_batch(batch_name, dry_run)
        total_results["weapons_meta"] += len(results["weapons_meta"])
        total_results["other_meta"] += len(results["other_meta"])
        total_results["lua_files"] += len(results["lua_files"])

    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)
    print(f"  weapons.meta files: {total_results['weapons_meta']}")
    print(f"  Other meta files: {total_results['other_meta']}")
    print(f"  Lua files: {total_results['lua_files']}")
    print(f"  Total: {sum(total_results.values())}")

    if dry_run:
        print("\nRun with --apply to make changes")


if __name__ == "__main__":
    main()
