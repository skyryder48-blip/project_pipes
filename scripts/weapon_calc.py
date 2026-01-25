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
# QUALITY/CONDITION TIER MULTIPLIERS
# =============================================================================
QUALITY_TIERS = {
    "worn": 1.80,      # Junk, neglected, worn weapons
    "standard": 1.00,  # Most service pistols
    "quality": 0.70,   # Premium brands, well-maintained
    "match": 0.55,     # Competition/military grade precision
}

# =============================================================================
# WORN/SWITCH ACCURACY PENALTY (Option D - wild spread for degraded weapons)
# =============================================================================
WORN_ACCURACY_MULTIPLIER = 1.75  # Worn weapons have 75% worse accuracy spread
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
# GLOBAL MULTIPLIER - Apply 2.5x to make values perceptible
# =============================================================================
PERCEPTION_MULTIPLIER = 2.5  # 2x-3x range, using middle value

# =============================================================================
# PARAMETER RANGES BY CALIBER (with 2.5x perception multiplier applied)
# =============================================================================
PARAMETER_RANGES = {
    ".22_lr": {
        # Shake: 0.02-0.06 * 2.5 = 0.05-0.15
        "RecoilShakeAmplitude": (0.05, 0.15),
        # Flip: 0.003-0.008 * 2.5 = 0.0075-0.02
        "IkRecoilDisplacement": (0.008, 0.020),
        # Recovery: inverted scale, 1.40-0.90 stretched to 1.60-0.60
        "RecoilRecoveryRate": (1.60, 0.60),
        # Fire rate: widened range 0.08-0.22 (was 0.10-0.18)
        "TimeBetweenShots": (0.08, 0.22),
        "AccuracySpread": (0.40, 0.80),
        "RecoilAccuracyMax": (0.60, 1.00),
    },
    "9mm": {
        # Shake: 0.12-0.35 * 2.5 = 0.30-0.875
        "RecoilShakeAmplitude": (0.30, 0.90),
        # Flip: 0.015-0.035 * 2.5 = 0.0375-0.0875
        "IkRecoilDisplacement": (0.040, 0.090),
        # Recovery: stretched range 1.40-0.25 (was 1.20-0.45)
        "RecoilRecoveryRate": (1.40, 0.25),
        # Fire rate: widened range 0.12-0.38 (was 0.15-0.28)
        "TimeBetweenShots": (0.12, 0.38),
        "AccuracySpread": (0.80, 1.80),
        "RecoilAccuracyMax": (1.20, 2.20),
    },
    ".45_acp": {
        # Shake: 0.20-0.55 * 2.5 = 0.50-1.375
        "RecoilShakeAmplitude": (0.50, 1.40),
        # Flip: 0.025-0.055 * 2.5 = 0.0625-0.1375
        "IkRecoilDisplacement": (0.065, 0.140),
        # Recovery: stretched range 1.30-0.18 (was 1.10-0.35)
        "RecoilRecoveryRate": (1.30, 0.18),
        # Fire rate: widened range 0.15-0.55 (was 0.18-0.40)
        "TimeBetweenShots": (0.15, 0.55),
        "AccuracySpread": (0.65, 2.00),
        "RecoilAccuracyMax": (1.50, 2.80),
    },
    ".40_sw": {
        # Shake: 0.18-0.45 * 2.5 = 0.45-1.125
        "RecoilShakeAmplitude": (0.45, 1.15),
        # Flip: 0.020-0.045 * 2.5 = 0.05-0.1125
        "IkRecoilDisplacement": (0.050, 0.115),
        # Recovery: stretched
        "RecoilRecoveryRate": (1.35, 0.22),
        # Fire rate: widened
        "TimeBetweenShots": (0.13, 0.45),
        "AccuracySpread": (0.75, 1.90),
        "RecoilAccuracyMax": (1.35, 2.50),
    },
    "10mm": {
        # Shake: 0.22-0.50 * 2.5 = 0.55-1.25
        "RecoilShakeAmplitude": (0.55, 1.25),
        # Flip: 0.022-0.050 * 2.5 = 0.055-0.125
        "IkRecoilDisplacement": (0.055, 0.125),
        # Recovery: stretched
        "RecoilRecoveryRate": (1.25, 0.20),
        # Fire rate: widened
        "TimeBetweenShots": (0.14, 0.48),
        "AccuracySpread": (0.70, 1.95),
        "RecoilAccuracyMax": (1.40, 2.60),
    },
    ".357_mag": {
        # Shake: 0.50-0.95 * 2.5 = 1.25-2.375
        "RecoilShakeAmplitude": (1.25, 2.40),
        # Flip: 0.045-0.090 * 2.5 = 0.1125-0.225
        "IkRecoilDisplacement": (0.115, 0.225),
        # Recovery: stretched (revolvers are slow)
        "RecoilRecoveryRate": (0.45, 0.10),
        # Fire rate: widened for DA/SA difference
        "TimeBetweenShots": (0.35, 1.10),
        "AccuracySpread": (0.55, 1.60),
        "RecoilAccuracyMax": (2.00, 3.20),
    },
    ".44_mag": {
        # Shake: 0.65-1.20 * 2.5 = 1.625-3.0
        "RecoilShakeAmplitude": (1.65, 3.00),
        # Flip: 0.060-0.110 * 2.5 = 0.15-0.275
        "IkRecoilDisplacement": (0.150, 0.280),
        # Recovery: very slow
        "RecoilRecoveryRate": (0.35, 0.08),
        # Fire rate: slow
        "TimeBetweenShots": (0.50, 1.40),
        "AccuracySpread": (0.60, 1.80),
        "RecoilAccuracyMax": (2.40, 3.60),
    },
    ".500_sw": {
        # Shake: 0.85-1.50 * 2.5 = 2.125-3.75
        "RecoilShakeAmplitude": (2.15, 3.75),
        # Flip: 0.080-0.150 * 2.5 = 0.20-0.375
        "IkRecoilDisplacement": (0.200, 0.380),
        # Recovery: extremely slow
        "RecoilRecoveryRate": (0.25, 0.05),
        # Fire rate: very slow
        "TimeBetweenShots": (0.70, 1.80),
        "AccuracySpread": (0.70, 2.20),
        "RecoilAccuracyMax": (2.80, 4.20),
    },
    "5.7x28": {
        # Shake: 0.06-0.15 * 2.5 = 0.15-0.375
        "RecoilShakeAmplitude": (0.15, 0.40),
        # Flip: 0.006-0.015 * 2.5 = 0.015-0.0375
        "IkRecoilDisplacement": (0.015, 0.040),
        # Recovery: fast
        "RecoilRecoveryRate": (1.50, 0.50),
        # Fire rate: fast
        "TimeBetweenShots": (0.10, 0.28),
        "AccuracySpread": (0.35, 0.90),
        "RecoilAccuracyMax": (0.80, 1.40),
    },
    ".380_acp": {
        # Shake: 0.08-0.20 * 2.5 = 0.20-0.50
        "RecoilShakeAmplitude": (0.20, 0.50),
        # Flip: 0.008-0.020 * 2.5 = 0.02-0.05
        "IkRecoilDisplacement": (0.020, 0.050),
        # Recovery: moderate
        "RecoilRecoveryRate": (1.45, 0.40),
        # Fire rate: moderate
        "TimeBetweenShots": (0.11, 0.32),
        "AccuracySpread": (0.60, 1.40),
        "RecoilAccuracyMax": (1.00, 1.80),
    },
}

# =============================================================================
# SWITCH PARAMETER OVERRIDES (full-auto specific) - with 2.5x perception multiplier
# =============================================================================
SWITCH_RANGES = {
    "9mm": {
        # Shake: 0.75 * 2.5 = 1.875
        "RecoilShakeAmplitude": 1.90,
        # Flip: 0.085 * 2.5 = 0.2125
        "IkRecoilDisplacement": 0.215,
        # Recovery: near zero control
        "RecoilRecoveryRate": 0.08,
        # Fire rate: full-auto ~1200 RPM
        "TimeBetweenShots": 0.052,
        "AccuracySpread": 3.50,
        "RecoilAccuracyMax": 3.50,
    },
    ".45_acp": {
        # Shake: 1.20 * 2.5 = 3.0
        "RecoilShakeAmplitude": 3.00,
        # Flip: 0.130 * 2.5 = 0.325
        "IkRecoilDisplacement": 0.325,
        # Recovery: basically uncontrollable
        "RecoilRecoveryRate": 0.05,
        # Fire rate: full-auto ~900 RPM
        "TimeBetweenShots": 0.065,
        "AccuracySpread": 4.50,
        "RecoilAccuracyMax": 4.50,
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
    Lower quality factor (match=0.55) = closer to min (better)
    Higher quality factor (worn=1.80) = closer to max (worse)
    """
    # Normalize quality factor to 0-1 range
    # worn=1.80 -> 1.0, match=0.55 -> 0.0
    normalized = (quality_factor - 0.55) / (1.80 - 0.55)
    normalized = max(0.0, min(1.0, normalized))
    return min_val + (max_val - min_val) * normalized


def calculate_weapon_values(spec: WeaponSpec) -> dict:
    """Calculate all handling values for a weapon"""
    caliber = normalize_caliber(spec.caliber)

    if caliber not in PARAMETER_RANGES:
        raise ValueError(f"Unknown caliber: {caliber}")

    ranges = PARAMETER_RANGES[caliber]
    quality_factor = QUALITY_TIERS.get(spec.quality_tier, 1.0)
    weight_factor = calculate_weight_factor(spec.weight_oz)

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
