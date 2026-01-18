# Ammunition System for FiveM

A realistic ammunition management system for Qbox Framework with ox_inventory. Supports multiple calibers with FMJ, Hollow Point, and Armor Piercing variants.

## Features

- **Separate ammo items** per type (9mm FMJ, 9mm HP, 9mm AP, etc.)
- **Right-click to use** - loads ammo into currently equipped weapon
- **Magazine replacement** - old ammo returns to inventory when switching types
- **Caliber validation** - prevents loading wrong ammo into weapons
- **Weapons spawn empty** - must load ammo separately
- **Component-based** - uses GTA V's native weapon component system for reliable sync

## Installation

### 1. Add the resource
Copy the `ammo_system` folder to your server's `resources` directory.

### 2. Add item definitions
Add the contents of `items.lua` to your `ox_inventory/data/items.lua`:

```lua
-- In ox_inventory/data/items.lua, add:
['ammo_9mm_fmj'] = {
    label = '9mm FMJ',
    weight = 10,
    stack = true,
    close = true,
    description = 'Standard 9mm full metal jacket ammunition.'
},
-- ... (copy all items from items.lua)
```

### 3. Add item images
Place ammo images in `ox_inventory/web/images/`:
- `ammo_9mm_fmj.png`
- `ammo_9mm_hp.png`
- `ammo_9mm_ap.png`
- (etc. for all calibers)

### 4. Configure server.cfg
```cfg
# Load dependencies first
ensure ox_lib
ensure ox_inventory
ensure qbx_core

# Load ammo system
ensure ammo_system

# Then load weapon resources
ensure weapon_g17
ensure weapon_g19
# ... etc
```

### 5. Configure weapon resources
Each weapon resource must have the ammo components defined in its meta. See the weapon batches for examples.

## Usage

### For Players

1. **Equip a weapon** from your inventory
2. **Right-click ammo** that matches your weapon's caliber
3. Ammo loads into the weapon (old ammo returns to inventory if switching types)
4. **Fire away!**

### Debug Commands (if enabled)

- `/ammostate` - Shows current weapon and ammo information

## Configuration

Edit `shared/config.lua`:

```lua
-- Enable debug mode
Config.Debug = true

-- Weapons spawn empty by default
Config.WeaponsSpawnEmpty = true

-- Return old ammo to inventory when swapping
Config.ReturnOldAmmo = true
```

## Adding New Weapons

1. Add weapon to `shared/weapons.lua`:

```lua
[`weapon_newgun`] = {
    caliber = '9mm',
    capacity = 15,
    component_prefix = 'COMPONENT_NEWGUN',
    label = 'New Gun'
}
```

2. Ensure your weapon meta has the matching components:
```xml
<AttachPoints>
  <Item>
    <AttachBone>AAPClip</AttachBone>
    <Components>
      <Item><n>COMPONENT_NEWGUN_CLIP_FMJ</n><Default value="true" /></Item>
      <Item><n>COMPONENT_NEWGUN_CLIP_HP</n><Default value="false" /></Item>
      <Item><n>COMPONENT_NEWGUN_CLIP_AP</n><Default value="false" /></Item>
    </Components>
  </Item>
</AttachPoints>
```

## Adding New Calibers

1. Add caliber definition to `shared/config.lua`:

```lua
Config.AmmoTypes['newcaliber'] = {
    fmj = {
        item = 'ammo_newcaliber_fmj',
        label = 'New Caliber FMJ',
        component_suffix = '_CLIP_FMJ',
        damage_modifier = 1.0,
        penetration = 0.15
    },
    hp = { ... },
    ap = { ... }
}
```

2. Add item definitions to `items.lua`
3. Add item images to ox_inventory

## Ammo Types

### FMJ (Full Metal Jacket)
- **Damage:** Baseline (1.0x)
- **Penetration:** Standard
- **Best for:** General use, balanced performance

### Hollow Point (HP)
- **Damage:** +10-12% vs unarmored
- **Penetration:** Reduced
- **Best for:** Unarmored targets, maximum stopping power

### Armor Piercing (AP)
- **Damage:** -10-12% vs unarmored
- **Penetration:** +100% (bypasses body armor)
- **Best for:** Armored targets, vehicles

## Supported Calibers

| Caliber | Weapons | Ammo Types |
|---------|---------|------------|
| 9mm | Glock 17/19/26, Beretta M9, Sig P320, etc. | FMJ, HP, AP |
| .45 ACP | 1911, Glock 21/30/41 | FMJ, HP, AP |
| .40 S&W | Glock 22 variants | FMJ, HP, AP |
| 5.7x28mm | FN 57, Ruger 5.7 | FMJ, AP |
| .22 LR | Sig P22, FN 502 | Standard |
| .357 Mag | Colt Python, King Cobra | FMJ, HP |
| .44 Mag | S&W Model 29 | FMJ, HP |
| .500 S&W | S&W 500 | Standard |
| 5.56 NATO | AR-15, M16, M4 | FMJ, HP, AP, Tracer |
| 7.62x39mm | AK-47, Mini AK | FMJ, HP, AP |
| 12 Gauge | Remington 870, Mossberg 500 | Buckshot, Slug, Birdshot, Dragon's Breath |
| .308 Win | Remington 700, M24 | FMJ, Match, AP |

## Exports

### Client Exports

```lua
-- Get currently equipped weapon hash
exports.ammo_system:GetEquippedWeapon()

-- Get current ammo type for a weapon
exports.ammo_system:GetCurrentAmmoType(weaponHash)

-- Get weapon configuration
exports.ammo_system:GetWeaponConfig(weaponHash)

-- Load ammo into weapon (returns success, oldType, oldCount, error, loadedCount)
exports.ammo_system:LoadAmmoIntoWeapon(ammoType, ammoCount)
```

### Server Exports

```lua
-- Get player's loaded ammo type for a weapon
exports.ammo_system:GetPlayerWeaponAmmo(source, weaponHash)

-- Set player's loaded ammo type for a weapon
exports.ammo_system:SetPlayerWeaponAmmo(source, weaponHash, ammoType)

-- Clear player's weapon ammo state
exports.ammo_system:ClearPlayerWeaponAmmo(source, weaponHash)
```

## Integration with Weapon Systems

When your server gives/removes weapons, trigger these events to keep ammo state in sync:

```lua
-- When giving a weapon
TriggerServerEvent('ammo_system:server:weaponAdded', weaponHash)

-- When removing a weapon
TriggerServerEvent('ammo_system:server:weaponRemoved', weaponHash)
```

## Troubleshooting

### Ammo won't load
- Ensure weapon is equipped (in hand, not just in inventory)
- Check caliber matches (9mm ammo for 9mm weapons)
- Verify weapon is in `shared/weapons.lua`

### Components not working
- Ensure weapon meta has correct component definitions
- Component prefix in weapons.lua must match meta file
- Load ammo_system BEFORE weapon resources

### State not syncing
- Check ox_lib is loaded
- Verify dependencies in fxmanifest.lua
- Enable Config.Debug to see console output

## Credits

Developed for realistic FiveM weapon balancing project.
Uses Qbox Framework and ox_inventory.
