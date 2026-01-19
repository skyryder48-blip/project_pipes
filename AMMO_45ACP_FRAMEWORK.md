# .45 ACP Ammunition System Framework

## Development Outline for `ammo_45acp` Resource

This document provides a complete framework for developing the centralized .45 ACP ammunition resource, following the established pattern from `ammo_9mm`.

---

## 1. Resource Overview

### Purpose
Centralized ammunition management for all .45 ACP weapons, providing:
- Standardized ammo definitions (FMJ, JHP)
- Magazine components for ammo type switching
- Damage modifiers per ammunition type
- Integration with ox_inventory

### Compatible Weapons (Batch 3)
| Weapon | Hash | Default Clip |
|--------|------|--------------|
| Colt M45A1 | `WEAPON_M45A1` | 8 rounds |
| Kimber 1911 | `WEAPON_KIMBER1911` | 7 rounds |
| Kimber Eclipse | `WEAPON_KIMBER_ECLIPSE` | 8 rounds |
| Glock 21 | `WEAPON_G21` | 13 rounds |
| Glock 30 | `WEAPON_G30` | 10 rounds |
| Glock 41 | `WEAPON_G41` | 13 rounds |
| Junk 1911 | `WEAPON_JUNK1911` | 7 rounds |

---

## 2. Ammunition Types

### 2.1 FMJ (Full Metal Jacket)
**Role:** Standard ammunition, baseline performance

| Property | Value | Notes |
|----------|-------|-------|
| Base Damage | 38 | Standard .45 ACP |
| Penetration | 0.20 | Moderate barrier penetration |
| Armor Modifier | 1.0x | Standard against armor |
| Falloff Modifier | 0.36 | Standard range effectiveness |

**Characteristics:**
- Reliable feeding in all firearms
- Over-penetration risk (24-28" gel penetration)
- Cost-effective, widely available
- Default ammunition type

### 2.2 JHP (Jacketed Hollow Point)
**Role:** Premium defensive ammunition, enhanced stopping power

| Property | Value | Notes |
|----------|-------|-------|
| Base Damage | 44 | +15.8% over FMJ |
| Penetration | 0.12 | Reduced barrier penetration |
| Armor Modifier | 0.75x | Less effective vs armor |
| Falloff Modifier | 0.38 | Slightly better energy retention |

**Characteristics:**
- Combined standard/+P performance (850-950 fps)
- Expansion: 0.85-0.95" (188-210% of original)
- Ideal penetration depth: 13-15"
- Higher cost, premium positioning

---

## 3. Folder Structure

```
ammo_45acp/
├── fxmanifest.lua
├── config.lua
├── server/
│   ├── sv_ammo.lua          # Server-side ammo management
│   └── sv_callbacks.lua      # NUI/client callbacks
├── client/
│   ├── cl_ammo.lua          # Client-side ammo handling
│   └── cl_events.lua        # Event handlers
├── shared/
│   └── sh_config.lua        # Shared configuration
└── meta/
    ├── weaponammoTypes.meta  # Ammo type definitions
    └── weaponcomponents.meta # Magazine components
```

---

## 4. Configuration Files

### 4.1 fxmanifest.lua

```lua
fx_version 'cerulean'
game 'gta5'

author 'Realistic Weapons Project'
description '.45 ACP Ammunition System - FMJ/JHP Types'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/sh_config.lua'
}

client_scripts {
    'client/cl_ammo.lua',
    'client/cl_events.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/sv_ammo.lua',
    'server/sv_callbacks.lua'
}

files {
    'meta/weaponammoTypes.meta',
    'meta/weaponcomponents.meta'
}

data_file 'WEAPONINFO_FILE_PATCH' 'meta/weaponammoTypes.meta'
data_file 'WEAPONCOMPONENTSINFO_FILE' 'meta/weaponcomponents.meta'

dependencies {
    'ox_inventory',
    'ox_lib'
}
```

### 4.2 shared/sh_config.lua

```lua
Config = {}

-- Ammunition definitions
Config.AmmoTypes = {
    ['ammo_45acp_fmj'] = {
        label = '.45 ACP FMJ',
        ammoType = 'AMMO_45ACP_FMJ',
        damageModifier = 1.0,
        penetration = 0.20,
        armorModifier = 1.0,
        price = 15,
        weight = 25,  -- per round in grams
    },
    ['ammo_45acp_jhp'] = {
        label = '.45 ACP JHP',
        ammoType = 'AMMO_45ACP_JHP',
        damageModifier = 1.158,  -- 44/38 = 1.158
        penetration = 0.12,
        armorModifier = 0.75,
        price = 35,
        weight = 25,
    }
}

-- Compatible weapons mapping
Config.CompatibleWeapons = {
    ['WEAPON_M45A1'] = {
        clipSize = 8,
        clips = {
            fmj = 'COMPONENT_M45A1_CLIP_FMJ',
            jhp = 'COMPONENT_M45A1_CLIP_JHP'
        }
    },
    ['WEAPON_KIMBER1911'] = {
        clipSize = 7,
        clips = {
            fmj = 'COMPONENT_KIMBER1911_CLIP_FMJ',
            jhp = 'COMPONENT_KIMBER1911_CLIP_JHP'
        }
    },
    ['WEAPON_KIMBER_ECLIPSE'] = {
        clipSize = 8,
        clips = {
            fmj = 'COMPONENT_KIMBER_ECLIPSE_CLIP_FMJ',
            jhp = 'COMPONENT_KIMBER_ECLIPSE_CLIP_JHP'
        }
    },
    ['WEAPON_G21'] = {
        clipSize = 13,
        clips = {
            fmj = 'COMPONENT_G21_CLIP_FMJ',
            jhp = 'COMPONENT_G21_CLIP_JHP'
        }
    },
    ['WEAPON_G30'] = {
        clipSize = 10,
        clips = {
            fmj = 'COMPONENT_G30_CLIP_FMJ',
            jhp = 'COMPONENT_G30_CLIP_JHP'
        }
    },
    ['WEAPON_G41'] = {
        clipSize = 13,
        clips = {
            fmj = 'COMPONENT_G41_CLIP_FMJ',
            jhp = 'COMPONENT_G41_CLIP_JHP'
        }
    },
    ['WEAPON_JUNK1911'] = {
        clipSize = 7,
        clips = {
            fmj = 'COMPONENT_JUNK1911_CLIP_FMJ',
            jhp = 'COMPONENT_JUNK1911_CLIP_JHP'
        }
    }
}

-- Default ammo type when weapon is purchased
Config.DefaultAmmoType = 'fmj'
```

---

## 5. Core Logic Implementation

### 5.1 Ammo Loading Flow

```
Player right-clicks ammo in inventory
    │
    ▼
Check if compatible weapon is equipped
    │
    ├── NO → Show error: "No compatible weapon equipped"
    │
    └── YES → Check current loaded ammo type
                │
                ├── SAME TYPE → Add rounds to magazine (up to capacity)
                │
                └── DIFFERENT TYPE → 
                        │
                        ▼
                    Return current rounds to inventory
                        │
                        ▼
                    Remove old magazine component
                        │
                        ▼
                    Add new magazine component
                        │
                        ▼
                    Load new ammo type
```

### 5.2 Key Functions

#### Client: cl_ammo.lua

```lua
-- Check if player has compatible weapon equipped
function HasCompatible45ACPWeapon()
    local ped = PlayerPedId()
    local currentWeapon = GetSelectedPedWeapon(ped)
    
    for weaponHash, data in pairs(Config.CompatibleWeapons) do
        if GetHashKey(weaponHash) == currentWeapon then
            return true, weaponHash, data
        end
    end
    
    return false, nil, nil
end

-- Get current ammo type loaded in weapon
function GetCurrentAmmoType(weaponHash)
    local ped = PlayerPedId()
    local weaponData = Config.CompatibleWeapons[weaponHash]
    
    if not weaponData then return nil end
    
    for ammoType, componentHash in pairs(weaponData.clips) do
        if HasPedGotWeaponComponent(ped, GetHashKey(weaponHash), GetHashKey(componentHash)) then
            return ammoType
        end
    end
    
    return Config.DefaultAmmoType
end

-- Switch ammo type
function SwitchAmmoType(weaponHash, newAmmoType, roundsToLoad)
    local ped = PlayerPedId()
    local weaponData = Config.CompatibleWeapons[weaponHash]
    local currentAmmoType = GetCurrentAmmoType(weaponHash)
    
    -- Get current rounds in magazine
    local currentRounds = GetAmmoInPedWeapon(ped, GetHashKey(weaponHash))
    
    -- Remove old component
    if currentAmmoType and weaponData.clips[currentAmmoType] then
        RemoveWeaponComponentFromPed(ped, GetHashKey(weaponHash), GetHashKey(weaponData.clips[currentAmmoType]))
    end
    
    -- Add new component
    GiveWeaponComponentToPed(ped, GetHashKey(weaponHash), GetHashKey(weaponData.clips[newAmmoType]))
    
    -- Set ammo count
    SetPedAmmo(ped, GetHashKey(weaponHash), roundsToLoad)
    
    -- Return old rounds to inventory (server callback)
    if currentRounds > 0 and currentAmmoType then
        TriggerServerEvent('ammo_45acp:returnAmmo', currentAmmoType, currentRounds)
    end
end
```

#### Server: sv_ammo.lua

```lua
-- Handle ammo use from inventory
RegisterNetEvent('ammo_45acp:useAmmo', function(ammoItem, amount)
    local source = source
    local Player = exports.ox_inventory:GetPlayer(source)
    
    if not Player then return end
    
    -- Validate ammo item exists
    local ammoConfig = Config.AmmoTypes[ammoItem]
    if not ammoConfig then return end
    
    -- Check player has the ammo
    local itemCount = exports.ox_inventory:GetItem(source, ammoItem, nil, true)
    if not itemCount or itemCount < amount then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Ammunition',
            description = 'Not enough ammunition',
            type = 'error'
        })
        return
    end
    
    -- Request weapon check from client
    TriggerClientEvent('ammo_45acp:loadAmmo', source, ammoItem, amount)
end)

-- Return unused ammo to inventory
RegisterNetEvent('ammo_45acp:returnAmmo', function(ammoType, amount)
    local source = source
    
    if amount <= 0 then return end
    
    local itemName = 'ammo_45acp_' .. ammoType
    
    exports.ox_inventory:AddItem(source, itemName, amount)
    
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Ammunition',
        description = amount .. ' rounds returned to inventory',
        type = 'info'
    })
end)
```

---

## 6. ox_inventory Integration

### 6.1 Item Definitions

Add to `ox_inventory/data/items.lua`:

```lua
-- .45 ACP Ammunition
['ammo_45acp_fmj'] = {
    label = '.45 ACP FMJ',
    weight = 25,
    stack = true,
    close = true,
    description = 'Standard .45 ACP full metal jacket ammunition',
    client = {
        export = 'ammo_45acp.useAmmo'
    }
},

['ammo_45acp_jhp'] = {
    label = '.45 ACP JHP',
    weight = 25,
    stack = true,
    close = true,
    description = 'Premium .45 ACP jacketed hollow point ammunition',
    client = {
        export = 'ammo_45acp.useAmmo'
    }
},
```

### 6.2 Weapon Registration

Each weapon should be registered with ox_inventory:

```lua
-- Example for M45A1
['weapon_m45a1'] = {
    label = 'Colt M45A1',
    weight = 1134,  -- 40 oz in grams
    durability = 0.1,
    ammoname = 'ammo_45acp_fmj',  -- Default ammo type
    client = {
        hash = 'WEAPON_M45A1'
    }
},
```

---

## 7. Meta Files

### 7.1 weaponcomponents.meta

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CWeaponComponentDataFileMgr>
  <Infos>
    <!-- ==================== M45A1 CLIPS ==================== -->
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_M45A1_CLIP_FMJ</n>
      <Model>w_pi_m45a1_mag1</Model>
      <LocName>WCT_CLIP_FMJ</LocName>
      <LocDesc>WCD_CLIP_45FMJ</LocDesc>
      <ClipSize value="8" />
      <AmmoInfo ref="AMMO_45ACP_FMJ" />
    </Item>
    
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_M45A1_CLIP_JHP</n>
      <Model>w_pi_m45a1_mag1</Model>
      <LocName>WCT_CLIP_JHP</LocName>
      <LocDesc>WCD_CLIP_45JHP</LocDesc>
      <ClipSize value="8" />
      <AmmoInfo ref="AMMO_45ACP_JHP" />
    </Item>
    
    <!-- ==================== KIMBER 1911 CLIPS ==================== -->
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_KIMBER1911_CLIP_FMJ</n>
      <Model>w_pi_kimber1911_mag1</Model>
      <LocName>WCT_CLIP_FMJ</LocName>
      <LocDesc>WCD_CLIP_45FMJ</LocDesc>
      <ClipSize value="7" />
      <AmmoInfo ref="AMMO_45ACP_FMJ" />
    </Item>
    
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_KIMBER1911_CLIP_JHP</n>
      <Model>w_pi_kimber1911_mag1</Model>
      <LocName>WCT_CLIP_JHP</LocName>
      <LocDesc>WCD_CLIP_45JHP</LocDesc>
      <ClipSize value="7" />
      <AmmoInfo ref="AMMO_45ACP_JHP" />
    </Item>
    
    <!-- ==================== KIMBER ECLIPSE CLIPS ==================== -->
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_KIMBER_ECLIPSE_CLIP_FMJ</n>
      <Model>w_pi_kimber_eclipse_mag1</Model>
      <LocName>WCT_CLIP_FMJ</LocName>
      <LocDesc>WCD_CLIP_45FMJ</LocDesc>
      <ClipSize value="8" />
      <AmmoInfo ref="AMMO_45ACP_FMJ" />
    </Item>
    
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_KIMBER_ECLIPSE_CLIP_JHP</n>
      <Model>w_pi_kimber_eclipse_mag1</Model>
      <LocName>WCT_CLIP_JHP</LocName>
      <LocDesc>WCD_CLIP_45JHP</LocDesc>
      <ClipSize value="8" />
      <AmmoInfo ref="AMMO_45ACP_JHP" />
    </Item>
    
    <!-- ==================== GLOCK 21 CLIPS ==================== -->
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_G21_CLIP_FMJ</n>
      <Model>w_pi_g21_mag1</Model>
      <LocName>WCT_CLIP_FMJ</LocName>
      <LocDesc>WCD_CLIP_45FMJ</LocDesc>
      <ClipSize value="13" />
      <AmmoInfo ref="AMMO_45ACP_FMJ" />
    </Item>
    
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_G21_CLIP_JHP</n>
      <Model>w_pi_g21_mag1</Model>
      <LocName>WCT_CLIP_JHP</LocName>
      <LocDesc>WCD_CLIP_45JHP</LocDesc>
      <ClipSize value="13" />
      <AmmoInfo ref="AMMO_45ACP_JHP" />
    </Item>
    
    <!-- ==================== GLOCK 30 CLIPS ==================== -->
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_G30_CLIP_FMJ</n>
      <Model>w_pi_g30_mag1</Model>
      <LocName>WCT_CLIP_FMJ</LocName>
      <LocDesc>WCD_CLIP_45FMJ</LocDesc>
      <ClipSize value="10" />
      <AmmoInfo ref="AMMO_45ACP_FMJ" />
    </Item>
    
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_G30_CLIP_JHP</n>
      <Model>w_pi_g30_mag1</Model>
      <LocName>WCT_CLIP_JHP</LocName>
      <LocDesc>WCD_CLIP_45JHP</LocDesc>
      <ClipSize value="10" />
      <AmmoInfo ref="AMMO_45ACP_JHP" />
    </Item>
    
    <!-- ==================== GLOCK 41 CLIPS ==================== -->
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_G41_CLIP_FMJ</n>
      <Model>w_pi_g41_mag1</Model>
      <LocName>WCT_CLIP_FMJ</LocName>
      <LocDesc>WCD_CLIP_45FMJ</LocDesc>
      <ClipSize value="13" />
      <AmmoInfo ref="AMMO_45ACP_FMJ" />
    </Item>
    
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_G41_CLIP_JHP</n>
      <Model>w_pi_g41_mag1</Model>
      <LocName>WCT_CLIP_JHP</LocName>
      <LocDesc>WCD_CLIP_45JHP</LocDesc>
      <ClipSize value="13" />
      <AmmoInfo ref="AMMO_45ACP_JHP" />
    </Item>
    
    <!-- ==================== JUNK 1911 CLIPS ==================== -->
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_JUNK1911_CLIP_FMJ</n>
      <Model>w_pi_junk1911_mag1</Model>
      <LocName>WCT_CLIP_FMJ</LocName>
      <LocDesc>WCD_CLIP_45FMJ</LocDesc>
      <ClipSize value="7" />
      <AmmoInfo ref="AMMO_45ACP_FMJ" />
    </Item>
    
    <Item type="CWeaponComponentClipInfo">
      <n>COMPONENT_JUNK1911_CLIP_JHP</n>
      <Model>w_pi_junk1911_mag1</Model>
      <LocName>WCT_CLIP_JHP</LocName>
      <LocDesc>WCD_CLIP_45JHP</LocDesc>
      <ClipSize value="7" />
      <AmmoInfo ref="AMMO_45ACP_JHP" />
    </Item>
  </Infos>
</CWeaponComponentDataFileMgr>
```

### 7.2 weaponammoTypes.meta

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CAmmoInfoBlob>
  <Infos>
    <!-- .45 ACP FMJ - Standard Ammunition -->
    <Item type="CAmmoInfo">
      <n>AMMO_45ACP_FMJ</n>
      <AmmoType>AMMO_PISTOL</AmmoType>
      <Damage value="38.000000" />
      <Speed value="255.000000" />
      <Penetration value="0.200000" />
      <ArmorPenetration value="0.100000" />
      <DamageFallOffRangeMin value="12.000000" />
      <DamageFallOffRangeMax value="40.000000" />
      <DamageFallOffModifier value="0.360000" />
      <AmmoFlags>None</AmmoFlags>
      <AmmoSpecialType>None</AmmoSpecialType>
    </Item>
    
    <!-- .45 ACP JHP - Hollow Point Ammunition -->
    <Item type="CAmmoInfo">
      <n>AMMO_45ACP_JHP</n>
      <AmmoType>AMMO_PISTOL</AmmoType>
      <Damage value="44.000000" />
      <Speed value="265.000000" />
      <Penetration value="0.120000" />
      <ArmorPenetration value="0.050000" />
      <DamageFallOffRangeMin value="12.000000" />
      <DamageFallOffRangeMax value="42.000000" />
      <DamageFallOffModifier value="0.380000" />
      <AmmoFlags>None</AmmoFlags>
      <AmmoSpecialType>None</AmmoSpecialType>
    </Item>
  </Infos>
</CAmmoInfoBlob>
```

---

## 8. Damage Application System

### 8.1 Runtime Damage Modification

Since ammo types affect damage differently, implement a damage handler:

```lua
-- Server-side damage handler
AddEventHandler('weaponDamageEvent', function(sender, eventData)
    local source = sender
    local targetEntity = eventData.hitEntity
    local weaponHash = eventData.weaponHash
    local damageDealt = eventData.damageDealt
    
    -- Check if weapon is .45 ACP
    local weaponName = GetWeaponNameFromHash(weaponHash)
    if not Config.CompatibleWeapons[weaponName] then return end
    
    -- Get loaded ammo type
    local ammoType = GetPlayerLoadedAmmoType(source, weaponName)
    local ammoConfig = Config.AmmoTypes['ammo_45acp_' .. ammoType]
    
    if ammoConfig then
        -- Apply damage modifier
        local modifiedDamage = damageDealt * ammoConfig.damageModifier
        
        -- Apply armor modifier if target is wearing armor
        if IsEntityArmored(targetEntity) then
            modifiedDamage = modifiedDamage * ammoConfig.armorModifier
        end
        
        -- Override damage
        eventData.damageDealt = modifiedDamage
    end
end)
```

---

## 9. Testing Checklist

### 9.1 Functional Tests
- [ ] FMJ ammo loads correctly into all 7 weapons
- [ ] JHP ammo loads correctly into all 7 weapons
- [ ] Switching ammo types returns old rounds to inventory
- [ ] Damage values match specifications (FMJ: 38, JHP: 44)
- [ ] Magazine capacities are correct per weapon
- [ ] Ammo only usable with compatible weapon equipped
- [ ] Error messages display when conditions not met

### 9.2 Balance Tests
- [ ] FMJ: 3 shots close, 7 shots at range (100 HP)
- [ ] JHP: 3 shots close, 6 shots at range (100 HP)
- [ ] Headshot multipliers apply correctly
- [ ] Damage falloff works as expected
- [ ] Armor penetration differences are noticeable

### 9.3 Integration Tests
- [ ] ox_inventory items display correctly
- [ ] Weapon purchase includes default ammo
- [ ] Ammo persists through reconnect
- [ ] No conflicts with other weapon resources

---

## 10. Server.cfg Load Order

```cfg
# Core dependencies
ensure oxmysql
ensure ox_lib
ensure ox_inventory

# Ammunition resources (load BEFORE weapons)
ensure ammo_9mm
ensure ammo_45acp

# Weapon resources
ensure weapon_m45a1
ensure weapon_kimber1911
ensure weapon_kimber_eclipse
ensure weapon_g21
ensure weapon_g30
ensure weapon_g41
ensure weapon_junk1911
```

---

## 11. Future Expansion Notes

### Adding New .45 ACP Weapons
1. Add weapon to `Config.CompatibleWeapons` in `sh_config.lua`
2. Add clip components to `weaponcomponents.meta`
3. Register weapon with ox_inventory
4. Test ammo loading functionality

### Adding New Ammo Types (e.g., +P, Subsonic)
1. Add ammo definition to `Config.AmmoTypes`
2. Add CAmmoInfo entry to `weaponammoTypes.meta`
3. Add clip components for each weapon
4. Update ox_inventory items
5. Balance test damage values

---

## 12. Reference: Ammo Type Comparison

| Property | FMJ | JHP |
|----------|-----|-----|
| **Damage** | 38 | 44 |
| **Damage Modifier** | 1.0x | 1.158x |
| **Penetration** | 0.20 | 0.12 |
| **Armor Effectiveness** | 100% | 75% |
| **Price (suggested)** | $15/round | $35/round |
| **Availability** | Common | Premium |
| **Use Case** | General/Range | Self-Defense |

---

*Document Version: 1.0*
*Compatible with: Batch 3 .45 ACP Weapons*
*Framework based on: ammo_9mm resource pattern*
