# FiveM weapon meta implementation for SIG MCX select-fire configurations

Implementing realistic select-fire weapons in FiveM requires combining weapons.meta configuration with Lua scripting, as GTA V's engine lacks native support for fire mode selection. The SIG MCX platform's three variants—M7 military rifle, civilian semi-auto Spear, and 300 BLK Rattler—each require distinct configurations that balance authenticity with gameplay mechanics.

The critical insight is that **all GTA V weapons can fire continuously when the trigger is held**; the `OnlyFireOneShotPerTriggerPress` flag enforces semi-automatic behavior, while the `Automatic` flag enables full-auto. For select-fire functionality, runtime input blocking via `DisablePlayerFiring()` provides the most reliable approach, as native functions cannot dynamically modify fire rate.

## Fire mode configuration through weapons.meta

The weapons.meta file controls firing behavior through two primary mechanisms: the `FireType` parameter (which determines projectile behavior) and `WeaponFlags` (which control automatic fire capability). For the SIG MCX variants, all three use `INSTANT_HIT` as the FireType since they're conventional firearms.

**TimeBetweenShots calculation** converts real-world RPM to the required decimal seconds format: `TimeBetweenShots = 60 / RPM`. For the M7's estimated **750 RPM** cyclic rate, this yields `0.080` seconds between shots. The MCX Rattler, sharing a similar gas piston system, would use approximately the same value for its select-fire variant.

| Weapon Variant | Real RPM | TimeBetweenShots | Fire Control |
|----------------|----------|------------------|--------------|
| M7 Military | ~750 | 0.080 | Safe-Semi-Auto |
| MCX Spear Civilian | 180 (practical) | 0.333 | Semi-only |
| MCX Rattler (semi) | 180 (practical) | 0.333 | Semi-only |

The **essential WeaponFlags** divide clearly between automatic and semi-automatic configurations:

```xml
<!-- Full-Automatic (M7 Military Auto Mode) -->
<WeaponFlags>Gun Automatic AnimReload AnimCrouchFire TwoHanded LongWeapon ApplyBulletForce</WeaponFlags>

<!-- Semi-Automatic Only (Civilian Variants) -->
<WeaponFlags>Gun OnlyFireOneShotPerTriggerPress AnimReload AnimCrouchFire TwoHanded LongWeapon ApplyBulletForce</WeaponFlags>
```

## Select-fire implementation requires Lua scripting

GTA V provides no native select-fire mechanism, making Lua scripting mandatory for weapons that toggle between semi and automatic fire. The **input blocking approach** is the industry-standard solution: detect trigger press, allow initial shot(s), then call `DisablePlayerFiring()` in a tight loop until the trigger releases.

```lua
-- Core semi-auto enforcement (must run every frame)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local weapon = GetSelectedPedWeapon(ped)
        
        if currentFireMode == 1 then -- Semi-auto mode active
            if IsControlJustPressed(0, 24) then
                -- Allow first shot, then block
                while IsDisabledControlPressed(1, 24) do
                    DisablePlayerFiring(PlayerId(), true)
                    Citizen.Wait(0)
                end
            end
        end
    end
end)
```

The critical technical detail: **`DisablePlayerFiring()` only works for one frame**, requiring continuous calling within a loop. Using `IsControlJustPressed()` detects the initial trigger pull (allowing one shot), then `IsDisabledControlPressed()` monitors whether the player continues holding the trigger while firing is blocked.

**Fire mode state tracking** should be maintained per-weapon using a table structure:

```lua
local FireModes = {}  -- [weaponHash] = mode (0=safety, 1=semi, 2=burst, 3=auto)

RegisterKeyMapping('togglefiremode', 'Toggle Fire Mode', 'keyboard', 'B')
RegisterCommand('togglefiremode', function()
    local weapon = GetSelectedPedWeapon(PlayerPedId())
    FireModes[weapon] = ((FireModes[weapon] or 0) + 1) % 4
    -- Notify player of new mode
end, false)
```

## Three implementation approaches for the M7 select-fire system

For the M7 military rifle's Safe-Semi-Auto selector, three viable approaches exist with distinct tradeoffs:

**Option 1: Full-auto only (simplified)** configures the weapon with the `Automatic` flag permanently. This approach requires zero scripting but sacrifices realism—acceptable for casual servers but inappropriate for milsim environments. The weapons.meta configuration is straightforward, with `TimeBetweenShots value="0.080"` providing the ~750 RPM cyclic rate.

**Option 2: Semi-auto with script toggle** (recommended) creates the weapon as automatic in meta, then uses Lua to enforce semi-auto by default. Players toggle to full-auto via keybind. This preserves the correct automatic fire behavior when enabled while maintaining ammunition conservation in semi-auto mode.

**Option 3: Separate weapon variants** creates two distinct weapons (WEAPON_M7_SEMI and WEAPON_M7_AUTO) that swap when toggling fire modes. This approach allows completely different stats per mode but causes issues: players lose attachments during swaps, synchronization complications arise in multiplayer, and inventory management becomes complex.

The recommended Option 2 implementation structure:

```lua
Config.SelectFireWeapons = {
    [`WEAPON_M7`] = {
        modes = {'semi', 'auto'},  -- Available modes
        defaultMode = 'semi',
        burstCount = nil  -- No burst mode
    }
}
```

## Civilian versus military differentiation through meta parameters

The **MCX Spear civilian variant** requires `OnlyFireOneShotPerTriggerPress` in WeaponFlags, permanently preventing automatic fire. Beyond the flag, several parameters should differ from the military M7 to reflect handling differences:

```xml
<!-- M7 Military (Select-Fire) -->
<Item type="CWeaponInfo">
    <Name>WEAPON_M7</Name>
    <Damage value="42.000000" />          <!-- 6.8x51mm high energy -->
    <TimeBetweenShots value="0.080000" /> <!-- ~750 RPM max -->
    <AccuracySpread value="2.800000" />   <!-- Moderate base spread -->
    <RecoilAccuracyMax value="3.500000" /><!-- High recoil penalty -->
    <WeaponFlags>Gun Automatic AnimReload TwoHanded LongWeapon</WeaponFlags>
</Item>

<!-- MCX Spear Civilian (Semi-Only) -->
<Item type="CWeaponInfo">
    <Name>WEAPON_MCXSPEAR_CIV</Name>
    <Damage value="42.000000" />          <!-- Same caliber -->
    <TimeBetweenShots value="0.200000" /> <!-- Controlled semi-auto -->
    <AccuracySpread value="2.200000" />   <!-- Better precision -->
    <RecoilAccuracyMax value="1.800000" /><!-- Lower sustained recoil -->
    <WeaponFlags>Gun OnlyFireOneShotPerTriggerPress AnimReload TwoHanded LongWeapon</WeaponFlags>
</Item>
```

The **accuracy advantage** for semi-auto comes from lower `AccuracySpread` (tighter initial grouping) and significantly reduced `RecoilAccuracyMax` (less accuracy degradation during sustained fire). This creates meaningful differentiation: the civilian variant excels at precise shots while the military version sacrifices accuracy for volume of fire.

## MCX Rattler 300 BLK with ammunition switching

The compact MCX Rattler/Canebrake presents unique implementation challenges due to its suppressor-optimized design and the substantial performance difference between supersonic and subsonic 300 Blackout ammunition.

**Real-world specifications** for the Rattler:
- **Barrel length**: 5.5 inches (civilian semi-auto only)
- **Weight**: 6.5 lb unloaded
- **Supersonic 300 BLK**: ~1,800 fps from 5.5" barrel, ~1,285 ft-lbs
- **Subsonic 300 BLK**: ~900-950 fps, ~470-540 ft-lbs

The **damage differential** is substantial: subsonic ammunition delivers approximately **60% less muzzle energy** than supersonic. In-game, this translates to a significant damage penalty compensated by near-silent operation when suppressed.

**ox_inventory ammunition configuration** handles multiple ammo types through the `ammoname` property and `metadata.specialAmmo` tracking:

```lua
-- data/weapons.lua
Ammo = {
    ['ammo-300blk-super'] = { label = '300 BLK Supersonic', weight = 20 },
    ['ammo-300blk-sub'] = { label = '300 BLK Subsonic', weight = 22 }
}

Weapons = {
    ['WEAPON_MCXRATTLER'] = {
        label = 'MCX Rattler',
        weight = 2950,  -- 6.5 lb in grams
        ammoname = 'ammo-300blk-super'  -- Default ammo type
    }
}
```

**Runtime damage modification** applies when firing based on loaded ammunition:

```lua
AddEventHandler('ox_inventory:currentWeapon', function(weapon)
    if weapon and weapon.name == 'WEAPON_MCXRATTLER' then
        local ammoType = weapon.metadata.specialAmmo or 'supersonic'
        local modifier = (ammoType == 'subsonic') and 0.6 or 1.0
        SetWeaponDamageModifier(`WEAPON_MCXRATTLER`, modifier)
    end
end)
```

The **detection radius reduction** for subsonic ammunition stacks with suppressor effects. While `AiSoundRange` cannot be modified at runtime without streaming new meta files, a custom alert system can check ammunition type:

```lua
local function getEffectiveDetectionRange(ped, weapon)
    local baseRange = 150.0
    local hasSuppressor = IsPedCurrentWeaponSilenced(ped)
    local isSubsonic = CurrentWeapon.metadata.specialAmmo == 'subsonic'
    
    local suppressorMod = hasSuppressor and 0.5 or 1.0
    local subsonicMod = isSubsonic and 0.7 or 1.0
    
    return baseRange * suppressorMod * subsonicMod
    -- Suppressor + subsonic: 150 * 0.5 * 0.7 = 52.5 effective range
end
```

## Burst fire requires timing-based implementation

GTA V lacks native burst fire support, requiring script-based shot counting. For weapons like an M16A4-style 3-round burst, the implementation monitors ammo consumption:

```lua
local shotsFired = 0
local lastAmmo = 0
local burstLimit = 3
local burstCooldown = 350  -- ms between bursts

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if currentFireMode == 2 then  -- Burst mode
            local weapon = GetSelectedPedWeapon(PlayerPedId())
            local currentAmmo = GetAmmoInPedWeapon(PlayerPedId(), weapon)
            
            -- Detect shots fired
            if currentAmmo < lastAmmo then
                shotsFired = shotsFired + (lastAmmo - currentAmmo)
            end
            lastAmmo = currentAmmo
            
            -- Enforce burst limit
            if shotsFired >= burstLimit then
                while IsControlPressed(0, 24) do
                    DisablePlayerFiring(PlayerId(), true)
                    Citizen.Wait(0)
                end
                Citizen.Wait(burstCooldown)
                shotsFired = 0
            end
        end
    end
end)
```

The **timing calculation** for burst delay depends on the weapon's base fire rate. At 750 RPM (0.080s between shots), three rounds fire in approximately 160ms. Adding the `burstCooldown` creates the characteristic burst rhythm.

## Complete weapons.meta template for all three variants

```xml
<?xml version="1.0" encoding="UTF-8"?>
<CWeaponInfoBlob>
  <Infos>
    <!-- M7 Military Select-Fire -->
    <Item type="CWeaponInfo">
      <Name>WEAPON_M7</Name>
      <Model>w_ar_m7</Model>
      <Slot>SLOT_RIFLE</Slot>
      <FireType>INSTANT_HIT</FireType>
      <Group>GROUP_RIFLE</Group>
      <AmmoInfo ref="AMMO_RIFLE" />
      <ClipSize value="20" />
      <Damage value="42.000000" />
      <DamageType>BULLET</DamageType>
      <Speed value="3000.000000" />          <!-- 6.8x51mm velocity -->
      <TimeBetweenShots value="0.080000" />  <!-- 750 RPM -->
      <AccuracySpread value="2.800000" />
      <RecoilAccuracyMax value="3.500000" />
      <WeaponRange value="200.000000" />
      <DamageFallOffRangeMin value="100.0" />
      <DamageFallOffRangeMax value="200.0" />
      <WeaponFlags>Gun Automatic AnimReload AnimCrouchFire TwoHanded LongWeapon ApplyBulletForce</WeaponFlags>
    </Item>

    <!-- MCX Spear Civilian Semi-Auto -->
    <Item type="CWeaponInfo">
      <Name>WEAPON_MCXSPEAR</Name>
      <Model>w_ar_mcxspear</Model>
      <Slot>SLOT_RIFLE</Slot>
      <FireType>INSTANT_HIT</FireType>
      <Group>GROUP_RIFLE</Group>
      <AmmoInfo ref="AMMO_RIFLE" />
      <ClipSize value="20" />
      <Damage value="42.000000" />
      <Speed value="2750.000000" />          <!-- 16" civilian barrel -->
      <TimeBetweenShots value="0.200000" />  <!-- Controlled semi -->
      <AccuracySpread value="2.200000" />
      <RecoilAccuracyMax value="1.800000" />
      <WeaponRange value="180.000000" />
      <WeaponFlags>Gun OnlyFireOneShotPerTriggerPress AnimReload AnimCrouchFire TwoHanded LongWeapon ApplyBulletForce</WeaponFlags>
    </Item>

    <!-- MCX Rattler 300 BLK Compact -->
    <Item type="CWeaponInfo">
      <Name>WEAPON_MCXRATTLER</Name>
      <Model>w_ar_mcxrattler</Model>
      <Slot>SLOT_RIFLE</Slot>
      <FireType>INSTANT_HIT</FireType>
      <Group>GROUP_RIFLE</Group>
      <AmmoInfo ref="AMMO_RIFLE" />
      <ClipSize value="30" />
      <Damage value="32.000000" />           <!-- 300 BLK base -->
      <Speed value="1800.000000" />          <!-- 5.5" barrel velocity -->
      <TimeBetweenShots value="0.200000" />  <!-- Semi-auto civilian -->
      <AccuracySpread value="3.500000" />    <!-- Short barrel penalty -->
      <RecoilAccuracyMax value="2.200000" />
      <WeaponRange value="80.000000" />      <!-- Limited effective range -->
      <AiSoundRange value="60.000000" />     <!-- Suppressor-ready design -->
      <WeaponFlags>Gun OnlyFireOneShotPerTriggerPress AnimReload AnimCrouchFire TwoHanded ApplyBulletForce</WeaponFlags>
    </Item>
  </Infos>
</CWeaponInfoBlob>
```

## Multiplayer synchronization and anti-cheat considerations

Fire mode state exists primarily client-side, but server validation prevents exploitation. Using **State Bags** (OneSync) synchronizes fire mode display across clients:

```lua
-- Client: Broadcast fire mode changes
LocalPlayer.state:set('fireMode', currentFireMode, true)

-- Server: Validate and log changes
AddStateBagChangeHandler('fireMode', nil, function(bagName, key, value)
    local playerId = tonumber(bagName:match('player:(%d+)'))
    if playerId and (value < 0 or value > 3) then
        -- Invalid mode - potential exploit
        DropPlayer(playerId, 'Invalid fire mode value')
    end
end)
```

**Anti-cheat integration** should monitor fire rate against weapon capabilities. If a semi-auto-only weapon fires faster than its `TimeBetweenShots` allows, the player is likely exploiting.

## Conclusion

Implementing the SIG MCX platform's three variants requires layered configuration: weapons.meta establishes base parameters and permanent fire restrictions, while Lua scripting enables dynamic select-fire behavior. The **M7 military variant** uses the `Automatic` flag with script-enforced semi-auto as default mode. The **civilian Spear** permanently restricts to semi-auto via `OnlyFireOneShotPerTriggerPress`. The **MCX Rattler** combines semi-auto restriction with ox_inventory's ammunition system for supersonic/subsonic switching, applying runtime damage modifiers based on loaded ammunition type.

The most reliable select-fire implementation uses the input blocking pattern with `DisablePlayerFiring()` called every frame within a detection loop. Burst fire requires shot counting via ammo monitoring since no native burst parameter exists. For ammunition-switching weapons, the combination of `metadata.specialAmmo` tracking and `SetWeaponDamageModifier()` provides the necessary runtime flexibility without requiring multiple weapon definitions.