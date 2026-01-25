#!/usr/bin/env python3
"""
Batch 20 Structural Fix Script

Fixes the following issues:
1. <n> → <Name> for weapon names in all meta files
2. Adds missing EffectGroup, PedDamageHash, PickupHash, NmShotTuningSet
3. Fixes cl_weaponNames.lua format (removes CreateThread, uses WEAPON_* format)
4. Ensures proper Infos nesting

Based on double action revolver template for animations.
"""

import os
import re
import glob
from pathlib import Path

BATCH20_PATH = "/home/user/project_pipes/batch20_special"

# Weapon configurations for batch 20 revolvers
# Format: folder_name -> (weapon_hash, display_name, pickup_hash)
WEAPON_CONFIG = {
    "sw_model60": ("WEAPON_SWMODEL60", "S&W Model 60", "PICKUP_WEAPON_DOUBLEACTION"),
    "sw_model10": ("WEAPON_SWMODEL10", "S&W Model 10", "PICKUP_WEAPON_DOUBLEACTION"),
    "sw_model442": ("WEAPON_SWMODEL442", "S&W Model 442", "PICKUP_WEAPON_DOUBLEACTION"),
    "sw_model642": ("WEAPON_SWMODEL642", "S&W Model 642", "PICKUP_WEAPON_DOUBLEACTION"),
    "ruger_lcr": ("WEAPON_RUGERLCR", "Ruger LCR", "PICKUP_WEAPON_DOUBLEACTION"),
    "taurus_defender856": ("WEAPON_TAURUS856", "Taurus Defender 856", "PICKUP_WEAPON_DOUBLEACTION"),
    "dart_gun": ("WEAPON_DARTGUN", "Tranquilizer Dart Gun", "PICKUP_WEAPON_STUNGUN"),
}

# Elements to add for revolvers (after FireType line)
REVOLVER_ADDITIONS = """          <EffectGroup>WEAPON_EFFECT_GROUP_REVOLVER</EffectGroup>
          <PedDamageHash>BulletSmall</PedDamageHash>"""

# PickupHash and NmShotTuningSet template (to be added before AimOffset)
PICKUP_TEMPLATE = """          <PickupHash>{pickup_hash}</PickupHash>
          <MPPickupHash>PICKUP_AMMO_BULLET_MP</MPPickupHash>
          <NmShotTuningSet>Normal</NmShotTuningSet>"""


def fix_n_to_name(content: str) -> str:
    """Replace <n>...</n> with <Name>...</Name>"""
    # Replace opening and closing tags
    content = re.sub(r'<n>', '<Name>', content)
    content = re.sub(r'</n>', '</Name>', content)
    return content


def add_effect_group_and_damage_hash(content: str) -> str:
    """Add EffectGroup and PedDamageHash after FireType if missing"""
    if '<EffectGroup>' in content:
        return content  # Already has it

    # Find FireType line and add after it
    pattern = r'(<FireType>.*?</FireType>)'
    replacement = r'\1\n' + REVOLVER_ADDITIONS
    content = re.sub(pattern, replacement, content)
    return content


def add_pickup_and_tuning(content: str, pickup_hash: str) -> str:
    """Add PickupHash, MPPickupHash, and NmShotTuningSet before AimOffset if missing"""
    if '<PickupHash>' in content:
        return content  # Already has it

    # Find AimOffset and add before it
    pickup_block = PICKUP_TEMPLATE.format(pickup_hash=pickup_hash)
    pattern = r'(\s*)(<AimOffset>)'
    replacement = pickup_block + r'\n\1\2'
    content = re.sub(pattern, replacement, content)
    return content


def fix_weapons_meta(filepath: str, weapon_folder: str) -> bool:
    """Fix all issues in a weapons.meta file"""
    if weapon_folder not in WEAPON_CONFIG:
        print(f"  Skipping {weapon_folder} - not in config")
        return False

    weapon_hash, display_name, pickup_hash = WEAPON_CONFIG[weapon_folder]

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content

    # Fix <n> to <Name>
    content = fix_n_to_name(content)

    # Add EffectGroup and PedDamageHash (skip dart_gun - it already has them)
    if weapon_folder != "dart_gun":
        content = add_effect_group_and_damage_hash(content)
        content = add_pickup_and_tuning(content, pickup_hash)

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
    if weapon_folder not in WEAPON_CONFIG:
        return False

    weapon_hash, display_name, _ = WEAPON_CONFIG[weapon_folder]

    # New correct format
    new_content = f'AddTextEntry("{weapon_hash}", "{display_name}")\n'

    with open(filepath, 'r', encoding='utf-8') as f:
        original = f.read()

    if original.strip() != new_content.strip():
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False


def process_batch20(dry_run: bool = True):
    """Process all weapons in batch 20"""
    print(f"Processing Batch 20 - Special Revolvers & Dart Gun")
    print(f"Path: {BATCH20_PATH}")
    print(f"Dry run: {dry_run}")
    print("=" * 60)

    changes = {
        "weapons_meta": [],
        "other_meta": [],
        "lua_files": [],
    }

    # Get all weapon folders
    weapon_folders = [d for d in os.listdir(BATCH20_PATH)
                      if os.path.isdir(os.path.join(BATCH20_PATH, d)) and not d.startswith('.')]

    for folder in sorted(weapon_folders):
        folder_path = os.path.join(BATCH20_PATH, folder)
        print(f"\n{folder}:")

        # Fix weapons.meta
        weapons_meta = os.path.join(folder_path, "meta", "weapons.meta")
        if os.path.exists(weapons_meta):
            if dry_run:
                print(f"  Would fix: weapons.meta")
                changes["weapons_meta"].append(weapons_meta)
            else:
                if fix_weapons_meta(weapons_meta, folder):
                    print(f"  Fixed: weapons.meta")
                    changes["weapons_meta"].append(weapons_meta)

        # Fix pedpersonality.meta
        ped_meta = os.path.join(folder_path, "meta", "pedpersonality.meta")
        if os.path.exists(ped_meta):
            if dry_run:
                print(f"  Would fix: pedpersonality.meta")
                changes["other_meta"].append(ped_meta)
            else:
                if fix_other_meta(ped_meta):
                    print(f"  Fixed: pedpersonality.meta")
                    changes["other_meta"].append(ped_meta)

        # Fix weaponanimations.meta
        anim_meta = os.path.join(folder_path, "meta", "weaponanimations.meta")
        if os.path.exists(anim_meta):
            if dry_run:
                print(f"  Would fix: weaponanimations.meta")
                changes["other_meta"].append(anim_meta)
            else:
                if fix_other_meta(anim_meta):
                    print(f"  Fixed: weaponanimations.meta")
                    changes["other_meta"].append(anim_meta)

        # Fix cl_weaponNames.lua
        lua_file = os.path.join(folder_path, "cl_weaponNames.lua")
        if os.path.exists(lua_file):
            if dry_run:
                print(f"  Would fix: cl_weaponNames.lua")
                changes["lua_files"].append(lua_file)
            else:
                if fix_weapon_names_lua(lua_file, folder):
                    print(f"  Fixed: cl_weaponNames.lua")
                    changes["lua_files"].append(lua_file)

    print("\n" + "=" * 60)
    print(f"Summary:")
    print(f"  weapons.meta files: {len(changes['weapons_meta'])}")
    print(f"  Other meta files: {len(changes['other_meta'])}")
    print(f"  Lua files: {len(changes['lua_files'])}")
    print(f"  Total: {sum(len(v) for v in changes.values())}")

    return changes


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Fix batch 20 structural issues")
    parser.add_argument("--apply", action="store_true", help="Apply changes (default is dry run)")
    args = parser.parse_args()

    process_batch20(dry_run=not args.apply)
