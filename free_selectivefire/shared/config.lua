--[[
    SELECTIVE FIRE SYSTEM - CONFIGURATION

    This file defines which weapons have selective fire capability,
    their available fire modes, and modification options.

    Fire Modes:
    - 'SEMI'  : Semi-automatic (1 shot per trigger pull)
    - 'BURST' : Burst fire (configurable round count, then pause)
    - 'FULL'  : Full-automatic (continuous fire while holding trigger)

    Configuration Options:
    - selectFire: boolean - Whether weapon has native select fire
    - modes: table - Available fire modes {'SEMI', 'BURST', 'FULL'}
    - defaultMode: string - Starting fire mode
    - burstCount: number - Rounds per burst (default: 3)
    - modifiable: boolean - Can be modified to add fire modes
    - modificationComponent: string - Component that enables modification
    - modesWhenModified: table - Fire modes available when modified

    UNIVERSAL COMPONENTS:
    This system uses universal modification components that work across
    multiple compatible weapons. A single inventory item can modify any
    weapon in its compatibility group:

    - COMPONENT_GLOCK_SWITCH: Works on all Glock pistols (9mm and 10mm)
    - COMPONENT_AR15_BUMPSTOCK: Works on all AR-15 platform rifles
    - COMPONENT_SMG_SWITCH: Works on convertible SMGs (TEC-9, etc.)
    - COMPONENT_AK_BUMPSTOCK: Works on AK platform rifles
]]

Config = {}

-- ============================================================================
-- GENERAL SETTINGS
-- ============================================================================

Config.ToggleKey = 'B'              -- Key to cycle fire modes
Config.ToggleKeyCode = 29           -- Control code for 'B' (INPUT_SPECIAL_ABILITY)
Config.PlaySound = true             -- Play subtle sound on mode change
Config.RememberMode = true          -- Remember last selected mode per weapon
Config.NotificationDuration = 2000  -- Brief notification duration (ms)

-- Fire rate timing (milliseconds between shots)
Config.FireRates = {
    SEMI = 250,                     -- Minimum time between semi-auto shots
    BURST = 60,                     -- Time between shots within burst
    FULL = 60,                      -- Time between full-auto shots
}

Config.BurstDelay = 350             -- Delay after burst before next burst (ms)
Config.DefaultBurstCount = 3        -- Default rounds per burst

-- ============================================================================
-- UNIVERSAL MODIFICATION COMPONENTS
-- Define groups of weapons that can share the same modification component
-- ============================================================================

Config.UniversalComponents = {
    -- Glock Switch - works on all Glock pistols
    GLOCK_SWITCH = {
        componentName = 'COMPONENT_GLOCK_SWITCH',
        compatibleWeapons = {
            'WEAPON_G17',
            'WEAPON_G17_BLK',
            'WEAPON_G17_GEN5',
            'WEAPON_G19',
            'WEAPON_G19X',
            'WEAPON_G19XD',
            'WEAPON_G26',
            'WEAPON_G43X',
            'WEAPON_G45',
            'WEAPON_G45_TAN',
            'WEAPON_GLOCK20',  -- 10mm Glock
        },
    },

    -- AR-15 Bump Stock - works on all AR-15 platform rifles
    AR15_BUMPSTOCK = {
        componentName = 'COMPONENT_AR15_BUMPSTOCK',
        compatibleWeapons = {
            'WEAPON_PSA_AR15',
            'WEAPON_DESERT_AR15',
            'WEAPON_ARP_BUMPSTOCK',
            'WEAPON_MK18',
            'WEAPON_SBR9',
        },
    },

    -- SMG Switch - works on convertible SMGs
    SMG_SWITCH = {
        componentName = 'COMPONENT_SMG_SWITCH',
        compatibleWeapons = {
            'WEAPON_TEC9',
        },
    },

    -- AK Bump Stock - works on AK platform rifles
    AK_BUMPSTOCK = {
        componentName = 'COMPONENT_AK_BUMPSTOCK',
        compatibleWeapons = {
            'WEAPON_MINI_AK47',
            'WEAPON_MK47',
        },
    },
}

-- ============================================================================
-- WEAPON DEFINITIONS
-- ============================================================================

Config.Weapons = {

    -- ========================================================================
    -- BATCH 11: 9mm AR-PISTOLS (SMG Platforms)
    -- ========================================================================

    [`WEAPON_UDP9`] = {
        name = 'UDP-9',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        description = 'Angstadt Arms UDP-9 - Semi/Full select fire',
    },

    [`WEAPON_BLUEARP`] = {
        name = 'Blue ARP',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'FULL',
        description = 'Budget AR-9 Platform - Semi/Full select fire',
    },

    -- ========================================================================
    -- BATCH 12: 5.56 NATO RIFLES
    -- ========================================================================

    [`WEAPON_M16`] = {
        name = 'M16A4',
        selectFire = true,
        modes = {'SEMI', 'BURST'},
        defaultMode = 'SEMI',
        burstCount = 3,
        description = 'Colt M16A4 - Semi/3-round burst (military standard)',
    },

    [`WEAPON_PSA_AR15`] = {
        name = 'PSA AR-15',
        selectFire = false,          -- Civilian semi-auto only
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_AR15_BUMPSTOCK',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'PSA PA-15 - Semi-only (civilian), bump stock capable',
    },

    [`WEAPON_DESERT_AR15`] = {
        name = 'Desert AR-15',
        selectFire = false,          -- Civilian semi-auto only
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_AR15_BUMPSTOCK',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'FDE AR-15 - Semi-only (civilian), bump stock capable',
    },

    [`WEAPON_RED_AUG`] = {
        name = 'Steyr AUG A3',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        description = 'Steyr AUG A3 - Semi/Full select fire (bullpup)',
    },

    [`WEAPON_CZ_BREN`] = {
        name = 'CZ BREN 2',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        description = 'CZ BREN 2 - Semi/Full select fire (modular)',
    },

    [`WEAPON_RAM7KNIGHT`] = {
        name = 'IWI Tavor',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        description = 'IWI Tavor X95 - Semi/Full select fire (bullpup)',
    },

    -- ========================================================================
    -- BATCH 13: 7.62x39mm RIFLES
    -- ========================================================================

    [`WEAPON_MINI_AK47`] = {
        name = 'Micro Draco',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'FULL',
        modifiable = true,
        modificationComponent = 'COMPONENT_AK_BUMPSTOCK',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Micro Draco AK Pistol - Semi/Full select fire',
    },

    [`WEAPON_MK47`] = {
        name = 'CMMG Mk47',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_AK_BUMPSTOCK',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'CMMG Mk47 Mutant - Semi/Full select fire',
    },

    -- ========================================================================
    -- BATCH 15/16: 9mm SMGs
    -- ========================================================================

    [`WEAPON_MICRO_MP5`] = {
        name = 'H&K MP5K',
        selectFire = true,
        modes = {'SEMI', 'BURST', 'FULL'},
        defaultMode = 'SEMI',
        burstCount = 3,
        description = 'H&K MP5K - Semi/Burst/Full (Navy trigger group)',
    },

    [`WEAPON_SIG_MPX`] = {
        name = 'SIG MPX',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        description = 'SIG MPX - Semi/Full select fire',
    },

    [`WEAPON_SCORPION`] = {
        name = 'CZ Scorpion EVO 3',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        description = 'CZ Scorpion EVO 3 - Semi/Full select fire',
    },

    [`WEAPON_TEC9`] = {
        name = 'TEC-9',
        selectFire = false,          -- Originally semi-only
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_SMG_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'TEC-9 - Semi-only, convertible to full-auto',
    },

    [`WEAPON_MPA30`] = {
        name = 'MPA30T',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        description = 'MasterPiece Arms MPA30T - Semi/Full select fire',
    },

    [`WEAPON_SUB2000`] = {
        name = 'Kel-Tec SUB-2000',
        selectFire = false,          -- Civilian semi-only
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        description = 'Kel-Tec SUB-2000 - Semi-only (civilian carbine)',
    },

    [`WEAPON_RAM9_DESERT`] = {
        name = 'RAM-9',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        description = 'RAM-9 - Semi/Full select fire',
    },

    -- ========================================================================
    -- BATCH 16: .45 ACP SMGs (MAC Platform)
    -- ========================================================================

    [`WEAPON_MAC10`] = {
        name = 'MAC-10',
        selectFire = true,
        modes = {'FULL'},            -- Open-bolt, full-auto only
        defaultMode = 'FULL',
        description = 'Ingram MAC-10 - Full-auto only (open-bolt)',
    },

    [`WEAPON_MAC4A1`] = {
        name = 'MAC-4A1',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'FULL',
        description = 'Modernized MAC - Semi/Full select fire',
    },

    -- ========================================================================
    -- BATCH 17: 5.56 NATO AR PISTOLS/SBRs
    -- ========================================================================

    [`WEAPON_MK18`] = {
        name = 'Daniel Defense MK18',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_AR15_BUMPSTOCK',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'DD MK18 CQBR - Semi/Full select fire',
    },

    [`WEAPON_ARP_BUMPSTOCK`] = {
        name = 'AR Pistol',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_AR15_BUMPSTOCK',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'AR Pistol - Semi-only, bump stock capable',
    },

    [`WEAPON_SBR9`] = {
        name = 'SBR-9',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_AR15_BUMPSTOCK',
        modesWhenModified = {'SEMI', 'FULL'},
        description = '9mm AR SBR - Semi/Full select fire',
    },

    [`WEAPON_MCX300`] = {
        name = 'SIG MCX .300 BLK',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'SEMI',
        description = 'SIG MCX .300 Blackout - Semi/Full select fire',
    },

    -- ========================================================================
    -- BATCH 19: PRECISION RIFLES (Semi-Auto Only)
    -- ========================================================================

    [`WEAPON_SIG550`] = {
        name = 'SIG 550 (Stgw 90)',
        selectFire = true,
        modes = {'SEMI', 'BURST', 'FULL'},
        defaultMode = 'SEMI',
        burstCount = 3,
        description = 'Swiss Army rifle - Semi/Burst/Full (military)',
    },

    [`WEAPON_BARRETTM82A1`] = {
        name = 'Barrett M82A1',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        description = 'Barrett M82A1 .50 BMG - Semi-auto anti-materiel',
    },

    [`WEAPON_BARRETTM107A1`] = {
        name = 'Barrett M107A1',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        description = 'Barrett M107A1 .50 BMG - Semi-auto anti-materiel',
    },

    [`WEAPON_NEMOWATCHMAN`] = {
        name = 'NEMO Omen Watchman',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        description = 'NEMO Watchman .300 WM - Semi-auto precision',
    },

    -- ========================================================================
    -- PISTOLS - FACTORY FULL-AUTO
    -- ========================================================================

    [`WEAPON_G18`] = {
        name = 'Glock 18',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'FULL',
        description = 'Glock 18 - Factory select-fire machine pistol',
    },

    -- ========================================================================
    -- PISTOLS - MODIFIABLE (Universal Glock Switch)
    -- All Glocks use COMPONENT_GLOCK_SWITCH - one item works on any Glock
    -- ========================================================================

    -- Batch 1: Compact 9mm
    [`WEAPON_G26`] = {
        name = 'Glock 26',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 26 - Semi-only, switch capable',
    },

    [`WEAPON_G26_SWITCH`] = {
        name = 'Glock 26 (Switched)',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'FULL',
        description = 'Glock 26 with auto sear - Semi/Full',
    },

    [`WEAPON_G43X`] = {
        name = 'Glock 43X',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 43X - Semi-only, switch capable',
    },

    -- Batch 2: Full-Size 9mm
    [`WEAPON_G17`] = {
        name = 'Glock 17',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 17 - Semi-only, switch capable',
    },

    [`WEAPON_G17_BLK`] = {
        name = 'Glock 17 (Blackout)',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 17 Blackout - Semi-only, switch capable',
    },

    [`WEAPON_G17_GEN5`] = {
        name = 'Glock 17 Gen5',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 17 Gen5 - Semi-only, switch capable',
    },

    [`WEAPON_G19`] = {
        name = 'Glock 19',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 19 - Semi-only, switch capable',
    },

    [`WEAPON_G19X`] = {
        name = 'Glock 19X',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 19X - Semi-only, switch capable',
    },

    [`WEAPON_G19X_SWITCH`] = {
        name = 'Glock 19X (Switched)',
        selectFire = true,
        modes = {'SEMI', 'FULL'},
        defaultMode = 'FULL',
        description = 'Glock 19X with auto sear - Semi/Full',
    },

    [`WEAPON_G45`] = {
        name = 'Glock 45',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 45 - Semi-only, switch capable',
    },

    [`WEAPON_G45_TAN`] = {
        name = 'Glock 45 (FDE)',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 45 FDE - Semi-only, switch capable',
    },

    [`WEAPON_G19XD`] = {
        name = 'Glock 19X (Desert)',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 19X Desert - Semi-only, switch capable',
    },

    -- ========================================================================
    -- 10mm AUTO PISTOLS (Uses Universal Glock Switch)
    -- ========================================================================

    [`WEAPON_GLOCK20`] = {
        name = 'Glock 20',
        selectFire = false,
        modes = {'SEMI'},
        defaultMode = 'SEMI',
        modifiable = true,
        modificationComponent = 'COMPONENT_GLOCK_SWITCH',
        modesWhenModified = {'SEMI', 'FULL'},
        description = 'Glock 20 10mm - Semi-only, switch capable',
    },

    -- ========================================================================
    -- SMGs - Native Full-Auto with Select Fire
    -- ========================================================================

    -- Future SMG batches can be added here
}

-- ============================================================================
-- UNIVERSAL MODIFICATION COMPONENTS LIST
-- These are the actual component hashes used for checking attachments
-- ============================================================================

Config.ModificationComponents = {
    -- Universal components
    'COMPONENT_GLOCK_SWITCH',
    'COMPONENT_AR15_BUMPSTOCK',
    'COMPONENT_SMG_SWITCH',
    'COMPONENT_AK_BUMPSTOCK',
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Get weapon config by hash
function GetWeaponConfig(weaponHash)
    return Config.Weapons[weaponHash]
end

-- Check if weapon has select fire capability
function HasSelectFire(weaponHash)
    local config = Config.Weapons[weaponHash]
    if not config then return false end
    return config.selectFire or false
end

-- Check if weapon is modifiable
function IsModifiable(weaponHash)
    local config = Config.Weapons[weaponHash]
    if not config then return false end
    return config.modifiable or false
end

-- Get available modes for weapon (considering modifications)
function GetAvailableModes(weaponHash, hasModification)
    local config = Config.Weapons[weaponHash]
    if not config then return {'SEMI'} end

    if hasModification and config.modesWhenModified then
        return config.modesWhenModified
    end

    return config.modes or {'SEMI'}
end

-- Get default mode for weapon
function GetDefaultMode(weaponHash)
    local config = Config.Weapons[weaponHash]
    if not config then return 'SEMI' end
    return config.defaultMode or 'SEMI'
end

-- Get burst count for weapon
function GetBurstCount(weaponHash)
    local config = Config.Weapons[weaponHash]
    if not config then return Config.DefaultBurstCount end
    return config.burstCount or Config.DefaultBurstCount
end

-- Get compatible weapons for a universal component
function GetCompatibleWeapons(componentGroup)
    local group = Config.UniversalComponents[componentGroup]
    if group then
        return group.compatibleWeapons
    end
    return {}
end

-- Check if a weapon is compatible with a universal component
function IsWeaponCompatible(weaponName, componentGroup)
    local compatibleWeapons = GetCompatibleWeapons(componentGroup)
    for _, weapon in ipairs(compatibleWeapons) do
        if weapon == weaponName then
            return true
        end
    end
    return false
end
