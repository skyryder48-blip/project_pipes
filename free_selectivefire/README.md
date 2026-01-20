# Free Selective Fire System

A realistic fire mode selector for FiveM weapons. This resource allows players to toggle between semi-automatic, burst, and full-automatic fire modes on supported weapons, based on real-world equivalents.

## Features

- **Realistic Fire Modes**: Semi-auto, 3-round burst, and full-auto based on real weapon capabilities
- **Modification Support**: Certain weapons can gain full-auto capability through attachments (Glock switches, bump stocks)
- **Per-Weapon Configuration**: Each weapon has its own available fire modes
- **Visual HUD Indicator**: Shows current fire mode when wielding select-fire weapons
- **Mode Memory**: Remembers your selected mode per weapon across weapon switches
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

| Mode | Behavior | Visual Indicator |
|------|----------|-----------------|
| **SEMI** | One shot per trigger pull | White "SEMI" |
| **BURST** | 3 rounds per trigger pull, then pause | Yellow "BURST" |
| **FULL** | Continuous fire while holding trigger | Red "AUTO" |

## Configuration

### General Settings (`shared/config.lua`)

```lua
Config.ToggleKey = 'B'              -- Key to cycle fire modes
Config.ToggleKeyCode = 29           -- FiveM control code
Config.ShowHUD = true               -- Show fire mode indicator
Config.PlaySound = true             -- Play sound on mode change
Config.RememberMode = true          -- Remember mode per weapon
```

### Adding New Weapons

To add a new weapon with select fire capability:

```lua
Config.Weapons[`WEAPON_YOURWEAPON`] = {
    name = 'Display Name',
    selectFire = true,                    -- Has native select fire
    modes = {'SEMI', 'BURST', 'FULL'},   -- Available modes
    defaultMode = 'SEMI',                 -- Starting mode
    burstCount = 3,                       -- Rounds per burst (optional)
    description = 'Description text',
}
```

### Adding Modifiable Weapons

For weapons that gain full-auto through modifications (like Glock switches):

```lua
Config.Weapons[`WEAPON_G17`] = {
    name = 'Glock 17',
    selectFire = false,                            -- No native select fire
    modes = {'SEMI'},                              -- Default: semi-only
    defaultMode = 'SEMI',
    modifiable = true,                             -- Can be modified
    modificationComponent = 'COMPONENT_G17_SWITCH', -- Component that enables mod
    modesWhenModified = {'SEMI', 'FULL'},          -- Modes when modified
}
```

## Pre-Configured Weapons

### Rifles with Select Fire

| Weapon | Modes | Default | Notes |
|--------|-------|---------|-------|
| WEAPON_M16 | SEMI, BURST | SEMI | M16A4 - 3-round burst |
| WEAPON_RED_AUG | SEMI, FULL | SEMI | Steyr AUG A3 bullpup |
| WEAPON_CZ_BREN | SEMI, FULL | SEMI | CZ BREN 2 modular |
| WEAPON_RAM7KNIGHT | SEMI, FULL | SEMI | IWI Tavor bullpup |
| WEAPON_MINI_AK47 | SEMI, FULL | FULL | Micro Draco AK pistol |
| WEAPON_MK47 | SEMI, FULL | SEMI | CMMG Mk47 Mutant |

### Civilian Rifles (Semi-only, Bump Stock Capable)

| Weapon | Base Modes | Modified Modes |
|--------|------------|----------------|
| WEAPON_PSA_AR15 | SEMI | SEMI, FULL |
| WEAPON_DESERT_AR15 | SEMI | SEMI, FULL |

### AR-9 Pistols / SMGs

| Weapon | Modes | Default | Notes |
|--------|-------|---------|-------|
| WEAPON_UDP9 | SEMI, FULL | SEMI | Angstadt Arms UDP-9 |
| WEAPON_BLUEARP | SEMI, FULL | FULL | Budget AR-9 |

### Pistols (Glock Switch Capable)

| Weapon | Base Modes | With Switch |
|--------|------------|-------------|
| WEAPON_G17 | SEMI | SEMI, FULL |
| WEAPON_G17_BLK | SEMI | SEMI, FULL |
| WEAPON_G17_GEN5 | SEMI | SEMI, FULL |
| WEAPON_G19 | SEMI | SEMI, FULL |
| WEAPON_G19X | SEMI | SEMI, FULL |
| WEAPON_G26 | SEMI | SEMI, FULL |
| WEAPON_G43X | SEMI | SEMI, FULL |
| WEAPON_G45 | SEMI | SEMI, FULL |

## Creating Modification Components

To enable Glock switches or bump stocks, you need to create weapon components in your weapon's `weaponcomponents.meta`:

### Example: Glock Switch Component

```xml
<Item type="CWeaponComponentInfo">
  <Name>COMPONENT_G17_SWITCH</Name>
  <Model>w_pi_g17_switch</Model>
  <LocName>WCT_SWITCH</LocName>
  <LocDesc>WCD_SWITCH</LocDesc>
</Item>
```

Then add to the weapon's `AttachPoints` in `weapons.meta`:

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

### Example: Bump Stock Component

```xml
<Item type="CWeaponComponentInfo">
  <Name>COMPONENT_PSA_AR15_BUMPSTOCK</Name>
  <Model>w_ar_psa_ar15_bumpstock</Model>
  <LocName>WCT_BUMPSTOCK</LocName>
  <LocDesc>WCD_BUMPSTOCK</LocDesc>
</Item>
```

## Exports

The resource provides exports for integration with other scripts:

```lua
-- Get current fire mode
local mode = exports['free_selectivefire']:GetCurrentFireMode()
-- Returns: 'SEMI', 'BURST', or 'FULL'

-- Get current weapon hash
local weapon = exports['free_selectivefire']:GetCurrentWeapon()

-- Check if current weapon has select fire
local hasSelectFire = exports['free_selectivefire']:HasSelectFire()
-- Optional: pass weapon hash
local hasSelectFire = exports['free_selectivefire']:HasSelectFire(weaponHash)

-- Set fire mode programmatically
local success = exports['free_selectivefire']:SetFireMode('FULL')
-- Returns: true if mode was set, false if not available

-- Get available modes for current weapon
local modes = exports['free_selectivefire']:GetAvailableModes()
-- Returns: {'SEMI', 'FULL'} or similar

-- Get HUD data (for custom UI)
local hudData = exports['free_selectivefire']:GetHUDData()
--[[
Returns: {
    mode = 'SEMI',
    weaponName = 'Glock 17',
    availableModes = {'SEMI', 'FULL'},
    hasSelectFire = true,
    isVisible = true,
}
]]
```

## Events

Listen to fire mode changes:

```lua
AddEventHandler('selectivefire:modeChanged', function(mode, weaponHash)
    print('Fire mode changed to: ' .. mode)
end)

AddEventHandler('selectivefire:noSelectFire', function(weaponHash)
    print('This weapon does not have select fire')
end)
```

## Custom UI Integration

If you want to use your own UI framework instead of the built-in HUD:

1. Set `Config.ShowHUD = false` in config
2. Listen to the `selectivefire:modeChanged` event
3. Use the `GetHUDData` export to get current state
4. Render your own UI

Example with NUI:

```lua
AddEventHandler('selectivefire:modeChanged', function(mode, weaponHash)
    local data = exports['free_selectivefire']:GetHUDData()
    SendNUIMessage({
        action = 'updateFireMode',
        data = data
    })
end)
```

## Troubleshooting

### Fire mode not changing
- Ensure the weapon is configured in `Config.Weapons`
- Check that the weapon has more than one mode available
- Verify the toggle key isn't conflicting with other resources

### Modification not working
- Verify the component name matches exactly in both config and meta
- Ensure the component is properly attached to the weapon
- Check that the player actually has the component equipped

### HUD not showing
- Verify `Config.ShowHUD = true`
- Ensure you're holding a weapon that has select fire
- Check for script errors in F8 console

## Compatibility

- Works with all custom addon weapons
- Compatible with most inventory systems
- Does not conflict with other weapon mods
- Can run alongside ammo_system_standalone

## Credits

- Custom Weapons Project
- FiveM Addon Weapon Tool Kit (animation references)

## License

Free to use and modify. Attribution appreciated but not required.
