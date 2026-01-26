#!/usr/bin/env python3
"""
Phase 1: Rifle Batch Fix Script (Batches 12, 13, 14)

Fixes the following issues:
1. <n> → <Name> for weapon names in all meta files
2. Adds EffectGroup (WEAPON_EFFECT_GROUP_RIFLE)
3. Adds PedDamageHash (BulletLarge for rifles)
4. Fixes HumanNameHash (WT_* → WEAPON_*)
5. Adds PickupHash and MPPickupHash
6. Adds NmShotTuningSet
7. Fixes cl_weaponNames.lua format
"""

import os
import re
import glob
from pathlib import Path

BASE_PATH = "/home/user/project_pipes"

# Batch configurations
BATCH_CONFIGS = {
    "batch12_weapons": {
        "name": "Batch 12 - Assault Rifles",
        "effect_group": "WEAPON_EFFECT_GROUP_RIFLE",
        "ped_damage": "BulletLarge",
        "pickup_hash": "PICKUP_WEAPON_ASSAULTRIFLE",
    },
    "batch13_weapons": {
        "name": "Batch 13 - AK Variants",
        "effect_group": "WEAPON_EFFECT_GROUP_RIFLE",
        "ped_damage": "BulletLarge",
        "pickup_hash": "PICKUP_WEAPON_ASSAULTRIFLE",
    },
    "batch14_weapons": {
        "name": "Batch 14 - Battle Rifles",
        "effect_group": "WEAPON_EFFECT_GROUP_RIFLE",
        "ped_damage": "BulletLarge",
        "pickup_hash": "PICKUP_WEAPON_ASSAULTRIFLE",
    },
}

# Weapon display names (folder_name -> (weapon_hash, display_name))
WEAPON_NAMES = {
    # Batch 12
    "weapon_cz_bren": ("WEAPON_CZ_BREN", "CZ Bren 2"),
    "weapon_desert_ar15": ("WEAPON_DESERT_AR15", "Desert AR-15"),
    "weapon_m16": ("WEAPON_M16", "M16A4"),
    "weapon_psa_ar15": ("WEAPON_PSA_AR15", "PSA AR-15"),
    "weapon_ram7knight": ("WEAPON_RAM7KNIGHT", "RAM-7 Knight"),
    "weapon_red_aug": ("WEAPON_RED_AUG", "Steyr AUG"),
    # Batch 13
    "weapon_mini_ak47": ("WEAPON_MINI_AK47", "Mini AK-47"),
    "weapon_mk47": ("WEAPON_MK47", "MK47 Mutant"),
    # Batch 14
    "weapon_m7": ("WEAPON_M7", "M7"),
    "weapon_mcx300": ("WEAPON_MCX300", "SIG MCX .300"),
    "weapon_sig_spear": ("WEAPON_SIG_SPEAR", "SIG Spear"),
}


def fix_n_to_name(content: str) -> str:
    """Replace <n>...</n> with <Name>...</Name>"""
    content = re.sub(r'<n>', '<Name>', content)
    content = re.sub(r'</n>', '</Name>', content)
    return content


def fix_human_name_hash(content: str) -> str:
    """Fix HumanNameHash from WT_* to WEAPON_*"""
    # Pattern: <HumanNameHash>WT_SOMETHING</HumanNameHash>
    pattern = r'<HumanNameHash>WT_([^<]+)</HumanNameHash>'
    replacement = r'<HumanNameHash>WEAPON_\1</HumanNameHash>'
    return re.sub(pattern, replacement, content)


def add_effect_group_and_damage(content: str, effect_group: str, ped_damage: str) -> str:
    """Add EffectGroup and PedDamageHash after FireType if missing"""
    if '<EffectGroup>' in content:
        return content

    # Find FireType and add after it
    addition = f"""
      <EffectGroup>{effect_group}</EffectGroup>
      <PedDamageHash>{ped_damage}</PedDamageHash>"""

    pattern = r'(<FireType>[^<]+</FireType>)'
    replacement = r'\1' + addition
    return re.sub(pattern, replacement, content)


def add_pickup_and_tuning(content: str, pickup_hash: str) -> str:
    """Add PickupHash, MPPickupHash, and NmShotTuningSet if missing"""
    if '<PickupHash>' in content:
        return content

    # Find HumanNameHash or PlayerControllerType and add before it
    pickup_block = f"""      <PickupHash>{pickup_hash}</PickupHash>
      <MPPickupHash>PICKUP_AMMO_BULLET_MP</MPPickupHash>
      <NmShotTuningSet>Normal</NmShotTuningSet>
"""

    # Try to add before HumanNameHash
    if '<HumanNameHash>' in content:
        pattern = r'(\s*)(<HumanNameHash>)'
        replacement = pickup_block + r'\1\2'
        return re.sub(pattern, replacement, content, count=1)

    # Fallback: add before PlayerControllerType
    if '<PlayerControllerType>' in content:
        pattern = r'(\s*)(<PlayerControllerType>)'
        replacement = pickup_block + r'\1\2'
        return re.sub(pattern, replacement, content, count=1)

    return content


def fix_weapons_meta(filepath: str, config: dict) -> bool:
    """Fix all issues in a weapons.meta file"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content

    # Apply fixes
    content = fix_n_to_name(content)
    content = fix_human_name_hash(content)
    content = add_effect_group_and_damage(content, config["effect_group"], config["ped_damage"])
    content = add_pickup_and_tuning(content, config["pickup_hash"])

    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False


def fix_other_meta(filepath: str) -> bool:
    """Fix <n> to <Name> in pedpersonality.meta and weaponanimations.meta"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content
    content = fix_n_to_name(content)

    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False


def fix_weapon_names_lua(filepath: str, weapon_folder: str) -> bool:
    """Fix cl_weaponNames.lua to use correct format"""
    if weapon_folder not in WEAPON_NAMES:
        return False

    weapon_hash, display_name = WEAPON_NAMES[weapon_folder]

    # New correct format
    new_content = f'AddTextEntry("{weapon_hash}", "{display_name}")\n'

    with open(filepath, 'r', encoding='utf-8') as f:
        original = f.read()

    # Check if already correct
    if original.strip() == new_content.strip():
        return False

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
    return True


def process_batch(batch_name: str, config: dict, dry_run: bool = True) -> dict:
    """Process all weapons in a batch"""
    batch_path = os.path.join(BASE_PATH, batch_name)

    print(f"\n{'='*60}")
    print(f"Processing {config['name']}...")
    print(f"Path: {batch_path}")
    print(f"Dry run: {dry_run}")
    print("=" * 60)

    results = {
        "weapons_meta": [],
        "other_meta": [],
        "lua_files": [],
        "errors": [],
    }

    if not os.path.isdir(batch_path):
        print(f"  ERROR: Batch directory not found: {batch_path}")
        return results

    # Find all weapon folders
    weapon_folders = [d for d in os.listdir(batch_path)
                      if os.path.isdir(os.path.join(batch_path, d)) and d.startswith('weapon_')]

    for folder in sorted(weapon_folders):
        # Skip disabled weapons
        if '.disabled' in folder:
            print(f"\n  {folder}: SKIPPED (disabled)")
            continue

        folder_path = os.path.join(batch_path, folder)
        print(f"\n  {folder}:")

        # Fix weapons.meta (try multiple naming conventions)
        weapons_meta = None
        for meta_name in ["weapons.meta", f"{folder}.meta"]:
            candidate = os.path.join(folder_path, "meta", meta_name)
            if os.path.exists(candidate):
                weapons_meta = candidate
                break

        # Also try glob for weapon_*.meta pattern
        if not weapons_meta:
            meta_dir = os.path.join(folder_path, "meta")
            if os.path.isdir(meta_dir):
                matches = glob.glob(os.path.join(meta_dir, "weapon_*.meta"))
                if len(matches) == 1:
                    weapons_meta = matches[0]

        if weapons_meta:
            meta_basename = os.path.basename(weapons_meta)
            if dry_run:
                print(f"    Would fix: {meta_basename}")
                results["weapons_meta"].append(weapons_meta)
            else:
                if fix_weapons_meta(weapons_meta, config):
                    print(f"    Fixed: {meta_basename}")
                    results["weapons_meta"].append(weapons_meta)

        # Fix pedpersonality.meta
        ped_meta = os.path.join(folder_path, "meta", "pedpersonality.meta")
        if os.path.exists(ped_meta):
            if dry_run:
                print(f"    Would fix: pedpersonality.meta")
                results["other_meta"].append(ped_meta)
            else:
                if fix_other_meta(ped_meta):
                    print(f"    Fixed: pedpersonality.meta")
                    results["other_meta"].append(ped_meta)

        # Fix weaponanimations.meta
        anim_meta = os.path.join(folder_path, "meta", "weaponanimations.meta")
        if os.path.exists(anim_meta):
            if dry_run:
                print(f"    Would fix: weaponanimations.meta")
                results["other_meta"].append(anim_meta)
            else:
                if fix_other_meta(anim_meta):
                    print(f"    Fixed: weaponanimations.meta")
                    results["other_meta"].append(anim_meta)

        # Fix cl_weaponNames.lua
        lua_file = os.path.join(folder_path, "cl_weaponNames.lua")
        if os.path.exists(lua_file):
            if dry_run:
                print(f"    Would fix: cl_weaponNames.lua")
                results["lua_files"].append(lua_file)
            else:
                if fix_weapon_names_lua(lua_file, folder):
                    print(f"    Fixed: cl_weaponNames.lua")
                    results["lua_files"].append(lua_file)

    return results


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Phase 1: Fix rifle batches 12-14")
    parser.add_argument("--apply", action="store_true", help="Apply changes (default is dry run)")
    parser.add_argument("--batch", type=int, help="Process only specific batch (12, 13, or 14)")
    args = parser.parse_args()

    dry_run = not args.apply

    print("Phase 1: Rifle Batch Fix Script")
    print("================================")
    print(f"Mode: {'DRY RUN' if dry_run else 'APPLYING CHANGES'}")

    total_results = {
        "weapons_meta": 0,
        "other_meta": 0,
        "lua_files": 0,
    }

    batches_to_process = BATCH_CONFIGS.keys()
    if args.batch:
        batch_key = f"batch{args.batch}_weapons"
        if batch_key in BATCH_CONFIGS:
            batches_to_process = [batch_key]
        else:
            print(f"ERROR: Batch {args.batch} not found")
            return

    for batch_name in batches_to_process:
        config = BATCH_CONFIGS[batch_name]
        results = process_batch(batch_name, config, dry_run)
        total_results["weapons_meta"] += len(results["weapons_meta"])
        total_results["other_meta"] += len(results["other_meta"])
        total_results["lua_files"] += len(results["lua_files"])

    print("\n" + "=" * 60)
    print("PHASE 1 SUMMARY")
    print("=" * 60)
    print(f"  weapons.meta files: {total_results['weapons_meta']}")
    print(f"  Other meta files: {total_results['other_meta']}")
    print(f"  Lua files: {total_results['lua_files']}")
    print(f"  Total files: {sum(total_results.values())}")

    if dry_run:
        print("\nRun with --apply to make changes")


if __name__ == "__main__":
    main()
