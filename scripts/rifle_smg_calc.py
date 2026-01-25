#!/usr/bin/env python3
"""
Rifle & SMG Damage/Handling Calculator - AGGRESSIVE DIFFERENTIATION

Applies realistic damage and AGGRESSIVELY DIFFERENTIATED handling values based on:
- Real-world caliber ballistics
- Barrel length effects
- Weight and ergonomics
- Quality tier (budget/standard/quality/match) with DRAMATIC differences
- Fire mode (semi/burst/full-auto)
- Perception multipliers for noticeable in-game effects

Uses same aggressive tuning philosophy as handgun weapon_calc.py:
- 4x perception multiplier for noticeable effects
- Proportional offsets for shake and flip
- Tier-based scaling with dramatic quality differences
- Floor/ceiling constraints
"""

import os
import re
from dataclasses import dataclass
from typing import Optional
import glob

BASE_PATH = "/home/user/project_pipes"

# =============================================================================
# PERCEPTION MULTIPLIERS - Make handling differences NOTICEABLE
# =============================================================================
PERCEPTION_MULTIPLIER = 3.5      # Global multiplier for handling values
SHAKE_OFFSET_BASE = 1.20         # Base offset added to shake
SHAKE_TIER_SCALE = 0.40          # Additional shake per tier deviation
FLIP_OFFSET_BASE = 0.80          # Base offset added to flip (IkRecoilDisplacement)
FLIP_TIER_SCALE = 0.15           # Additional flip per tier deviation
FLIP_GLOBAL_MULTIPLIER = 1.40    # Global flip multiplier for dramatic muzzle rise

# =============================================================================
# FLOOR/CEILING VALUES - Keep values in reasonable game range
# =============================================================================
VALUE_FLOORS = {
    "RecoilShakeAmplitude": 0.30,   # Minimum visible shake
    "IkRecoilDisplacement": 0.08,   # Minimum visible flip
    "RecoilRecoveryRate": 0.15,     # Minimum recovery
    "AccuracySpread": 0.40,         # Minimum spread (match rifles)
    "RecoilAccuracyMax": 1.50,      # Minimum accuracy degradation
}

VALUE_CEILINGS = {
    "RecoilShakeAmplitude": 3.50,   # Maximum shake (full-auto .308)
    "IkRecoilDisplacement": 2.50,   # Maximum flip
    "RecoilRecoveryRate": 1.20,     # Maximum recovery (match quality)
    "AccuracySpread": 5.00,         # Maximum spread (spray weapons)
    "RecoilAccuracyMax": 6.00,      # Maximum accuracy loss
}

# =============================================================================
# REAL-WORLD CALIBER DATA
# =============================================================================
CALIBER_DATA = {
    # 5.56x45mm NATO - Standard infantry rifle round
    "5.56x45": {
        "base_damage": 42.0,
        "velocity_fps": 3100,
        "energy_ftlbs": 1275,
        "penetration": 0.40,
        "recoil_base": 0.35,        # Low rifle recoil
        "flip_base": 0.18,          # Moderate muzzle rise
        "effective_range": 600,
        "barrel_baseline": 20.0,
    },
    # 7.62x39mm - Soviet/Russian intermediate round
    "7.62x39": {
        "base_damage": 48.0,
        "velocity_fps": 2350,
        "energy_ftlbs": 1520,
        "penetration": 0.45,
        "recoil_base": 0.50,        # Higher recoil
        "flip_base": 0.28,          # More muzzle rise
        "effective_range": 400,
        "barrel_baseline": 16.0,
    },
    # .308 Win / 7.62x51mm NATO - Full power rifle round
    "7.62x51": {
        "base_damage": 55.0,
        "velocity_fps": 2650,
        "energy_ftlbs": 2620,
        "penetration": 0.60,
        "recoil_base": 0.70,        # Significant recoil
        "flip_base": 0.40,          # Heavy muzzle rise
        "effective_range": 800,
        "barrel_baseline": 20.0,
    },
    # 6.8x51mm / .277 SIG Fury - Next-gen army round (80,000 PSI!)
    "6.8x51": {
        "base_damage": 57.0,
        "velocity_fps": 3000,
        "energy_ftlbs": 2700,
        "penetration": 0.70,
        "recoil_base": 0.75,        # High recoil (extreme pressure)
        "flip_base": 0.45,          # Heavy muzzle rise
        "effective_range": 1000,
        "barrel_baseline": 16.0,
    },
    # 9mm Parabellum - SMG version
    "9mm_smg": {
        "base_damage": 28.0,
        "velocity_fps": 1250,
        "energy_ftlbs": 430,
        "penetration": 0.25,
        "recoil_base": 0.18,        # Low recoil
        "flip_base": 0.10,          # Minimal flip
        "effective_range": 100,
        "barrel_baseline": 8.0,
    },
    # .45 ACP - SMG version
    "45_acp_smg": {
        "base_damage": 32.0,
        "velocity_fps": 950,
        "energy_ftlbs": 460,
        "penetration": 0.28,
        "recoil_base": 0.28,        # More recoil than 9mm
        "flip_base": 0.16,          # More flip
        "effective_range": 75,
        "barrel_baseline": 6.0,
    },
    # .300 Blackout - PDW round
    "300_blk": {
        "base_damage": 45.0,
        "velocity_fps": 2215,
        "energy_ftlbs": 1360,
        "penetration": 0.42,
        "recoil_base": 0.40,        # Moderate recoil
        "flip_base": 0.22,          # Moderate flip
        "effective_range": 300,
        "barrel_baseline": 9.0,
    },
}

# =============================================================================
# QUALITY TIERS - AGGRESSIVE differences between tiers
# =============================================================================
QUALITY_TIERS = {
    "budget": {
        "tier_offset": 1.0,         # +1.0 tier deviation (worse)
        "accuracy_mult": 2.00,      # 2x worse accuracy
        "recoil_mult": 1.60,        # 60% more recoil
        "recovery_mult": 0.60,      # 40% slower recovery
        "shake_mult": 1.50,         # 50% more shake
        "flip_mult": 1.40,          # 40% more flip
    },
    "standard": {
        "tier_offset": 0.0,         # Baseline
        "accuracy_mult": 1.00,
        "recoil_mult": 1.00,
        "recovery_mult": 1.00,
        "shake_mult": 1.00,
        "flip_mult": 1.00,
    },
    "quality": {
        "tier_offset": -0.5,        # -0.5 tier deviation (better)
        "accuracy_mult": 0.70,      # 30% better accuracy
        "recoil_mult": 0.80,        # 20% less recoil
        "recovery_mult": 1.25,      # 25% faster recovery
        "shake_mult": 0.75,         # 25% less shake
        "flip_mult": 0.80,          # 20% less flip
    },
    "match": {
        "tier_offset": -0.8,        # -0.8 tier deviation (much better)
        "accuracy_mult": 0.45,      # 55% better accuracy
        "recoil_mult": 0.60,        # 40% less recoil
        "recovery_mult": 1.50,      # 50% faster recovery
        "shake_mult": 0.55,         # 45% less shake
        "flip_mult": 0.60,          # 40% less flip
    },
}

# =============================================================================
# FIRE MODE MODIFIERS
# =============================================================================
FIRE_MODES = {
    "semi": {
        "rpm_max": 500,
        "accuracy_mult": 1.00,
        "recoil_mult": 1.00,
        "recovery_bonus": 0.15,
    },
    "burst": {
        "rpm_max": 800,
        "accuracy_mult": 1.20,
        "recoil_mult": 1.15,
        "recovery_bonus": 0.08,
    },
    "auto": {
        "rpm_max": 900,
        "accuracy_mult": 1.50,
        "recoil_mult": 1.30,
        "recovery_bonus": 0.00,
    },
    "auto_fast": {
        "rpm_max": 1200,
        "accuracy_mult": 2.20,       # Much worse accuracy
        "recoil_mult": 1.60,         # Much more recoil
        "recovery_bonus": -0.15,     # Recovery penalty
    },
}


def clamp(value: float, floor: float, ceiling: float) -> float:
    """Clamp value between floor and ceiling"""
    return max(floor, min(ceiling, value))


def calculate_barrel_modifier(barrel_inches: float, caliber: str) -> dict:
    """Calculate damage/velocity modifiers based on barrel length"""
    cal_data = CALIBER_DATA.get(caliber, {})
    baseline = cal_data.get("barrel_baseline", 16.0)
    ratio = barrel_inches / baseline

    # Velocity and damage scale with barrel
    if ratio < 1.0:
        velocity_mult = 0.88 + (0.12 * ratio)
        damage_mult = 0.82 + (0.18 * ratio)
        recoil_mult = 1.30 - (0.30 * ratio)  # Short barrels = more blast/recoil
    else:
        velocity_mult = 1.0 + (0.03 * (ratio - 1.0))
        damage_mult = 1.0 + (0.05 * (ratio - 1.0))
        recoil_mult = 1.0 - (0.08 * (ratio - 1.0))  # Long barrels = less recoil

    return {
        "velocity_mult": clamp(velocity_mult, 0.75, 1.15),
        "damage_mult": clamp(damage_mult, 0.75, 1.12),
        "recoil_mult": clamp(recoil_mult, 0.85, 1.40),
    }


@dataclass
class RifleSMGSpec:
    """Specification for a rifle or SMG"""
    name: str
    display_name: str
    caliber: str
    barrel_inches: float
    weight_lbs: float
    quality: str
    fire_mode: str
    rpm: int = 0
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
    """Calculate all weapon stats with AGGRESSIVE differentiation"""

    cal_data = CALIBER_DATA.get(spec.caliber)
    if not cal_data:
        raise ValueError(f"Unknown caliber: {spec.caliber}")

    quality = QUALITY_TIERS.get(spec.quality, QUALITY_TIERS["standard"])
    fire = FIRE_MODES.get(spec.fire_mode, FIRE_MODES["semi"])
    barrel = calculate_barrel_modifier(spec.barrel_inches, spec.caliber)

    # Weight factor: lighter = more felt recoil
    weight_baseline = 7.0
    weight_factor = weight_baseline / spec.weight_lbs
    weight_factor = clamp(weight_factor, 0.75, 1.40)

    # =========================================================================
    # DAMAGE CALCULATION
    # =========================================================================
    base_damage = cal_data["base_damage"] * barrel["damage_mult"]

    # =========================================================================
    # RECOIL SHAKE AMPLITUDE - with perception multiplier and tier offsets
    # =========================================================================
    shake_base = cal_data["recoil_base"] * PERCEPTION_MULTIPLIER
    shake_base *= barrel["recoil_mult"]
    shake_base *= quality["shake_mult"]
    shake_base *= fire["recoil_mult"]
    shake_base *= weight_factor

    # Add tier offset
    tier_shake_offset = SHAKE_OFFSET_BASE + (quality["tier_offset"] * SHAKE_TIER_SCALE)
    shake_final = shake_base + tier_shake_offset

    shake_final = clamp(shake_final, VALUE_FLOORS["RecoilShakeAmplitude"],
                        VALUE_CEILINGS["RecoilShakeAmplitude"])

    # =========================================================================
    # IK RECOIL DISPLACEMENT (FLIP) - with perception multiplier
    # =========================================================================
    flip_base = cal_data["flip_base"] * PERCEPTION_MULTIPLIER
    flip_base *= barrel["recoil_mult"]
    flip_base *= quality["flip_mult"]
    flip_base *= fire["recoil_mult"]
    flip_base *= weight_factor

    # Add tier offset and global multiplier
    tier_flip_offset = FLIP_OFFSET_BASE + (quality["tier_offset"] * FLIP_TIER_SCALE)
    flip_final = (flip_base + tier_flip_offset) * FLIP_GLOBAL_MULTIPLIER

    flip_final = clamp(flip_final, VALUE_FLOORS["IkRecoilDisplacement"],
                       VALUE_CEILINGS["IkRecoilDisplacement"])

    # =========================================================================
    # ACCURACY SPREAD - dramatic quality differences
    # =========================================================================
    spread_base = 0.80 if "smg" not in spec.caliber else 1.20
    spread = spread_base * quality["accuracy_mult"] * fire["accuracy_mult"]

    # Budget tier gets extra penalty
    if spec.quality == "budget":
        spread *= 1.30

    spread = clamp(spread, VALUE_FLOORS["AccuracySpread"],
                   VALUE_CEILINGS["AccuracySpread"])

    # =========================================================================
    # RECOIL ACCURACY MAX - how bad accuracy gets during sustained fire
    # =========================================================================
    acc_max_base = 2.00 if "smg" not in spec.caliber else 2.50
    acc_max = acc_max_base * quality["recoil_mult"] * fire["accuracy_mult"]

    # Full-auto modes degrade accuracy significantly more
    if spec.fire_mode in ["auto", "auto_fast"]:
        acc_max *= 1.40

    acc_max = clamp(acc_max, VALUE_FLOORS["RecoilAccuracyMax"],
                    VALUE_CEILINGS["RecoilAccuracyMax"])

    # =========================================================================
    # RECOIL RECOVERY RATE - how fast you regain accuracy
    # =========================================================================
    recovery_base = 0.50
    recovery = recovery_base * quality["recovery_mult"]
    recovery += fire["recovery_bonus"]

    # Heavy weapons recover slower but are more stable
    recovery /= (weight_factor * 0.7 + 0.3)

    recovery = clamp(recovery, VALUE_FLOORS["RecoilRecoveryRate"],
                     VALUE_CEILINGS["RecoilRecoveryRate"])

    # =========================================================================
    # SHAKE FREQUENCY - higher for faster firing weapons
    # =========================================================================
    rpm = spec.rpm if spec.rpm > 0 else fire["rpm_max"]
    shake_freq = 0.40 + (rpm / 1800)
    shake_freq = clamp(shake_freq, 0.40, 0.95)

    # =========================================================================
    # FIRE RATE - from RPM
    # =========================================================================
    time_between = 60.0 / rpm if rpm > 0 else 0.12

    # =========================================================================
    # OTHER VALUES
    # =========================================================================
    velocity_ms = cal_data["velocity_fps"] * barrel["velocity_mult"] * 0.3048
    eff_range = cal_data["effective_range"]
    falloff_min = eff_range * 0.15
    falloff_max = eff_range * 0.50
    falloff_mod = 0.35 if "smg" in spec.caliber else 0.40
    weapon_range = eff_range * 0.60
    force = 40 + (cal_data["energy_ftlbs"] / 20)
    penetration = cal_data["penetration"] * (0.95 + (0.05 * barrel["velocity_mult"]))

    return {
        "Damage": round(base_damage, 1),
        "DamageFallOffRangeMin": round(falloff_min, 1),
        "DamageFallOffRangeMax": round(falloff_max, 1),
        "DamageFallOffModifier": round(falloff_mod, 2),
        "Speed": round(velocity_ms, 1),
        "Force": round(clamp(force, 50, 180), 1),
        "Penetration": round(clamp(penetration, 0.20, 0.75), 2),
        "WeaponRange": round(weapon_range, 1),
        "TimeBetweenShots": round(time_between, 3),
        "AccuracySpread": round(spread, 2),
        "RecoilAccuracyMax": round(acc_max, 2),
        "RecoilRecoveryRate": round(recovery, 2),
        "RecoilShakeAmplitude": round(shake_final, 2),
        "RecoilShakeFrequency": round(shake_freq, 2),
        "IkRecoilDisplacement": round(flip_final, 3),
    }


def find_weapon_meta(batch_path: str, weapon_name: str) -> Optional[str]:
    """Find the weapon meta file"""
    path1 = os.path.join(batch_path, f"weapon_{weapon_name}", "meta", f"weapon_{weapon_name}.meta")
    if os.path.exists(path1):
        return path1

    path2 = os.path.join(batch_path, f"weapon_{weapon_name}", "meta", "weapons.meta")
    if os.path.exists(path2):
        return path2

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
                elif param == "IkRecoilDisplacement":
                    pattern = rf'(<{param} value=")[^"]*(")'
                    replacement = rf'\g<1>{value:.3f}\2'
                elif param in ["DamageFallOffModifier", "Penetration"]:
                    pattern = rf'(<{param} value=")[^"]*(")'
                    replacement = rf'\g<1>{value:.2f}\2'
                else:
                    pattern = rf'(<{param} value=")[^"]*(")'
                    replacement = rf'\g<1>{value:.2f}\2'
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
    print(f"\n{'='*70}")
    print(f"Processing {batch_name}")
    print(f"Path: {batch_path}")
    print(f"Mode: {'DRY RUN' if dry_run else 'APPLYING'}")
    print('='*70)

    for spec in weapons:
        print(f"\n  {spec.display_name} ({spec.caliber}, {spec.quality} tier)")

        meta_path = find_weapon_meta(batch_path, spec.name)
        if not meta_path:
            print(f"    ERROR: Meta file not found for weapon_{spec.name}")
            continue

        values = calculate_weapon_stats(spec)

        print(f"    Damage: {values['Damage']} | Range: {values['WeaponRange']}m")
        print(f"    Fire Rate: {values['TimeBetweenShots']}s ({int(60/values['TimeBetweenShots'])} RPM)")
        print(f"    Shake: {values['RecoilShakeAmplitude']} | Flip: {values['IkRecoilDisplacement']}")
        print(f"    Spread: {values['AccuracySpread']} | AccMax: {values['RecoilAccuracyMax']}")
        print(f"    Recovery: {values['RecoilRecoveryRate']}")

        if not dry_run:
            if update_weapon_meta(meta_path, values):
                print(f"    ✓ Updated")
            else:
                print(f"    - No changes")


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Rifle & SMG Damage/Handling Calculator")
    parser.add_argument("--apply", action="store_true", help="Apply changes")
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

    print("="*70)
    print("Rifle & SMG Handling Calculator - AGGRESSIVE DIFFERENTIATION")
    print("="*70)
    print(f"Perception Multiplier: {PERCEPTION_MULTIPLIER}x")
    print(f"Flip Global Multiplier: {FLIP_GLOBAL_MULTIPLIER}x")

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
        print("\n" + "="*70)
        print("DRY RUN COMPLETE - Run with --apply to make changes")
        print("="*70)


if __name__ == "__main__":
    main()
