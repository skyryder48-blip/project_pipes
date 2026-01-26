--[[
    Ammunition Damage Modifiers - COMPLETE DIFFERENTIATION
    =======================================================

    EVERY caliber + ammo type combination has UNIQUE values.
    No two bullets are the same.

    Based on real-world ballistic research:
    - FBI Ammunition Protocol (12-18" penetration standard)
    - Terminal ballistics (permanent/temporary cavity)
    - Muzzle energy comparisons per caliber
    - Armor interaction (NIJ levels)

    See BALLISTICS_RESEARCH.md for complete methodology.
]]

Config = Config or {}

-- =============================================================================
-- COMPLETE AMMO MODIFIERS BY CALIBER
-- Every single caliber/ammo combination with unique values
-- =============================================================================

Config.AmmoModifiers = {

    -- =========================================================================
    -- 9mm PARABELLUM (Baseline Caliber)
    -- Energy: 350 ft-lbs | Velocity: 1,150 fps
    -- =========================================================================
    ['9mm_fmj'] = {
        damageMult = 1.00,
        armorMult = 1.00,
        penetration = 0.75,
        armorBypass = false,
        effects = {},
    },
    ['9mm_hp'] = {
        damageMult = 1.15,
        armorMult = 0.50,
        penetration = 0.48,
        armorBypass = false,
        effects = {},
    },
    ['9mm_ap'] = {
        damageMult = 0.92,
        armorMult = 1.75,
        penetration = 0.88,
        armorBypass = true,
        effects = {},
    },

    -- =========================================================================
    -- .45 ACP
    -- Energy: 356 ft-lbs | Velocity: 830 fps (subsonic)
    -- Big slow bullet, excellent expansion, poor armor performance
    -- =========================================================================
    ['45acp_fmj'] = {
        damageMult = 1.02,      -- Slightly more mass than 9mm
        armorMult = 0.95,       -- Slow velocity = worse vs armor
        penetration = 0.70,
        armorBypass = false,
        effects = {},
    },
    ['45acp_jhp'] = {
        damageMult = 1.22,      -- Excellent expansion (.45 mushrooms huge)
        armorMult = 0.42,       -- Terrible vs armor
        penetration = 0.52,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .40 S&W
    -- Energy: 420 ft-lbs | Velocity: 990 fps
    -- "Snappy" recoil, compromise between 9mm and .45
    -- =========================================================================
    ['40sw_fmj'] = {
        damageMult = 1.08,      -- More energy than 9mm
        armorMult = 1.02,       -- Slightly better velocity
        penetration = 0.72,
        armorBypass = false,
        effects = {},
    },
    ['40sw_jhp'] = {
        damageMult = 1.26,      -- Good expansion + energy
        armorMult = 0.48,
        penetration = 0.55,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .357 MAGNUM
    -- Energy: 535-710 ft-lbs | Velocity: 1,235-1,450 fps
    -- Legendary "man-stopper", velocity-dependent expansion
    -- =========================================================================
    ['357mag_fmj'] = {
        damageMult = 1.18,      -- Significant energy advantage
        armorMult = 1.08,       -- High velocity helps
        penetration = 0.85,     -- Deep penetration
        armorBypass = false,
        effects = {},
    },
    ['357mag_jhp'] = {
        damageMult = 1.42,      -- Devastating at velocity
        armorMult = 0.52,
        penetration = 0.55,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .38 SPECIAL
    -- Energy: 165-250 ft-lbs | Velocity: 755-945 fps
    -- Weak caliber, only 57% of 9mm energy
    -- =========================================================================
    ['38spl_fmj'] = {
        damageMult = 0.72,      -- Significantly weaker than 9mm
        armorMult = 0.85,
        penetration = 0.65,
        armorBypass = false,
        effects = {},
    },
    ['38spl_jhp'] = {
        damageMult = 0.88,      -- +P loads help, still weak
        armorMult = 0.40,       -- Poor expansion at low velocity
        penetration = 0.50,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .44 MAGNUM
    -- Energy: 971-1,200 ft-lbs | Velocity: 1,350-1,500 fps
    -- "Dirty Harry" - massive power, 2x+ the energy of 9mm
    -- =========================================================================
    ['44mag_fmj'] = {
        damageMult = 1.52,      -- Massive energy
        armorMult = 1.12,       -- Sheer power helps
        penetration = 0.88,     -- Deep penetration
        armorBypass = false,
        effects = {},
    },
    ['44mag_jhp'] = {
        damageMult = 1.85,      -- Devastating expansion
        armorMult = 0.58,
        penetration = 0.68,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .500 S&W MAGNUM
    -- Energy: 2,418-3,032 ft-lbs | Velocity: 1,650-1,800 fps
    -- MOST POWERFUL PRODUCTION HANDGUN - equals rifle cartridges
    -- =========================================================================
    ['500sw_fmj'] = {
        damageMult = 1.95,      -- Rifle-level power
        armorMult = 1.25,       -- Sheer energy defeats soft armor
        penetration = 0.92,
        armorBypass = false,
        effects = {},
    },
    ['500sw_jhp'] = {
        damageMult = 2.35,      -- Catastrophic wound channel
        armorMult = 0.65,
        penetration = 0.75,
        armorBypass = false,
        effects = {},
    },
    ['500sw_bear'] = {
        damageMult = 1.88,      -- Penetration over expansion
        armorMult = 1.42,       -- Hard cast defeats barriers
        penetration = 0.98,     -- Maximum penetration
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- 5.7x28mm
    -- Energy: 250-340 ft-lbs | Velocity: 1,700-2,100 fps
    -- PDW cartridge - high velocity, low recoil, armor-defeating AP
    -- =========================================================================
    ['57x28_fmj'] = {
        damageMult = 0.82,      -- Less energy than 9mm
        armorMult = 1.05,       -- Velocity helps slightly
        penetration = 0.70,
        armorBypass = false,
        effects = {},
    },
    ['57x28_jhp'] = {
        damageMult = 0.98,      -- Small diameter limits expansion
        armorMult = 0.45,
        penetration = 0.55,
        armorBypass = false,
        effects = {},
    },
    ['57x28_ap'] = {
        damageMult = 0.78,      -- SS190 - armor focus
        armorMult = 2.20,       -- Defeats Level IIIA
        penetration = 0.96,
        armorBypass = true,
        effects = {},
    },

    -- =========================================================================
    -- 10mm AUTO
    -- Dual personality: FBI spec (400 ft-lbs) vs Full power (650 ft-lbs)
    -- =========================================================================
    ['10mm_fbi'] = {
        damageMult = 1.05,      -- Downloaded = .40 S&W equivalent
        armorMult = 1.00,
        penetration = 0.72,
        armorBypass = false,
        effects = {},
    },
    ['10mm_fullpower'] = {
        damageMult = 1.38,      -- Full Norma spec = .357 Mag
        armorMult = 1.08,
        penetration = 0.68,
        armorBypass = false,
        effects = {},
    },
    ['10mm_bear'] = {
        damageMult = 1.48,      -- Hard cast 220gr deep penetrator
        armorMult = 1.22,       -- Hard cast defeats barriers
        penetration = 0.96,     -- 32"+ gel penetration
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .22 LR
    -- Energy: 80-115 ft-lbs | Velocity: 1,000-1,200 fps
    -- WEAKEST handgun cartridge - training/plinking
    -- =========================================================================
    ['22lr_fmj'] = {
        damageMult = 0.38,      -- Very weak
        armorMult = 0.65,
        penetration = 0.50,
        armorBypass = false,
        effects = {},
    },
    ['22lr_jhp'] = {
        damageMult = 0.45,      -- Unreliable expansion
        armorMult = 0.35,
        penetration = 0.35,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- 12 GAUGE SHOTGUN
    -- Unique pellet-based system
    -- =========================================================================
    ['12ga_00buck'] = {
        damageMult = 1.00,      -- 8 pellets × base
        armorMult = 0.60,
        penetration = 0.65,
        pellets = 8,
        spread = 0.12,
        armorBypass = false,
        effects = {},
    },
    ['12ga_1buck'] = {
        damageMult = 0.72,      -- 12 smaller pellets
        armorMult = 0.52,
        penetration = 0.55,
        pellets = 12,
        spread = 0.15,
        armorBypass = false,
        effects = {},
    },
    ['12ga_slug'] = {
        damageMult = 5.50,      -- Single massive projectile
        armorMult = 1.05,
        penetration = 0.82,
        pellets = 1,
        spread = 0.01,
        armorBypass = false,
        effects = {},
    },
    ['12ga_birdshot'] = {
        damageMult = 0.42,      -- 19 tiny pellets
        armorMult = 0.28,
        penetration = 0.28,
        pellets = 19,
        spread = 0.25,
        armorBypass = false,
        effects = {},
    },
    ['12ga_dragonsbreath'] = {
        damageMult = 0.78,
        armorMult = 0.48,
        penetration = 0.32,
        pellets = 8,
        spread = 0.14,
        armorBypass = false,
        effects = {
            fire = true,
            fireTrail = true,
            fireDuration = 3500,
            fireDamage = 5,
        },
    },
    ['12ga_beanbag'] = {
        damageMult = 0.06,
        armorMult = 0.82,
        penetration = 0.00,
        pellets = 1,
        spread = 0.02,
        armorBypass = false,
        effects = {
            ragdoll = true,
            ragdollForce = 550,
            ragdollDuration = 2200,
        },
    },
    ['12ga_pepperball'] = {
        damageMult = 0.03,
        armorMult = 1.00,
        penetration = 0.00,
        pellets = 6,
        spread = 0.10,
        armorBypass = false,
        effects = {
            blind = true,
            blindDuration = 8500,
            cough = true,
            coughInterval = 1800,
        },
    },
    ['12ga_breach'] = {
        damageMult = 0.32,
        armorMult = 0.52,
        penetration = 0.00,
        pellets = 1,
        spread = 0.01,
        armorBypass = false,
        effects = {
            envDamage = 5.5,
        },
    },

    -- =========================================================================
    -- 5.56 NATO
    -- Energy: 1,282 ft-lbs | Velocity: 3,150 fps
    -- Standard AR-15/M4 cartridge
    -- =========================================================================
    ['556_fmj'] = {
        damageMult = 1.00,      -- Rifle baseline
        armorMult = 1.15,       -- High velocity
        penetration = 0.72,
        armorBypass = false,
        effects = {},
    },
    ['556_sp'] = {
        damageMult = 1.14,      -- Soft point expansion
        armorMult = 0.75,
        penetration = 0.58,
        armorBypass = false,
        effects = {},
    },
    ['556_ap'] = {
        damageMult = 0.88,      -- M855A1 penetrator
        armorMult = 1.95,
        penetration = 0.92,
        armorBypass = true,
        effects = {},
    },

    -- =========================================================================
    -- 6.8x51mm (NGSW)
    -- Energy: 2,680 ft-lbs | Velocity: 3,000 fps
    -- Next-gen military - designed to defeat Level IV
    -- =========================================================================
    ['68x51_fmj'] = {
        damageMult = 1.28,      -- More powerful than 5.56
        armorMult = 1.45,       -- Designed for armor defeat
        penetration = 0.88,
        armorBypass = true,     -- Even FMJ defeats body armor
        effects = {},
    },
    ['68x51_ap'] = {
        damageMult = 1.22,
        armorMult = 2.10,       -- Maximum armor defeat
        penetration = 0.98,
        armorBypass = true,
        effects = {},
    },

    -- =========================================================================
    -- .300 BLACKOUT
    -- Supersonic: 1,349 ft-lbs | Subsonic: 498 ft-lbs
    -- Suppressor-optimized cartridge
    -- =========================================================================
    ['300blk_supersonic'] = {
        damageMult = 1.05,      -- 7.62x39 equivalent
        armorMult = 1.08,
        penetration = 0.72,
        armorBypass = false,
        effects = {},
    },
    ['300blk_subsonic'] = {
        damageMult = 0.85,      -- Much less energy
        armorMult = 0.88,
        penetration = 0.68,
        armorBypass = false,
        effects = {
            suppressed = true,
            soundReduction = 0.55,
        },
    },

    -- =========================================================================
    -- 7.62x39mm
    -- Energy: 1,508 ft-lbs | Velocity: 2,350 fps
    -- Soviet AK cartridge - 14% more energy than 5.56
    -- =========================================================================
    ['762x39_fmj'] = {
        damageMult = 1.12,      -- More mass than 5.56
        armorMult = 1.05,       -- Slower velocity
        penetration = 0.74,
        armorBypass = false,
        effects = {},
    },
    ['762x39_sp'] = {
        damageMult = 1.28,      -- Good expansion
        armorMult = 0.68,
        penetration = 0.56,
        armorBypass = false,
        effects = {},
    },
    ['762x39_ap'] = {
        damageMult = 1.02,      -- 7N23 BP penetrator
        armorMult = 1.85,
        penetration = 0.92,
        armorBypass = true,
        effects = {},
    },

    -- =========================================================================
    -- 7.62x51mm NATO / .308 Winchester
    -- Energy: 2,559 ft-lbs | Velocity: 2,800 fps
    -- Full-power battle rifle cartridge
    -- =========================================================================
    ['762x51_fmj'] = {
        damageMult = 1.35,      -- Much more than 5.56
        armorMult = 1.22,
        penetration = 0.78,
        armorBypass = false,
        effects = {},
    },
    ['762x51_match'] = {
        damageMult = 1.42,      -- Premium precision
        armorMult = 1.18,
        penetration = 0.76,
        armorBypass = false,
        effects = {
            accuracy = 0.88,
        },
    },
    ['762x51_ap'] = {
        damageMult = 1.28,      -- M993 tungsten
        armorMult = 2.05,       -- Defeats Level III+
        penetration = 0.95,
        armorBypass = true,
        effects = {},
    },

    -- =========================================================================
    -- .300 WINCHESTER MAGNUM
    -- Energy: 3,501 ft-lbs | Velocity: 2,960 fps
    -- Long-range precision/hunting magnum
    -- =========================================================================
    ['300wm_fmj'] = {
        damageMult = 1.58,      -- Magnum power
        armorMult = 1.32,
        penetration = 0.82,
        armorBypass = false,
        effects = {},
    },
    ['300wm_match'] = {
        damageMult = 1.65,      -- Competition precision
        armorMult = 1.28,
        penetration = 0.80,
        armorBypass = false,
        effects = {
            accuracy = 0.85,
        },
    },

    -- =========================================================================
    -- .50 BMG (12.7x99mm NATO)
    -- Energy: 12,140-13,200 ft-lbs | Velocity: 2,810-2,910 fps
    -- ANTI-MATERIEL - 36x the energy of 9mm
    -- =========================================================================
    ['50bmg_ball'] = {
        damageMult = 2.20,      -- Massive baseline
        armorMult = 1.65,
        penetration = 0.95,
        armorBypass = true,     -- Defeats ALL body armor
        effects = {},
    },
    ['50bmg_api'] = {
        damageMult = 2.10,      -- Armor Piercing Incendiary
        armorMult = 2.25,
        penetration = 1.00,
        armorBypass = true,
        effects = {
            fire = true,
            vehicleFire = true,
            fireDuration = 5500,
        },
    },
    ['50bmg_boom'] = {
        damageMult = 3.00,      -- EXPLOSIVE MULTIPURPOSE (Raufoss Mk 211)
        armorMult = 1.85,
        penetration = 0.98,
        armorBypass = true,
        effects = {
            explosive = true,
            explosionRadius = 2.0,
            explosionDamage = 75,
            vehicleExplosion = true,
        },
    },

    -- =========================================================================
    -- TRANQUILIZER DART
    -- Non-lethal incapacitation
    -- =========================================================================
    ['dart_tranq'] = {
        damageMult = 0.02,
        armorMult = 0.00,       -- Blocked by any armor
        penetration = 0.00,
        armorBypass = false,
        effects = {
            incapacitate = true,
            incapDuration = 32000,
            phase1Duration = 5500,
            phase2Duration = 5500,
            phase3Duration = 21000,
        },
    },
}

-- =============================================================================
-- CALIBER TO MODIFIER KEY MAPPING
-- Maps caliber + ammo type to the specific modifier key
-- =============================================================================

Config.CaliberAmmoMap = {
    ['9mm'] = {
        ['fmj'] = '9mm_fmj',
        ['hp'] = '9mm_hp',
        ['ap'] = '9mm_ap',
    },
    ['.45acp'] = {
        ['fmj'] = '45acp_fmj',
        ['jhp'] = '45acp_jhp',
    },
    ['.40sw'] = {
        ['fmj'] = '40sw_fmj',
        ['jhp'] = '40sw_jhp',
    },
    ['.357mag'] = {
        ['fmj'] = '357mag_fmj',
        ['jhp'] = '357mag_jhp',
    },
    ['.38spl'] = {
        ['fmj'] = '38spl_fmj',
        ['jhp'] = '38spl_jhp',
    },
    ['.44mag'] = {
        ['fmj'] = '44mag_fmj',
        ['jhp'] = '44mag_jhp',
    },
    ['.500sw'] = {
        ['fmj'] = '500sw_fmj',
        ['jhp'] = '500sw_jhp',
        ['bear'] = '500sw_bear',
    },
    ['5.7x28'] = {
        ['fmj'] = '57x28_fmj',
        ['jhp'] = '57x28_jhp',
        ['ap'] = '57x28_ap',
    },
    ['10mm'] = {
        ['fbi'] = '10mm_fbi',
        ['fullpower'] = '10mm_fullpower',
        ['bear'] = '10mm_bear',
    },
    ['.22lr'] = {
        ['fmj'] = '22lr_fmj',
        ['jhp'] = '22lr_jhp',
    },
    ['12ga'] = {
        ['00buck'] = '12ga_00buck',
        ['1buck'] = '12ga_1buck',
        ['slug'] = '12ga_slug',
        ['birdshot'] = '12ga_birdshot',
        ['dragonsbreath'] = '12ga_dragonsbreath',
        ['beanbag'] = '12ga_beanbag',
        ['pepperball'] = '12ga_pepperball',
        ['breach'] = '12ga_breach',
    },
    ['5.56'] = {
        ['fmj'] = '556_fmj',
        ['sp'] = '556_sp',
        ['ap'] = '556_ap',
    },
    ['6.8x51'] = {
        ['fmj'] = '68x51_fmj',
        ['ap'] = '68x51_ap',
    },
    ['.300blk'] = {
        ['supersonic'] = '300blk_supersonic',
        ['subsonic'] = '300blk_subsonic',
    },
    ['7.62x39'] = {
        ['fmj'] = '762x39_fmj',
        ['sp'] = '762x39_sp',
        ['ap'] = '762x39_ap',
    },
    ['7.62x51'] = {
        ['fmj'] = '762x51_fmj',
        ['match'] = '762x51_match',
        ['ap'] = '762x51_ap',
    },
    ['.300wm'] = {
        ['fmj'] = '300wm_fmj',
        ['match'] = '300wm_match',
    },
    ['.50bmg'] = {
        ['ball'] = '50bmg_ball',
        ['api'] = '50bmg_api',
        ['boom'] = '50bmg_boom',
    },
    ['dart'] = {
        ['tranq'] = 'dart_tranq',
    },
}

-- =============================================================================
-- DEFAULT AMMO TYPE PER CALIBER
-- =============================================================================

Config.DefaultAmmoModifier = {
    ['9mm'] = 'fmj',
    ['.45acp'] = 'fmj',
    ['.40sw'] = 'fmj',
    ['.357mag'] = 'fmj',
    ['.38spl'] = 'fmj',
    ['.44mag'] = 'fmj',
    ['.500sw'] = 'fmj',
    ['5.7x28'] = 'fmj',
    ['10mm'] = 'fbi',
    ['.22lr'] = 'fmj',
    ['5.56'] = 'fmj',
    ['6.8x51'] = 'fmj',
    ['.300blk'] = 'supersonic',
    ['12ga'] = '00buck',
    ['7.62x39'] = 'fmj',
    ['7.62x51'] = 'fmj',
    ['.300wm'] = 'fmj',
    ['.50bmg'] = 'ball',
    ['dart'] = 'tranq',
}

-- =============================================================================
-- HELPER FUNCTIONS
-- =============================================================================

--- Get the modifier table for an ammo type with caliber context
-- @param ammoType string The ammo type (e.g., 'fmj', 'jhp', 'ap')
-- @param caliber string The weapon's caliber (e.g., '9mm', '.45acp')
-- @return table The modifier table with unique caliber-specific values
function GetAmmoModifier(ammoType, caliber)
    -- Build the lookup key
    local caliberMap = Config.CaliberAmmoMap[caliber]
    if caliberMap and caliberMap[ammoType] then
        local modifierKey = caliberMap[ammoType]
        local modifier = Config.AmmoModifiers[modifierKey]
        if modifier then
            return modifier
        end
    end

    -- Fallback: try direct key lookup (for backwards compatibility)
    if Config.AmmoModifiers[ammoType] then
        return Config.AmmoModifiers[ammoType]
    end

    -- Ultimate fallback: generic FMJ-like stats
    return {
        damageMult = 1.00,
        armorMult = 1.00,
        penetration = 0.70,
        armorBypass = false,
        effects = {},
    }
end

--- Get the default ammo type for a caliber
-- @param caliber string The caliber
-- @return string The default ammo type
function GetDefaultAmmoType(caliber)
    return Config.DefaultAmmoModifier[caliber] or 'fmj'
end

--- Check if an ammo type exists for a caliber
-- @param caliber string The caliber
-- @param ammoType string The ammo type
-- @return boolean Whether the combination exists
function IsValidAmmoType(caliber, ammoType)
    local caliberMap = Config.CaliberAmmoMap[caliber]
    return caliberMap and caliberMap[ammoType] ~= nil
end

--- Get all available ammo types for a caliber
-- @param caliber string The caliber
-- @return table List of available ammo types
function GetAmmoTypesForCaliber(caliber)
    local caliberMap = Config.CaliberAmmoMap[caliber]
    if not caliberMap then return {} end

    local types = {}
    for ammoType, _ in pairs(caliberMap) do
        table.insert(types, ammoType)
    end
    return types
end

-- =============================================================================
-- EXPORTS
-- =============================================================================

exports('GetAmmoModifier', GetAmmoModifier)
exports('GetDefaultAmmoType', GetDefaultAmmoType)
exports('IsValidAmmoType', IsValidAmmoType)
exports('GetAmmoTypesForCaliber', GetAmmoTypesForCaliber)
