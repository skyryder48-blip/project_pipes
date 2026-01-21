# Custom Weapons Project

A comprehensive FiveM weapon system featuring realistic ammunition, magazine management, and selective fire capabilities. Fully integrated with ox_inventory and ox_lib.

## Features

- **98+ Custom Weapons** across 20+ batches
- **Realistic Ammunition System** with multiple ammo types per caliber
- **Magazine Management** with physical magazine inventory items
- **Selective Fire System** with semi-auto, burst, and full-auto modes
- **Universal Modification Components** (Glock switches, bump stocks)
- **Server-side Validation** for fire rate anomaly detection

---

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- FiveM Server Build 2802+

---

## Installation

### 1. Resource Installation

Copy the following folders to your server's `resources` directory:

```
resources/
├── [weapons]/
│   └── (your weapon stream files)
├── ammo_system_standalone/
└── free_selectivefire/
```

### 2. Server Configuration

Add to your `server.cfg`:

```cfg
# Load dependencies first
ensure ox_lib
ensure ox_inventory

# Load weapon systems
ensure ammo_system_standalone
ensure free_selectivefire
```

### 3. Weapon Stream Files

Place your weapon model files in the appropriate stream folders:

```
[weapons]/
├── g17/
│   ├── w_pi_g17.ydr
│   ├── w_pi_g17.ytd
│   └── weapons_g17.meta
├── g19/
│   └── ...
└── ...
```

See `docs/WEAPON_LIST.md` for complete weapon naming conventions.

### 4. ox_inventory Items

Add the items from `docs/OX_INVENTORY_ITEMS.lua` to your ox_inventory items configuration.

**Location:** `ox_inventory/data/items.lua`

Items include:
- Ammunition (55+ types)
- Magazines (70+ types)
- Speedloaders (6 types)
- Modification Components (4 universal types)

### 5. Ammo Meta Files

The ammo meta files are automatically loaded via `fxmanifest.lua`:

```
ammo_system_standalone/meta/
├── ammo_9mm.meta
├── ammo_45acp.meta
├── ammo_40sw.meta
├── ammo_357mag.meta
├── ammo_38spl.meta
├── ammo_44mag.meta
├── ammo_500sw.meta
├── ammo_57x28.meta
├── ammo_10mm.meta
├── ammo_22lr.meta
├── ammo_12gauge.meta
├── ammo_556.meta
├── ammo_68x51.meta
├── ammo_300blk.meta
├── ammo_762x39.meta
├── ammo_762x51.meta
├── ammo_300wm.meta
├── ammo_50bmg.meta
└── ammo_dart.meta
```

### 6. Weapon Components Meta

The selective fire modification components are loaded automatically:

```
free_selectivefire/meta/
└── weaponcomponents_modifications.meta
```

---

## Configuration

### Ammunition System

**File:** `ammo_system_standalone/shared/config.lua`

```lua
Config.Debug = false                -- Enable debug logging
Config.ReturnOldAmmo = true         -- Return old ammo when swapping types
Config.ReloadDelay = 1500           -- Reload animation duration (ms)
```

### Magazine System

**File:** `ammo_system_standalone/shared/magazines.lua`

```lua
Config.MagazineSystem = {
    enabled = true,
    loadTimePerRound = 0.5,         -- Seconds per round when loading
    swapTime = {
        standard = 1.5,             -- Standard mag swap time
        extended = 2.0,             -- Extended mag swap time
        drum = 3.0,                 -- Drum mag swap time
    },
    allowPartialLoad = true,        -- Allow partial magazine loads
    autoReloadFromInventory = true, -- Auto-reload from inventory
    autoReloadPriority = 'same_ammo_first',
}
```

### Selective Fire System

**File:** `free_selectivefire/shared/config.lua`

```lua
Config.ToggleKey = 'B'              -- Fire mode toggle key (ox_lib keybind)
Config.PlaySound = true             -- Play sound on mode change
Config.RememberMode = true          -- Remember mode per weapon

Config.FireRates = {
    SEMI = 250,                     -- Min time between semi-auto shots (ms)
    BURST = 60,                     -- Time between burst shots (ms)
    FULL = 60,                      -- Time between full-auto shots (ms)
}

Config.BurstDelay = 350             -- Delay after burst (ms)
Config.DefaultBurstCount = 3        -- Default burst rounds
```

### Server Validation

**File:** `free_selectivefire/server/sv_firevalidation.lua`

```lua
ValidationConfig = {
    EnableValidation = true,        -- Enable fire rate validation
    EnableLogging = true,           -- Log violations
    EnableKick = false,             -- Kick on excessive violations
    ViolationThreshold = 5,         -- Violations before logging
    KickThreshold = 15,             -- Violations before kick
}
```

---

## Usage

### Fire Mode Toggle

Press **B** (default, rebindable in FiveM settings) to cycle through available fire modes:
- **SEMI** - Semi-automatic (1 shot per trigger pull)
- **BURST** - 3-round burst (configurable)
- **FULL** - Full-automatic

### Magazine Management

1. **Load Magazine:** Right-click empty magazine in inventory
2. **Select Ammo Type:** Choose from available ammunition
3. **Equip Magazine:** Right-click loaded magazine while holding weapon
4. **Combat Reload:** Automatic when magazine empties (if enabled)

### Modification Components

Universal components work on multiple compatible weapons:

| Component | Compatible Weapons |
|-----------|-------------------|
| `glock_switch` | All Glock 9mm/10mm pistols |
| `bump_stock` | All AR-15 platform rifles |
| `smg_switch` | TEC-9 and compatible SMGs |
| `ak_bumpstock` | AK platform rifles |

---

## Caliber System

### Available Calibers

| Caliber | Ammo Types | Default |
|---------|------------|---------|
| 9mm | FMJ, HP, AP | FMJ |
| .45 ACP | FMJ, JHP | FMJ |
| .40 S&W | FMJ, JHP | FMJ |
| .357 Mag | FMJ, JHP | FMJ |
| .38 Spl | FMJ, JHP | FMJ |
| .44 Mag | FMJ, JHP | FMJ |
| .500 S&W | FMJ, JHP | FMJ |
| 5.7x28mm | FMJ, JHP, AP | FMJ |
| 10mm | FBI, Full Power, Bear | FBI |
| .22 LR | FMJ, JHP | FMJ |
| 5.56 NATO | FMJ, SP, AP | FMJ |
| 6.8x51mm | FMJ, AP | FMJ |
| .300 BLK | Supersonic, Subsonic | Supersonic |
| 7.62x39mm | FMJ, SP, AP | FMJ |
| 7.62x51mm | FMJ, Match, AP | FMJ |
| .300 Win Mag | FMJ, Match | FMJ |
| .50 BMG | Ball, API, BOOM | Ball |
| 12 Gauge | 00 Buck, #1 Buck, Slug, Birdshot, Pepperball, Dragon's Breath, Beanbag, Breach | 00 Buck |
| Dart | Tranquilizer | Tranq |

---

## Exports

### Ammunition System

```lua
-- Get weapon info
exports.ammo_system_standalone:GetWeaponInfo(weaponHash)

-- Check if weapon is supported
exports.ammo_system_standalone:IsWeaponSupported(weaponHash)

-- Get equipped weapon
exports.ammo_system_standalone:GetEquippedWeapon()
```

### Magazine System

```lua
-- Load magazine
exports.ammo_system_standalone:LoadMagazine(magazineItem, magazineSlot)

-- Unload magazine
exports.ammo_system_standalone:UnloadMagazine(magazineItem, magazineSlot, metadata)

-- Equip magazine
exports.ammo_system_standalone:EquipMagazine(magazineItem, magazineSlot, metadata)

-- Get equipped magazine for weapon
exports.ammo_system_standalone:GetEquippedMagazine(weaponHash)
```

### Selective Fire System

```lua
-- Get current fire mode
exports.free_selectivefire:GetCurrentFireMode()

-- Get current weapon hash
exports.free_selectivefire:GetCurrentWeaponHash()

-- Check if weapon has select fire
exports.free_selectivefire:HasSelectFire(weaponHash)

-- Set fire mode programmatically
exports.free_selectivefire:SetFireMode(mode)  -- 'SEMI', 'BURST', 'FULL'

-- Get available modes for current weapon
exports.free_selectivefire:GetAvailableModes()

-- Check armed status
exports.free_selectivefire:IsArmed()
```

### Server Exports

```lua
-- Get player violations
exports.free_selectivefire:GetViolations(playerId)

-- Reset player violations
exports.free_selectivefire:ResetViolations(playerId)

-- Get player's current fire mode
exports.free_selectivefire:GetPlayerFireMode(playerId)
```

---

## Admin Commands

Server console commands for selective fire validation:

```
sf_check <playerId>    -- Check player's fire state and violations
sf_reset <playerId>    -- Reset player's violation count
sf_clear <playerId>    -- Clear all state for player
```

---

## Troubleshooting

### Weapons not appearing
- Ensure weapon stream files are in correct folder structure
- Verify `weapons_*.meta` files reference correct model names
- Check server console for streaming errors

### Ammo not loading
- Verify ammo meta files are listed in `fxmanifest.lua`
- Check `data_file` declarations match file paths
- Enable `Config.Debug = true` for detailed logging

### Fire modes not working
- Ensure ox_lib is loaded before free_selectivefire
- Check weapon is defined in `Config.Weapons`
- Verify keybind is not conflicting (check FiveM settings)

### Magazine system issues
- Ensure ox_inventory items are properly configured
- Check magazine `weapons` array matches weapon names exactly
- Verify caliber matches between weapon and magazine

---

## File Structure

```
project_pipes/
├── ammo_system_standalone/
│   ├── client/
│   │   ├── cl_ammo.lua
│   │   ├── magazine_client.lua
│   │   └── pepperball_effects.lua
│   ├── server/
│   │   └── sv_ammo.lua
│   ├── shared/
│   │   ├── config.lua
│   │   ├── weapons.lua
│   │   └── magazines.lua
│   ├── meta/
│   │   └── ammo_*.meta
│   └── fxmanifest.lua
├── free_selectivefire/
│   ├── client/
│   │   └── cl_firecontrol.lua
│   ├── server/
│   │   └── sv_firevalidation.lua
│   ├── shared/
│   │   └── config.lua
│   ├── meta/
│   │   └── weaponcomponents_modifications.meta
│   └── fxmanifest.lua
└── docs/
    ├── WEAPON_LIST.md
    └── OX_INVENTORY_ITEMS.lua
```

---

## Credits

- ox_lib and ox_inventory by Overextended
- Weapon models by various FiveM developers

## License

This project is provided as-is for roleplay server use.
