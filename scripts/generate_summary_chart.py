#!/usr/bin/env python3
"""
Generate a summary chart of weapon handling values for review.
"""

import os
import re
from pathlib import Path

# Sample weapons from each category for diversity
SAMPLE_WEAPONS = {
    "batch12_weapons": [
        ("weapon_psa_ar15", "PSA AR-15 (budget 5.56)"),
        ("weapon_m16", "M16A4 (quality 5.56)"),
    ],
    "batch13_weapons": [
        ("weapon_mini_ak47", "Mini AK-47 (standard 7.62x39)"),
        ("weapon_mk47", "MK47 Mutant (match 7.62x39)"),
    ],
    "batch14_weapons": [
        ("weapon_m7", "M7 (quality .308)"),
        ("weapon_sig_spear", "SIG Spear (match 6.8x51)"),
    ],
    "batch15_weapons": [
        ("weapon_tec9", "TEC-9 (budget 9mm)"),
        ("weapon_sig_mpx", "SIG MPX (match 9mm)"),
        ("weapon_mpa30", "MPA30 (standard 9mm)"),
    ],
    "batch16_weapons": [
        ("weapon_mac10", "MAC-10 (standard .45)"),
    ],
    "batch17_weapons": [
        ("weapon_arp_bumpstock", "ARP Bumpstock (budget PDW)"),
        ("weapon_mk18", "MK18 (quality SBR)"),
    ],
    "batch18_shotguns": [
        ("mossberg_shockwave", "Mossberg Shockwave"),
        ("beretta_1301", "Beretta 1301"),
        ("remington_870", "Remington 870"),
    ],
    "batch19_rifles": [
        ("remington_700", "Remington 700"),
        ("barrett_m82a1", "Barrett M82A1"),
        ("victus_xmr", "Victus XMR"),
    ],
}

BASE_PATH = "/home/user/project_pipes"

def extract_value(content, tag):
    """Extract a numeric value from XML tag."""
    pattern = rf'<{tag}\s+value="([\d.-]+)"'
    match = re.search(pattern, content)
    if match:
        return float(match.group(1))
    return None

def extract_weapon_data(file_path):
    """Extract key handling values from weapon meta."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    data = {
        'damage': extract_value(content, 'Damage'),
        'range': extract_value(content, 'WeaponRange'),
        'spread': extract_value(content, 'AccuracySpread'),
        'recoil_max': extract_value(content, 'RecoilAccuracyMax'),
        'recovery': extract_value(content, 'RecoilRecoveryRate'),
        'shake': extract_value(content, 'RecoilShakeAmplitude'),
        'fire_rate': extract_value(content, 'TimeBetweenShots'),
    }
    return data

def find_meta_file(batch_path, weapon_folder):
    """Find the weapons.meta file for a weapon."""
    weapon_path = os.path.join(batch_path, weapon_folder, "meta")
    if not os.path.exists(weapon_path):
        return None

    for f in os.listdir(weapon_path):
        if f.endswith('.meta') and 'archetypes' not in f and 'animations' not in f and 'personality' not in f:
            if 'weapons' in f or f.startswith('weapon_'):
                return os.path.join(weapon_path, f)
    return None

def main():
    print("=" * 120)
    print("WEAPON HANDLING SUMMARY CHART")
    print("=" * 120)
    print()
    print(f"{'Weapon':<30} {'Damage':>8} {'Range':>8} {'Spread':>8} {'RecoilMax':>10} {'Recovery':>10} {'Shake':>8} {'RPM':>8}")
    print("-" * 120)

    current_batch = None

    for batch_name, weapons in SAMPLE_WEAPONS.items():
        batch_path = os.path.join(BASE_PATH, batch_name)

        if not os.path.exists(batch_path):
            continue

        # Print batch header
        if current_batch != batch_name:
            if current_batch is not None:
                print()
            batch_label = batch_name.replace("_", " ").title()
            print(f"\n--- {batch_label} ---")
            current_batch = batch_name

        for weapon_folder, display_name in weapons:
            meta_file = find_meta_file(batch_path, weapon_folder)

            if not meta_file:
                print(f"  {display_name:<28} [NOT FOUND]")
                continue

            data = extract_weapon_data(meta_file)

            # Calculate RPM from fire rate
            rpm = int(60 / data['fire_rate']) if data['fire_rate'] and data['fire_rate'] > 0 else 0

            print(f"  {display_name:<28} {data['damage'] or 0:>7.1f} {data['range'] or 0:>7.0f}m {data['spread'] or 0:>7.2f} {data['recoil_max'] or 0:>9.2f} {data['recovery'] or 0:>9.2f} {data['shake'] or 0:>7.2f} {rpm:>7}")

    print()
    print("=" * 120)
    print("LEGEND:")
    print("  Damage = Base damage per hit (after 11% reduction)")
    print("  Range = Effective range in meters")
    print("  Spread = Base accuracy spread (lower = more accurate)")
    print("  RecoilMax = Maximum recoil accumulation (lower = less bloom)")
    print("  Recovery = Recoil recovery rate (higher = faster reset)")
    print("  Shake = Visual recoil shake amplitude")
    print("  RPM = Rounds per minute (fire rate)")
    print("=" * 120)

if __name__ == '__main__':
    main()
