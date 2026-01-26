# Magazine System Guide

## Table of Contents
1. [3D Model Naming Conventions](#3d-model-naming-conventions)
2. [Magazine Compatibility Groups](#magazine-compatibility-groups)
3. [Store Inventory Guide](#store-inventory-guide)
4. [Weaponcomponents.meta Setup](#weaponcomponentsmeta-setup)

---

## 3D Model Naming Conventions

### GTA V Weapon Component Model Naming Standard

Magazine 3D models follow this pattern:
```
w_[type]_[weapon]_mag[variant]
```

| Prefix | Weapon Type |
|--------|-------------|
| `w_pi_` | Pistol |
| `w_sm_` | SMG/Submachine Gun |
| `w_ar_` | Assault Rifle |
| `w_sr_` | Sniper Rifle |
| `w_sg_` | Shotgun |
| `w_mg_` | Machine Gun |

### Magazine Variant Suffixes

| Suffix | Description | Example |
|--------|-------------|---------|
| `_mag` | Standard magazine | `w_pi_g17_mag` |
| `_mag1` | Alternate standard | `w_pi_g17_mag1` |
| `_mag2` | Extended magazine | `w_pi_g17_mag2` |
| `_mag3` | Drum magazine | `w_pi_g17_mag3` |

### Your Current Naming Convention

Based on your files (`w_pi_*_mag1`, `w_pi_*_mag2`):
- `_mag1` = Standard magazine model
- `_mag2` = Extended magazine model

### Required Model Names by Weapon

```
GLOCK 17 (9mm Full-Size):
├── w_pi_g17_mag1      → Standard 17rd
├── w_pi_g17_mag2      → Extended 33rd stick
└── w_pi_g17_mag3      → Drum 50rd (if applicable)

GLOCK 26 (9mm Compact):
├── w_pi_g26_mag1      → Standard 10rd
├── w_pi_g26_mag2      → Extended 17rd
└── w_pi_g26_mag3      → Stick 33rd

M9 / BERETTA:
├── w_pi_m9_mag1       → Standard 15rd
└── w_pi_m9_mag2       → Extended 30rd

1911:
├── w_pi_1911_mag1     → Standard 7-8rd
└── w_pi_1911_mag2     → Extended 10rd

MP5 (SMG):
├── w_sm_mp5_mag1      → Standard 30rd
└── w_sm_mp5_mag2      → Extended (if applicable)

MK18 / AR-15 (5.56):
├── w_ar_mk18_mag1     → STANAG 30rd
├── w_ar_mk18_mag2     → Extended 40rd
└── w_ar_mk18_mag3     → Drum 60rd

AK / MK47 (7.62x39):
├── w_ar_ak47_mag1     → Standard 30rd
├── w_ar_ak47_mag2     → Extended 40rd
└── w_ar_ak47_mag3     → Drum 75rd
```

---

## Magazine Compatibility Groups

### NON-UNIVERSAL MAGAZINES

Magazines are grouped by PLATFORM, not just caliber. A Glock 9mm magazine will NOT work in a SIG or Beretta.

### 9mm PISTOL COMPATIBILITY

#### Group: Glock Full-Size 9mm (Double-Stack)
**Shares: `mag_glock9_*`**
```
WEAPON_G17          WEAPON_G17_BLK      WEAPON_G17_GEN5
WEAPON_G18          WEAPON_G19          WEAPON_G19X
WEAPON_G19XD        WEAPON_G19X_SWITCH  WEAPON_G45
WEAPON_G45_TAN
```
Available magazines:
- `mag_glock9_standard` (17rd)
- `mag_glock9_extended` (33rd stick)
- `mag_glock9_drum` (50rd)

#### Group: Glock Compact 9mm (Sub-Compact Frame)
**Shares: `mag_g26_*`**
```
WEAPON_G26          WEAPON_G43X         WEAPON_G26_SWITCH
```
Available magazines:
- `mag_g26_standard` (10rd)
- `mag_g26_extended` (17rd)
- `mag_g26_stick` (33rd)

#### Group: Springfield/Taurus Compact
**Shares: `mag_compact9_*`**
```
WEAPON_GX4          WEAPON_HELLCAT
```
Available magazines:
- `mag_compact9_standard` (11rd)
- `mag_compact9_extended` (15rd)

#### Group: Beretta 9mm
**Shares: `mag_beretta_*`**
```
WEAPON_M9           WEAPON_PX4          WEAPON_PX4STORM
```
Available magazines:
- `mag_beretta_standard` (15rd)
- `mag_beretta_extended` (30rd)

**M9A3 ONLY** (unique magazine):
- `mag_beretta_m9a3` (17rd)

#### Group: SIG Sauer 9mm
**Shares: `mag_sig_*`**
```
WEAPON_P320         WEAPON_SIGP320      WEAPON_SIGP226
WEAPON_SIGP226MK25  WEAPON_SIGP229
```
Available magazines:
- `mag_sig_standard` (15rd)
- `mag_sig_extended` (21rd)

**P210 ONLY** (Swiss heritage, unique):
- `mag_sig_p210` (8rd)

#### Group: Weapon-Specific 9mm (No Sharing)
| Weapon | Magazine | Notes |
|--------|----------|-------|
| WEAPON_FN509 | `mag_fn509_*` | FN proprietary |
| WEAPON_TP9SF | `mag_tp9sf_standard` | Canik proprietary |
| WEAPON_WALTHERP88 | `mag_walther_standard` | Walther proprietary |
| WEAPON_RUGERSR9 | `mag_rugersr9_standard` | Ruger proprietary |
| WEAPON_PSADAGGER | `mag_psadagger_standard` | Glock-pattern but branded |

### .45 ACP COMPATIBILITY

#### Group: Glock .45 ACP
**Shares: `mag_glock45_*`**
```
WEAPON_G21          WEAPON_G41
```
Available magazines:
- `mag_glock45_standard` (13rd)
- `mag_glock45_extended` (26rd)

**G30 ONLY** (compact frame):
- `mag_glock45_compact` (10rd)

#### Group: 1911 Platform
**Shares: `mag_1911_*`**
```
WEAPON_M45A1        WEAPON_KIMBER1911   WEAPON_JUNK1911
WEAPON_KIMBER_ECLIPSE
```
Available magazines:
- `mag_1911_standard` (7rd)
- `mag_1911_8rd` (8rd)
- `mag_1911_extended` (10rd)

**SIG P220 ONLY**:
- `mag_sigp220_standard` (8rd)

### .40 S&W COMPATIBILITY

#### Group: Glock .40 S&W
**Shares: `mag_glock40_*`**
```
WEAPON_G22_GEN4     WEAPON_G22_GEN5
```
Available magazines:
- `mag_glock40_standard` (15rd)
- `mag_glock40_extended` (22rd)

**Glock Demon ONLY**:
- `mag_glock40_compact` (13rd)

### 9mm SMG COMPATIBILITY

#### Group: AR-9 / Glock-Mag SMGs
**Shares: `mag_ar9_*`** (Glock-pattern mag well)
```
WEAPON_UDP9         WEAPON_BLUEARP
```
- `mag_ar9_standard` (17rd)
- `mag_ar9_extended` (33rd)

#### Group: Kel-Tec SUB-2000
**Unique**: Uses Glock magazines but tracked separately
- `mag_sub2000_standard` (33rd)

#### Weapon-Specific SMGs (No Sharing)
| Weapon | Magazine | Notes |
|--------|----------|-------|
| WEAPON_MICRO_MP5 | `mag_mp5_standard` | H&K roller-lock |
| WEAPON_SIG_MPX | `mag_mpx_standard` | SIG proprietary |
| WEAPON_SCORPION | `mag_scorpion_*` | CZ proprietary, has drum |
| WEAPON_TEC9 | `mag_tec9_standard` | Intratec unique |
| WEAPON_MPA30 | `mag_mpa30_standard` | MasterPiece Arms |
| WEAPON_RAM9_DESERT | `mag_ram9_standard` | RAM proprietary |

### .45 ACP SMG COMPATIBILITY

#### Group: MAC Series
**Shares: `mag_mac_*`**
```
WEAPON_MAC10        WEAPON_MAC4A1
```
- `mag_mac_standard` (30rd)
- `mag_mac_extended` (50rd)

### 5.56 NATO RIFLE COMPATIBILITY

#### Group: STANAG Compatible (AR-15 Pattern)
**Shares: `mag_556_*`**
```
WEAPON_MK18         WEAPON_ARP_BUMPSTOCK    WEAPON_SBR9
```
- `mag_556_standard` (30rd STANAG)
- `mag_556_extended` (40rd)
- `mag_556_drum` (60rd)

**SIG 550 ONLY** (Swiss proprietary, NOT STANAG):
- `mag_sig550_standard` (20rd)
- `mag_sig550_extended` (30rd)

### 7.62x39mm COMPATIBILITY

#### Group: AK Pattern
**Shares: `mag_762x39_*`**
```
WEAPON_MINI_AK47    WEAPON_MK47
```
- `mag_762x39_standard` (30rd)
- `mag_762x39_extended` (40rd RPK)
- `mag_762x39_drum` (75rd) - MK47 only, too heavy for Draco

### SPECIALTY CALIBERS

#### 5.7x28mm
**Shares: `mag_57_*`**
```
WEAPON_FN57         WEAPON_RUGER57
```
- `mag_57_standard` (20rd)
- `mag_57_extended` (30rd)

#### 10mm Auto
**GLOCK 20 ONLY**:
- `mag_10mm_standard` (15rd)
- `mag_10mm_extended` (30rd)

#### .22 LR
**Weapon-Specific** (different mag designs):
| Weapon | Magazine |
|--------|----------|
| WEAPON_P22, WEAPON_SIGP22 | `mag_22_standard` (10rd) |
| WEAPON_FN502 | `mag_fn502_standard` (15rd) |
| WEAPON_PMR30 | `mag_pmr30_standard` (30rd) |

#### 6.8x51mm NGSW
**Shares: `mag_68x51_*`**
```
WEAPON_SIG_SPEAR    WEAPON_M7
```
- `mag_68x51_standard` (20rd)

#### .300 Blackout
**MCX ONLY**:
- `mag_300blk_standard` (30rd)

#### .300 Win Mag
**NEMO Watchman ONLY**:
- `mag_300wm_standard` (14rd)

#### .50 BMG
**Barrett ONLY**:
```
WEAPON_BARRETTM82A1     WEAPON_BARRETTM107A1
```
- `mag_50bmg_barrett` (10rd)

**Victus XMR ONLY**:
- `mag_50bmg_victus` (5rd)

### REVOLVERS (Speedloaders - Fixed Capacity)

Revolvers have FIXED cylinder capacity. Speedloaders only affect reload speed.

| Speedloader | Weapons | Capacity |
|-------------|---------|----------|
| `speedloader_357` | King Cobra, Python, SW657 | 6rd |
| `speedloader_38` | SW Model 15, Model 10 | 6rd |
| `speedloader_38_5rd` | SW Model 60/442/642, Ruger LCR | 5rd |
| `speedloader_taurus856` | Taurus 856 | 6rd |
| `speedloader_44` | SW Model 29, Raging Bull | 6rd |
| `speedloader_500` | S&W 500 | 5rd |

### SHOTGUNS (No Magazines)

Tube-fed shotguns have NO magazine items. Capacity is fixed:
- Mini Shotty: 4 rounds
- Model 680, Remington 870: 5 rounds
- Mossberg 500, Shockwave: 6 rounds
- Browning Auto-5: 5 rounds
- Beretta 1301: 8 rounds

---

## Store Inventory Guide

### Recommended Store Stock by Type

#### Gun Store - Basic
```lua
-- 9mm Magazines (most common)
{ item = 'mag_glock9_standard', price = 30, quantity = 50 },
{ item = 'mag_beretta_standard', price = 28, quantity = 30 },
{ item = 'mag_sig_standard', price = 35, quantity = 30 },

-- .45 ACP Magazines
{ item = 'mag_1911_standard', price = 25, quantity = 30 },
{ item = 'mag_glock45_standard', price = 35, quantity = 20 },

-- Speedloaders
{ item = 'speedloader_357', price = 15, quantity = 20 },
{ item = 'speedloader_38', price = 12, quantity = 25 },
```

#### Gun Store - Premium
```lua
-- Extended Pistol Mags
{ item = 'mag_glock9_extended', price = 90, quantity = 15 },
{ item = 'mag_sig_extended', price = 75, quantity = 15 },
{ item = 'mag_1911_extended', price = 55, quantity = 10 },

-- Drums (Rare)
{ item = 'mag_glock9_drum', price = 275, quantity = 5 },
```

#### Military Surplus / Black Market
```lua
-- Rifle Magazines
{ item = 'mag_556_standard', price = 25, quantity = 30 },
{ item = 'mag_556_extended', price = 65, quantity = 10 },
{ item = 'mag_556_drum', price = 195, quantity = 3 },

-- AK Magazines
{ item = 'mag_762x39_standard', price = 35, quantity = 20 },
{ item = 'mag_762x39_extended', price = 75, quantity = 8 },
{ item = 'mag_762x39_drum', price = 225, quantity = 2 },

-- SMG Magazines
{ item = 'mag_mp5_standard', price = 55, quantity = 15 },
{ item = 'mag_scorpion_standard', price = 50, quantity = 15 },
{ item = 'mag_mac_standard', price = 45, quantity = 10 },
```

#### Specialty / High-End
```lua
-- .50 BMG (Very Rare)
{ item = 'mag_50bmg_barrett', price = 275, quantity = 2 },
{ item = 'mag_50bmg_victus', price = 195, quantity = 3 },

-- 6.8x51mm NGSW
{ item = 'mag_68x51_standard', price = 55, quantity = 5 },

-- .300 Win Mag
{ item = 'mag_300wm_standard', price = 125, quantity = 3 },
```

### Complete Magazine List for ox_inventory

Add to `ox_inventory/data/items.lua`:
```lua
-- Copy entire contents of free-bullets/inventory/magazine_items.lua
```

---

## Weaponcomponents.meta Setup

### Why Standard Magazines Don't Show

The `<Model />` tag in weaponcomponents.meta is empty:
```xml
<Item type="CWeaponComponentClipInfo">
  <n>COMPONENT_G17_CLIP_FMJ</n>
  <Model />  <!-- EMPTY - No 3D model specified -->
  ...
</Item>
```

### Fix: Add Model References

Update each component to reference the correct model:
```xml
<!-- Standard 17rd Magazine -->
<Item type="CWeaponComponentClipInfo">
  <n>COMPONENT_G17_CLIP_FMJ</n>
  <Model>w_pi_g17_mag1</Model>  <!-- Standard mag model -->
  ...
</Item>

<!-- Extended 33rd Magazine -->
<Item type="CWeaponComponentClipInfo">
  <n>COMPONENT_G17_EXTCLIP_FMJ</n>
  <Model>w_pi_g17_mag2</Model>  <!-- Extended mag model -->
  ...
</Item>

<!-- Drum 50rd Magazine -->
<Item type="CWeaponComponentClipInfo">
  <n>COMPONENT_G17_DRUM_FMJ</n>
  <Model>w_pi_g17_mag3</Model>  <!-- Drum mag model -->
  ...
</Item>
```

### Component Naming Pattern

```
COMPONENT_[WEAPON]_[MAGTYPE]_[AMMOTYPE]

Examples:
COMPONENT_G17_CLIP_FMJ       = Standard FMJ
COMPONENT_G17_CLIP_HP        = Standard Hollow Point
COMPONENT_G17_EXTCLIP_FMJ    = Extended FMJ
COMPONENT_G17_DRUM_AP        = Drum Armor Piercing
```

### Model File Placement

Place your `.ydr` and `.ytd` files in the weapon's stream folder:
```
weapon_g17/
├── stream/
│   ├── w_pi_g17_mag1.ydr    # Standard mag mesh
│   ├── w_pi_g17_mag1.ytd    # Standard mag texture
│   ├── w_pi_g17_mag2.ydr    # Extended mag mesh
│   └── w_pi_g17_mag2.ytd    # Extended mag texture
└── meta/
    └── weaponcomponents.meta
```

---

## Quick Reference: Magazine → Model Mapping

| Magazine Type | Component Suffix | Model Suffix |
|---------------|------------------|--------------|
| Standard | `_CLIP_` | `_mag1` |
| Extended | `_EXTCLIP_` | `_mag2` |
| Drum | `_DRUM_` | `_mag3` |

### Example Full Mapping for G17

| ox_inventory Item | Component | Model |
|-------------------|-----------|-------|
| `mag_glock9_standard` + FMJ | `COMPONENT_G17_CLIP_FMJ` | `w_pi_g17_mag1` |
| `mag_glock9_standard` + HP | `COMPONENT_G17_CLIP_HP` | `w_pi_g17_mag1` |
| `mag_glock9_extended` + FMJ | `COMPONENT_G17_EXTCLIP_FMJ` | `w_pi_g17_mag2` |
| `mag_glock9_drum` + FMJ | `COMPONENT_G17_DRUM_FMJ` | `w_pi_g17_mag3` |
