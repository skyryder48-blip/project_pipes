#!/usr/bin/env python3
"""
Weapon Damage Adjustment Script

Adjusts damage values across all weapon batches by a specified percentage.
"""

import os
import re
import glob
from pathlib import Path

# =============================================================================
# CONFIGURATION
# =============================================================================
DAMAGE_MULTIPLIER = 0.88  # 12% reduction = multiply by 0.88

# Batch directories (batches 1-11 for handguns)
BASE_PATH = "/home/user/project_pipes"
BATCH_DIRS = [
    "Batch1_Compact_9mm_Pistols",
    "Batch2_FullSize_9mm_Pistols",
    "batch3_45acp",
    "batch4_40sw",
    "batch5_357mag",
    "batch6_magnums",
    "batch7_57x28",
    "batch8_22lr",
    "batch9_pocket_pistols",
    "batch10_10mm",
    "batch11",
]


def find_weapon_meta_files(batch_path: str) -> list:
    """Find all weapon meta files in a batch directory"""
    meta_files = []

    # Pattern 1: weapon_*/meta/weapon_*.meta
    pattern1 = os.path.join(batch_path, "weapon_*", "meta", "weapon_*.meta")
    meta_files.extend(glob.glob(pattern1))

    # Pattern 2: weapon_*/meta/weapons.meta (some batches use this)
    pattern2 = os.path.join(batch_path, "weapon_*", "meta", "weapons.meta")
    meta_files.extend(glob.glob(pattern2))

    # Pattern 3: nested batch directories (like batch6_magnums/batch7_57x28)
    pattern3 = os.path.join(batch_path, "*", "*", "weapon_*", "meta", "*.meta")
    meta_files.extend(glob.glob(pattern3))

    return meta_files


def adjust_damage_in_file(file_path: str, multiplier: float, dry_run: bool = True) -> dict:
    """Adjust damage values in a weapon meta file"""
    result = {
        "file": file_path,
        "changes": [],
        "error": None
    }

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        original_content = content

        # Pattern to match <Damage value="X"/> (excluding DamageTime, DamageFallOff, etc.)
        # We need to be careful to only match the main Damage value
        damage_pattern = r'(<Damage value=")(\d+\.?\d*)("/>|" />)'

        def replace_damage(match):
            prefix = match.group(1)
            old_value = float(match.group(2))
            suffix = match.group(3)
            new_value = round(old_value * multiplier, 6)
            result["changes"].append({
                "param": "Damage",
                "old": old_value,
                "new": new_value
            })
            return f'{prefix}{new_value:.6f}{suffix}'

        content = re.sub(damage_pattern, replace_damage, content)

        # Also update HudDamage to match (integer value)
        hud_pattern = r'(<HudDamage value=")(\d+)("/>|" />)'

        def replace_hud_damage(match):
            prefix = match.group(1)
            old_value = int(match.group(2))
            suffix = match.group(3)
            new_value = int(round(old_value * multiplier))
            result["changes"].append({
                "param": "HudDamage",
                "old": old_value,
                "new": new_value
            })
            return f'{prefix}{new_value}{suffix}'

        content = re.sub(hud_pattern, replace_hud_damage, content)

        if content != original_content and not dry_run:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)

    except Exception as e:
        result["error"] = str(e)

    return result


def process_all_batches(dry_run: bool = True) -> dict:
    """Process all batch directories"""
    results = {
        "processed": [],
        "errors": [],
        "summary": {
            "total_files": 0,
            "total_changes": 0
        }
    }

    for batch_dir in BATCH_DIRS:
        batch_path = os.path.join(BASE_PATH, batch_dir)

        if not os.path.exists(batch_path):
            results["errors"].append(f"Batch directory not found: {batch_path}")
            continue

        meta_files = find_weapon_meta_files(batch_path)

        for meta_file in meta_files:
            result = adjust_damage_in_file(meta_file, DAMAGE_MULTIPLIER, dry_run)

            if result["error"]:
                results["errors"].append(f"{meta_file}: {result['error']}")
            elif result["changes"]:
                results["processed"].append(result)
                results["summary"]["total_files"] += 1
                results["summary"]["total_changes"] += len(result["changes"])

    return results


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Adjust weapon damage values")
    parser.add_argument("--apply", action="store_true", help="Apply changes (default is dry-run)")
    parser.add_argument("--multiplier", type=float, default=DAMAGE_MULTIPLIER,
                        help=f"Damage multiplier (default: {DAMAGE_MULTIPLIER})")
    args = parser.parse_args()

    multiplier = args.multiplier

    print(f"\nDamage Adjustment: {(1 - multiplier) * 100:.1f}% reduction (multiplier: {multiplier})")
    print(f"Dry run: {not args.apply}\n")

    results = process_all_batches(dry_run=not args.apply)

    # Print results
    print(f"{'='*60}")
    print(f"Processed {results['summary']['total_files']} files")
    print(f"Total changes: {results['summary']['total_changes']}")
    print(f"{'='*60}\n")

    for item in results["processed"]:
        weapon_name = Path(item["file"]).stem
        print(f"{weapon_name}:")
        for change in item["changes"]:
            print(f"  {change['param']}: {change['old']} -> {change['new']}")

    if results["errors"]:
        print(f"\nErrors:")
        for err in results["errors"]:
            print(f"  - {err}")


if __name__ == "__main__":
    main()
