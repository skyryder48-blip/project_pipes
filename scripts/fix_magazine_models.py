#!/usr/bin/env python3
"""
Fix empty <Model /> tags in weaponcomponents.meta files for batches 1-11.

This script adds proper model references based on the naming convention:
- w_pi_[weapon]_mag1 = Standard magazine (CLIP components)
- w_pi_[weapon]_mag2 = Extended magazine (EXTCLIP components)
"""

import os
import re
from pathlib import Path

# Base project directory
PROJECT_DIR = Path("/home/user/project_pipes")

# Batch directories to process (batches 1-11)
BATCH_PATTERNS = [
    "Batch1_*",
    "Batch2_*",
    "batch3_*",
    "batch4_*",
    "batch5_*",
    "batch6_*",
    "batch7_*",
    "batch8_*",
    "batch9_*",
    "batch10_*",
    "batch11",
]

def get_weapon_name_from_path(filepath):
    """Extract weapon name from file path (e.g., weapon_g26 -> g26)"""
    path_parts = filepath.parts
    for part in path_parts:
        if part.startswith("weapon_"):
            return part.replace("weapon_", "")
    return None

def determine_model_name(weapon_name, component_name):
    """
    Determine the 3D model name based on weapon and component type.

    Convention:
    - Standard clips (CLIP_, CLIP1_, MAG1_) -> _mag1
    - Extended clips (EXTCLIP_, CLIP2_, MAG2_) -> _mag2
    - Drum magazines (DRUM_, CLIP3_, MAG3_) -> _mag3
    - Large drum magazines (LGDRUM_, CLIP4_, MAG4_) -> _mag4
    - Stick magazines (STICK_, CLIP5_, MAG5_) -> _mag5

    Revolvers don't typically have visible magazine models, so we skip them.
    """
    # Skip revolvers - they don't have detachable magazine models
    revolver_indicators = ['python', 'kingcobra', 'model15', 'model29', 'ragingbull',
                          'sw500', 'sw_657', 'sw_model', 'taurus856', 'rugerlcr']

    weapon_lower = weapon_name.lower()
    for indicator in revolver_indicators:
        if indicator in weapon_lower:
            return None  # No magazine model for revolvers

    # Determine magazine type from component name (order matters - check specific first)
    # Check for numbered patterns first (MAG5_, CLIP5_, etc.)
    if "_MAG5_" in component_name or "_CLIP5_" in component_name:
        return f"w_pi_{weapon_name}_mag5"
    elif "_MAG4_" in component_name or "_CLIP4_" in component_name or "_LGDRUM_" in component_name:
        return f"w_pi_{weapon_name}_mag4"
    elif "_MAG3_" in component_name or "_CLIP3_" in component_name or "_DRUM_" in component_name:
        return f"w_pi_{weapon_name}_mag3"
    elif "_MAG2_" in component_name or "_CLIP2_" in component_name or "_EXTCLIP_" in component_name:
        return f"w_pi_{weapon_name}_mag2"
    elif "_STICK_" in component_name:
        return f"w_pi_{weapon_name}_mag5"
    elif "_CLIP_" in component_name or "_MAG1_" in component_name or "CLIP_01" in component_name or "CLIP_FMJ" in component_name:
        return f"w_pi_{weapon_name}_mag1"

    return None

def fix_weaponcomponents_file(filepath):
    """
    Fix empty <Model /> tags in a weaponcomponents.meta file.
    Returns tuple of (modified, changes_made)
    """
    weapon_name = get_weapon_name_from_path(filepath)
    if not weapon_name:
        print(f"  WARNING: Could not determine weapon name for {filepath}")
        return False, 0

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    changes_made = 0

    # Find all component blocks and their names
    # Pattern to match component items
    item_pattern = r'(<Item[^>]*>.*?<Name>([^<]+)</Name>.*?)<Model\s*/>(.*?</Item>)'

    def replace_model(match):
        nonlocal changes_made
        before = match.group(1)
        component_name = match.group(2)
        after = match.group(3)

        model_name = determine_model_name(weapon_name, component_name)

        if model_name:
            changes_made += 1
            return f"{before}<Model>{model_name}</Model>{after}"
        else:
            # Keep empty for revolvers
            return match.group(0)

    content = re.sub(item_pattern, replace_model, content, flags=re.DOTALL)

    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True, changes_made

    return False, 0

def find_batch_directories():
    """Find all batch directories matching our patterns."""
    batch_dirs = []
    for pattern in BATCH_PATTERNS:
        matches = list(PROJECT_DIR.glob(pattern))
        batch_dirs.extend(matches)
    return sorted(set(batch_dirs))

def main():
    print("=" * 60)
    print("Magazine Model Reference Fixer for Batches 1-11")
    print("=" * 60)
    print()

    batch_dirs = find_batch_directories()
    print(f"Found {len(batch_dirs)} batch directories to process")
    print()

    total_files = 0
    total_modified = 0
    total_changes = 0

    for batch_dir in batch_dirs:
        print(f"Processing: {batch_dir.name}")

        # Find all weaponcomponents.meta files in this batch
        meta_files = list(batch_dir.glob("**/weaponcomponents.meta"))

        for meta_file in meta_files:
            weapon_name = get_weapon_name_from_path(meta_file)
            total_files += 1

            modified, changes = fix_weaponcomponents_file(meta_file)

            if modified:
                total_modified += 1
                total_changes += changes
                print(f"  ✓ {weapon_name}: {changes} model references added")
            else:
                if changes == 0:
                    print(f"  - {weapon_name}: skipped (revolver or no changes needed)")

    print()
    print("=" * 60)
    print("Summary:")
    print(f"  Files processed: {total_files}")
    print(f"  Files modified:  {total_modified}")
    print(f"  Model refs added: {total_changes}")
    print("=" * 60)

if __name__ == "__main__":
    main()
