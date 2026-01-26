#!/usr/bin/env python3
"""
Comprehensive SMG Fix Script (Batches 15, 16, 17)

Based on WEAPON_SMG_MK2 template structure.
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
13. EffectGroup, PedDamageHash
14. Correct Group (GROUP_SMG) and WheelSlot (WHEEL_SMG)
"""

import os
import re
from pathlib import Path

BASE_PATH = "/home/user/project_pipes"

# SMG weapon configurations
SMG_CONFIGS = {
    # Batch 15 - 9mm SMGs
    "weapon_micro_mp5": {
        "name": "WEAPON_MICRO_MP5",
        "display": "Micro MP5",
        "model": "w_sb_micro_mp5",
        "slot": "SLOT_MICRO_MP5",
        "order_nav": 400,
        "order_best": 200,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    "weapon_mpa30": {
        "name": "WEAPON_MPA30",
        "display": "MPA30",
        "model": "w_sb_mpa30",
        "slot": "SLOT_MPA30",
        "order_nav": 401,
        "order_best": 201,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    "weapon_ram9_desert": {
        "name": "WEAPON_RAM9_DESERT",
        "display": "RAM-9 Desert",
        "model": "w_sb_ram9_desert",
        "slot": "SLOT_RAM9_DESERT",
        "order_nav": 402,
        "order_best": 202,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    "weapon_scorpion": {
        "name": "WEAPON_SCORPION",
        "display": "CZ Scorpion",
        "model": "w_sb_scorpion",
        "slot": "SLOT_SCORPION",
        "order_nav": 403,
        "order_best": 203,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    "weapon_sig_mpx": {
        "name": "WEAPON_SIG_MPX",
        "display": "SIG MPX",
        "model": "w_sb_sig_mpx",
        "slot": "SLOT_SIG_MPX",
        "order_nav": 404,
        "order_best": 204,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    "weapon_sub2000": {
        "name": "WEAPON_SUB2000",
        "display": "SUB-2000",
        "model": "w_sb_sub2000",
        "slot": "SLOT_SUB2000",
        "order_nav": 405,
        "order_best": 205,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    "weapon_tec9": {
        "name": "WEAPON_TEC9",
        "display": "TEC-9",
        "model": "w_sb_tec9",
        "slot": "SLOT_TEC9",
        "order_nav": 406,
        "order_best": 206,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    # Batch 16 - .45 ACP SMGs
    "weapon_mac10": {
        "name": "WEAPON_MAC10",
        "display": "MAC-10",
        "model": "w_sb_mac10",
        "slot": "SLOT_MAC10",
        "order_nav": 410,
        "order_best": 210,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    "weapon_mac4a1": {
        "name": "WEAPON_MAC4A1",
        "display": "MAC-4A1",
        "model": "w_sb_mac4a1",
        "slot": "SLOT_MAC4A1",
        "order_nav": 411,
        "order_best": 211,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    # Batch 17 - Special SMGs/PDWs
    "weapon_arp_bumpstock": {
        "name": "WEAPON_ARP_BUMPSTOCK",
        "display": "ARP Bumpstock",
        "model": "w_sb_arp_bumpstock",
        "slot": "SLOT_ARP_BUMPSTOCK",
        "order_nav": 420,
        "order_best": 220,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    "weapon_mk18": {
        "name": "WEAPON_MK18",
        "display": "MK18",
        "model": "w_sb_mk18",
        "slot": "SLOT_MK18",
        "order_nav": 421,
        "order_best": 221,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
    "weapon_sbr9": {
        "name": "WEAPON_SBR9",
        "display": "SBR9",
        "model": "w_sb_sbr9",
        "slot": "SLOT_SBR9",
        "order_nav": 422,
        "order_best": 222,
        "ammo": "AMMO_SMG",
        "group": "GROUP_SMG",
        "wheel_slot": "WHEEL_SMG",
        "audio": "AUDIO_ITEM_SMG",
    },
}

# Template for complete weapons.meta structure (SMG variant)
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

# FX block template for SMGs
SMG_FX_BLOCK = '''          <AimOffset>
            <X value="0.000000" />
            <Y value="0.015000" />
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
            <EffectName>muz_smg_fp</EffectName>
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
            <Scale value="1.000000" />
            <EffectName>muz_smg</EffectName>
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
            <EffectName>weap_sh_smg</EffectName>
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
          <FlashFxLightOffsetDistance value="3.000000" />
          <FlashFxLightRGBAMax value="0xFFFFE4C9" />
          <FlashFxLightIntensityMax value="1.200000" />
          <FlashFxLightFallOffMax value="6.000000" />
          <FlashFxFadeOutTime value="0.040000" />
          <FlashFxAltBone />
          <ReloadUpperBodyFixupExpression></ReloadUpperBodyFixupExpression>'''


def extract_existing_values(content: str) -> dict:
    """Extract key values from existing weapons.meta"""
    values = {}

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
        'force_hit_ped': r'<ForceHitPed value="([^"]+)"',
        'force_hit_vehicle': r'<ForceHitVehicle value="([^"]+)"',
        'force_hit_heli': r'<ForceHitFlyingHeli value="([^"]+)"',
        'armor_penetration': r'<ArmorPenetration value="([^"]+)"',
        'aiming_time': r'<AimingTime value="([^"]+)"',
        'bullet_direction_offset': r'<BulletDirectionOffsetInDegrees value="([^"]+)"',
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
    """Build the weapon info content block for SMG"""

    comment = existing_values.get('comment', f'''          <!-- {config["display"]} -->''')

    # Get values with defaults for SMGs
    damage = existing_values.get('damage', '25.0')
    clip_size = existing_values.get('clip_size', '30')
    accuracy_spread = existing_values.get('accuracy_spread', '1.50')
    recoil_accuracy_max = existing_values.get('recoil_accuracy_max', '2.00')
    recoil_recovery_rate = existing_values.get('recoil_recovery_rate', '0.55')
    time_between_shots = existing_values.get('time_between_shots', '0.085')
    weapon_range = existing_values.get('weapon_range', '80.0')
    speed = existing_values.get('speed', '370.0')
    force = existing_values.get('force', '65.0')
    penetration = existing_values.get('penetration', '0.25')
    damage_falloff_min = existing_values.get('damage_falloff_min', '25.0')
    damage_falloff_max = existing_values.get('damage_falloff_max', '70.0')
    damage_falloff_modifier = existing_values.get('damage_falloff_modifier', '0.35')
    recoil_shake_amplitude = existing_values.get('recoil_shake_amplitude', '0.18')
    recoil_shake_frequency = existing_values.get('recoil_shake_frequency', '0.45')
    force_hit_ped = existing_values.get('force_hit_ped', '55.0')
    force_hit_vehicle = existing_values.get('force_hit_vehicle', '28.0')
    force_hit_heli = existing_values.get('force_hit_heli', '18.0')
    armor_penetration = existing_values.get('armor_penetration', '0.18')
    aiming_time = existing_values.get('aiming_time', '0.30')
    bullet_direction_offset = existing_values.get('bullet_direction_offset', '0.12')

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
          <EffectGroup>WEAPON_EFFECT_GROUP_SMG</EffectGroup>
          <PedDamageHash>BulletSmall</PedDamageHash>
          <WheelSlot>{config["wheel_slot"]}</WheelSlot>
          <Group>{config["group"]}</Group>
          <AmmoInfo ref="{config["ammo"]}" />
          <AimingInfo ref="{aiming_info_name}" />

          <ClipSize value="{clip_size}" />

          <AccuracySpread value="{accuracy_spread}" />
          <AccurateModeAccuracyModifier value="0.200000" />
          <RunAndGunAccuracyModifier value="0.500000" />
          <RunAndGunAccuracyMinOverride value="-1.000000" />
          <RecoilAccuracyMax value="{recoil_accuracy_max}" />
          <RecoilErrorTime value="0.350000" />
          <RecoilRecoveryRate value="{recoil_recovery_rate}" />

          <RecoilAccuracyToAllowHeadShotAI value="0.500000" />
          <MinHeadShotDistanceAI value="3.000000" />
          <MaxHeadShotDistanceAI value="50.000000" />
          <HeadShotDamageModifierAI value="4.000000" />
          <RecoilAccuracyToAllowHeadShotPlayer value="0.450000" />
          <MinHeadShotDistancePlayer value="0.000000" />
          <MaxHeadShotDistancePlayer value="50.000000" />
          <HeadShotDamageModifierPlayer value="2.500000" />

          <Damage value="{damage}" />
          <DamageTime value="0.000000" />
          <DamageTimeInVehicle value="0.000000" />
          <DamageTimeInVehicleHeadShot value="0.000000" />
          <HitLimbsDamageModifier value="0.500000" />
          <NetworkHitLimbsDamageModifier value="0.800000" />
          <LightlyArmouredDamageModifier value="0.600000" />

          <Force value="{force}" />
          <ForceHitPed value="{force_hit_ped}" />
          <ForceHitVehicle value="{force_hit_vehicle}" />
          <ForceHitFlyingHeli value="{force_hit_heli}" />
          <OverrideForces />
          <ForceMaxStrengthMult value="1.000000" />
          <ForceFalloffRangeStart value="0.000000" />
          <ForceFalloffRangeEnd value="80.000000" />
          <ForceFalloffMin value="0.400000" />
          <ProjectileForce value="0.000000" />
          <FragImpulse value="200.000000" />

          <Penetration value="{penetration}" />
          <VerticalLaunchAdjustment value="0.000000" />
          <DropForwardVelocity value="0.000000" />

          <Speed value="{speed}" />

          <BulletsInBatch value="1" />
          <BatchSpread value="0.000000" />

          <ReloadTimeMP value="2.200000" />
          <ReloadTimeSP value="2.200000" />

          <TimeBetweenShots value="{time_between_shots}" />

          <DamageFallOffRangeMin value="{damage_falloff_min}" />
          <DamageFallOffRangeMax value="{damage_falloff_max}" />
          <DamageFallOffModifier value="{damage_falloff_modifier}" />

          <NetworkPlayerDamageModifier value="1.000000" />
          <NetworkPedDamageModifier value="1.000000" />
          <NetworkHeadShotPlayerDamageModifier value="1.000000" />
          <LockOnRange value="0.000000" />
          <WeaponRange value="{weapon_range}" />

          <BulletDirectionOffsetInDegrees value="{bullet_direction_offset}" />
          <RecoilShakeAmplitude value="{recoil_shake_amplitude}" />
          <RecoilShakeFrequency value="{recoil_shake_frequency}" />
          <RecoilShakeRollMagnitude value="0.120000" />
          <RecoilShakeDuration value="0.180000" />

          <AiSoundRange value="140.000000" />
          <AimingMod1 value="0.700000" />
          <AimingModTime1 value="0.180000" />
          <AimingMod2 value="0.450000" />
          <AimingModTime2 value="0.300000" />

          <Flags>WF_GUN, WF_GUN_2_HANDED, WF_NO_SHOOTING_BERSERK, WF_PED_GUN_2_HANDED, WF_WEAPON, WF_LOUDWEAPON, WF_TAKE_ARM_L_LONG_GUN_IMMEDIATE_DAMAGE_REACTIONS, WF_MAKE_PED_BACKUP</Flags>

          <AltWheelSlot>WHEEL_UNARMED</AltWheelSlot>
          <PickupGlowAsset />
          <PickupTextRep />
          <ModelHashKey>{config["model"]}</ModelHashKey>
          <DefaultCameraHash>DEFAULT_FOLLOW_CAMERA</DefaultCameraHash>
          <CoverCameraHash>DEFAULT_FOLLOW_CAMERA</CoverCameraHash>
          <RunAndGunCameraHash>DEFAULT_FOLLOW_CAMERA</RunAndGunCameraHash>
          <CinematicShootingCameraHash>DEFAULT_CINEMATIC_SHOOTING_CAMERA</CinematicShootingCameraHash>
          <PickupHash>PICKUP_WEAPON_SMG</PickupHash>
          <MPPickupHash>PICKUP_AMMO_BULLET_MP</MPPickupHash>
          <NmShotTuningSet>Normal</NmShotTuningSet>
'''

    # Add FX block
    content += SMG_FX_BLOCK.format(ammo=config["ammo"])

    return content


def process_weapon(folder_name: str, batch_path: str, dry_run: bool = True) -> bool:
    """Process a single weapon folder"""
    if folder_name not in SMG_CONFIGS:
        print(f"  Skipping {folder_name} - not in config")
        return False

    config = SMG_CONFIGS[folder_name]
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
    if folder_name not in SMG_CONFIGS:
        return False

    config = SMG_CONFIGS[folder_name]
    new_content = f'AddTextEntry("{config["name"]}", "{config["display"]}")\n'

    if not os.path.exists(filepath):
        # Create the file if it doesn't exist
        if dry_run:
            print(f"    Would create: cl_weaponNames.lua")
            return True
        else:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"    Created: cl_weaponNames.lua")
            return True

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
        if fix_weapon_names_lua(lua_file, folder, dry_run):
            results["lua_files"].append(lua_file)

    return results


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Complete SMG fix for batches 15-17")
    parser.add_argument("--apply", action="store_true", help="Apply changes (default is dry run)")
    parser.add_argument("--batch", type=int, help="Process only specific batch (15, 16, or 17)")
    args = parser.parse_args()

    dry_run = not args.apply

    print("Complete SMG Fix Script (Phase 2)")
    print("=" * 60)
    print(f"Mode: {'DRY RUN' if dry_run else 'APPLYING CHANGES'}")

    batches = ["batch15_weapons", "batch16_weapons", "batch17_weapons"]
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
