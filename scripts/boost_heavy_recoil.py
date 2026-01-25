#!/usr/bin/env python3
"""
Boost recoil effects for shotguns and .50 BMG rifles.
These weapons should have significantly heavier felt recoil.
"""

import os
import re
import sys

# Shotgun recoil values - pump shotguns have heavy single impulse
SHOTGUN_RECOIL = {
    "mini_shotty": {      # Small, light = hardest kicking
        "shake": 4.2,
        "roll": 0.70,
        "duration": 0.65,
        "frequency": 0.0
    },
    "mossberg_shockwave": {  # Pistol grip, no stock = brutal
        "shake": 4.5,
        "roll": 0.75,
        "duration": 0.70,
        "frequency": 0.0
    },
    "remington_870": {    # Standard pump
        "shake": 3.2,
        "roll": 0.55,
        "duration": 0.60,
        "frequency": 0.0
    },
    "mossberg_500": {     # Standard pump
        "shake": 3.0,
        "roll": 0.50,
        "duration": 0.58,
        "frequency": 0.0
    },
    "model_680": {        # Quality pump
        "shake": 2.8,
        "roll": 0.48,
        "duration": 0.55,
        "frequency": 0.0
    },
    "beretta_1301": {     # Semi-auto = gas operated = less felt recoil
        "shake": 2.2,
        "roll": 0.40,
        "duration": 0.45,
        "frequency": 0.0
    },
    "browning_auto5": {   # Semi-auto, classic long recoil action
        "shake": 2.5,
        "roll": 0.45,
        "duration": 0.50,
        "frequency": 0.0
    },
}

# .50 BMG recoil values - these are MASSIVE rounds
FIFTY_CAL_RECOIL = {
    "barrett_m82a1": {    # Semi-auto with muzzle brake
        "shake": 4.8,
        "roll": 0.65,
        "duration": 0.85,
        "frequency": 0.0
    },
    "barrett_m107a1": {   # Updated M82, similar recoil system
        "shake": 4.5,
        "roll": 0.62,
        "duration": 0.80,
        "frequency": 0.0
    },
}

BASE_PATH = "/home/user/project_pipes"

def update_recoil_values(file_path, shake, roll, duration, frequency, dry_run=True):
    """Update recoil values in a weapons.meta file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract weapon name
    name_match = re.search(r'<Name>(WEAPON_[^<]+)</Name>', content)
    weapon_name = name_match.group(1) if name_match else "Unknown"

    # Get old values
    old_shake = re.search(r'<RecoilShakeAmplitude\s+value="([\d.]+)"', content)
    old_roll = re.search(r'<RecoilShakeRollMagnitude\s+value="([\d.]+)"', content)
    old_duration = re.search(r'<RecoilShakeDuration\s+value="([\d.]+)"', content)

    old_shake_val = float(old_shake.group(1)) if old_shake else 0
    old_roll_val = float(old_roll.group(1)) if old_roll else 0
    old_duration_val = float(old_duration.group(1)) if old_duration else 0

    # Apply new values
    new_content = content
    new_content = re.sub(
        r'<RecoilShakeAmplitude\s+value="[\d.]+"',
        f'<RecoilShakeAmplitude value="{shake:.2f}"',
        new_content
    )
    new_content = re.sub(
        r'<RecoilShakeRollMagnitude\s+value="[\d.]+"',
        f'<RecoilShakeRollMagnitude value="{roll:.3f}"',
        new_content
    )
    new_content = re.sub(
        r'<RecoilShakeDuration\s+value="[\d.]+"',
        f'<RecoilShakeDuration value="{duration:.3f}"',
        new_content
    )
    new_content = re.sub(
        r'<RecoilShakeFrequency\s+value="[\d.]+"',
        f'<RecoilShakeFrequency value="{frequency:.2f}"',
        new_content
    )

    if not dry_run:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)

    return weapon_name, old_shake_val, old_roll_val, old_duration_val

def find_weapons_meta(batch_path, weapon_folder):
    """Find the weapons.meta file for a weapon."""
    weapon_path = os.path.join(batch_path, weapon_folder, "meta")
    if not os.path.exists(weapon_path):
        return None

    for f in os.listdir(weapon_path):
        if f.endswith('.meta') and 'archetypes' not in f and 'animations' not in f and 'personality' not in f:
            if 'weapons' in f.lower() or f.startswith('weapon_'):
                return os.path.join(weapon_path, f)
    return None

def main():
    dry_run = '--apply' not in sys.argv

    print("=" * 80)
    print("HEAVY RECOIL BOOST - Shotguns & .50 BMG")
    print("=" * 80)
    print(f"Mode: {'DRY RUN' if dry_run else 'APPLYING'}")
    print()

    # Process shotguns
    print("\n" + "=" * 80)
    print("BATCH 18 - SHOTGUNS")
    print("=" * 80)

    shotgun_path = os.path.join(BASE_PATH, "batch18_shotguns")
    for weapon_folder, values in SHOTGUN_RECOIL.items():
        meta_file = find_weapons_meta(shotgun_path, weapon_folder)
        if not meta_file:
            print(f"  ⚠ {weapon_folder}: NOT FOUND")
            continue

        weapon_name, old_shake, old_roll, old_dur = update_recoil_values(
            meta_file,
            values['shake'],
            values['roll'],
            values['duration'],
            values['frequency'],
            dry_run
        )

        print(f"\n  {weapon_name}")
        print(f"    Shake:    {old_shake:.2f} → {values['shake']:.2f}")
        print(f"    Roll:     {old_roll:.3f} → {values['roll']:.3f}")
        print(f"    Duration: {old_dur:.3f} → {values['duration']:.3f}")
        if not dry_run:
            print(f"    ✓ Updated")

    # Process .50 cal snipers
    print("\n" + "=" * 80)
    print("BATCH 19 - .50 BMG RIFLES")
    print("=" * 80)

    sniper_path = os.path.join(BASE_PATH, "batch19_rifles")
    for weapon_folder, values in FIFTY_CAL_RECOIL.items():
        meta_file = find_weapons_meta(sniper_path, weapon_folder)
        if not meta_file:
            print(f"  ⚠ {weapon_folder}: NOT FOUND")
            continue

        weapon_name, old_shake, old_roll, old_dur = update_recoil_values(
            meta_file,
            values['shake'],
            values['roll'],
            values['duration'],
            values['frequency'],
            dry_run
        )

        print(f"\n  {weapon_name}")
        print(f"    Shake:    {old_shake:.2f} → {values['shake']:.2f}")
        print(f"    Roll:     {old_roll:.3f} → {values['roll']:.3f}")
        print(f"    Duration: {old_dur:.3f} → {values['duration']:.3f}")
        if not dry_run:
            print(f"    ✓ Updated")

    print("\n" + "=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print(f"  Shotguns processed: {len(SHOTGUN_RECOIL)}")
    print(f"  .50 BMG processed:  {len(FIFTY_CAL_RECOIL)}")

    if dry_run:
        print("\nRun with --apply to apply changes")

if __name__ == '__main__':
    main()
