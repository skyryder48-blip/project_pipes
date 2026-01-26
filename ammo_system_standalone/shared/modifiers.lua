--[[
    Ammunition Damage Modifiers
    ===========================

    Based on real-world ballistic research:
    - FBI Ammunition Protocol (12-18" penetration standard)
    - Terminal ballistics (permanent/temporary cavity)
    - Armor interaction (NIJ levels, hardened cores)

    See BALLISTICS_RESEARCH.md for complete methodology.

    FORMULA:
    Final Damage = Base Weapon Damage × damageMult × armorMult (if armored)

    All values are RELATIVE to FMJ baseline (1.00)
]]

Config = Config or {}

-- =============================================================================
-- AMMO TYPE MODIFIERS
-- =============================================================================
--
-- damageMult:    Damage multiplier vs unarmored targets (1.0 = baseline)
-- armorMult:     Damage multiplier vs armored targets (1.0 = normal)
-- penetration:   Barrier penetration factor (0.0-1.0, higher = more penetration)
-- armorBypass:   If true, ignores armor entirely (AP rounds)
-- effects:       Special effects table { effectName = value/true }
--
-- =============================================================================

Config.AmmoModifiers = {
    -- =========================================================================
    -- UNIVERSAL AMMUNITION TYPES
    -- These apply to any caliber unless overridden
    -- =========================================================================

    -- FMJ: Full Metal Jacket - BASELINE
    -- Copper-jacketed lead core, maintains shape on impact
    -- 18-24" gel penetration, over-penetration risk
    ['fmj'] = {
        damageMult = 1.00,      -- Baseline damage
        armorMult = 1.00,       -- Normal armor interaction
        penetration = 0.75,     -- Good barrier penetration
        armorBypass = false,
        effects = {},
    },

    -- HP: Hollow Point (standard)
    -- Expands to 1.5x diameter, larger wound channel
    -- FBI ideal 12-16" penetration, transfers all energy
    ['hp'] = {
        damageMult = 1.15,      -- +15% (expansion bonus)
        armorMult = 0.50,       -- -50% vs armor (soft tip defeated)
        penetration = 0.48,     -- Reduced penetration (controlled)
        armorBypass = false,
        effects = {},
    },

    -- JHP: Jacketed Hollow Point (premium)
    -- Engineered expansion (Federal HST, Speer Gold Dot)
    -- Consistent mushroom, 1.5-2.0x expansion
    ['jhp'] = {
        damageMult = 1.20,      -- +20% (premium expansion)
        armorMult = 0.45,       -- -55% vs armor
        penetration = 0.45,     -- Controlled to FBI spec
        armorBypass = false,
        effects = {},
    },

    -- AP: Armor Piercing
    -- Hardened steel/tungsten core, ice-pick wound
    -- Defeats soft armor (Level IIIA), reduced tissue damage
    ['ap'] = {
        damageMult = 0.92,      -- -8% (no expansion, narrow track)
        armorMult = 1.80,       -- +80% vs armor OR bypass
        penetration = 0.90,     -- Excellent barrier penetration
        armorBypass = true,     -- Ignores soft armor
        effects = {},
    },

    -- SP: Soft Point
    -- Exposed lead tip, controlled expansion
    -- Hunting/defense crossover, moderate performance
    ['sp'] = {
        damageMult = 1.10,      -- +10% (partial expansion)
        armorMult = 0.70,       -- -30% vs armor
        penetration = 0.58,     -- Moderate
        armorBypass = false,
        effects = {},
    },

    -- Match: Competition/Precision Grade
    -- HPBT design for accuracy, NOT hollow point behavior
    -- Sub-MOA capable, consistent BC
    ['match'] = {
        damageMult = 1.05,      -- +5% (precision shot placement)
        armorMult = 1.00,       -- Normal (no expansion)
        penetration = 0.76,     -- Similar to FMJ
        armorBypass = false,
        effects = {
            accuracy = 0.90,    -- 10% better accuracy (spread multiplier)
        },
    },

    -- Tracer: Marking/Incendiary Compound
    -- Visible trail, slight ballistic difference
    ['tracer'] = {
        damageMult = 1.00,      -- No change
        armorMult = 1.00,       -- No change
        penetration = 0.75,     -- Same as FMJ
        armorBypass = false,
        effects = {
            tracer = true,      -- Visual trail effect
        },
    },

    -- =========================================================================
    -- 10MM AUTO SPECIALTY LOADS
    -- Dual personality caliber: FBI-spec vs Full-power
    -- =========================================================================

    -- FBI: FBI Service Load (downloaded 10mm)
    -- 180gr @ 1,000 fps = ~400 ft-lbs (.40 S&W equivalent)
    ['fbi'] = {
        damageMult = 1.00,      -- Baseline for 10mm
        armorMult = 1.00,       -- Normal
        penetration = 0.72,     -- Moderate
        armorBypass = false,
        effects = {},
    },

    -- Full Power: Original Norma spec
    -- 180gr @ 1,300 fps = ~650 ft-lbs (.357 Mag equivalent)
    ['fullpower'] = {
        damageMult = 1.24,      -- +24% (significantly more energy)
        armorMult = 0.95,       -- Slight reduction (velocity defeats soft armor)
        penetration = 0.65,     -- Less controlled
        armorBypass = false,
        effects = {},
    },

    -- Bear: Hard Cast Bear Defense
    -- 220gr @ 1,200 fps = ~700 ft-lbs, 32"+ penetration
    ['bear'] = {
        damageMult = 1.19,      -- +19% (heavy bullet)
        armorMult = 1.10,       -- Slight bonus (hard cast penetrates)
        penetration = 0.95,     -- Extreme penetration
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .300 BLACKOUT SPECIALTY LOADS
    -- Suppressor-optimized cartridge
    -- =========================================================================

    -- Supersonic: Standard .300 BLK
    -- 110gr @ 2,350 fps (7.62x39 equivalent)
    ['supersonic'] = {
        damageMult = 1.00,      -- Baseline
        armorMult = 1.00,       -- Normal
        penetration = 0.70,     -- Rifle-typical
        armorBypass = false,
        effects = {},
    },

    -- Subsonic: Heavy Suppressor Load
    -- 220gr @ 1,010 fps (below speed of sound)
    ['subsonic'] = {
        damageMult = 0.88,      -- -12% (much less energy)
        armorMult = 0.90,       -- Slight reduction
        penetration = 0.68,     -- Similar depth, less violence
        armorBypass = false,
        effects = {
            suppressed = true,
            soundReduction = 0.50,  -- 50% quieter
        },
    },

    -- =========================================================================
    -- 12 GAUGE SHOTGUN LOADS
    -- Unique: Pellet count × per-pellet damage
    -- =========================================================================

    -- 00 Buckshot: Standard Combat Load
    -- 8 pellets × .33 caliber @ 1,200 fps
    ['00buck'] = {
        damageMult = 1.00,      -- Baseline per pellet
        armorMult = 0.60,       -- -40% vs armor (soft lead)
        penetration = 0.65,     -- Good penetration
        pellets = 8,
        spread = 0.12,
        armorBypass = false,
        effects = {},
    },

    -- #1 Buckshot: More Pellets
    -- 12 pellets × .30 caliber, more hit probability
    ['1buck'] = {
        damageMult = 0.70,      -- -30% per pellet (smaller)
        armorMult = 0.50,       -- -50% vs armor
        penetration = 0.55,     -- Less per-pellet penetration
        pellets = 12,
        spread = 0.15,
        armorBypass = false,
        effects = {},
    },

    -- Slug: Single Projectile
    -- 1 oz (437gr) @ 1,600 fps = ~2,500 ft-lbs
    ['slug'] = {
        damageMult = 6.00,      -- 6x single hit (replaces pellet system)
        armorMult = 1.00,       -- Normal (solid projectile)
        penetration = 0.80,     -- Excellent
        pellets = 1,
        spread = 0.01,          -- Very tight
        armorBypass = false,
        effects = {},
    },

    -- Birdshot: Small Game/Training
    -- ~19 pellets × #4 shot, wide pattern
    ['birdshot'] = {
        damageMult = 0.40,      -- -60% per pellet (tiny)
        armorMult = 0.30,       -- -70% vs armor (ineffective)
        penetration = 0.30,     -- Poor
        pellets = 19,
        spread = 0.25,          -- Very wide
        armorBypass = false,
        effects = {},
    },

    -- Dragon's Breath: Incendiary
    -- Magnesium pellets, spectacular fire trail
    ['dragonsbreath'] = {
        damageMult = 0.75,      -- -25% per pellet (soft material)
        armorMult = 0.50,       -- -50% vs armor
        penetration = 0.30,     -- Poor
        pellets = 8,
        spread = 0.14,
        armorBypass = false,
        effects = {
            fire = true,
            fireTrail = true,
            fireDuration = 3000,    -- 3 seconds burn
            fireDamage = 4,         -- DPS while burning
        },
    },

    -- Beanbag: Less-Lethal Impact
    -- Fabric pouch, 40-joule kinetic impact
    ['beanbag'] = {
        damageMult = 0.05,      -- 5% (minimal lethal damage)
        armorMult = 0.80,       -- Works through soft armor
        penetration = 0.00,     -- No penetration
        pellets = 1,
        spread = 0.02,
        armorBypass = false,
        effects = {
            ragdoll = true,
            ragdollForce = 500,
            ragdollDuration = 2000,
        },
    },

    -- Pepperball: OC Irritant
    -- Breaks on impact, releases capsaicin
    ['pepperball'] = {
        damageMult = 0.02,      -- 2% (nearly zero)
        armorMult = 1.00,       -- Works on anyone
        penetration = 0.00,     -- No penetration
        pellets = 6,
        spread = 0.10,
        armorBypass = false,
        effects = {
            blind = true,
            blindDuration = 8000,   -- 8 seconds
            cough = true,
            coughInterval = 2000,   -- Cough every 2 seconds
        },
    },

    -- Breach: Door Breaching
    -- Frangible slug, no ricochet, high object damage
    ['breach'] = {
        damageMult = 0.30,      -- Low vs people
        armorMult = 0.50,       -- Poor vs armor
        penetration = 0.00,     -- No through penetration
        pellets = 1,
        spread = 0.01,
        armorBypass = false,
        effects = {
            envDamage = 5.0,    -- 5x damage to objects/doors
        },
    },

    -- =========================================================================
    -- .50 BMG SPECIALTY LOADS
    -- Anti-materiel rifle ammunition
    -- =========================================================================

    -- Ball: M33 Standard
    -- 647gr @ 2,910 fps = 13,200 ft-lbs
    ['ball'] = {
        damageMult = 1.00,      -- Baseline for .50 BMG
        armorMult = 1.50,       -- +50% vs armor (sheer energy)
        penetration = 0.95,     -- Extreme
        armorBypass = true,     -- Defeats all soft armor
        effects = {},
    },

    -- API: Armor Piercing Incendiary (M8)
    -- Tungsten core + incendiary charge
    ['api'] = {
        damageMult = 0.95,      -- -5% (more penetration, less expansion)
        armorMult = 2.00,       -- +100% vs armor
        penetration = 1.00,     -- Maximum
        armorBypass = true,
        effects = {
            fire = true,
            vehicleFire = true,     -- Ignites vehicles on impact
            fireDuration = 5000,
        },
    },

    -- BOOM: Explosive Multipurpose (Raufoss Mk 211)
    -- Tungsten penetrator + explosive + incendiary
    ['boom'] = {
        damageMult = 1.10,      -- +10% (explosive contribution)
        armorMult = 1.50,       -- +50% vs armor
        penetration = 0.98,
        armorBypass = true,
        effects = {
            explosive = true,
            explosionRadius = 1.5,      -- 1.5m radius
            explosionDamage = 50,       -- Additional explosion damage
            vehicleExplosion = true,    -- Triggers vehicle explosion
        },
    },

    -- =========================================================================
    -- TRANQUILIZER
    -- =========================================================================

    -- Tranq: Sedative Dart
    -- Progressive incapacitation over 30 seconds
    ['tranq'] = {
        damageMult = 0.02,      -- 2% (negligible)
        armorMult = 0.00,       -- Blocked by armor
        penetration = 0.00,     -- No penetration
        armorBypass = false,
        effects = {
            incapacitate = true,
            incapDuration = 30000,  -- 30 seconds total
            phase1Duration = 5000,  -- Stumbling phase
            phase2Duration = 5000,  -- Falling phase
            phase3Duration = 20000, -- Unconscious phase
        },
    },
}

-- =============================================================================
-- CALIBER-SPECIFIC OVERRIDES
-- Some calibers have unique characteristics that override universal types
-- =============================================================================

Config.CaliberOverrides = {
    -- .22 LR: Low power, unreliable HP expansion
    ['.22lr'] = {
        ['jhp'] = {
            damageMult = 1.12,      -- Reduced bonus (small bullet)
            penetration = 0.35,     -- Less reliable expansion
        },
    },

    -- 5.7x28mm: High velocity, good AP, weak HP
    ['5.7x28'] = {
        ['jhp'] = {
            damageMult = 1.18,      -- Reduced (small diameter)
            penetration = 0.55,
        },
        ['ap'] = {
            damageMult = 0.92,
            penetration = 0.96,     -- SS190 defeats Level IIIA
            armorBypass = true,
        },
    },

    -- .357 Magnum: Powerful JHP, barrel-dependent
    ['.357mag'] = {
        ['jhp'] = {
            damageMult = 1.22,      -- Excellent expansion at velocity
            penetration = 0.52,
        },
    },

    -- .44 Magnum: Massive JHP expansion
    ['.44mag'] = {
        ['jhp'] = {
            damageMult = 1.25,      -- Large diameter = bigger mushroom
            penetration = 0.68,
        },
    },

    -- .500 S&W: Maximum handgun expansion
    ['.500sw'] = {
        ['jhp'] = {
            damageMult = 1.28,      -- Devastating expansion
            penetration = 0.72,
        },
    },

    -- 6.8x51mm: Designed to defeat Level IV
    ['6.8x51'] = {
        ['fmj'] = {
            armorBypass = true,     -- Even FMJ defeats body armor
            penetration = 0.85,
        },
        ['ap'] = {
            damageMult = 0.95,
            penetration = 0.98,
            armorBypass = true,
        },
    },

    -- 7.62x51mm NATO: Battle rifle cartridge
    ['7.62x51'] = {
        ['ap'] = {
            damageMult = 0.95,
            penetration = 0.95,     -- M993 defeats Level III+
            armorBypass = true,
        },
    },

    -- .50 BMG: All variants bypass soft armor
    ['.50bmg'] = {
        -- All .50 BMG inherits armorBypass = true
    },
}

-- =============================================================================
-- DEFAULT AMMO TYPE PER CALIBER
-- Used when no ammo type is specified
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

--- Get the modifier table for an ammo type, with caliber overrides applied
-- @param ammoType string The ammo type (e.g., 'fmj', 'jhp', 'ap')
-- @param caliber string|nil Optional caliber for overrides
-- @return table The modifier table
function GetAmmoModifier(ammoType, caliber)
    local base = Config.AmmoModifiers[ammoType]
    if not base then
        -- Fallback to FMJ if unknown type
        base = Config.AmmoModifiers['fmj']
    end

    -- Check for caliber-specific override
    if caliber and Config.CaliberOverrides[caliber] and Config.CaliberOverrides[caliber][ammoType] then
        local override = Config.CaliberOverrides[caliber][ammoType]
        -- Merge override into base (override values take precedence)
        local result = {}
        for k, v in pairs(base) do result[k] = v end
        for k, v in pairs(override) do result[k] = v end
        return result
    end

    return base
end

--- Get the default ammo type for a caliber
-- @param caliber string The caliber
-- @return string The default ammo type
function GetDefaultAmmoType(caliber)
    return Config.DefaultAmmoModifier[caliber] or 'fmj'
end

-- =============================================================================
-- EXPORTS (for other resources)
-- =============================================================================

exports('GetAmmoModifier', GetAmmoModifier)
exports('GetDefaultAmmoType', GetDefaultAmmoType)
