#!/usr/bin/env python3
"""
Apply 11% damage reduction to all weapons in batches 12-19.
"""

import os
import re
import sys
from pathlib import Path

# Configuration
DAMAGE_REDUCTION = 0.11  # 11% reduction
BATCHES = [
    ("batch12_weapons", "/home/user/project_pipes/batch12_weapons"),
    ("batch13_weapons", "/home/user/project_pipes/batch13_weapons"),
    ("batch14_weapons", "/home/user/project_pipes/batch14_weapons"),
    ("batch15_weapons", "/home/user/project_pipes/batch15_weapons"),
    ("batch16_weapons", "/home/user/project_pipes/batch16_weapons"),
    ("batch17_weapons", "/home/user/project_pipes/batch17_weapons"),
    ("batch18_shotguns", "/home/user/project_pipes/batch18_shotguns"),
    ("batch19_rifles", "/home/user/project_pipes/batch19_rifles"),
]

def find_weapons_meta(batch_path):
    """Find all weapons.meta files in a batch directory."""
    meta_files = []
    for root, dirs, files in os.walk(batch_path):
        for f in files:
            if f.endswith('.meta') and 'weapons' in f.lower():
                meta_files.append(os.path.join(root, f))
            # Also check for weapon_*.meta pattern
            if f.startswith('weapon_') and f.endswith('.meta') and 'archetypes' not in f and 'animations' not in f and 'personality' not in f:
                full_path = os.path.join(root, f)
                if full_path not in meta_files:
                    meta_files.append(full_path)
    return meta_files

def extract_weapon_name(content):
    """Extract weapon name from file content."""
    match = re.search(r'<Name>(WEAPON_[^<]+)</Name>', content)
    if match:
        return match.group(1)
    return "Unknown"

def apply_damage_reduction(file_path, dry_run=True):
    """Apply 11% damage reduction to a weapon meta file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    weapon_name = extract_weapon_name(content)

    # Find and reduce damage value
    damage_pattern = r'<Damage\s+value="([\d.]+)"'
    match = re.search(damage_pattern, content)

    if not match:
        return None, None, weapon_name

    old_damage = float(match.group(1))
    new_damage = round(old_damage * (1 - DAMAGE_REDUCTION), 2)

    new_content = re.sub(
        damage_pattern,
        f'<Damage value="{new_damage:.2f}"',
        content
    )

    if not dry_run:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)

    return old_damage, new_damage, weapon_name

def main():
    dry_run = '--apply' not in sys.argv

    print("=" * 70)
    print("DAMAGE REDUCTION SCRIPT - 11% Reduction")
    print("=" * 70)
    print(f"Mode: {'DRY RUN' if dry_run else 'APPLYING'}")
    print()

    all_changes = []

    for batch_name, batch_path in BATCHES:
        if not os.path.exists(batch_path):
            print(f"⚠ Batch not found: {batch_path}")
            continue

        meta_files = find_weapons_meta(batch_path)

        if not meta_files:
            print(f"⚠ No weapons.meta files in {batch_name}")
            continue

        print(f"\n{'=' * 70}")
        print(f"Processing {batch_name}")
        print(f"{'=' * 70}")

        for meta_file in meta_files:
            old_dmg, new_dmg, weapon_name = apply_damage_reduction(meta_file, dry_run)

            if old_dmg is not None:
                print(f"  {weapon_name}")
                print(f"    Damage: {old_dmg:.2f} → {new_dmg:.2f} (-{DAMAGE_REDUCTION*100:.0f}%)")
                all_changes.append({
                    'batch': batch_name,
                    'weapon': weapon_name,
                    'old': old_dmg,
                    'new': new_dmg,
                    'file': meta_file
                })
                if not dry_run:
                    print(f"    ✓ Updated")

    print(f"\n{'=' * 70}")
    print(f"SUMMARY: {len(all_changes)} weapons processed")
    print(f"{'=' * 70}")

    if dry_run:
        print("\nRun with --apply to apply changes")

if __name__ == '__main__':
    main()
