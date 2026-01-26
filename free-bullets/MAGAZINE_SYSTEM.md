# Full Realistic Magazine System

## Overview

This system implements a fully realistic magazine management system where:
- **Magazines are physical inventory items** that must be purchased
- **Magazines must be loaded with ammo** before they can be used
- **Players carry multiple pre-loaded magazines** into combat
- **Empty magazines persist** and can be reloaded later
- **Loading can be done directly from inventory** (no workbench required)

## How It Works

### Inventory Items

```
LOOSE AMMO (stackable)     EMPTY MAGAZINES (stackable)     LOADED MAGAZINES (unique)
├── ammo_9mm_fmj          ├── mag_g26_standard            ├── mag_g26_standard
├── ammo_9mm_hp           ├── mag_g26_extended            │   └── metadata: {ammoType:'hp', count:10}
├── ammo_9mm_ap           └── mag_g26_drum                └── mag_g26_extended
└── ...                                                        └── metadata: {ammoType:'fmj', count:33}
```

### Player Workflow

#### Before Combat (Preparation)

1. **Buy magazines** from gun store
   - `mag_g26_standard` - $25 (10 rounds)
   - `mag_g26_extended` - $85 (33 rounds)
   - `mag_g26_drum` - $250 (50 rounds)

2. **Buy loose ammo**
   - `ammo_9mm_fmj` x100 - Standard rounds
   - `ammo_9mm_hp` x50 - Hollow points
   - `ammo_9mm_ap` x50 - Armor piercing

3. **Load magazines from inventory**
   - Right-click empty magazine → "Load Magazine"
   - Select ammo type (FMJ, HP, or AP)
   - Select amount (full, half, or custom)
   - Wait for loading progress bar

4. **Result:** Player now has loaded magazines ready for combat
   ```
   Inventory:
   - mag_g26_extended (33/33 HP)
   - mag_g26_extended (33/33 HP)
   - mag_g26_extended (33/33 FMJ)
   - mag_g26_standard (10/10 AP)
   - ammo_9mm_fmj x1 (leftover)
   ```

#### During Combat

1. **Equip weapon** - Glock 26

2. **Equip magazine**
   - Right-click loaded magazine → "Equip to Weapon"
   - Magazine is removed from inventory
   - Weapon now has that magazine's capacity and ammo type

3. **Fire weapon**
   - Ammo count decreases as shots are fired
   - System tracks remaining rounds in current magazine

4. **Magazine empties**
   - System checks inventory for another loaded magazine
   - If found: Auto-swap to next magazine (prioritizes same ammo type)
   - Empty magazine returns to inventory for later reloading
   - If no magazines: Player is notified, empty mag returned

5. **Manual magazine swap**
   - Right-click different loaded magazine → "Equip to Weapon"
   - Current magazine (with remaining ammo) returns to inventory
   - New magazine is equipped

#### After Combat

1. **Empty magazines** are back in inventory (stackable when empty)
2. **Partially used magazines** have metadata with remaining count
3. **Reload empty magazines** from loose ammo for next fight

### Unloading Magazines

If you want to change ammo types in a magazine:

1. Right-click loaded magazine → "Unload Magazine"
2. Wait for unloading progress
3. Loose ammo returns to inventory
4. Magazine becomes empty (stackable)
5. Reload with different ammo type

---

## Technical Implementation

### File Structure

```
ammo_system_standalone/
├── shared/
│   ├── config.lua           # Ammo type definitions
│   ├── weapons.lua          # Weapon → caliber mapping
│   └── magazines.lua        # Magazine definitions (NEW)
├── client/
│   ├── ammo_client.lua      # Existing ammo switching
│   └── magazine_client.lua  # Magazine management (NEW)
├── server/
│   ├── ammo_server.lua      # Existing ammo handling
│   └── magazine_server.lua  # Magazine inventory ops (NEW)
├── inventory/
│   └── magazine_items.lua   # ox_inventory item definitions (NEW)
└── meta/
    ├── weaponcomponents_9mm.meta          # Standard clips
    └── weaponcomponents_9mm_extended.meta # Extended/drum clips (NEW)
```

### Component Naming Convention

```
Standard:  COMPONENT_{WEAPON}_CLIP_{AMMO}
Extended:  COMPONENT_{WEAPON}_EXTCLIP_{AMMO}
Drum:      COMPONENT_{WEAPON}_DRUM_{AMMO}

Examples:
- COMPONENT_G26_CLIP_FMJ      (10 rounds, FMJ)
- COMPONENT_G26_EXTCLIP_HP    (33 rounds, HP)
- COMPONENT_G26_DRUM_AP       (50 rounds, AP)
```

### Magazine Metadata Structure

```lua
-- Empty magazine (stackable)
{
    name = "mag_g26_extended",
    count = 3,  -- Player has 3 empty mags
    -- No metadata = empty
}

-- Loaded magazine (unique item)
{
    name = "mag_g26_extended",
    count = 1,
    metadata = {
        ammoType = "hp",      -- Type of ammo loaded
        count = 28,           -- Rounds remaining
        maxCount = 33,        -- Magazine capacity
        label = "Glock 26 Extended Mag (28/33 HP)"
    }
}
```

---

## Configuration Options

```lua
Config.MagazineSystem = {
    enabled = true,

    -- Time to load one round (seconds)
    loadTimePerRound = 0.5,

    -- Swap times by magazine type
    swapTime = {
        standard = 1.5,
        extended = 2.0,
        drum = 3.0,
    },

    -- Allow loading partial magazines
    allowPartialLoad = true,

    -- Auto-reload when magazine empties
    autoReloadFromInventory = true,

    -- Priority for auto-reload
    -- 'same_ammo_first' - Prefer same ammo type
    -- 'highest_capacity' - Prefer fullest magazine
    -- 'any' - First available
    autoReloadPriority = 'same_ammo_first',
}
```

---

## Adding New Magazines

### 1. Add to magazines.lua

```lua
['mag_newweapon_extended'] = {
    label = "New Weapon Extended (25rd)",
    weapons = { 'WEAPON_NEWWEAPON' },
    capacity = 25,
    type = 'extended',
    componentSuffix = '_EXTCLIP_',
    weight = 150,
    price = 75,
},
```

### 2. Add to ox_inventory items

```lua
['mag_newweapon_extended'] = {
    label = 'New Weapon Extended (25rd)',
    weight = 150,
    stack = true,
    close = true,
    description = 'Extended magazine for New Weapon',
},
```

### 3. Create weapon components

```xml
<Item type="CWeaponComponentClipInfo">
  <n>COMPONENT_NEWWEAPON_EXTCLIP_FMJ</n>
  <ClipSize value="25" />
  <AmmoInfo ref="AMMO_9MM_FMJ" />
  <!-- ... other properties ... -->
</Item>
```

---

## Weapon Modification System (Switches, Bump Stocks, Binary Triggers)

Fire mode modifications are handled by the **selective fire system** via component attachment.

### How It Works:
1. Player uses modification item (e.g., `glock_switch`) on compatible weapon
2. Item attaches a component (e.g., `COMPONENT_G26_SWITCH`) to the weapon
3. Selective fire system detects component via `HasPedGotWeaponComponent()`
4. Fire modes unlock automatically (SEMI → SEMI/FULL)

### Benefits of Component Approach:
- **No separate weapon variants** - Same G26, different behavior
- **Magazines work identically** - No reconfiguration needed
- **Reversible modifications** - Components can be detached
- **Simpler inventory** - One weapon item, multiple capabilities

### Example Configuration (selective fire):
```lua
[`WEAPON_G26`] = {
    name = 'Glock 26',
    selectFire = false,
    modes = {'SEMI'},
    defaultMode = 'SEMI',
    modifiable = true,
    modificationComponent = 'COMPONENT_G26_SWITCH',
    modesWhenModified = {'SEMI', 'FULL'},
}
```

See: `free_selectivefire/shared/config.lua` for full configuration

---

## Realism Notes

### Why This System?

1. **Magazines are physical objects** - You can't magically change the ammo in a magazine mid-firefight

2. **Extended mags require investment** - Players must buy and carry larger magazines, adding weight and cost

3. **Combat preparation matters** - Players who prepare multiple loaded magazines have an advantage

4. **Empty mags persist** - Realistic - you don't throw away expensive magazines, you reload them

5. **No workbench required** - Loading a magazine is simple enough to do anywhere (just time-consuming)

### Balancing Considerations

- **Extended mags** add weight and reduce handling (accuracy penalty)
- **Drum mags** are heavy, slow to swap, but devastating with capacity
- **Loading time** prevents mid-combat reloading of empty mags
- **Magazine cost** creates economic investment in loadout

---

## Integration with Existing Ammo System

This magazine system **extends** the existing ammo type system:

- **Ammo types** (FMJ, HP, AP) still define ballistic properties
- **Magazines** now determine capacity AND carry the ammo type
- **Weapon components** combine both: `COMPONENT_G26_EXTCLIP_HP` = 33 rounds of HP

The two systems work together:
1. Player loads magazine with specific ammo type
2. When equipped, system applies matching component
3. Component defines both capacity (ClipSize) and ammo (AmmoInfo)
