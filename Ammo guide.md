# GTA V/FiveM weapon meta ammunition implementation guide

The GTA V weapon system implements ammunition types through two complementary mechanisms: **AmmoInfo structures** in weapons.meta that define base ammo properties, and **weapon components** (primarily for MK2 weapons) that swap magazine modules to change active ammo types at runtime. Custom ammunition with realistic ballistic properties requires understanding both systems, plus shotgun-specific parameters like BulletsInBatch for pellet-based rounds.

## How AmmoInfo and AmmoSpecialType define ammunition behavior

Every weapon references an AmmoInfo definition that controls maximum capacity and special properties. The core structure in weapons.meta follows this pattern:

```xml
<Item type="CAmmoInfo">
  <Name>AMMO_PISTOL</Name>
  <AmmoMax value="100" />
  <AmmoMax50 value="100" />
  <AmmoMax100 value="100" />
  <AmmoMaxMP value="100" />
  <AmmoFlags />
  <AmmoSpecialType>None</AmmoSpecialType>
</Item>
```

The **AmmoSpecialType enumeration** is the key parameter for implementing different ammunition behaviors. Each value triggers distinct game mechanics:

| AmmoSpecialType | Value | Gameplay Effect |
|-----------------|-------|-----------------|
| **None** | 0 | Standard ammunition with no special properties |
| **ArmorPiercing** | 1 | Ignores body armor and bulletproof helmets; does not affect Ballistic Armor |
| **Explosive** | 2 | Creates explosion on impact with associated effects |
| **FMJ** | 3 | Penetrates bulletproof glass and armored vehicle windows; **+vehicle damage** |
| **HollowPoint** | 4 | Increased damage to unarmored targets; reduced effectiveness against armor |
| **Incendiary** | 5 | Chance to ignite targets; NPCs drop and remain stunned while burning |
| **Tracer** | 6 | Visible bullet trails (aesthetic only, no damage modification) |

Weapons link to ammo using `<AmmoInfo ref="AMMO_PISTOL" />` in CWeaponInfo. The actual damage calculation happens through separate weapon parameters including **Damage**, **Penetration**, and damage modifier fields—the AmmoSpecialType primarily determines special behavior triggers rather than raw damage values.

## Damage parameters that matter for realistic balancing

The CWeaponInfo structure contains the parameters needed for implementing realistic ammunition differences:

```xml
<Damage value="26.000000" />
<Penetration value="0.100000" />
<Force value="40.000000" />
<NetworkPlayerDamageModifier value="0.500000" />
<LightlyArmouredDamageModifier value="0.750000" />
<VehicleDamageModifier value="1.000000" />
<DamageFallOffRangeMin value="5.000000" />
<DamageFallOffRangeMax value="40.000000" />
<DamageFallOffModifier value="0.500000" />
```

For realistic ammunition balancing, these parameters translate to:

- **FMJ rounds**: Set `Penetration` to **0.8-1.0** and `VehicleDamageModifier` to **1.5-2.0**. Use `AmmoSpecialType` value 3 for bulletproof glass penetration
- **Hollow Point**: Increase base `Damage` by **25-50%** but set `Penetration` to **0.05-0.1** and `LightlyArmouredDamageModifier` to **0.4-0.6**
- **Armor Piercing**: Set `AmmoSpecialType` to 1, reduce base `Damage` by **10-20%**, but armor bypass is automatic via the special type

The **DamageType** parameter works alongside AmmoSpecialType—most firearms use `BULLET`, but incendiary rounds can use `FIRE` for burn damage, and less-lethal implementations can use `ELECTRIC` (stun gun behavior).

## MK2 weapons implement ammo switching through component swapping

GTA V's MK2 weapon system provides the architectural blueprint for runtime ammunition switching. Each ammo type is a **CWeaponComponentClipInfo** that overrides the weapon's default AmmoInfo when attached:

```xml
<Item type="CWeaponComponentClipInfo">
  <Name>COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT</Name>
  <Model>w_pi_pistolmk2_mag_hp</Model>
  <AttachBone>AAPClip</AttachBone>
  <ClipSize value="8" />
  <AmmoInfo ref="AMMO_PISTOL_HOLLOWPOINT" />
</Item>
```

**Critical implementation detail**: Changing ammo types requires swapping components—the game does not support multiple active ammo types without this mechanism. When you attach `COMPONENT_PISTOL_MK2_CLIP_FMJ`, the weapon's active AmmoInfo switches from `AMMO_PISTOL` to `AMMO_PISTOL_FMJ`, which the native `GET_PED_AMMO_TYPE_FROM_WEAPON` reflects.

The component must be registered in the weapon's AttachPoints:

```xml
<AttachPoints>
  <Item>
    <AttachBone>AAPClip</AttachBone>
    <Components>
      <Item>
        <Name>COMPONENT_PISTOL_MK2_CLIP_01</Name>
        <Default value="true" />
      </Item>
      <Item>
        <Name>COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT</Name>
        <Default value="false" />
      </Item>
    </Components>
  </Item>
</AttachPoints>
```

Each ammo type maintains a **separate inventory pool**—AMMO_PISTOL and AMMO_PISTOL_FMJ are tracked independently, enabling players to carry different ammunition counts for each type.

## Shotgun pellet mechanics use BulletsInBatch and BatchSpread

Shotgun ammunition implementation differs fundamentally from rifles through the pellet system. Two parameters control multi-projectile behavior:

**BulletsInBatch** defines the number of pellets fired per trigger pull. Base game values reveal the design philosophy:

| Weapon | BulletsInBatch | Effective Damage Pattern |
|--------|---------------|-------------------------|
| WEAPON_PUMPSHOTGUN | 8 | Standard buckshot |
| WEAPON_HEAVYSHOTGUN | **1** | Slug (single projectile) |
| WEAPON_ASSAULTSHOTGUN | 6 | Reduced spread burst |
| WEAPON_SAWNOFFSHOTGUN | 8 | Wide spread buckshot |

**The damage calculation is per-pellet**: setting `Damage="29"` with `BulletsInBatch="8"` yields **232 maximum damage** if all pellets connect. This is crucial for balancing—slug implementations need proportionally higher base damage to compensate for guaranteed single-hit mechanics.

**BatchSpread** controls the cone angle for pellet dispersion (measured in radians):

- `0.04` = Standard buckshot spread
- `0.06` = Wider birdshot pattern  
- `0.0` = Zero spread (slug behavior)

### Implementing different shotgun ammo types

**Buckshot (00 Buck):**
```xml
<BulletsInBatch value="8" />
<BatchSpread value="0.040000" />
<Damage value="29.000000" />
<DamageFallOffRangeMax value="40.000000" />
```

**Slugs (single projectile):**
```xml
<BulletsInBatch value="1" />
<BatchSpread value="0.000000" />
<Damage value="117.000000" />
<WeaponRange value="50.000000" />
<DamageFallOffRangeMin value="20.000000" />
<VehicleDamageModifier value="3.000000" />
```

**Birdshot (many small pellets):**
```xml
<BulletsInBatch value="19" />
<BatchSpread value="0.060000" />
<Damage value="8.000000" />
<DamageFallOffRangeMax value="20.000000" />
```

**Engine limitation**: Pellet counts above approximately **30** cause pattern irregularities where the spread paradoxically tightens rather than widening.

**Dragon's Breath implementation** combines incendiary properties with standard pellet mechanics:
```xml
<BulletsInBatch value="8" />
<DamageType>FIRE</DamageType>
<AmmoSpecialType>Incendiary</AmmoSpecialType>
```

## Sniper tracer rounds use visual effects without damage changes

The MK2 Heavy Sniper's tracer implementation demonstrates pure aesthetic ammunition—`AmmoSpecialType="Tracer"` (value 6) adds visible bullet trails without modifying damage calculations. The tracer effect is rendered client-side based on the ammo type flag, making it synchronization-friendly since no gameplay values differ from standard rounds.

For custom tracer implementations, the component structure mirrors other ammo types:

```xml
<Item type="CWeaponComponentClipInfo">
  <Name>COMPONENT_HEAVYSNIPER_MK2_CLIP_TRACER</Name>
  <ClipSize value="6" />
  <AmmoInfo ref="AMMO_SNIPER_TRACER" />
</Item>
```

The AMMO_SNIPER_TRACER definition sets `AmmoSpecialType` to Tracer while maintaining identical damage parameters to standard sniper ammunition.

## FiveM network synchronization affects custom ammo design

Custom ammunition introduces synchronization considerations that determine which implementation approach works reliably in multiplayer:

**What syncs automatically:**
- Weapon component state (MK2-style ammo switching) via `GIVE_WEAPON_COMPONENT_TO_PED`
- Damage values from modified weapons.meta files **when all clients load identical resources**
- Visual effects tied to AmmoSpecialType (tracers, incendiary particles)

**What does NOT sync:**
- Runtime modifications via `SetWeaponDamageModifier` (client-local only)
- Direct health modifications without server validation

The **weaponDamageEvent** server event provides authoritative damage control:

```lua
AddEventHandler('weaponDamageEvent', function(sender, data)
    local ammoType = Player(sender).state.currentAmmoType
    if ammoType == 'armor_piercing' then
        -- Damage proceeds with armor bypass
        return
    elseif ammoType == 'hollow_point' then
        -- Could modify or validate damage
    end
end)
```

### Recommended implementation approaches by use case

**For MK2 weapons** (native component system): Use the built-in component switching with FiveM natives:
```lua
GiveWeaponComponentToPed(ped, `WEAPON_PISTOL_MK2`, `COMPONENT_PISTOL_MK2_CLIP_FMJ`)
```
This syncs automatically and includes all visual effects.

**For standard weapons** (custom ammo types): Create new ammo components in weaponcomponents.meta, register them in the weapon's AttachPoints, and switch via the component system. This requires all clients to have matching resource files.

**For server-authoritative systems**: Use state bags to track ammo type per player and intercept weaponDamageEvent to apply custom damage modifiers server-side:
```lua
LocalPlayer.state:set('ammoType', 'hollow_point', true)  -- Replicated state
```

## FiveM resource structure for weapon modifications

Custom ammunition requires proper resource packaging:

```lua
-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

files {
    'data/weapons.meta',
    'data/weaponcomponents.meta'
}

data_file 'WEAPONINFO_FILE' 'data/weapons.meta'
data_file 'WEAPON_COMPONENTS_FILE' 'data/weaponcomponents.meta'
```

The `WEAPONINFO_FILE` directive loads ammunition definitions; `WEAPON_COMPONENTS_FILE` handles magazine components with AmmoInfo references.

## Complete implementation example for realistic pistol ammunition

**weapons.meta additions:**
```xml
<!-- Hollow Point ammo definition -->
<Item type="CAmmoInfo">
  <Name>AMMO_PISTOL_HP_CUSTOM</Name>
  <AmmoMax value="150" />
  <AmmoMaxMP value="150" />
  <AmmoSpecialType>HollowPoint</AmmoSpecialType>
</Item>

<!-- Armor Piercing ammo definition -->
<Item type="CAmmoInfo">
  <Name>AMMO_PISTOL_AP_CUSTOM</Name>
  <AmmoMax value="100" />
  <AmmoMaxMP value="100" />
  <AmmoSpecialType>ArmorPiercing</AmmoSpecialType>
</Item>
```

**weaponcomponents.meta additions:**
```xml
<Item type="CWeaponComponentClipInfo">
  <Name>COMPONENT_PISTOL_CLIP_HP</Name>
  <AttachBone>AAPClip</AttachBone>
  <ClipSize value="12" />
  <AmmoInfo ref="AMMO_PISTOL_HP_CUSTOM" />
</Item>

<Item type="CWeaponComponentClipInfo">
  <Name>COMPONENT_PISTOL_CLIP_AP</Name>
  <AttachBone>AAPClip</AttachBone>
  <ClipSize value="10" />
  <AmmoInfo ref="AMMO_PISTOL_AP_CUSTOM" />
</Item>
```

**Weapon registration (in weapons.meta CWeaponInfo):**
```xml
<AttachPoints>
  <Item>
    <AttachBone>AAPClip</AttachBone>
    <Components>
      <Item><Name>COMPONENT_PISTOL_CLIP_01</Name><Default value="true" /></Item>
      <Item><Name>COMPONENT_PISTOL_CLIP_HP</Name><Default value="false" /></Item>
      <Item><Name>COMPONENT_PISTOL_CLIP_AP</Name><Default value="false" /></Item>
    </Components>
  </Item>
</AttachPoints>
```

## Conclusion

GTA V's ammunition system provides robust infrastructure for realistic weapon balancing through the **AmmoSpecialType** enumeration for special behaviors, **component-based magazine swapping** for runtime ammo selection, and **BulletsInBatch/BatchSpread** parameters for shotgun pellet mechanics. 

The key architectural insight is that ammunition properties are not purely about damage numbers—the special type triggers distinct game behaviors (armor bypass, fire effects, glass penetration) that must be paired with appropriate damage modifiers in CWeaponInfo. For FiveM implementations, the MK2 component system offers the most reliable synchronization path, while server-authoritative approaches via weaponDamageEvent provide maximum control for custom ballistic models.