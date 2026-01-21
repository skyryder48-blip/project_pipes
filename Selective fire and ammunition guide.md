# FiveM weapon systems for selective fire and custom ammunition

**Building selective fire and multi-ammo systems in FiveM requires a script-based approach using frame-by-frame firing control and server-side damage interception rather than native fire mode switching.** GTA V has no built-in player burst fire—all implementations are scripted approximations using timing. For ammunition types, the recommended architecture combines ox_inventory's metadata system with the `weaponDamageEvent` server event to apply damage modifiers based on loaded ammo. This approach integrates cleanly with Qbox and ox_inventory while maintaining server authority for anti-cheat compatibility.

## Selective fire implementation fundamentals

GTA V's native firing patterns (`SET_PED_FIRING_PATTERN`) control AI behavior only—they do not affect player fire modes. The working approach uses `DisablePlayerFiring(PlayerId(), true)` called every frame to control when players can shoot.

**Core implementation pattern for fire modes:**

```lua
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentFireMode == "semi" then
            if IsControlJustPressed(0, 24) then
                Wait(50) -- Allow first shot
                while IsControlPressed(0, 24) or IsDisabledControlPressed(0, 24) do
                    DisablePlayerFiring(PlayerId(), true)
                    Wait(0)
                end
            end
        elseif currentFireMode == "burst" then
            if IsControlJustPressed(0, 24) then
                Wait(300) -- ~3 rounds at standard fire rate
                while IsControlPressed(0, 24) or IsDisabledControlPressed(0, 24) do
                    DisablePlayerFiring(PlayerId(), true)
                    Wait(0)
                end
            end
        elseif currentFireMode == "safety" then
            DisablePlayerFiring(PlayerId(), true)
        end
        -- Full auto requires no intervention (default GTA behavior)
    end
end)
```

**Burst timing calculation:** `burstCount × TimeBetweenShots × 1000` (in milliseconds). For a weapon with **0.118s** TimeBetweenShots, 3-round burst needs approximately **300ms** delay before disabling further firing.

Available firing pattern hashes (for AI reference only):
- `FIRING_PATTERN_FULL_AUTO` = 0xC6EE6B4C
- `FIRING_PATTERN_SINGLE_SHOT` = 0x5D60E4E0
- `FIRING_PATTERN_BURST_FIRE` = 0xD6FF6D61
- `FIRING_PATTERN_BURST_FIRE_RIFLE` = 0x9C74B406

**Known limitations:** Fire modes typically break in vehicles due to different control schemes. Burst fire can be interrupted by ragdoll or ladder climbing, causing bullets to fire after interruption. Minigun and WidowMaker have special behavior that breaks fire mode scripts.

## Damage modification for ammunition types

The primary natives for runtime damage modification are:

| Native | Scope | Persistence |
|--------|-------|-------------|
| `_SET_WEAPON_DAMAGE_MODIFIER(weaponHash, multiplier)` | Per-weapon | Persists until changed |
| `SET_PLAYER_WEAPON_DAMAGE_MODIFIER(player, modifier)` | All weapons for player | Persists, minimum 0.1 |
| `GET_WEAPON_COMPONENT_DAMAGE_MODIFIER(componentHash)` | Component-based | Read-only |

For your caliber-based system with **9mm at 34 base damage**, damage modifiers apply multiplicatively. Hollow Point at **1.5x** yields 51 damage; Armor Piercing at **0.9x** base but with penetration flag yields 30.6 damage that bypasses armor.

**Server-side damage interception (requires OneSync):**

```lua
AddEventHandler('weaponDamageEvent', function(sender, data)
    -- data.weaponType: Hash | data.weaponDamage: Amount
    -- data.hitComponent: Body part | data.hitGlobalId: Victim network ID
    
    local ammoType = GetPlayerAmmoType(sender, data.weaponType)
    
    if ammoType == "AP" then
        data.damageFlags = data.damageFlags | DAMAGE_FLAG_IGNORE_ARMOR
    elseif ammoType == "HP" then
        if not TargetHasArmor(data.hitGlobalId) then
            data.weaponDamage = data.weaponDamage * 1.5
        end
    elseif ammoType == "BLANK" then
        CancelEvent()
        return
    end
end)
```

**Key weapons.meta parameters for ammunition behavior:**

| Parameter | Description | Example |
|-----------|-------------|---------|
| `Damage` | Base damage value | `34.0` for 9mm |
| `Penetration` | Material penetration (0.0-1.0) | `0.5` for rifles |
| `HitLimbsDamageModifier` | Limb-specific multiplier | `0.8` |
| `HeadShotDamageModifierPlayer` | Headshot multiplier | `2.5` |
| `DamageFallOffRangeMin/Max` | Distance-based falloff | `50/150` |
| `ArmourPenetrating` | WeaponFlag for armor bypass | Flag presence |

Tracer effects use `TracerFx` in weapons.meta with particle effects like `bullet_tracer`, `bullet_tracer_valkyrie`, or custom effects. TracerFxChanceSP/MP controls frequency (**0.5** = 50% of rounds show tracers).

## ox_inventory architecture and limitations

ox_inventory treats ammunition as regular inventory items with a **one-to-one mapping** between weapons and ammo types via the `ammoname` property. This means **ox_inventory does not natively support multiple ammo subtypes per weapon**.

**Weapon definition structure:**
```lua
['WEAPON_COMBATPISTOL'] = {
    label = 'Combat Pistol',
    weight = 785,
    durability = 0.2,
    ammoname = 'ammo-9'  -- Links to single ammo item type
}
```

**CurrentWeapon data structure available via exports:**
```lua
currentWeapon = {
    ammo = 'ammo-9',         -- Ammo item name
    metadata = {
        ammo = 30,           -- Loaded count
        durability = 100,
        components = {},
        serial = 'ABC123'
    },
    hash = number,
    name = 'WEAPON_PISTOL',
    slot = 1
}
```

**Key exports for custom ammo integration:**

```lua
-- Client: Listen for weapon changes
AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
    if currentWeapon then
        local ammoType = currentWeapon.metadata.ammoType or 'standard'
        ApplyAmmoTypeModifiers(currentWeapon.hash, ammoType)
    end
end)

-- Server: Hook item creation for custom metadata
exports.ox_inventory:registerHook('createItem', function(payload)
    if payload.item.name == 'ammo_ap_9mm' then
        payload.metadata.damageMultiplier = 1.5
        payload.metadata.penetration = 0.8
        return payload.metadata
    end
end, { itemFilter = { ammo_ap_9mm = true } })

-- Server: Search for specific ammo type with metadata
local slots = exports.ox_inventory:GetSlotsWithItem('ammo-9', { type = 'tracer' }, true)
```

**ox_inventory hooks available:**
- `swapItems` — Item movement between slots/inventories
- `createItem` — Item creation (buy/AddItem)
- `buyItem` — Purchase validation
- `craftItem` — Crafting validation

## Implementing physical magazine ammo types

For your requirement of **inventory interaction (not keybind cycling)**, the recommended approach creates separate ammo items for each type with metadata:

**Item definitions in items.lua:**
```lua
['ammo-9-fmj'] = { label = '9mm FMJ', weight = 10 },
['ammo-9-hp'] = { label = '9mm Hollow Point', weight = 10 },
['ammo-9-ap'] = { label = '9mm Armor Piercing', weight = 12 },
['ammo-9-tracer'] = { label = '9mm Tracer', weight = 10 }
```

**Item use callback for ammo switching:**
```lua
exports.ox_inventory:AddItem(source, 'ammo-9-ap', 50, {
    type = 'armor_piercing',
    damageMultiplier = 0.9,
    penetration = 0.9,
    armorBypass = true
})

-- When player loads magazine into weapon
exports['ox_inventory']:AddItemUse('ammo-9-ap', function(source, item)
    local weapon = exports.ox_inventory:GetCurrentWeapon(source)
    if weapon and IsCompatibleCaliber(weapon.name, '9mm') then
        -- Update weapon metadata with ammo type
        exports.ox_inventory:SetMetadata(source, weapon.slot, {
            ammo = weapon.metadata.ammo + item.count,
            ammoType = 'AP',
            damageMultiplier = 0.9
        })
        exports.ox_inventory:RemoveItem(source, 'ammo-9-ap', item.count)
        TriggerClientEvent('ammo:updateVisuals', source, weapon.hash, 'AP')
    end
end)
```

**Magazine-based workflow:**
1. Player opens inventory and sees magazine items with different ammo types
2. Player drags/uses magazine on equipped weapon
3. Script validates caliber compatibility
4. Weapon metadata updates with ammo type properties
5. `weaponDamageEvent` reads metadata and applies modifiers server-side

## Network synchronization with StateBags

For syncing ammo type across clients, **StateBags provide eventual consistency** with automatic scope management:

```lua
-- Server: Set player's ammo type
Player(source).state:set('selectedAmmoType', 'armor_piercing', true)

-- Client: React to changes
AddStateBagChangeHandler('selectedAmmoType', nil, function(bagName, key, value)
    local playerId = tonumber(bagName:match('player:(%d+)'))
    if playerId then
        ApplyAmmoTypeEffects(playerId, value)
    end
end)
```

StateBag rate limits default to **75 packets/second** with **125 burst**. For weapon systems, this is adequate since ammo type changes are infrequent events.

**When to use StateBags vs events:**
- **StateBags**: Persistent state (current ammo type), data that needs reconnection survival
- **Events**: One-time actions (fire mode toggle, reload notification), immediate response needed

## Existing resources worth reviewing

**Open-source selective fire implementations:**

| Resource | Features | Status |
|----------|----------|--------|
| [inferno-collection/Weapons](https://github.com/inferno-collection/Weapons) | Safety, semi, burst, full-auto; per-weapon config | Archived, comprehensive |
| [RCPisAwesome/Recoil-Fire-Rate-Selection](https://github.com/RCPisAwesome/Recoil-Fire-Rate-Selection) | Fire rate UI, safety button | Active |
| [castawaygaming/singleshot-fix](https://github.com/castawaygaming/singleshot-fix) | Single shot, burst, MK2 support | Simple implementation |

**Ammunition management resources:**

| Resource | Features | Framework |
|----------|----------|-----------|
| [qb-weapons](https://github.com/qbcore-framework/qb-weapons) | Ammo types with modifiers (HP 1.25x, AP 0.9x/0.9 pen) | QBCore |
| [Big Bang Advanced Ammo](https://big-bang-scripts.tebex.io/package/6878489) | 6 ammo types, tracer colors, 0.00ms idle | Paid, multi-framework |
| [snag_weapon_metas](https://github.com/CyCoSnag/snag_weapon_metas) | Edit damage, penetration, effects | Standalone |

**For Qbox specifically:** qbx_smallresources provides weapon draw animations and per-weapon recoil configuration that complements custom ammo systems.

## Recommended architecture for Qbox integration

```
┌─────────────── CLIENT ───────────────┐
│ ox_inventory:currentWeapon event     │
│         ↓                            │
│ StateBag change handlers → Visuals   │
│         ↓                            │
│ SET_WEAPON_DAMAGE_MODIFIER (cached)  │
│ DisablePlayerFiring (fire modes)     │
└──────────────────────────────────────┘
              ↕ StateBags / Events
┌─────────────── SERVER ───────────────┐
│ weaponDamageEvent → Validate/Modify  │
│         ↓                            │
│ StateBag → Sync ammo types           │
│         ↓                            │
│ ox_inventory hooks → Consumption     │
│         ↓                            │
│ oxmysql → Persist to database        │
└──────────────────────────────────────┘
```

**Database schema for weapon preferences:**
```sql
CREATE TABLE player_weapon_preferences (
    citizen_id VARCHAR(50) NOT NULL,
    weapon_hash BIGINT NOT NULL,
    ammo_type VARCHAR(50) DEFAULT 'standard',
    fire_mode VARCHAR(20) DEFAULT 'auto',
    UNIQUE KEY (citizen_id, weapon_hash)
);
```

**Performance best practices:**
- Use event-driven approach, not tick-based checking
- `_SET_WEAPON_DAMAGE_MODIFIER` persists—call once on weapon equip
- Cache `PlayerPedId()` instead of calling repeatedly
- Target under **0.1ms** idle resource usage
- Store ammo type in weapon metadata for automatic persistence

## Conclusion

For your realistic weapon meta project, the proven approach combines **frame-by-frame firing control** for selective fire with **server-side damage interception** for ammunition effects. ox_inventory's metadata system stores ammo type in weapon items, which `weaponDamageEvent` reads to apply appropriate modifiers. The physical magazine workflow uses separate ammo items (`ammo-9-hp`, `ammo-9-ap`) that players load through inventory interaction, updating the weapon's metadata. This architecture maintains server authority for damage calculation while keeping visual feedback client-side, integrating cleanly with Qbox and your existing caliber-based damage scaling.