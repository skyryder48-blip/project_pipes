# Batch 1: Compact 9mm Pistols - Summary

## Weapons Created

| Weapon | Hash | Capacity | Barrel | Key Characteristics |
|--------|------|----------|--------|---------------------|
| Glock 26 Gen 5 | `weapon_g26` | 10+1 | 3.43" | Best recoil control, longest barrel, heaviest (550g) |
| Glock 26 Switch | `weapon_g26_switch` | 10+1 | 3.43" | Full-auto (~1100 RPM), high recoil, reduced accuracy |
| Glock 43X | `weapon_g43x` | 10+1 | 3.41" | Lightest (465g), snappier recoil, slim profile |
| Springfield Hellcat | `weapon_hellcat` | 11+1 | 3.0" | Highest capacity, shortest barrel, faster falloff |
| Taurus GX4 | `weapon_gx4` | 11+1 | 3.06" | Budget option, heavier trigger, slightly slower fire rate |

## Ballistic Specifications (All 9mm)

All weapons use the same base 9mm damage model:
- **Base Damage:** 34 (3 shots to kill up close)
- **Damage at Range:** ~13 (8 shots to kill at max range)
- **Headshot Multiplier:** 3.0x (1-shot kill within 7 units)
- **Damage Falloff Range:** 12-15m start, 45-50m end

## Weapon-Specific Variations

### Bullet Speed (based on barrel length)
- G26/G26 Switch: 320 m/s (3.43" barrel)
- G43X: 318 m/s (3.41" barrel)
- Hellcat: 325 m/s (3.0" barrel - higher due to shorter barrel dynamics)
- GX4: 315 m/s (3.06" barrel)

### Recoil Amplitude (based on weight/spring system)
- G26: 0.180 (best - dual spring, heavy)
- GX4: 0.205 (good - dual spring)
- Hellcat: 0.210 (good - dual spring, adaptive grip)
- G43X: 0.220 (snappier - single spring, lightest)
- G26 Switch: 0.350 (hard to control - full auto)

### Fire Rate
- Semi-auto (all except Switch): 0.180s between shots (~333 RPM practical)
- GX4: 0.200s (heavier 6.5 lb trigger)
- G26 Switch: 0.055s (~1100 RPM full-auto)

## Folder Structure

Each weapon folder contains:
```
weapon_[name]/
├── meta/
│   └── weapon_[name].meta
├── stream/
│   └── (empty - add your .ydr/.ytd files here)
├── cl_weaponNames.lua
└── fxmanifest.lua
```

## Installation

1. Copy the weapon folder to your server's `resources` directory
2. Add your stream files (.ydr, .ytd) to the `stream/` folder
3. Add `ensure weapon_[name]` to your server.cfg
4. Restart server

## Audio

All weapons currently use `AUDIO_ITEM_SNSPISTOL` (SNS Pistol audio). Update the `<Audio>` tag in the meta file to use custom audio when ready.

## Model Files Required

For each weapon, you'll need to add to the `stream/` folder:
- `w_pi_[name].ydr` - Weapon model
- `w_pi_[name].ytd` - Weapon textures

Model names referenced in meta files:
- weapon_g26: `w_pi_g26`
- weapon_g26_switch: `w_pi_g26_switch`
- weapon_g43x: `w_pi_g43x`
- weapon_hellcat: `w_pi_hellcat`
- weapon_gx4: `w_pi_gx4`
