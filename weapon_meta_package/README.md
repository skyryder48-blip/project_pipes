# FiveM Weapon Meta Templates

## Quick Summary

For our realistic weapon project, here's what each meta file does:

| File | Contains | Same for All Weapons? |
|------|----------|----------------------|
| `weapons.meta` | **ALL ballistic data** (damage, velocity, recoil, accuracy) | NO - unique per weapon |
| `weaponarchetypes.meta` | Model/texture linking | YES - use empty template |
| `weaponanimations.meta` | Animation references | YES - per category (pistol/rifle/etc) |
| `weaponcomponents.meta` | Magazine/attachment definitions | Per weapon (for ammo types) |

## The Bottom Line

**99% of our work goes into `weapons.meta`** - that's where all the real-world ballistic research is applied.

The other files are essentially **boilerplate** that just need to exist for the weapon to function.

---

## How to Fix Existing Weapons

Your Batch 1 & 2 weapons have `weapons.meta` files with all the ballistic data, but are missing:
- `weaponarchetypes.meta` (boilerplate)
- `weaponanimations.meta` (boilerplate)

### Option 1: Use the Generator Script

```bash
cd weapon_g17/
bash ../meta_templates/generate_weapon_metas.sh g17
```

For full-auto weapons (G18, switches):
```bash
cd weapon_g19x_switch/
bash ../meta_templates/generate_weapon_metas.sh g19x_switch auto
```

### Option 2: Copy Templates Manually

1. Copy `weaponarchetypes.meta` directly (same for all weapons)
2. Copy `weaponanimations_pistol.meta` and:
   - Rename to `weaponanimations.meta`
   - Replace `WEAPON_YOURWEAPON` with your weapon hash (e.g., `WEAPON_G17`)

### Option 3: Update fxmanifest.lua

Add these data_file declarations:

```lua
files {
    'meta/weapons.meta',
    'meta/weaponarchetypes.meta',
    'meta/weaponanimations.meta',
    'meta/weaponcomponents.meta',  -- if you have ammo components
}

-- LOAD ORDER MATTERS!
data_file 'WEAPONCOMPONENTSINFO_FILE' 'meta/weaponcomponents.meta'
data_file 'WEAPON_METADATA_FILE' 'meta/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'meta/weaponanimations.meta'
data_file 'WEAPONINFO_FILE' 'meta/weapons.meta'
```

---

## Full-Auto vs Semi-Auto Weapons

| Weapon Type | Animation Template | Example Weapons |
|-------------|-------------------|-----------------|
| Semi-Auto Pistol | `weaponanimations_pistol.meta` | G17, G19, M9, P320, 1911 |
| Full-Auto Pistol | `weaponanimations_pistol_auto.meta` | G18, G26 Switch, G19X Switch |

Full-auto weapons use the AP Pistol animation set which has faster cycling animations.

---

## Complete Weapon Folder Structure

```
weapon_g17/
├── meta/
│   ├── weapons.meta           <- Your ballistic data (already created)
│   ├── weaponarchetypes.meta  <- Copy from templates (same for all)
│   ├── weaponanimations.meta  <- Generate with script or copy template
│   └── weaponcomponents.meta  <- For FMJ/HP/AP ammo (already created)
├── stream/
│   ├── w_pi_g17.ydr           <- Your model file
│   └── w_pi_g17.ytd           <- Your texture file
├── cl_weaponNames.lua         <- Display names
└── fxmanifest.lua             <- Resource manifest (update with data_file declarations)
```

---

## Files Included

- `weaponarchetypes.meta` - Universal boilerplate (copy to any weapon)
- `weaponanimations_pistol.meta` - Semi-auto pistol template
- `weaponanimations_pistol_auto.meta` - Full-auto pistol template
- `generate_weapon_metas.sh` - Shell script to auto-generate files
- `weapon_g17_complete/` - Complete working example with all files

---

## Testing Checklist

After adding the missing meta files:

1. ✓ `weapons.meta` exists with ballistic data
2. ✓ `weaponarchetypes.meta` exists (even if empty)
3. ✓ `weaponanimations.meta` exists with correct weapon hash
4. ✓ `fxmanifest.lua` has all data_file declarations
5. ✓ Model files (.ydr, .ytd) in stream/ folder
6. ✓ Resource is ensured in server.cfg

If weapon still doesn't work, check F8 console for errors about missing files or invalid XML.
