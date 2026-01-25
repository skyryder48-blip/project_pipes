#!/usr/bin/env python3
"""
Fix naming issues in batches 18 and 19

Fixes:
1. <n> → <Name> in all meta files
2. WT_* → WEAPON_* in HumanNameHash
3. cl_weaponNames.lua format (WT_* → WEAPON_*, remove CreateThread wrapper)
"""

import os
import re

BASE_PATH = "/home/user/project_pipes"

# Weapon configurations for batch 18 (shotguns) and 19 (sniper rifles)
WEAPON_CONFIG = {
    # Batch 18 - Shotguns
    "beretta_1301": ("WEAPON_BERETTA1301", "Beretta 1301"),
    "browning_auto5": ("WEAPON_BROWNINGAUTO5", "Browning Auto-5"),
    "mini_shotty": ("WEAPON_MINISHOTTY", "Mini Shotty"),
    "model_680": ("WEAPON_MODEL680", "Model 680"),
    "mossberg_500": ("WEAPON_MOSSBERG500", "Mossberg 500"),
    "mossberg_shockwave": ("WEAPON_SHOCKWAVE", "Mossberg Shockwave"),
    "remington_870": ("WEAPON_REMINGTON870", "Remington 870"),
    # Batch 19 - Sniper Rifles
    "barrett_m107a1": ("WEAPON_BARRETTM107A1", "Barrett M107A1"),
    "barrett_m82a1": ("WEAPON_BARRETTM82A1", "Barrett M82A1"),
    "nemo_omen_watchman": ("WEAPON_NEMOWATCHMAN", "NEMO Omen Watchman"),
    "remington_700": ("WEAPON_REMINGTON700", "Remington 700"),
    "remington_m24": ("WEAPON_REMINGTONM24", "Remington M24"),
    "sauer_101": ("WEAPON_SAUER101", "Sauer 101"),
    "sig_550": ("WEAPON_SIG550", "SIG 550"),
    "victus_xmr": ("WEAPON_VICTUSXMR", "Victus XMR"),
}


def fix_meta_file(filepath: str) -> bool:
    """Fix <n> to <Name> and WT_ to WEAPON_ in meta files"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content

    # Fix <n> to <Name>
    content = re.sub(r'<n>', '<Name>', content)
    content = re.sub(r'</n>', '</Name>', content)

    # Fix WT_ to WEAPON_ in HumanNameHash
    content = re.sub(r'<HumanNameHash>WT_([^<]+)</HumanNameHash>',
                     r'<HumanNameHash>WEAPON_\1</HumanNameHash>', content)

    if content != original:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False


def fix_lua_file(filepath: str, weapon_folder: str) -> bool:
    """Fix cl_weaponNames.lua to use WEAPON_* format"""
    if weapon_folder not in WEAPON_CONFIG:
        return False

    weapon_hash, display_name = WEAPON_CONFIG[weapon_folder]
    new_content = f'AddTextEntry("{weapon_hash}", "{display_name}")\n'

    with open(filepath, 'r', encoding='utf-8') as f:
        original = f.read()

    if original.strip() != new_content.strip():
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    return False


def process_batch(batch_path: str, dry_run: bool = True) -> dict:
    """Process all weapons in a batch"""
    print(f"\nProcessing {batch_path}...")
    print("=" * 60)

    results = {
        "meta_files": [],
        "lua_files": [],
    }

    if not os.path.isdir(batch_path):
        print(f"  ERROR: Batch directory not found")
        return results

    # Get all weapon folders
    weapon_folders = [d for d in os.listdir(batch_path)
                      if os.path.isdir(os.path.join(batch_path, d)) and not d.startswith('.')]

    for folder in sorted(weapon_folders):
        folder_path = os.path.join(batch_path, folder)
        print(f"\n  {folder}:")

        # Fix all meta files
        meta_dir = os.path.join(folder_path, "meta")
        if os.path.isdir(meta_dir):
            for meta_file in os.listdir(meta_dir):
                if meta_file.endswith(".meta"):
                    meta_path = os.path.join(meta_dir, meta_file)
                    if dry_run:
                        print(f"    Would fix: {meta_file}")
                        results["meta_files"].append(meta_path)
                    else:
                        if fix_meta_file(meta_path):
                            print(f"    Fixed: {meta_file}")
                            results["meta_files"].append(meta_path)

        # Fix cl_weaponNames.lua
        lua_file = os.path.join(folder_path, "cl_weaponNames.lua")
        if os.path.exists(lua_file):
            if dry_run:
                print(f"    Would fix: cl_weaponNames.lua")
                results["lua_files"].append(lua_file)
            else:
                if fix_lua_file(lua_file, folder):
                    print(f"    Fixed: cl_weaponNames.lua")
                    results["lua_files"].append(lua_file)

    return results


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Fix naming issues in batches 18-19")
    parser.add_argument("--apply", action="store_true", help="Apply changes")
    args = parser.parse_args()

    dry_run = not args.apply

    print("Batch 18-19 Naming Fix Script")
    print("=" * 60)
    print(f"Mode: {'DRY RUN' if dry_run else 'APPLYING CHANGES'}")

    batches = [
        os.path.join(BASE_PATH, "batch18_shotguns"),
        os.path.join(BASE_PATH, "batch19_rifles"),
    ]

    total_meta = 0
    total_lua = 0

    for batch_path in batches:
        results = process_batch(batch_path, dry_run)
        total_meta += len(results["meta_files"])
        total_lua += len(results["lua_files"])

    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)
    print(f"  Meta files: {total_meta}")
    print(f"  Lua files: {total_lua}")
    print(f"  Total: {total_meta + total_lua}")

    if dry_run:
        print("\nRun with --apply to make changes")


if __name__ == "__main__":
    main()
