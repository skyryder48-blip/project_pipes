# Glock 17 Gen 4 - Complete Weapon Package

## Folder Structure
```
weapon_g17/
├── meta/
│   ├── weapons.meta          <- ALL BALLISTIC DATA (damage, velocity, recoil, etc.)
│   ├── weaponarchetypes.meta <- Boilerplate (model/texture linking)
│   ├── weaponanimations.meta <- Boilerplate (base game pistol animations)
│   └── weaponcomponents.meta <- FMJ/HP/AP magazine components
├── stream/
│   ├── w_pi_g17.ydr          <- YOUR MODEL FILE
│   └── w_pi_g17.ytd          <- YOUR TEXTURE FILE
├── cl_weaponNames.lua        <- Display names
└── fxmanifest.lua            <- Resource manifest
```

## Installation
1. Add your model files (.ydr, .ytd) to the `stream/` folder
2. Copy this folder to your server's `resources/` directory
3. Add `ensure weapon_g17` to your server.cfg
4. Restart server

## Ballistic Specifications
| Parameter | Value | Real-World Basis |
|-----------|-------|------------------|
| Damage | 34 | 9mm baseline (3-shot close, 8-shot far) |
| Bullet Speed | 355 m/s | 4.49" barrel, 115gr FMJ |
| Headshot Modifier | 2.90x | 2-shot headshot at all ranges |
| Magazine | 17+1 | Standard G17 capacity |
| Fire Rate | 0.170s | ~350 RPM practical |
| Recoil | 0.200 | 625g weight, moderate |

## Ammo Components
- COMPONENT_G17_CLIP_FMJ (default, 17 rounds)
- COMPONENT_G17_CLIP_HP (17 rounds, +10% damage)
- COMPONENT_G17_CLIP_AP (15 rounds, armor piercing)
