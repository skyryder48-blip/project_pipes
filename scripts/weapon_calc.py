#!/usr/bin/env python3
"""
Weapon Handling Differentiation Calculator

Calculates weapon handling values based on:
- Caliber multipliers
- Quality/condition tiers
- Switch/full-auto modifiers
- Weight factors
"""

import os
import re
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from typing import Optional
import json

# =============================================================================
# CALIBER MULTIPLIERS
# =============================================================================
CALIBER_MULTIPLIERS = {
    ".22_lr": 0.25,
    "9mm": 1.00,
    ".45_acp": 1.40,
    ".40_sw": 1.20,
    "10mm": 1.35,
    ".357_mag": 2.20,
    ".44_mag": 2.80,
    ".500_sw": 5.00,
    "5.7x28": 0.60,
    ".380_acp": 0.70,
}

# =============================================================================
# QUALITY/CONDITION TIER MULTIPLIERS (More aggressive for profound feel)
# =============================================================================
QUALITY_TIERS = {
    "worn": 2.00,      # Junk, neglected, worn weapons - significantly worse
    "standard": 1.00,  # Most service pistols - baseline
    "quality": 0.60,   # Premium brands, well-maintained - noticeably better
    "match": 0.40,     # Competition/military grade precision - excellent
}

# =============================================================================
# WORN/SWITCH ACCURACY PENALTY (Option D - wild spread for degraded weapons)
# =============================================================================
WORN_ACCURACY_MULTIPLIER = 2.00  # Worn weapons have 100% worse accuracy spread
SWITCH_ACCURACY_ALREADY_SET = True  # Switch ranges already include high spread

# =============================================================================
# SWITCH/FULL-AUTO MULTIPLIER
# =============================================================================
SWITCH_MULTIPLIER = 2.50  # Full-auto = exponential recoil increase

# =============================================================================
# BASE VALUES (9mm Standard baseline)
# =============================================================================
BASE_VALUES = {
    "RecoilShakeAmplitude": 0.22,
    "IkRecoilDisplacement": 0.022,
    "RecoilRecoveryRate": 0.85,
    "TimeBetweenShots": 0.19,
    "AccuracySpread": 1.50,
    "RecoilAccuracyMax": 1.80,
}

# =============================================================================
# GLOBAL MULTIPLIER - Apply 4x to make values perceptible
# =============================================================================
PERCEPTION_MULTIPLIER = 4.0  # Increased from 2.5x for more noticeable effects

# =============================================================================
# PROPORTIONAL OFFSETS - Scaled by parameter type
# =============================================================================
SHAKE_BASE_OFFSET = 0.80     # Base offset for shake
SHAKE_TIER_SCALE = 0.40      # Additional per tier deviation from standard
FLIP_BASE_OFFSET = 0.10      # Base offset for flip
FLIP_TIER_SCALE = 0.05       # Additional per tier deviation
FIRE_RATE_BASE_OFFSET = 0.30 # Base offset for fire rate

# =============================================================================
# FLOOR/CEILING VALUES - Ensures values stay in perceptible/reasonable range
# =============================================================================
VALUE_FLOORS = {
    "RecoilShakeAmplitude": 1.00,   # Minimum shake - always noticeable
    "IkRecoilDisplacement": 0.10,   # Minimum flip - always visible
    "RecoilRecoveryRate": 0.03,     # Minimum recovery - nearly uncontrollable
    "TimeBetweenShots": 0.40,       # Minimum time - prevents unrealistic speed
    "AccuracySpread": 0.50,         # Minimum spread
    "RecoilAccuracyMax": 1.00,      # Minimum accuracy penalty
}

VALUE_CEILINGS = {
    "RecoilShakeAmplitude": 6.50,   # Maximum shake - screen shaking chaos
    "IkRecoilDisplacement": 0.70,   # Maximum flip - gun pointing at sky
    "RecoilRecoveryRate": 2.50,     # Maximum recovery - instant stabilization
    "TimeBetweenShots": 2.00,       # Maximum time - very slow deliberate fire
    "AccuracySpread": 6.00,         # Maximum spread - can't hit anything
    "RecoilAccuracyMax": 6.00,      # Maximum accuracy penalty
}

# =============================================================================
# FIRE RATE RECOVERY LINK - Poor recovery = slower effective fire rate
# =============================================================================
RECOVERY_FIRE_RATE_FACTOR = 0.30   # How much recovery affects fire rate
RECOVERY_BASELINE = 1.50           # Recovery value considered "normal"

# =============================================================================
# PARAMETER RANGES BY CALIBER (with 4x perception multiplier applied)
# =============================================================================
PARAMETER_RANGES = {
    ".22_lr": {
        # Shake: base 0.02-0.06 * 4 = 0.08-0.24
        "RecoilShakeAmplitude": (0.08, 0.24),
        # Flip: base 0.003-0.008 * 4 = 0.012-0.032
        "IkRecoilDisplacement": (0.012, 0.032),
        # Recovery: stretched range
        "RecoilRecoveryRate": (1.80, 0.50),
        # Fire rate: widened
        "TimeBetweenShots": (0.08, 0.24),
        "AccuracySpread": (0.40, 0.90),
        "RecoilAccuracyMax": (0.60, 1.20),
    },
    "9mm": {
        # Shake: base 0.12-0.35 * 4 = 0.48-1.40
        "RecoilShakeAmplitude": (0.50, 1.45),
        # Flip: base 0.015-0.035 * 4 = 0.06-0.14
        "IkRecoilDisplacement": (0.060, 0.145),
        # Recovery: stretched range
        "RecoilRecoveryRate": (1.60, 0.20),
        # Fire rate: widened
        "TimeBetweenShots": (0.12, 0.42),
        "AccuracySpread": (0.80, 2.00),
        "RecoilAccuracyMax": (1.20, 2.50),
    },
    ".45_acp": {
        # Shake: base 0.20-0.55 * 4 = 0.80-2.20
        "RecoilShakeAmplitude": (0.80, 2.25),
        # Flip: base 0.025-0.055 * 4 = 0.10-0.22
        "IkRecoilDisplacement": (0.100, 0.225),
        # Recovery: stretched range
        "RecoilRecoveryRate": (1.50, 0.15),
        # Fire rate: widened
        "TimeBetweenShots": (0.14, 0.60),
        "AccuracySpread": (0.65, 2.20),
        "RecoilAccuracyMax": (1.50, 3.00),
    },
    ".40_sw": {
        # Shake: base 0.18-0.45 * 4 = 0.72-1.80
        "RecoilShakeAmplitude": (0.72, 1.85),
        # Flip: base 0.020-0.045 * 4 = 0.08-0.18
        "IkRecoilDisplacement": (0.080, 0.185),
        # Recovery: stretched
        "RecoilRecoveryRate": (1.55, 0.18),
        # Fire rate: widened
        "TimeBetweenShots": (0.13, 0.50),
        "AccuracySpread": (0.75, 2.10),
        "RecoilAccuracyMax": (1.35, 2.75),
    },
    "10mm": {
        # Shake: base 0.22-0.50 * 4 = 0.88-2.00
        "RecoilShakeAmplitude": (0.88, 2.00),
        # Flip: base 0.022-0.050 * 4 = 0.088-0.20
        "IkRecoilDisplacement": (0.088, 0.200),
        # Recovery: stretched
        "RecoilRecoveryRate": (1.45, 0.16),
        # Fire rate: widened
        "TimeBetweenShots": (0.14, 0.52),
        "AccuracySpread": (0.70, 2.15),
        "RecoilAccuracyMax": (1.40, 2.85),
    },
    ".357_mag": {
        # Shake: base 0.50-0.95 * 4 = 2.00-3.80
        "RecoilShakeAmplitude": (2.00, 3.85),
        # Flip: base 0.045-0.090 * 4 = 0.18-0.36
        "IkRecoilDisplacement": (0.180, 0.360),
        # Recovery: stretched (revolvers are slow)
        "RecoilRecoveryRate": (0.40, 0.08),
        # Fire rate: widened for DA/SA difference
        "TimeBetweenShots": (0.35, 1.20),
        "AccuracySpread": (0.55, 1.80),
        "RecoilAccuracyMax": (2.00, 3.50),
    },
    ".44_mag": {
        # Shake: base 0.65-1.20 * 4 = 2.60-4.80
        "RecoilShakeAmplitude": (2.65, 4.80),
        # Flip: base 0.060-0.110 * 4 = 0.24-0.44
        "IkRecoilDisplacement": (0.240, 0.450),
        # Recovery: very slow
        "RecoilRecoveryRate": (0.30, 0.06),
        # Fire rate: slow
        "TimeBetweenShots": (0.50, 1.50),
        "AccuracySpread": (0.60, 2.00),
        "RecoilAccuracyMax": (2.40, 3.80),
    },
    ".500_sw": {
        # Shake: base 0.85-1.50 * 4 = 3.40-6.00
        "RecoilShakeAmplitude": (3.40, 6.00),
        # Flip: base 0.080-0.150 * 4 = 0.32-0.60
        "IkRecoilDisplacement": (0.320, 0.600),
        # Recovery: extremely slow
        "RecoilRecoveryRate": (0.20, 0.04),
        # Fire rate: very slow
        "TimeBetweenShots": (0.70, 1.90),
        "AccuracySpread": (0.70, 2.40),
        "RecoilAccuracyMax": (2.80, 4.50),
    },
    "5.7x28": {
        # Shake: base 0.06-0.15 * 4 = 0.24-0.60
        "RecoilShakeAmplitude": (0.24, 0.65),
        # Flip: base 0.006-0.015 * 4 = 0.024-0.06
        "IkRecoilDisplacement": (0.024, 0.065),
        # Recovery: fast
        "RecoilRecoveryRate": (1.70, 0.45),
        # Fire rate: fast
        "TimeBetweenShots": (0.10, 0.30),
        "AccuracySpread": (0.35, 1.00),
        "RecoilAccuracyMax": (0.80, 1.60),
    },
    ".380_acp": {
        # Shake: base 0.08-0.20 * 4 = 0.32-0.80
        "RecoilShakeAmplitude": (0.32, 0.80),
        # Flip: base 0.008-0.020 * 4 = 0.032-0.08
        "IkRecoilDisplacement": (0.032, 0.080),
        # Recovery: moderate
        "RecoilRecoveryRate": (1.65, 0.35),
        # Fire rate: moderate
        "TimeBetweenShots": (0.11, 0.35),
        "AccuracySpread": (0.60, 1.55),
        "RecoilAccuracyMax": (1.00, 2.00),
    },
}

# =============================================================================
# SWITCH PARAMETER OVERRIDES (full-auto specific) - with 4x perception multiplier
# =============================================================================
SWITCH_RANGES = {
    "9mm": {
        # Shake: 0.75 * 4 = 3.0
        "RecoilShakeAmplitude": 3.00,
        # Flip: 0.085 * 4 = 0.34
        "IkRecoilDisplacement": 0.340,
        # Recovery: near zero control
        "RecoilRecoveryRate": 0.06,
        # Fire rate: full-auto ~1200 RPM
        "TimeBetweenShots": 0.052,
        "AccuracySpread": 4.50,
        "RecoilAccuracyMax": 4.50,
    },
    ".45_acp": {
        # Shake: 1.20 * 4 = 4.8
        "RecoilShakeAmplitude": 4.80,
        # Flip: 0.130 * 4 = 0.52
        "IkRecoilDisplacement": 0.520,
        # Recovery: basically uncontrollable
        "RecoilRecoveryRate": 0.04,
        # Fire rate: full-auto ~900 RPM
        "TimeBetweenShots": 0.065,
        "AccuracySpread": 5.50,
        "RecoilAccuracyMax": 5.50,
    },
}


@dataclass
class WeaponSpec:
    """Specification for a weapon's handling characteristics"""
    name: str
    caliber: str
    quality_tier: str
    is_switch: bool = False
    weight_oz: float = 30.0  # Default weight for weight factor calculation
    notes: str = ""


# =============================================================================
# WEAPON DEFINITIONS - BATCH 1 (Compact 9mm)
# =============================================================================
BATCH1_WEAPONS = [
    WeaponSpec("g26", "9mm", "standard", False, 26.0, "Glock 26 subcompact"),
    WeaponSpec("g26_switch", "9mm", "standard", True, 26.0, "Glock 26 with auto sear"),
    WeaponSpec("g43x", "9mm", "quality", False, 23.0, "Glock 43X slim"),
    WeaponSpec("gx4", "9mm", "standard", False, 22.0, "Taurus GX4"),
    WeaponSpec("hellcat", "9mm", "quality", False, 18.0, "Springfield Hellcat"),
]

# =============================================================================
# WEAPON DEFINITIONS - BATCH 3 (.45 ACP)
# =============================================================================
BATCH3_WEAPONS = [
    WeaponSpec("g21", "45_acp", "standard", False, 38.0, "Glock 21 full size"),
    WeaponSpec("g30", "45_acp", "standard", False, 34.0, "Glock 30 compact"),
    WeaponSpec("g41", "45_acp", "quality", False, 36.0, "Glock 41 competition"),
    WeaponSpec("junk1911", "45_acp", "worn", False, 39.0, "Worn/neglected 1911"),
    WeaponSpec("kimber1911", "45_acp", "quality", False, 38.0, "Kimber Custom"),
    WeaponSpec("kimber_eclipse", "45_acp", "match", False, 38.0, "Kimber Eclipse Target"),
    WeaponSpec("m45a1", "45_acp", "match", False, 40.0, "USMC M45A1 MEUSOC"),
]


def normalize_caliber(caliber: str) -> str:
    """Normalize caliber string for lookup"""
    caliber = caliber.lower().replace(" ", "_").replace("-", "_")
    if caliber in ["45_acp", ".45_acp", "45acp"]:
        return ".45_acp"
    if caliber in ["9mm", "9x19"]:
        return "9mm"
    if caliber in ["22_lr", ".22_lr", "22lr"]:
        return ".22_lr"
    if caliber in ["40_sw", ".40_sw", "40sw"]:
        return ".40_sw"
    if caliber in ["357_mag", ".357_mag", "357mag"]:
        return ".357_mag"
    if caliber in ["44_mag", ".44_mag", "44mag"]:
        return ".44_mag"
    if caliber in ["500_sw", ".500_sw", "500sw"]:
        return ".500_sw"
    if caliber in ["5.7x28", "57x28", "5_7x28"]:
        return "5.7x28"
    if caliber in ["380_acp", ".380_acp", "380acp"]:
        return ".380_acp"
    if caliber in ["10mm"]:
        return "10mm"
    return caliber


def calculate_weight_factor(weight_oz: float) -> float:
    """Calculate weight factor - lighter guns = more felt recoil"""
    baseline_weight = 30.0
    return baseline_weight / weight_oz


def interpolate_value(min_val: float, max_val: float, quality_factor: float) -> float:
    """
    Interpolate between min and max based on quality factor.
    Lower quality factor (match=0.40) = closer to min (better)
    Higher quality factor (worn=2.00) = closer to max (worse)
    """
    # Normalize quality factor to 0-1 range
    # worn=2.00 -> 1.0, match=0.40 -> 0.0
    normalized = (quality_factor - 0.40) / (2.00 - 0.40)
    normalized = max(0.0, min(1.0, normalized))
    return min_val + (max_val - min_val) * normalized


def clamp_value(value: float, param: str) -> float:
    """Clamp a value between its floor and ceiling"""
    floor = VALUE_FLOORS.get(param, 0.0)
    ceiling = VALUE_CEILINGS.get(param, float('inf'))
    return max(floor, min(ceiling, value))


def calculate_tier_offset(quality_tier: str) -> float:
    """Calculate how far from standard this tier is (for proportional offsets)"""
    # standard = 0, quality/match = negative, worn = positive
    tier_values = {"worn": 1.0, "standard": 0.0, "quality": -0.4, "match": -0.6}
    return tier_values.get(quality_tier, 0.0)


def calculate_weapon_values(spec: WeaponSpec) -> dict:
    """Calculate all handling values for a weapon"""
    caliber = normalize_caliber(spec.caliber)

    if caliber not in PARAMETER_RANGES:
        raise ValueError(f"Unknown caliber: {caliber}")

    ranges = PARAMETER_RANGES[caliber]
    quality_factor = QUALITY_TIERS.get(spec.quality_tier, 1.0)
    weight_factor = calculate_weight_factor(spec.weight_oz)
    tier_offset = calculate_tier_offset(spec.quality_tier)

    values = {}

    # If it's a switch weapon, use switch-specific values
    if spec.is_switch and caliber in SWITCH_RANGES:
        switch_vals = SWITCH_RANGES[caliber]
        for param, val in switch_vals.items():
            values[param] = val
    else:
        for param, (min_val, max_val) in ranges.items():
            base_value = interpolate_value(min_val, max_val, quality_factor)

            # Apply weight factor to recoil-related parameters
            if param in ["RecoilShakeAmplitude", "IkRecoilDisplacement"]:
                base_value *= weight_factor

            # For RecoilRecoveryRate, higher is better, so invert weight factor effect
            if param == "RecoilRecoveryRate":
                base_value /= weight_factor

            values[param] = base_value

        # Option D: Apply worn accuracy penalty for wild spread on degraded weapons
        if spec.quality_tier == "worn":
            if "AccuracySpread" in values:
                values["AccuracySpread"] *= WORN_ACCURACY_MULTIPLIER
            if "RecoilAccuracyMax" in values:
                values["RecoilAccuracyMax"] *= WORN_ACCURACY_MULTIPLIER

    # Apply proportional offsets based on tier
    if "RecoilShakeAmplitude" in values:
        proportional_offset = SHAKE_BASE_OFFSET + (tier_offset * SHAKE_TIER_SCALE)
        values["RecoilShakeAmplitude"] += proportional_offset

    if "IkRecoilDisplacement" in values:
        proportional_offset = FLIP_BASE_OFFSET + (tier_offset * FLIP_TIER_SCALE)
        values["IkRecoilDisplacement"] += proportional_offset

    # Apply base fire rate offset
    if "TimeBetweenShots" in values:
        values["TimeBetweenShots"] += FIRE_RATE_BASE_OFFSET

    # Link fire rate to recovery - poor recovery = slower effective follow-up
    # NOTE: Switch weapons bypass this - they fire fast but with wild inaccuracy
    if "RecoilRecoveryRate" in values and "TimeBetweenShots" in values and not spec.is_switch:
        recovery = values["RecoilRecoveryRate"]
        # If recovery is below baseline, add penalty to fire rate
        recovery_penalty = max(0, (RECOVERY_BASELINE - recovery) * RECOVERY_FIRE_RATE_FACTOR)
        values["TimeBetweenShots"] += recovery_penalty

    # Apply floor/ceiling constraints to all values
    for param in values:
        values[param] = clamp_value(values[param], param)

    # Round values appropriately
    for param in values:
        if param == "TimeBetweenShots":
            values[param] = round(values[param], 3)
        elif param in ["IkRecoilDisplacement"]:
            values[param] = round(values[param], 4)
        else:
            values[param] = round(values[param], 2)

    return values


def generate_reference_table(weapons: list[WeaponSpec], batch_name: str) -> str:
    """Generate markdown reference table for a batch of weapons"""
    lines = [
        f"## {batch_name}",
        "",
        "| Weapon | Caliber | Tier | Switch | Shake | Flip | Recovery | FireRate | Spread | AccMax |",
        "|--------|---------|------|--------|-------|------|----------|----------|--------|--------|",
    ]

    for spec in weapons:
        values = calculate_weapon_values(spec)
        switch_mark = "YES" if spec.is_switch else "-"
        lines.append(
            f"| {spec.name} | {spec.caliber} | {spec.quality_tier} | {switch_mark} | "
            f"{values['RecoilShakeAmplitude']:.2f} | {values['IkRecoilDisplacement']:.4f} | "
            f"{values['RecoilRecoveryRate']:.2f} | {values['TimeBetweenShots']:.3f} | "
            f"{values['AccuracySpread']:.2f} | {values['RecoilAccuracyMax']:.2f} |"
        )

    return "\n".join(lines)


def update_weapon_meta(file_path: str, values: dict) -> bool:
    """Update a weapon meta file with new handling values"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        original_content = content

        # Update each parameter
        for param, value in values.items():
            # Handle different value formats
            if param == "TimeBetweenShots":
                pattern = rf'(<{param} value=")[^"]*(")'
                replacement = rf'\g<1>{value:.6f}\2'
            elif param == "IkRecoilDisplacement":
                pattern = rf'(<{param} value=")[^"]*(")'
                replacement = rf'\g<1>{value:.6f}\2'
            else:
                pattern = rf'(<{param} value=")[^"]*(")'
                replacement = rf'\g<1>{value:.6f}\2'

            content = re.sub(pattern, replacement, content)

        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        return False
    except Exception as e:
        print(f"Error updating {file_path}: {e}")
        return False


def find_weapon_meta_file(base_path: str, weapon_name: str) -> Optional[str]:
    """Find the weapon meta file for a given weapon"""
    weapon_dir = f"weapon_{weapon_name}"
    meta_file = f"weapon_{weapon_name}.meta"
    full_path = os.path.join(base_path, weapon_dir, "meta", meta_file)

    if os.path.exists(full_path):
        return full_path
    return None


def process_batch(batch_path: str, weapons: list[WeaponSpec], dry_run: bool = True) -> dict:
    """Process all weapons in a batch"""
    results = {
        "updated": [],
        "skipped": [],
        "errors": [],
    }

    for spec in weapons:
        meta_path = find_weapon_meta_file(batch_path, spec.name)

        if not meta_path:
            results["errors"].append(f"{spec.name}: meta file not found")
            continue

        values = calculate_weapon_values(spec)

        if dry_run:
            results["updated"].append({
                "weapon": spec.name,
                "path": meta_path,
                "values": values,
            })
        else:
            if update_weapon_meta(meta_path, values):
                results["updated"].append({
                    "weapon": spec.name,
                    "path": meta_path,
                    "values": values,
                })
            else:
                results["skipped"].append(f"{spec.name}: no changes made")

    return results


def main():
    """Main entry point"""
    import argparse

    parser = argparse.ArgumentParser(description="Weapon Handling Calculator")
    parser.add_argument("--batch", type=int, help="Process specific batch (1 or 3)")
    parser.add_argument("--apply", action="store_true", help="Apply changes (default is dry-run)")
    parser.add_argument("--reference", action="store_true", help="Generate reference tables only")
    parser.add_argument("--weapon", type=str, help="Calculate values for specific weapon")
    args = parser.parse_args()

    base_path = "/home/user/project_pipes"

    batch_configs = {
        1: {
            "path": os.path.join(base_path, "Batch1_Compact_9mm_Pistols"),
            "weapons": BATCH1_WEAPONS,
            "name": "Batch 1 - Compact 9mm Pistols",
        },
        3: {
            "path": os.path.join(base_path, "batch3_45acp"),
            "weapons": BATCH3_WEAPONS,
            "name": "Batch 3 - .45 ACP Pistols",
        },
    }

    if args.reference:
        print("# Weapon Handling Reference Tables\n")
        for batch_num, config in batch_configs.items():
            print(generate_reference_table(config["weapons"], config["name"]))
            print("\n")
        return

    if args.weapon:
        # Find weapon in any batch
        for config in batch_configs.values():
            for spec in config["weapons"]:
                if spec.name == args.weapon:
                    values = calculate_weapon_values(spec)
                    print(f"\n{spec.name} ({spec.caliber}, {spec.quality_tier}):")
                    for param, val in values.items():
                        print(f"  {param}: {val}")
                    return
        print(f"Weapon '{args.weapon}' not found")
        return

    if args.batch:
        if args.batch not in batch_configs:
            print(f"Unknown batch: {args.batch}")
            return

        config = batch_configs[args.batch]
        print(f"\nProcessing {config['name']}...")
        print(f"Path: {config['path']}")
        print(f"Dry run: {not args.apply}\n")

        results = process_batch(config["path"], config["weapons"], dry_run=not args.apply)

        if results["updated"]:
            print("Updated weapons:")
            for item in results["updated"]:
                print(f"  - {item['weapon']}")
                for param, val in item["values"].items():
                    print(f"      {param}: {val}")

        if results["errors"]:
            print("\nErrors:")
            for err in results["errors"]:
                print(f"  - {err}")
    else:
        # Process all configured batches
        for batch_num, config in batch_configs.items():
            print(f"\n{'='*60}")
            print(f"Processing {config['name']}...")
            print(f"Path: {config['path']}")
            print(f"Dry run: {not args.apply}")
            print('='*60)

            results = process_batch(config["path"], config["weapons"], dry_run=not args.apply)

            if results["updated"]:
                print("\nUpdated weapons:")
                for item in results["updated"]:
                    print(f"\n  {item['weapon']}:")
                    for param, val in item["values"].items():
                        print(f"    {param}: {val}")

            if results["errors"]:
                print("\nErrors:")
                for err in results["errors"]:
                    print(f"  - {err}")


if __name__ == "__main__":
    main()
