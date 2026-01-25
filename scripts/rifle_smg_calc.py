#!/usr/bin/env python3
"""
Rifle & SMG Damage/Handling Calculator

Applies realistic damage and handling values based on:
- Real-world caliber ballistics
- Barrel length effects
- Weight and ergonomics
- Quality tier (budget/standard/quality/match)
- Fire mode (semi/burst/full-auto)

Calibers covered:
- 5.56x45mm NATO (batch 12 - AR-15s, AUG, BREN)
- 7.62x39mm (batch 13 - AK variants)
- .308 Win / 7.62x51mm NATO (batch 14 - battle rifles)
- 6.8x51mm / .277 Fury (batch 14 - SIG Spear)
- 9mm Parabellum SMG (batch 15 - SMGs)
- .45 ACP SMG (batch 16 - MAC-10, MAC-4A1)
- 5.56x45mm PDW (batch 17 - short barrel rifles)
"""

import os
import re
from dataclasses import dataclass
from typing import Optional
import glob

BASE_PATH = "/home/user/project_pipes"

# =============================================================================
# REAL-WORLD CALIBER DATA
# =============================================================================
# Based on actual ballistic data from manufacturer specs and testing

CALIBER_DATA = {
    # 5.56x45mm NATO - Standard infantry rifle round
    # M193: 55gr @ 3,250 fps = 1,290 ft-lbs
    # M855: 62gr @ 3,020 fps = 1,255 ft-lbs
    "5.56x45": {
        "base_damage": 42.0,        # 3-4 shots to kill at close range
        "velocity_fps": 3100,       # Average from 20" barrel
        "energy_ftlbs": 1275,       # Baseline energy
        "penetration": 0.40,        # Moderate steel core penetration
        "recoil_multiplier": 1.0,   # Baseline for rifles
        "effective_range": 600,     # Meters
        "barrel_20_velocity": 3250, # Full velocity from 20" barrel
    },
    # 7.62x39mm - Soviet/Russian intermediate round
    # 123gr @ 2,350 fps = 1,520 ft-lbs
    "7.62x39": {
        "base_damage": 48.0,        # Higher damage than 5.56
        "velocity_fps": 2350,       # From 16" barrel
        "energy_ftlbs": 1520,       # More energy than 5.56
        "penetration": 0.45,        # Better barrier penetration
        "recoil_multiplier": 1.35,  # More recoil than 5.56
        "effective_range": 400,     # Shorter effective range
        "barrel_16_velocity": 2350,
    },
    # .308 Win / 7.62x51mm NATO - Full power rifle round
    # 168gr @ 2,650 fps = 2,620 ft-lbs
    "7.62x51": {
        "base_damage": 55.0,        # 2-3 shots to kill
        "velocity_fps": 2650,       # From 20" barrel
        "energy_ftlbs": 2620,       # Double 5.56 energy
        "penetration": 0.60,        # Excellent penetration
        "recoil_multiplier": 1.80,  # Significant recoil
        "effective_range": 800,     # Extended range
        "barrel_20_velocity": 2800,
    },
    # 6.8x51mm / .277 SIG Fury - Next-gen army round
    # 135gr @ 3,000 fps = 2,697 ft-lbs (80,000 PSI!)
    "6.8x51": {
        "base_damage": 57.0,        # Highest rifle damage
        "velocity_fps": 3000,       # Exceptional velocity
        "energy_ftlbs": 2700,       # Highest energy
        "penetration": 0.70,        # Defeats Level IV armor
        "recoil_multiplier": 2.00,  # High recoil (high pressure)
        "effective_range": 1000,    # Extended effective range
        "barrel_16_velocity": 3000,
    },
    # 9mm Parabellum - SMG version (longer barrel = more velocity)
    # 124gr @ 1,250 fps from SMG barrel = 430 ft-lbs
    "9mm_smg": {
        "base_damage": 28.0,        # SMG damage lower than rifles
        "velocity_fps": 1250,       # Higher than pistol due to barrel
        "energy_ftlbs": 430,        # Modest energy
        "penetration": 0.25,        # Limited penetration
        "recoil_multiplier": 0.50,  # Low recoil, easy control
        "effective_range": 100,     # Limited range
        "barrel_8_velocity": 1250,
    },
    # .45 ACP - SMG version
    # 230gr @ 950 fps = 460 ft-lbs
    "45_acp_smg": {
        "base_damage": 32.0,        # Higher than 9mm
        "velocity_fps": 950,        # Subsonic
        "energy_ftlbs": 460,        # Slightly more than 9mm
        "penetration": 0.28,        # Limited penetration
        "recoil_multiplier": 0.70,  # More recoil than 9mm
        "effective_range": 75,      # Very limited range
        "barrel_6_velocity": 950,
    },
    # .300 Blackout - Specialized PDW round
    # 125gr @ 2,215 fps = 1,360 ft-lbs (supersonic)
    # 220gr @ 1,010 fps = 498 ft-lbs (subsonic)
    "300_blk": {
        "base_damage": 45.0,        # Between 5.56 and 7.62x39
        "velocity_fps": 2215,       # Supersonic load
        "energy_ftlbs": 1360,       # Good energy from short barrel
        "penetration": 0.42,        # Similar to 7.62x39
        "recoil_multiplier": 1.20,  # Moderate recoil
        "effective_range": 300,     # Optimized for CQB
        "barrel_9_velocity": 2215,
    },
}

# =============================================================================
# QUALITY TIERS - Affects accuracy and handling
# =============================================================================
QUALITY_TIERS = {
    "budget": {
        "accuracy_mult": 1.50,      # 50% worse accuracy
        "recoil_mult": 1.30,        # 30% more recoil
        "recovery_mult": 0.80,      # 20% slower recovery
        "damage_mult": 1.00,        # Same damage
    },
    "standard": {
        "accuracy_mult": 1.00,      # Baseline
        "recoil_mult": 1.00,
        "recovery_mult": 1.00,
        "damage_mult": 1.00,
    },
    "quality": {
        "accuracy_mult": 0.75,      # 25% better accuracy
        "recoil_mult": 0.85,        # 15% less recoil
        "recovery_mult": 1.15,      # 15% faster recovery
        "damage_mult": 1.00,
    },
    "match": {
        "accuracy_mult": 0.55,      # 45% better accuracy
        "recoil_mult": 0.70,        # 30% less recoil
        "recovery_mult": 1.30,      # 30% faster recovery
        "damage_mult": 1.00,
    },
}

# =============================================================================
# BARREL LENGTH MODIFIERS
# =============================================================================
def calculate_barrel_modifier(barrel_inches: float, caliber: str) -> dict:
    """Calculate damage/velocity modifiers based on barrel length"""
    # Baseline barrel lengths for each caliber
    baseline = {
        "5.56x45": 20.0,    # M16 standard
        "7.62x39": 16.0,    # AKM standard
        "7.62x51": 20.0,    # M14/FAL standard
        "6.8x51": 16.0,     # MCX Spear standard
        "9mm_smg": 8.0,     # Typical SMG
        "45_acp_smg": 6.0,  # MAC-10 standard
        "300_blk": 9.0,     # Optimized barrel
    }

    base = baseline.get(caliber, 16.0)
    ratio = barrel_inches / base

    # Velocity loss: approximately 25-50 fps per inch below baseline
    # More dramatic for rifle calibers
    if caliber in ["5.56x45", "7.62x51", "6.8x51"]:
        velocity_mult = 0.90 + (0.10 * ratio) if ratio < 1.0 else 1.0 + (0.02 * (ratio - 1.0))
    else:
        velocity_mult = 0.95 + (0.05 * ratio) if ratio < 1.0 else 1.0

    # Damage scales with velocity (kinetic energy = 1/2 * m * v^2)
    # But we use a more moderate scaling for game balance
    damage_mult = 0.85 + (0.15 * ratio) if ratio < 1.0 else 1.0 + (0.05 * (ratio - 1.0))
    damage_mult = min(1.10, max(0.75, damage_mult))  # Clamp 75%-110%

    # Shorter barrels = more muzzle blast, harder to control
    recoil_mult = 1.20 - (0.20 * ratio) if ratio < 1.0 else 1.0 - (0.05 * (ratio - 1.0))
    recoil_mult = min(1.30, max(0.90, recoil_mult))

    return {
        "velocity_mult": velocity_mult,
        "damage_mult": damage_mult,
        "recoil_mult": recoil_mult,
    }


# =============================================================================
# FIRE MODE MODIFIERS
# =============================================================================
FIRE_MODE = {
    "semi": {
        "time_between_shots": 0.12,  # ~500 RPM max practical
        "accuracy_mult": 1.00,
        "recoil_recovery_bonus": 0.20,
    },
    "burst": {
        "time_between_shots": 0.075,  # ~800 RPM in burst
        "accuracy_mult": 1.15,
        "recoil_recovery_bonus": 0.10,
    },
    "auto": {
        "time_between_shots": 0.070,  # ~857 RPM
        "accuracy_mult": 1.40,        # Significantly worse accuracy
        "recoil_recovery_bonus": 0.00,
    },
    "auto_fast": {
        "time_between_shots": 0.055,  # ~1,090 RPM (MAC-10 speed)
        "accuracy_mult": 1.80,        # Much worse accuracy
        "recoil_recovery_bonus": -0.10,
    },
}


@dataclass
class RifleSMGSpec:
    """Specification for a rifle or SMG"""
    name: str                    # Weapon folder name (e.g., "cz_bren")
    display_name: str            # Human readable name
    caliber: str                 # Caliber key
    barrel_inches: float         # Barrel length
    weight_lbs: float            # Empty weight
    quality: str                 # Quality tier
    fire_mode: str               # Primary fire mode
    rpm: int = 0                 # Cyclic rate if known
    notes: str = ""


# =============================================================================
# BATCH 12 - 5.56x45mm NATO Assault Rifles
# =============================================================================
BATCH12_RIFLES = [
    RifleSMGSpec("cz_bren", "CZ Bren 2", "5.56x45", 14.0, 5.86, "quality", "auto", 850,
                 "Czech modular rifle, competition-tuned gas piston, lowest recoil"),
    RifleSMGSpec("desert_ar15", "Desert AR-15", "5.56x45", 16.0, 6.5, "standard", "semi", 0,
                 "Standard AR-15 pattern, semi-auto civilian"),
    RifleSMGSpec("m16", "M16A4", "5.56x45", 20.0, 7.5, "quality", "burst", 800,
                 "Benchmark military rifle, longest barrel, best accuracy"),
    RifleSMGSpec("psa_ar15", "PSA AR-15", "5.56x45", 16.0, 6.7, "budget", "semi", 0,
                 "Budget AR-15, functional but basic"),
    RifleSMGSpec("ram7knight", "RAM-7 Knight", "5.56x45", 14.5, 6.8, "quality", "auto", 800,
                 "Compact bullpup, good ergonomics"),
    RifleSMGSpec("red_aug", "Steyr AUG", "5.56x45", 16.0, 7.9, "quality", "auto", 680,
                 "Austrian bullpup, integrated optic, reliable"),
]

# =============================================================================
# BATCH 13 - 7.62x39mm AK Variants
# =============================================================================
BATCH13_RIFLES = [
    RifleSMGSpec("mini_ak47", "Mini AK-47", "7.62x39", 10.5, 5.5, "standard", "auto", 600,
                 "Compact AK pistol, difficult control, loud"),
    RifleSMGSpec("mk47", "MK47 Mutant", "7.62x39", 16.1, 7.0, "match", "semi", 0,
                 "AR-15 ergonomics + AK caliber, best 7.62x39 accuracy"),
]

# =============================================================================
# BATCH 14 - .308/6.8mm Battle Rifles
# =============================================================================
BATCH14_RIFLES = [
    RifleSMGSpec("m7", "M7", "7.62x51", 16.0, 8.5, "quality", "semi", 0,
                 "Modern .308 battle rifle"),
    RifleSMGSpec("mcx300", "SIG MCX .300", "300_blk", 9.0, 6.8, "quality", "auto", 700,
                 ".300 Blackout PDW, optimized for suppressed use"),
    RifleSMGSpec("sig_spear", "SIG MCX Spear", "6.8x51", 16.0, 9.2, "match", "semi", 0,
                 "NGSW winner, highest damage rifle, 80,000 PSI chamber"),
]

# =============================================================================
# BATCH 15 - 9mm SMGs
# =============================================================================
BATCH15_SMGS = [
    RifleSMGSpec("micro_mp5", "Micro MP5", "9mm_smg", 4.5, 4.4, "quality", "auto", 800,
                 "HK quality, compact, reliable"),
    RifleSMGSpec("mpa30", "MPA30", "9mm_smg", 6.0, 5.5, "standard", "auto", 750,
                 "Masterpiece Arms, MAC clone improved"),
    RifleSMGSpec("ram9_desert", "RAM-9 Desert", "9mm_smg", 8.0, 5.8, "quality", "auto", 800,
                 "Modern 9mm carbine, good ergonomics"),
    RifleSMGSpec("scorpion", "CZ Scorpion", "9mm_smg", 7.7, 5.0, "quality", "auto", 850,
                 "Czech PDW, excellent trigger, low recoil"),
    RifleSMGSpec("sig_mpx", "SIG MPX", "9mm_smg", 4.5, 5.0, "match", "auto", 850,
                 "Gas-piston 9mm, smoothest recoil, suppressor-ready"),
    RifleSMGSpec("sub2000", "SUB-2000", "9mm_smg", 16.0, 4.0, "standard", "semi", 0,
                 "Folding carbine, Glock mag compatible, long barrel"),
    RifleSMGSpec("tec9", "TEC-9", "9mm_smg", 5.0, 3.1, "budget", "semi", 0,
                 "Budget machine pistol, worst accuracy, unreliable"),
]

# =============================================================================
# BATCH 16 - .45 ACP SMGs
# =============================================================================
BATCH16_SMGS = [
    RifleSMGSpec("mac10", "MAC-10", "45_acp_smg", 5.75, 6.26, "standard", "auto_fast", 1090,
                 "Classic machine pistol, extreme fire rate, uncontrollable"),
    RifleSMGSpec("mac4a1", "MAC-4A1", "45_acp_smg", 5.0, 5.8, "standard", "auto_fast", 1000,
                 "Compact MAC variant, similar characteristics"),
]

# =============================================================================
# BATCH 17 - PDWs/Short Barrel Rifles
# =============================================================================
BATCH17_PDWS = [
    RifleSMGSpec("arp_bumpstock", "ARP Bumpstock", "9mm_smg", 6.0, 5.2, "budget", "auto", 900,
                 "Budget PDW, high rate of fire"),
    RifleSMGSpec("mk18", "MK18", "5.56x45", 10.3, 6.0, "quality", "auto", 700,
                 "Navy SEAL CQB rifle, short barrel 5.56, loud"),
    RifleSMGSpec("sbr9", "SBR9", "9mm_smg", 5.5, 4.8, "standard", "auto", 850,
                 "9mm SBR, compact package"),
]


def calculate_weapon_stats(spec: RifleSMGSpec) -> dict:
    """Calculate all weapon stats based on specifications"""

    # Get base caliber data
    cal_data = CALIBER_DATA.get(spec.caliber)
    if not cal_data:
        raise ValueError(f"Unknown caliber: {spec.caliber}")

    # Get quality modifiers
    quality = QUALITY_TIERS.get(spec.quality, QUALITY_TIERS["standard"])

    # Get barrel modifiers
    barrel = calculate_barrel_modifier(spec.barrel_inches, spec.caliber)

    # Get fire mode data
    fire = FIRE_MODE.get(spec.fire_mode, FIRE_MODE["semi"])

    # Calculate base stats
    base_damage = cal_data["base_damage"] * barrel["damage_mult"] * quality["damage_mult"]

    # Weight factor: lighter = more felt recoil, heavier = more stable
    weight_baseline = 7.0  # Average rifle weight
    weight_factor = weight_baseline / spec.weight_lbs
    weight_factor = max(0.80, min(1.30, weight_factor))  # Clamp

    # Calculate recoil values
    base_recoil = cal_data["recoil_multiplier"]
    total_recoil_mult = base_recoil * barrel["recoil_mult"] * quality["recoil_mult"] * weight_factor

    # RecoilShakeAmplitude: 0.15-0.50 for SMGs, 0.20-0.45 for rifles
    if "smg" in spec.caliber:
        shake_base = 0.12
        shake_scale = 0.30
    else:
        shake_base = 0.18
        shake_scale = 0.35
    recoil_shake = shake_base + (shake_scale * total_recoil_mult)
    recoil_shake = min(0.60, max(0.10, recoil_shake))

    # RecoilShakeFrequency: higher for faster firing weapons
    rpm = spec.rpm if spec.rpm > 0 else 500
    shake_freq = 0.30 + (rpm / 2000)  # Scale with RPM
    shake_freq = min(0.75, max(0.35, shake_freq))

    # AccuracySpread: affected by quality and caliber
    base_spread = 1.0 if "smg" in spec.caliber else 0.75
    accuracy_spread = base_spread * quality["accuracy_mult"] * fire["accuracy_mult"]
    accuracy_spread = min(4.00, max(0.50, accuracy_spread))

    # RecoilAccuracyMax: how much accuracy degrades during sustained fire
    recoil_acc_max = 1.50 + (total_recoil_mult * 0.80)
    recoil_acc_max *= fire["accuracy_mult"]
    recoil_acc_max = min(5.00, max(1.20, recoil_acc_max))

    # RecoilRecoveryRate: how fast you regain accuracy after firing
    base_recovery = 0.55  # Rifles recover faster than pistols
    recovery = base_recovery * quality["recovery_mult"]
    recovery += fire["recoil_recovery_bonus"]
    recovery /= weight_factor  # Heavier = slower recovery but more stable
    recovery = min(0.85, max(0.25, recovery))

    # TimeBetweenShots: from fire mode, adjusted by weight
    time_between = fire["time_between_shots"]
    if spec.rpm > 0:
        time_between = 60.0 / spec.rpm  # Use actual RPM if known

    # Penetration: from caliber, slightly affected by barrel
    penetration = cal_data["penetration"] * (0.95 + (0.05 * barrel["velocity_mult"]))

    # Velocity (Speed): from caliber modified by barrel
    velocity = cal_data["velocity_fps"] * barrel["velocity_mult"]
    velocity_ms = velocity * 0.3048  # Convert to m/s

    # Damage falloff ranges: based on effective range
    eff_range = cal_data["effective_range"]
    falloff_min = eff_range * 0.15  # Start falloff at 15% of effective range
    falloff_max = eff_range * 0.50  # Full falloff at 50% of effective range
    falloff_modifier = 0.35 if "smg" in spec.caliber else 0.40  # SMGs lose more at range

    # Weapon range
    weapon_range = eff_range * 0.60  # Game range is 60% of real effective range

    # Force values: based on energy
    energy = cal_data["energy_ftlbs"]
    force = 40 + (energy / 20)  # Scale force with energy
    force = min(200, max(50, force))

    return {
        "Damage": round(base_damage, 1),
        "DamageFallOffRangeMin": round(falloff_min, 1),
        "DamageFallOffRangeMax": round(falloff_max, 1),
        "DamageFallOffModifier": round(falloff_modifier, 2),
        "Speed": round(velocity_ms, 1),
        "Force": round(force, 1),
        "Penetration": round(penetration, 2),
        "WeaponRange": round(weapon_range, 1),
        "TimeBetweenShots": round(time_between, 3),
        "AccuracySpread": round(accuracy_spread, 2),
        "RecoilAccuracyMax": round(recoil_acc_max, 2),
        "RecoilRecoveryRate": round(recovery, 2),
        "RecoilShakeAmplitude": round(recoil_shake, 2),
        "RecoilShakeFrequency": round(shake_freq, 2),
    }


def find_weapon_meta(batch_path: str, weapon_name: str) -> Optional[str]:
    """Find the weapon meta file"""
    # Try weapon_{name}/meta/weapon_{name}.meta
    path1 = os.path.join(batch_path, f"weapon_{weapon_name}", "meta", f"weapon_{weapon_name}.meta")
    if os.path.exists(path1):
        return path1

    # Try weapon_{name}/meta/weapons.meta
    path2 = os.path.join(batch_path, f"weapon_{weapon_name}", "meta", "weapons.meta")
    if os.path.exists(path2):
        return path2

    # Glob for any meta file
    pattern = os.path.join(batch_path, f"weapon_{weapon_name}", "meta", "*.meta")
    matches = glob.glob(pattern)
    for m in matches:
        if "weapon" in os.path.basename(m).lower():
            return m

    return None


def update_weapon_meta(file_path: str, values: dict) -> bool:
    """Update weapon meta file with new values"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        original = content

        for param, value in values.items():
            if isinstance(value, float):
                if param == "TimeBetweenShots":
                    pattern = rf'(<{param} value=")[^"]*(")'
                    replacement = rf'\g<1>{value:.3f}\2'
                elif param in ["DamageFallOffModifier", "Penetration"]:
                    pattern = rf'(<{param} value=")[^"]*(")'
                    replacement = rf'\g<1>{value:.2f}\2'
                else:
                    pattern = rf'(<{param} value=")[^"]*(")'
                    replacement = rf'\g<1>{value:.1f}\2'
                content = re.sub(pattern, replacement, content)

        if content != original:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        return False
    except Exception as e:
        print(f"  ERROR: {e}")
        return False


def process_batch(batch_path: str, weapons: list, batch_name: str, dry_run: bool = True):
    """Process all weapons in a batch"""
    print(f"\n{'='*60}")
    print(f"Processing {batch_name}")
    print(f"Path: {batch_path}")
    print(f"Mode: {'DRY RUN' if dry_run else 'APPLYING'}")
    print('='*60)

    for spec in weapons:
        print(f"\n  {spec.display_name} ({spec.caliber}, {spec.barrel_inches}\" barrel)")

        meta_path = find_weapon_meta(batch_path, spec.name)
        if not meta_path:
            print(f"    ERROR: Meta file not found for weapon_{spec.name}")
            continue

        values = calculate_weapon_stats(spec)

        print(f"    Damage: {values['Damage']}")
        print(f"    Speed: {values['Speed']} m/s")
        print(f"    Range: {values['WeaponRange']}m (falloff {values['DamageFallOffRangeMin']}-{values['DamageFallOffRangeMax']})")
        print(f"    Fire Rate: {values['TimeBetweenShots']}s ({int(60/values['TimeBetweenShots'])} RPM)")
        print(f"    Recoil: shake={values['RecoilShakeAmplitude']}, spread={values['AccuracySpread']}")
        print(f"    Recovery: {values['RecoilRecoveryRate']}")

        if not dry_run:
            if update_weapon_meta(meta_path, values):
                print(f"    ✓ Updated {os.path.basename(meta_path)}")
            else:
                print(f"    - No changes to {os.path.basename(meta_path)}")


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Rifle & SMG Damage/Handling Calculator")
    parser.add_argument("--apply", action="store_true", help="Apply changes (default is dry-run)")
    parser.add_argument("--batch", type=int, help="Process specific batch (12-17)")
    args = parser.parse_args()

    dry_run = not args.apply

    batch_configs = {
        12: (os.path.join(BASE_PATH, "batch12_weapons"), BATCH12_RIFLES, "Batch 12 - 5.56 NATO Rifles"),
        13: (os.path.join(BASE_PATH, "batch13_weapons"), BATCH13_RIFLES, "Batch 13 - 7.62x39 AK Variants"),
        14: (os.path.join(BASE_PATH, "batch14_weapons"), BATCH14_RIFLES, "Batch 14 - .308/6.8mm Battle Rifles"),
        15: (os.path.join(BASE_PATH, "batch15_weapons"), BATCH15_SMGS, "Batch 15 - 9mm SMGs"),
        16: (os.path.join(BASE_PATH, "batch16_weapons"), BATCH16_SMGS, "Batch 16 - .45 ACP SMGs"),
        17: (os.path.join(BASE_PATH, "batch17_weapons"), BATCH17_PDWS, "Batch 17 - PDWs/SBRs"),
    }

    print("Rifle & SMG Damage/Handling Calculator")
    print("="*60)

    if args.batch:
        if args.batch in batch_configs:
            path, weapons, name = batch_configs[args.batch]
            process_batch(path, weapons, name, dry_run)
        else:
            print(f"Unknown batch: {args.batch}")
    else:
        for batch_num in sorted(batch_configs.keys()):
            path, weapons, name = batch_configs[batch_num]
            process_batch(path, weapons, name, dry_run)

    if dry_run:
        print("\n" + "="*60)
        print("DRY RUN COMPLETE - Run with --apply to make changes")
        print("="*60)


if __name__ == "__main__":
    main()
