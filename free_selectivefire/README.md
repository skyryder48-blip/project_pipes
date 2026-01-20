# Free Selective Fire System

A realistic fire mode selector for FiveM weapons. This resource allows players to toggle between semi-automatic, burst, and full-automatic fire modes on supported weapons, based on real-world equivalents.

## Features

- **Realistic Fire Modes**: Semi-auto, 3-round burst, and full-auto based on real weapon capabilities
- **Modification Support**: Certain weapons can gain full-auto capability through attachments (Glock switches, bump stocks)
- **Per-Weapon Configuration**: Each weapon has its own available fire modes
- **Subtle Feedback**: Brief notification and sound on mode change
- **Mode Memory**: Remembers your selected mode per weapon
- **Configurable**: Easy to add new weapons or modify existing configurations

## Installation

1. Copy the `free_selectivefire` folder to your server's `resources` directory
2. Add `ensure free_selectivefire` to your `server.cfg`
3. Restart your server or start the resource

## Usage

### Default Controls

| Key | Action |
|-----|--------|
| **B** | Cycle fire modes (Semi → Burst → Full → Semi...) |

### Fire Modes

| Mode | Behavior |
|------|----------|
| **Semi-Auto** | One shot per trigger pull |
| **Burst** | 3 rounds per trigger pull, then pause |
| **Full-Auto** | Continuous fire while holding trigger |

## Configuration

### General Settings (`shared/config.lua`)

```lua
Config.ToggleKey = 'B'              -- Key to cycle fire modes
Config.ToggleKeyCode = 29           -- FiveM control code
Config.PlaySound = true             -- Play sound on mode change
Config.RememberMode = true          -- Remember mode per weapon
```

### Adding New Weapons

```lua
Config.Weapons[`WEAPON_YOURWEAPON`] = {
    name = 'Display Name',
    selectFire = true,
    modes = {'SEMI', 'BURST', 'FULL'},
    defaultMode = 'SEMI',
    burstCount = 3,  -- optional, for burst mode
}
```

### Adding Modifiable Weapons

For weapons that gain full-auto through modifications:

```lua
Config.Weapons[`WEAPON_G17`] = {
    name = 'Glock 17',
    selectFire = false,
    modes = {'SEMI'},
    defaultMode = 'SEMI',
    modifiable = true,
    modificationComponent = 'COMPONENT_G17_SWITCH',
    modesWhenModified = {'SEMI', 'FULL'},
}
```

## Pre-Configured Weapons

### Rifles with Select Fire

| Weapon | Modes | Default |
|--------|-------|---------|
| M16 | SEMI, BURST | SEMI |
| AUG, BREN, Tavor | SEMI, FULL | SEMI |
| Mini AK47 | SEMI, FULL | FULL |
| MK47 | SEMI, FULL | SEMI |

### Civilian Rifles (Bump Stock Capable)

| Weapon | Base | With Modification |
|--------|------|-------------------|
| PSA AR-15 | SEMI | SEMI, FULL |
| Desert AR-15 | SEMI | SEMI, FULL |

### AR-9 Pistols / SMGs

| Weapon | Modes | Default |
|--------|-------|---------|
| UDP-9 | SEMI, FULL | SEMI |
| Blue ARP | SEMI, FULL | FULL |

### Pistols (Glock Switch Capable)

| Weapon | Base | With Switch |
|--------|------|-------------|
| G17, G17_BLK, G17_GEN5 | SEMI | SEMI, FULL |
| G19, G19X, G45 | SEMI | SEMI, FULL |
| G26, G43X | SEMI | SEMI, FULL |

## Creating Modification Components

### Glock Switch Component (weaponcomponents.meta)

```xml
<Item type="CWeaponComponentInfo">
  <Name>COMPONENT_G17_SWITCH</Name>
  <Model>w_pi_g17_switch</Model>
  <LocName>WCT_SWITCH</LocName>
  <LocDesc>WCD_SWITCH</LocDesc>
</Item>
```

Add to weapon's `AttachPoints` in `weapons.meta`:

```xml
<Item>
  <AttachBone>WAPGrip</AttachBone>
  <Components>
    <Item>
      <Name>COMPONENT_G17_SWITCH</Name>
      <Default value="false" />
    </Item>
  </Components>
</Item>
```

## Exports

```lua
-- Get current fire mode
local mode = exports['free_selectivefire']:GetCurrentFireMode()

-- Check if weapon has select fire
local hasSelectFire = exports['free_selectivefire']:HasSelectFire()

-- Set fire mode programmatically
exports['free_selectivefire']:SetFireMode('FULL')

-- Get available modes
local modes = exports['free_selectivefire']:GetAvailableModes()
```

## Compatibility

- Works with all custom addon weapons
- Compatible with most inventory systems
- Can run alongside ammo_system_standalone

## Credits

- Custom Weapons Project

## License

Free to use and modify.
