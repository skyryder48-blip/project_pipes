--[[
    Ammunition Damage Modifiers - COMPLETE DIFFERENTIATION
    =======================================================

    FMJ = BASELINE (1.0) - Weapon meta defines actual damage per caliber
    HP/JHP = ENHANCED - Represents +P performance (expansion + energy)
    AP = ARMOR FOCUS - Penetration over raw damage

    Based on real-world ballistic research:
    - FBI Ammunition Protocol (12-18" penetration standard)
    - Terminal ballistics (permanent/temporary cavity)
    - Armor interaction (NIJ levels)

    See BALLISTICS_RESEARCH.md for complete methodology.
]]

Config = Config or {}

-- =============================================================================
-- COMPLETE AMMO MODIFIERS BY CALIBER
-- FMJ = 1.0 baseline, HP/JHP = enhanced damage variant
-- =============================================================================

Config.AmmoModifiers = {

    -- =========================================================================
    -- 9mm PARABELLUM (Reference Caliber)
    -- Energy: 350 ft-lbs | Velocity: 1,150 fps
    -- =========================================================================
    ['9mm_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.00,
        penetration = 0.75,
        armorBypass = false,
        effects = {},
    },
    ['9mm_hp'] = {
        damageMult = 1.18,      -- +P JHP performance
        armorMult = 0.50,       -- Expansion defeats armor penetration
        penetration = 0.48,
        armorBypass = false,
        effects = {},
    },
    ['9mm_ap'] = {
        damageMult = 0.92,      -- Penetration focus, less tissue damage
        armorMult = 1.75,
        penetration = 0.88,
        armorBypass = true,
        effects = {
            tracer = true,
            tracerFrequency = 5,      -- Every 5th round (realistic)
        },
    },

    -- =========================================================================
    -- .45 ACP
    -- Energy: 356 ft-lbs | Velocity: 830 fps (subsonic)
    -- Big slow bullet, excellent expansion
    -- =========================================================================
    ['45acp_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 0.95,       -- Slow velocity = worse vs armor
        penetration = 0.70,
        armorBypass = false,
        effects = {},
    },
    ['45acp_jhp'] = {
        damageMult = 1.22,      -- +P JHP - .45 mushrooms huge
        armorMult = 0.42,       -- Terrible vs armor
        penetration = 0.52,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .40 S&W
    -- Energy: 420 ft-lbs | Velocity: 990 fps
    -- Compromise between 9mm and .45
    -- =========================================================================
    ['40sw_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.02,
        penetration = 0.72,
        armorBypass = false,
        effects = {},
    },
    ['40sw_jhp'] = {
        damageMult = 1.20,      -- +P JHP performance
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
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.08,       -- High velocity helps
        penetration = 0.85,
        armorBypass = false,
        effects = {},
    },
    ['357mag_jhp'] = {
        damageMult = 1.28,      -- +P JHP - devastating at velocity
        armorMult = 0.52,
        penetration = 0.55,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .38 SPECIAL
    -- Energy: 165-250 ft-lbs | Velocity: 755-945 fps
    -- Weaker caliber - weapon meta accounts for this
    -- =========================================================================
    ['38spl_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 0.85,
        penetration = 0.65,
        armorBypass = false,
        effects = {},
    },
    ['38spl_jhp'] = {
        damageMult = 1.15,      -- +P JHP - modest improvement
        armorMult = 0.40,
        penetration = 0.50,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .44 MAGNUM
    -- Energy: 971-1,200 ft-lbs | Velocity: 1,350-1,500 fps
    -- "Dirty Harry" - massive power
    -- =========================================================================
    ['44mag_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.12,       -- Sheer power helps
        penetration = 0.88,
        armorBypass = false,
        effects = {},
    },
    ['44mag_jhp'] = {
        damageMult = 1.25,      -- +P JHP - devastating expansion
        armorMult = 0.58,
        penetration = 0.68,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- .500 S&W MAGNUM
    -- Energy: 2,418-3,032 ft-lbs | Velocity: 1,650-1,800 fps
    -- MOST POWERFUL PRODUCTION HANDGUN
    -- =========================================================================
    ['500sw_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.25,       -- Sheer energy defeats soft armor
        penetration = 0.92,
        armorBypass = false,
        effects = {},
    },
    ['500sw_jhp'] = {
        damageMult = 1.22,      -- +P JHP - catastrophic wound channel
        armorMult = 0.65,
        penetration = 0.75,
        armorBypass = false,
        effects = {},
    },
    ['500sw_bear'] = {
        damageMult = 1.35,      -- Hard cast deep penetrator
        armorMult = 1.42,       -- Hard cast defeats barriers
        penetration = 0.98,     -- Maximum penetration
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- 5.7x28mm
    -- Energy: 250-340 ft-lbs | Velocity: 1,700-2,100 fps
    -- PDW cartridge - armor-defeating design
    -- =========================================================================
    ['57x28_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.05,       -- Velocity helps
        penetration = 0.70,
        armorBypass = false,
        effects = {},
    },
    ['57x28_jhp'] = {
        damageMult = 1.12,      -- +P JHP - small diameter limits expansion
        armorMult = 0.45,
        penetration = 0.55,
        armorBypass = false,
        effects = {},
    },
    ['57x28_ap'] = {
        damageMult = 0.88,      -- SS190 - armor focus
        armorMult = 2.20,       -- Defeats Level IIIA
        penetration = 0.96,
        armorBypass = true,
        effects = {
            tracer = true,
            tracerFrequency = 5,      -- Every 5th round (realistic)
        },
    },

    -- =========================================================================
    -- 10mm AUTO
    -- FBI spec vs Full power variants
    -- =========================================================================
    ['10mm_fmj'] = {
        damageMult = 1.00,      -- BASELINE (FBI spec)
        armorMult = 1.00,
        penetration = 0.72,
        armorBypass = false,
        effects = {},
    },
    ['10mm_jhp'] = {
        damageMult = 1.32,      -- Full power JHP = .357 Mag performance
        armorMult = 0.55,
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
    -- Weakest handgun - weapon meta accounts for this
    -- =========================================================================
    ['22lr_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 0.65,
        penetration = 0.50,
        armorBypass = false,
        effects = {},
    },
    ['22lr_jhp'] = {
        damageMult = 1.15,      -- +P JHP - unreliable expansion
        armorMult = 0.35,
        penetration = 0.35,
        armorBypass = false,
        effects = {},
    },

    -- =========================================================================
    -- 12 GAUGE SHOTGUN
    -- Pellet-based system
    -- =========================================================================
    ['12ga_00buck'] = {
        damageMult = 1.00,      -- BASELINE - 8 pellets × base
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
            fireDuration = 6000,      -- 6 seconds burn
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
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.15,       -- High velocity
        penetration = 0.72,
        armorBypass = false,
        effects = {},
    },
    ['556_hp'] = {
        damageMult = 1.18,      -- +P HP - soft point expansion
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
        effects = {
            tracer = true,
            tracerFrequency = 5,      -- Every 5th round (realistic)
        },
    },

    -- =========================================================================
    -- 6.8x51mm (NGSW)
    -- Energy: 2,680 ft-lbs | Velocity: 3,000 fps
    -- Next-gen military - designed to defeat Level IV
    -- =========================================================================
    ['68x51_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.45,       -- Designed for armor defeat
        penetration = 0.88,
        armorBypass = true,     -- Even FMJ defeats body armor
        effects = {},
    },
    ['68x51_ap'] = {
        damageMult = 0.95,      -- Penetration focus
        armorMult = 2.10,       -- Maximum armor defeat
        penetration = 0.98,
        armorBypass = true,
        effects = {
            tracer = true,
            tracerFrequency = 5,      -- Every 5th round (realistic)
        },
    },

    -- =========================================================================
    -- .300 BLACKOUT
    -- Supersonic: 1,349 ft-lbs | Subsonic: 498 ft-lbs
    -- Suppressor-optimized cartridge
    -- =========================================================================
    ['300blk_supersonic'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.08,
        penetration = 0.72,
        armorBypass = false,
        effects = {},
    },
    ['300blk_subsonic'] = {
        damageMult = 0.82,      -- Much less energy
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
    -- Soviet AK cartridge
    -- =========================================================================
    ['762x39_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.05,
        penetration = 0.74,
        armorBypass = false,
        effects = {},
    },
    ['762x39_hp'] = {
        damageMult = 1.18,      -- +P HP - good expansion
        armorMult = 0.68,
        penetration = 0.56,
        armorBypass = false,
        effects = {},
    },
    ['762x39_ap'] = {
        damageMult = 0.90,      -- 7N23 BP penetrator
        armorMult = 1.85,
        penetration = 0.92,
        armorBypass = true,
        effects = {
            tracer = true,
            tracerFrequency = 5,      -- Every 5th round (realistic)
        },
    },

    -- =========================================================================
    -- 7.62x51mm NATO / .308 Winchester
    -- Energy: 2,559 ft-lbs | Velocity: 2,800 fps
    -- Full-power battle rifle cartridge
    -- =========================================================================
    ['762x51_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.22,
        penetration = 0.78,
        armorBypass = false,
        effects = {},
    },
    ['762x51_match'] = {
        damageMult = 1.08,      -- Premium precision load
        armorMult = 1.18,
        penetration = 0.76,
        armorBypass = false,
        effects = {
            accuracy = 0.88,
        },
    },
    ['762x51_ap'] = {
        damageMult = 0.92,      -- M993 tungsten
        armorMult = 2.05,       -- Defeats Level III+
        penetration = 0.95,
        armorBypass = true,
        effects = {
            tracer = true,
            tracerFrequency = 5,      -- Every 5th round (realistic)
        },
    },

    -- =========================================================================
    -- .300 WINCHESTER MAGNUM
    -- Energy: 3,501 ft-lbs | Velocity: 2,960 fps
    -- Long-range precision/hunting magnum
    -- =========================================================================
    ['300wm_fmj'] = {
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.32,
        penetration = 0.82,
        armorBypass = false,
        effects = {},
    },
    ['300wm_match'] = {
        damageMult = 1.08,      -- Competition precision
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
        damageMult = 1.00,      -- BASELINE
        armorMult = 1.65,
        penetration = 0.95,
        armorBypass = true,     -- Defeats ALL body armor
        effects = {},
    },
    ['50bmg_api'] = {
        damageMult = 0.95,      -- Armor Piercing Incendiary
        armorMult = 2.25,
        penetration = 1.00,
        armorBypass = true,
        effects = {
            fire = true,
            vehicleFire = true,
            fireDuration = 6000,      -- 6 seconds burn
            tracer = true,            -- API rounds have tracer element
            tracerFrequency = 5,      -- Every 5th round
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
        ['fmj'] = '10mm_fmj',
        ['jhp'] = '10mm_jhp',
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
        ['hp'] = '556_hp',
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
        ['hp'] = '762x39_hp',
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
    ['10mm'] = 'fmj',
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
-- VISUAL & AUDIO EFFECT CONFIGURATION
-- Phase 2: Muzzle Flash, Sound, Fire, Tracers
-- =============================================================================

Config.VisualEffects = {
    -- Tracer configuration (AP rounds only, realistic frequency)
    tracer = {
        -- Clear/wind tracer attempt using subtle distortion particle
        -- Falls back to faint white if unavailable
        particleFx = 'proj_tracer',           -- Base tracer particle
        particleAsset = 'core',               -- Particle asset dictionary
        color = { r = 240, g = 240, b = 245 }, -- Near-white/clear appearance
        scale = 0.6,                          -- Smaller = more subtle
        alpha = 0.4,                          -- Semi-transparent for "wind" effect
        duration = 150,                       -- Short trail duration (ms)
    },

    -- Muzzle flash variations by caliber class
    muzzleFlash = {
        -- Subsonic: Minimal flash (suppressor-ready)
        subsonic = {
            scale = 0.25,                     -- 25% of normal flash
            duration = 0.6,                   -- Shorter duration
            brightness = 0.3,                 -- Dim
        },
        -- Standard pistol calibers
        pistol = {
            scale = 1.0,
            duration = 1.0,
            brightness = 1.0,
        },
        -- Magnum handguns (.357, .44, .500 S&W)
        magnum = {
            scale = 1.8,                      -- Much larger fireball
            duration = 1.4,                   -- Longer visible
            brightness = 1.5,                 -- Brighter
        },
        -- Standard rifle calibers
        rifle = {
            scale = 1.2,
            duration = 1.0,
            brightness = 1.1,
        },
        -- Sniper/precision rifles (.308, .300 WM, .50 BMG)
        sniper = {
            scale = 2.2,                      -- Large concussive flash
            duration = 1.6,
            brightness = 1.8,
        },
        -- Incendiary rounds
        incendiary = {
            scale = 1.5,
            duration = 1.8,
            brightness = 1.6,
            color = { r = 255, g = 180, b = 50 }, -- Orange tint
        },
        -- Shotgun
        shotgun = {
            scale = 1.6,
            duration = 1.2,
            brightness = 1.3,
        },
        -- Dragon's breath
        dragonsbreath = {
            scale = 2.5,                      -- Massive fireball
            duration = 2.5,
            brightness = 2.0,
            color = { r = 255, g = 100, b = 30 }, -- Deep orange/red
        },
    },

    -- Fire effect configuration
    fire = {
        particleAsset = 'core',
        particleFx = 'fire_object_md',        -- Medium fire particle
        damageInterval = 500,                 -- Damage tick every 500ms
        defaultDuration = 6000,               -- 6 seconds burn (user specified)
        defaultDamage = 5,                    -- Damage per tick
    },
}

-- =============================================================================
-- AUDIO EFFECT CONFIGURATION
-- Sound modifications by caliber/ammo type
-- =============================================================================

Config.AudioEffects = {
    -- Sound volume multipliers (1.0 = default)
    volumeMultiplier = {
        -- Subsonic: 70% reduction (user specified)
        subsonic = 0.30,                      -- 30% of normal volume

        -- Standard calibers (baseline)
        pistol_standard = 1.0,
        rifle_standard = 1.0,

        -- Enhanced volume for powerful calibers
        magnum_357 = 1.35,                    -- .357 Mag - sharp crack
        magnum_44 = 1.50,                     -- .44 Mag - thunderous
        magnum_500 = 1.75,                    -- .500 S&W - deafening
        sniper_308 = 1.40,                    -- .308/7.62x51 - heavy report
        sniper_300wm = 1.55,                  -- .300 Win Mag - concussive
        sniper_50bmg = 2.00,                  -- .50 BMG - ear-splitting boom
    },

    -- Caliber to sound profile mapping
    caliberSoundProfile = {
        -- Subsonic rounds
        ['.300blk_subsonic'] = 'subsonic',

        -- Magnum pistols
        ['.357mag'] = 'magnum_357',
        ['.44mag'] = 'magnum_44',
        ['.500sw'] = 'magnum_500',

        -- Sniper/precision rifles
        ['7.62x51'] = 'sniper_308',
        ['.300wm'] = 'sniper_300wm',
        ['.50bmg'] = 'sniper_50bmg',

        -- Standard (explicit for completeness)
        ['9mm'] = 'pistol_standard',
        ['.45acp'] = 'pistol_standard',
        ['.40sw'] = 'pistol_standard',
        ['5.56'] = 'rifle_standard',
        ['7.62x39'] = 'rifle_standard',
    },
}

-- =============================================================================
-- CALIBER CLASS MAPPING
-- Maps calibers to muzzle flash profiles
-- =============================================================================

Config.CaliberClass = {
    -- Subsonic
    ['300blk_subsonic'] = 'subsonic',

    -- Magnum pistols
    ['.357mag'] = 'magnum',
    ['.44mag'] = 'magnum',
    ['.500sw'] = 'magnum',

    -- Sniper/precision
    ['7.62x51'] = 'sniper',
    ['.300wm'] = 'sniper',
    ['.50bmg'] = 'sniper',

    -- Shotgun
    ['12ga'] = 'shotgun',

    -- Standard pistols
    ['9mm'] = 'pistol',
    ['.45acp'] = 'pistol',
    ['.40sw'] = 'pistol',
    ['.38spl'] = 'pistol',
    ['5.7x28'] = 'pistol',
    ['10mm'] = 'pistol',
    ['.22lr'] = 'pistol',

    -- Standard rifles
    ['5.56'] = 'rifle',
    ['6.8x51'] = 'rifle',
    ['.300blk'] = 'rifle',
    ['7.62x39'] = 'rifle',
}

-- =============================================================================
-- BULLET PENETRATION SYSTEM
-- Material penetration and overpenetration (pass-through) mechanics
-- =============================================================================

Config.Penetration = {
    -- Enable/disable penetration system
    enabled = true,

    -- ==========================================================================
    -- MATERIAL PENETRATION THRESHOLDS
    -- Minimum penetration value required to pass through material
    -- ==========================================================================
    materials = {
        -- Soft materials (easy to penetrate)
        ['glass'] = 0.20,           -- Car windows, building glass
        ['plastic'] = 0.25,         -- Thin plastic panels
        ['cloth'] = 0.15,           -- Fabric, curtains
        ['cardboard'] = 0.10,       -- Boxes, paper products

        -- Medium materials
        ['wood_thin'] = 0.45,       -- Interior doors, plywood
        ['wood_thick'] = 0.65,      -- Exterior doors, furniture
        ['drywall'] = 0.40,         -- Interior walls
        ['sheet_metal'] = 0.55,     -- Car body panels, ductwork
        ['aluminum'] = 0.60,        -- Light metal panels

        -- Hard materials (difficult to penetrate)
        ['car_door'] = 0.70,        -- Vehicle doors (sheet metal + frame)
        ['car_body'] = 0.75,        -- Vehicle body panels
        ['steel_thin'] = 0.80,      -- Thin steel plate
        ['steel_thick'] = 0.92,     -- Thick steel, shipping containers
        ['concrete_thin'] = 0.85,   -- Thin concrete, cinder blocks
        ['concrete_thick'] = 0.98,  -- Thick concrete walls
        ['brick'] = 0.88,           -- Brick walls

        -- Impenetrable (requires explosives)
        ['reinforced'] = 1.10,      -- Reinforced concrete, vault doors
        ['armor_plate'] = 1.20,     -- Military armor plating
    },

    -- ==========================================================================
    -- OVERPENETRATION (PASS-THROUGH TARGETS)
    -- Based on penetration value, determines if bullet exits target
    -- ==========================================================================
    overpenetration = {
        -- Penetration thresholds for target pass-through
        thresholds = {
            -- { minPen, maxPen, chance, damageRetained, maxTargets }
            { 0.00, 0.50, 0.00, 0.00, 1 },   -- No overpenetration (HP, weak rounds)
            { 0.51, 0.65, 0.15, 0.30, 1 },   -- 15% chance, 30% damage (pistol FMJ)
            { 0.66, 0.75, 0.35, 0.45, 2 },   -- 35% chance, 45% damage (magnum, rifle)
            { 0.76, 0.85, 0.55, 0.55, 2 },   -- 55% chance, 55% damage (strong rifle)
            { 0.86, 0.92, 0.75, 0.65, 3 },   -- 75% chance, 65% damage (AP rounds)
            { 0.93, 0.98, 0.90, 0.75, 3 },   -- 90% chance, 75% damage (bear, .50 cal)
            { 0.99, 1.00, 1.00, 0.85, 4 },   -- 100% chance, 85% damage (.50 BMG AP)
        },

        -- Maximum range to check for secondary targets (meters)
        maxRange = 50.0,

        -- Angle cone for secondary target detection (degrees)
        coneAngle = 5.0,
    },

    -- ==========================================================================
    -- MATERIAL DAMAGE RETENTION
    -- How much damage is retained after penetrating material
    -- ==========================================================================
    damageRetention = {
        ['glass'] = 0.95,           -- Almost full damage
        ['plastic'] = 0.92,
        ['cloth'] = 0.98,
        ['cardboard'] = 0.98,
        ['wood_thin'] = 0.75,
        ['wood_thick'] = 0.55,
        ['drywall'] = 0.80,
        ['sheet_metal'] = 0.60,
        ['aluminum'] = 0.65,
        ['car_door'] = 0.50,
        ['car_body'] = 0.55,
        ['steel_thin'] = 0.40,
        ['steel_thick'] = 0.25,
        ['concrete_thin'] = 0.35,
        ['concrete_thick'] = 0.15,
        ['brick'] = 0.30,
    },

    -- ==========================================================================
    -- GTA MATERIAL MAPPING
    -- Maps GTA material hashes to our penetration categories
    -- ==========================================================================
    gtaMaterialMap = {
        -- Glass
        [1482427218] = 'glass',         --فLASS
        [2147483647] = 'glass',         -- DEFAULT (fallback for some glass)
        [-1461680979] = 'glass',        -- CAR_GLASS

        -- Metal/Vehicle
        [-1913017724] = 'car_body',     -- CAR_METAL
        [-893254096] = 'car_door',      -- VEHICLE_DOOR
        [488148577] = 'sheet_metal',    -- METAL
        [-1833215086] = 'aluminum',     -- METAL_HOLLOW

        -- Wood
        [-1055417819] = 'wood_thin',    -- WOOD_LIGHT
        [1141996760] = 'wood_thick',    -- WOOD_HEAVY
        [-901136114] = 'wood_thin',     -- WOOD_HOLLOW

        -- Concrete/Stone
        [-1595148316] = 'concrete_thin', -- CONCRETE
        [1109728704] = 'concrete_thick', -- CONCRETE_DUSTY
        [581794674] = 'brick',          -- BRICK
        [-1942898710] = 'concrete_thick', -- STONE

        -- Cloth/Soft
        [1019530692] = 'cloth',         -- CLOTH
        [-1820030605] = 'cloth',        -- CARPET
        [2137197282] = 'plastic',       -- PLASTIC

        -- Drywall/Interior
        [-1903687135] = 'drywall',      -- PLASTER
    },
}

-- ==========================================================================
-- CALIBER POWER CLASSIFICATION
-- Used for overpenetration calculations - higher = more penetration potential
-- ==========================================================================
Config.CaliberPower = {
    -- Weak calibers (no/minimal overpenetration)
    ['.22lr'] = 0.25,
    ['.38spl'] = 0.45,

    -- Standard pistol calibers
    ['9mm'] = 0.55,
    ['.40sw'] = 0.60,
    ['.45acp'] = 0.58,
    ['5.7x28'] = 0.52,
    ['10mm'] = 0.65,

    -- Magnum pistols
    ['.357mag'] = 0.72,
    ['.44mag'] = 0.78,
    ['.500sw'] = 0.88,

    -- Intermediate rifle
    ['5.56'] = 0.70,
    ['7.62x39'] = 0.75,
    ['.300blk'] = 0.68,
    ['6.8x51'] = 0.82,

    -- Full power rifle
    ['7.62x51'] = 0.85,
    ['.300wm'] = 0.90,

    -- Anti-materiel
    ['.50bmg'] = 1.00,

    -- Shotgun (varies by load)
    ['12ga'] = 0.50,  -- Base, modified by specific load
}

-- ==========================================================================
-- HELPER FUNCTIONS
-- ==========================================================================

--- Get overpenetration stats for a penetration value
-- @param penValue number The penetration value (0.0-1.0)
-- @return table { chance, damageRetained, maxTargets }
function GetOverpenetrationStats(penValue)
    for _, threshold in ipairs(Config.Penetration.overpenetration.thresholds) do
        if penValue >= threshold[1] and penValue <= threshold[2] then
            return {
                chance = threshold[3],
                damageRetained = threshold[4],
                maxTargets = threshold[5],
            }
        end
    end
    -- Default: no overpenetration
    return { chance = 0, damageRetained = 0, maxTargets = 1 }
end

--- Check if a round can penetrate a material
-- @param penValue number The penetration value
-- @param material string The material type
-- @return boolean, number Whether it penetrates and damage retention
function CanPenetrateMaterial(penValue, material)
    local threshold = Config.Penetration.materials[material]
    if not threshold then
        return false, 0
    end

    if penValue >= threshold then
        local retention = Config.Penetration.damageRetention[material] or 0.5
        return true, retention
    end

    return false, 0
end

--- Get material type from GTA material hash
-- @param materialHash number The GTA material hash
-- @return string The material category
function GetMaterialFromHash(materialHash)
    return Config.Penetration.gtaMaterialMap[materialHash] or 'concrete_thick'
end

--- Calculate effective penetration (caliber power + ammo modifier)
-- @param caliber string The caliber
-- @param ammoModifier table The ammo modifier table
-- @return number Effective penetration value
function GetEffectivePenetration(caliber, ammoModifier)
    local caliberPower = Config.CaliberPower[caliber] or 0.5
    local ammoPen = ammoModifier.penetration or 0.7

    -- Combine caliber power and ammo penetration
    -- Weighted: 40% caliber, 60% ammo type
    return (caliberPower * 0.4) + (ammoPen * 0.6)
end

-- =============================================================================
-- RANGE FALLOFF SYSTEM
-- Damage decreases over distance based on caliber ballistics
-- =============================================================================

Config.RangeFalloff = {
    enabled = true,

    -- Caliber effective ranges (meters)
    -- effectiveRange: Full damage up to this distance
    -- maxRange: Zero damage beyond this distance
    -- falloffCurve: How quickly damage drops (1.0 = linear, 2.0 = steep, 0.5 = gradual)
    calibers = {
        -- Weak pistol calibers - short range
        ['.22lr'] = {
            effectiveRange = 25,
            maxRange = 75,
            falloffCurve = 1.5,
            minDamagePercent = 0.20,   -- Minimum 20% damage at max range
        },
        ['.38spl'] = {
            effectiveRange = 35,
            maxRange = 100,
            falloffCurve = 1.3,
            minDamagePercent = 0.25,
        },

        -- Standard pistol calibers
        ['9mm'] = {
            effectiveRange = 50,
            maxRange = 150,
            falloffCurve = 1.2,
            minDamagePercent = 0.30,
        },
        ['.40sw'] = {
            effectiveRange = 50,
            maxRange = 150,
            falloffCurve = 1.2,
            minDamagePercent = 0.30,
        },
        ['.45acp'] = {
            effectiveRange = 45,
            maxRange = 125,
            falloffCurve = 1.3,
            minDamagePercent = 0.28,
        },
        ['5.7x28'] = {
            effectiveRange = 75,
            maxRange = 200,
            falloffCurve = 1.0,
            minDamagePercent = 0.35,
        },
        ['10mm'] = {
            effectiveRange = 60,
            maxRange = 175,
            falloffCurve = 1.1,
            minDamagePercent = 0.32,
        },

        -- Magnum pistols - extended range
        ['.357mag'] = {
            effectiveRange = 75,
            maxRange = 200,
            falloffCurve = 1.0,
            minDamagePercent = 0.35,
        },
        ['.44mag'] = {
            effectiveRange = 100,
            maxRange = 250,
            falloffCurve = 0.9,
            minDamagePercent = 0.38,
        },
        ['.500sw'] = {
            effectiveRange = 125,
            maxRange = 300,
            falloffCurve = 0.8,
            minDamagePercent = 0.40,
        },

        -- Intermediate rifle calibers
        ['5.56'] = {
            effectiveRange = 300,
            maxRange = 600,
            falloffCurve = 0.8,
            minDamagePercent = 0.40,
        },
        ['7.62x39'] = {
            effectiveRange = 250,
            maxRange = 500,
            falloffCurve = 0.9,
            minDamagePercent = 0.38,
        },
        ['.300blk'] = {
            effectiveRange = 200,
            maxRange = 400,
            falloffCurve = 1.0,
            minDamagePercent = 0.35,
        },
        ['6.8x51'] = {
            effectiveRange = 400,
            maxRange = 800,
            falloffCurve = 0.7,
            minDamagePercent = 0.45,
        },

        -- Full power rifle calibers
        ['7.62x51'] = {
            effectiveRange = 500,
            maxRange = 1000,
            falloffCurve = 0.6,
            minDamagePercent = 0.50,
        },
        ['.300wm'] = {
            effectiveRange = 800,
            maxRange = 1500,
            falloffCurve = 0.5,
            minDamagePercent = 0.55,
        },

        -- Anti-materiel
        ['.50bmg'] = {
            effectiveRange = 1200,
            maxRange = 2500,
            falloffCurve = 0.4,
            minDamagePercent = 0.60,
        },

        -- Shotgun (buckshot spreads, slug maintains)
        ['12ga'] = {
            effectiveRange = 30,       -- Buckshot effective
            maxRange = 75,
            falloffCurve = 2.0,        -- Steep falloff for pellets
            minDamagePercent = 0.15,
        },
    },

    -- Slug override for shotgun (better range than buckshot)
    slugOverride = {
        effectiveRange = 100,
        maxRange = 200,
        falloffCurve = 1.2,
        minDamagePercent = 0.35,
    },
}

-- =============================================================================
-- SUPPRESSOR SYNERGY SYSTEM
-- Combines suppressor attachment with ammo type for enhanced effects
-- =============================================================================

Config.SuppressorSynergy = {
    enabled = true,

    -- Base suppressor effects (without special ammo)
    baseSuppressor = {
        soundReduction = 0.40,        -- 40% quieter
        muzzleFlashReduction = 0.60,  -- 60% less flash
        damageModifier = 1.0,         -- No damage change
        rangeModifier = 0.95,         -- Slight range reduction
    },

    -- Subsonic + Suppressor (optimal combination)
    subsonicSuppressed = {
        soundReduction = 0.85,        -- 85% quieter (near silent)
        muzzleFlashReduction = 0.90,  -- Minimal flash
        damageModifier = 0.95,        -- Slight damage reduction
        rangeModifier = 0.85,         -- Reduced range
        eliminatesCrack = true,       -- No supersonic crack
    },

    -- Supersonic + Suppressor (still has crack)
    supersonicSuppressed = {
        soundReduction = 0.35,        -- Only 35% quieter (crack remains)
        muzzleFlashReduction = 0.60,
        damageModifier = 1.0,
        rangeModifier = 0.98,
        eliminatesCrack = false,
    },

    -- Suppressor-compatible calibers (velocity below ~1100 fps is subsonic)
    subsonicCapable = {
        ['.45acp'] = true,            -- Naturally subsonic
        ['.300blk'] = true,           -- Designed for suppression
        ['9mm'] = true,               -- With subsonic loads
        ['.22lr'] = true,             -- Standard velocity is subsonic
    },

    -- Calibers that cannot effectively use suppressors
    unsuppressible = {
        ['.357mag'] = true,           -- Too much pressure
        ['.500sw'] = true,            -- Way too loud regardless
        ['.50bmg'] = true,            -- Anti-materiel, no practical suppression
    },
}

-- =============================================================================
-- LIMB DAMAGE SYSTEM
-- Damage modifiers and effects based on hit location
-- For integration with medical scripts
-- =============================================================================

Config.LimbDamage = {
    enabled = true,

    -- GTA bone IDs mapped to body regions
    boneToRegion = {
        -- Head
        [31086] = 'head',       -- SKEL_Head
        [39317] = 'head',       -- SKEL_Neck_1

        -- Torso (center mass)
        [24818] = 'torso',      -- SKEL_Spine3
        [24817] = 'torso',      -- SKEL_Spine2
        [24816] = 'torso',      -- SKEL_Spine1
        [11816] = 'torso',      -- SKEL_Pelvis
        [57597] = 'torso',      -- SKEL_ROOT

        -- Arms
        [61163] = 'arm_left',   -- SKEL_L_UpperArm
        [45509] = 'arm_left',   -- SKEL_L_Forearm
        [18905] = 'arm_left',   -- SKEL_L_Hand
        [40269] = 'arm_right',  -- SKEL_R_UpperArm
        [28252] = 'arm_right',  -- SKEL_R_Forearm
        [57005] = 'arm_right',  -- SKEL_R_Hand

        -- Legs
        [58271] = 'leg_left',   -- SKEL_L_Thigh
        [63931] = 'leg_left',   -- SKEL_L_Calf
        [14201] = 'leg_left',   -- SKEL_L_Foot
        [51826] = 'leg_right',  -- SKEL_R_Thigh
        [36864] = 'leg_right',  -- SKEL_R_Calf
        [52301] = 'leg_right',  -- SKEL_R_Foot
    },

    -- Damage multipliers per region
    damageMultipliers = {
        ['head'] = 2.50,          -- Headshots are devastating
        ['torso'] = 1.00,         -- Baseline
        ['arm_left'] = 0.65,      -- Reduced damage
        ['arm_right'] = 0.65,
        ['leg_left'] = 0.70,
        ['leg_right'] = 0.70,
    },

    -- Effects triggered per region (for med script integration)
    -- These are event names that will be triggered with hit data
    regionEffects = {
        ['head'] = {
            event = 'medical:headTrauma',
            bleedRate = 'severe',       -- For med script
            canKnockout = true,
            knockoutChance = 0.35,      -- 35% chance to knock unconscious
            visionImpairment = true,
        },
        ['torso'] = {
            event = 'medical:torsoWound',
            bleedRate = 'moderate',
            organDamageChance = 0.20,   -- 20% chance of organ damage
            canCauseInternalBleeding = true,
        },
        ['arm_left'] = {
            event = 'medical:armWound',
            bleedRate = 'light',
            limbSide = 'left',
            aimPenalty = 0.30,          -- 30% worse aim
            canDropWeapon = true,
            dropChance = 0.15,
        },
        ['arm_right'] = {
            event = 'medical:armWound',
            bleedRate = 'light',
            limbSide = 'right',
            aimPenalty = 0.40,          -- Primary arm, worse penalty
            canDropWeapon = true,
            dropChance = 0.25,
        },
        ['leg_left'] = {
            event = 'medical:legWound',
            bleedRate = 'moderate',
            limbSide = 'left',
            movementPenalty = 0.35,     -- 35% slower
            canCauseLimp = true,
            canCauseFall = true,
            fallChance = 0.20,
        },
        ['leg_right'] = {
            event = 'medical:legWound',
            bleedRate = 'moderate',
            limbSide = 'right',
            movementPenalty = 0.35,
            canCauseLimp = true,
            canCauseFall = true,
            fallChance = 0.20,
        },
    },

    -- Ammo type modifiers to bleed rate
    ammoBleedModifiers = {
        ['fmj'] = 1.0,            -- Baseline
        ['hp'] = 1.50,            -- 50% more bleeding (expansion)
        ['jhp'] = 1.60,           -- 60% more bleeding
        ['ap'] = 0.70,            -- 30% less bleeding (clean holes)
        ['match'] = 1.0,
        ['subsonic'] = 0.90,
        ['bear'] = 1.20,          -- Hard cast, decent wound channel
    },

    -- Caliber base bleed multiplier (bigger = more bleeding)
    caliberBleedMultiplier = {
        ['.22lr'] = 0.50,
        ['.38spl'] = 0.70,
        ['9mm'] = 0.85,
        ['.40sw'] = 0.95,
        ['.45acp'] = 1.00,
        ['5.7x28'] = 0.75,
        ['10mm'] = 1.10,
        ['.357mag'] = 1.25,
        ['.44mag'] = 1.50,
        ['.500sw'] = 2.00,
        ['5.56'] = 1.20,
        ['7.62x39'] = 1.40,
        ['7.62x51'] = 1.60,
        ['.300wm'] = 1.80,
        ['.50bmg'] = 3.00,        -- Catastrophic
        ['12ga'] = 1.50,          -- Shotgun, varies by load
    },
}

-- =============================================================================
-- ARMOR DEGRADATION SYSTEM
-- Armor takes damage and becomes less effective
-- =============================================================================

Config.ArmorDegradation = {
    enabled = true,

    -- Degradation rates per ammo type (% integrity lost per hit)
    degradationRates = {
        ['fmj'] = 8,              -- 8% per hit
        ['hp'] = 15,              -- 15% - expansion tears material
        ['jhp'] = 18,             -- 18% - maximum shredding
        ['ap'] = 3,               -- 3% - clean penetrating holes
        ['match'] = 8,
        ['subsonic'] = 6,
        ['bear'] = 12,            -- Hard cast does damage
    },

    -- Caliber multiplier to degradation (bigger = more armor damage)
    caliberDegradation = {
        ['.22lr'] = 0.3,
        ['.38spl'] = 0.5,
        ['9mm'] = 0.8,
        ['.40sw'] = 0.9,
        ['.45acp'] = 1.0,
        ['5.7x28'] = 0.6,         -- Small, less material damage
        ['10mm'] = 1.1,
        ['.357mag'] = 1.3,
        ['.44mag'] = 1.6,
        ['.500sw'] = 2.2,
        ['5.56'] = 1.4,
        ['7.62x39'] = 1.6,
        ['7.62x51'] = 2.0,
        ['.300wm'] = 2.4,
        ['.50bmg'] = 5.0,         -- Destroys armor
        ['12ga'] = 1.8,
    },

    -- Armor effectiveness based on integrity
    integrityEffectiveness = {
        { min = 80, max = 100, effectiveness = 1.00 },  -- Full protection
        { min = 60, max = 79,  effectiveness = 0.85 },  -- 85% effective
        { min = 40, max = 59,  effectiveness = 0.65 },  -- 65% effective
        { min = 20, max = 39,  effectiveness = 0.40 },  -- Compromised
        { min = 0,  max = 19,  effectiveness = 0.15 },  -- Nearly destroyed
    },
}

-- =============================================================================
-- HELPER FUNCTIONS - RANGE FALLOFF
-- =============================================================================

--- Calculate damage multiplier based on distance
-- @param caliber string The weapon caliber
-- @param distance number Distance in meters
-- @param ammoType string The ammo type (for slug override)
-- @return number Damage multiplier (0.0 - 1.0)
function CalculateRangeFalloff(caliber, distance, ammoType)
    if not Config.RangeFalloff.enabled then
        return 1.0
    end

    local rangeData = Config.RangeFalloff.calibers[caliber]
    if not rangeData then
        return 1.0
    end

    -- Check for shotgun slug override
    if caliber == '12ga' and ammoType == 'slug' then
        rangeData = Config.RangeFalloff.slugOverride
    end

    -- Within effective range = full damage
    if distance <= rangeData.effectiveRange then
        return 1.0
    end

    -- Beyond max range = minimum damage
    if distance >= rangeData.maxRange then
        return rangeData.minDamagePercent
    end

    -- Calculate falloff
    local falloffDistance = distance - rangeData.effectiveRange
    local falloffRange = rangeData.maxRange - rangeData.effectiveRange
    local falloffPercent = falloffDistance / falloffRange

    -- Apply curve
    local curvedFalloff = math.pow(falloffPercent, rangeData.falloffCurve)

    -- Interpolate between full and minimum damage
    local damagePercent = 1.0 - (curvedFalloff * (1.0 - rangeData.minDamagePercent))

    return math.max(rangeData.minDamagePercent, damagePercent)
end

-- =============================================================================
-- HELPER FUNCTIONS - SUPPRESSOR
-- =============================================================================

--- Get suppressor synergy modifiers
-- @param caliber string The weapon caliber
-- @param ammoType string The ammo type
-- @param hasSuppressor boolean Whether weapon has suppressor
-- @return table Modifier values
function GetSuppressorModifiers(caliber, ammoType, hasSuppressor)
    if not Config.SuppressorSynergy.enabled or not hasSuppressor then
        return {
            soundReduction = 0,
            muzzleFlashReduction = 0,
            damageModifier = 1.0,
            rangeModifier = 1.0,
            eliminatesCrack = false,
        }
    end

    -- Check if caliber can be suppressed
    if Config.SuppressorSynergy.unsuppressible[caliber] then
        return {
            soundReduction = 0.10,        -- Minimal effect
            muzzleFlashReduction = 0.20,
            damageModifier = 1.0,
            rangeModifier = 1.0,
            eliminatesCrack = false,
        }
    end

    -- Check for subsonic ammo
    local isSubsonic = ammoType == 'subsonic' or
                       (caliber == '.45acp') or  -- Naturally subsonic
                       (caliber == '.300blk' and ammoType == 'subsonic')

    if isSubsonic and Config.SuppressorSynergy.subsonicCapable[caliber] then
        return Config.SuppressorSynergy.subsonicSuppressed
    else
        return Config.SuppressorSynergy.supersonicSuppressed
    end
end

-- =============================================================================
-- HELPER FUNCTIONS - LIMB DAMAGE
-- =============================================================================

--- Get body region from bone index
-- @param boneIndex number The GTA bone index
-- @return string Body region name
function GetBodyRegion(boneIndex)
    return Config.LimbDamage.boneToRegion[boneIndex] or 'torso'
end

--- Calculate limb damage modifier and effects
-- @param boneIndex number The hit bone
-- @param caliber string The weapon caliber
-- @param ammoType string The ammo type
-- @return number, table Damage multiplier and effect data
function CalculateLimbDamage(boneIndex, caliber, ammoType)
    if not Config.LimbDamage.enabled then
        return 1.0, nil
    end

    local region = GetBodyRegion(boneIndex)
    local damageMult = Config.LimbDamage.damageMultipliers[region] or 1.0
    local effectData = Config.LimbDamage.regionEffects[region]

    if not effectData then
        return damageMult, nil
    end

    -- Calculate bleed severity
    local ammoBleedMod = Config.LimbDamage.ammoBleedModifiers[ammoType] or 1.0
    local caliberBleedMod = Config.LimbDamage.caliberBleedMultiplier[caliber] or 1.0
    local totalBleedMod = ammoBleedMod * caliberBleedMod

    -- Build effect package for med script
    local effects = {
        region = region,
        event = effectData.event,
        bleedRate = effectData.bleedRate,
        bleedMultiplier = totalBleedMod,
        caliber = caliber,
        ammoType = ammoType,
    }

    -- Copy all effect properties
    for key, value in pairs(effectData) do
        if key ~= 'event' and key ~= 'bleedRate' then
            effects[key] = value
        end
    end

    return damageMult, effects
end

--- Get armor effectiveness based on integrity
-- @param integrity number Armor integrity (0-100)
-- @return number Effectiveness multiplier
function GetArmorEffectiveness(integrity)
    if not Config.ArmorDegradation.enabled then
        return 1.0
    end

    for _, tier in ipairs(Config.ArmorDegradation.integrityEffectiveness) do
        if integrity >= tier.min and integrity <= tier.max then
            return tier.effectiveness
        end
    end

    return 0.15  -- Nearly destroyed
end

--- Calculate armor degradation from a hit
-- @param caliber string The weapon caliber
-- @param ammoType string The ammo type
-- @return number Integrity points lost
function CalculateArmorDegradation(caliber, ammoType)
    if not Config.ArmorDegradation.enabled then
        return 0
    end

    local baseRate = Config.ArmorDegradation.degradationRates[ammoType] or 8
    local caliberMult = Config.ArmorDegradation.caliberDegradation[caliber] or 1.0

    return math.floor(baseRate * caliberMult)
end

-- =============================================================================
-- ENVIRONMENTAL INTERACTION SYSTEM
-- Bullet interactions with world objects and surfaces
-- =============================================================================

Config.EnvironmentalEffects = {
    enabled = true,

    -- ==========================================================================
    -- 1. FUEL/EXPLOSIVE INTERACTIONS
    -- ==========================================================================
    fuel = {
        enabled = true,

        -- Ammo types that can ignite fuel sources
        ignitionAmmo = {
            -- Incendiary/fire rounds
            ['12ga_dragonsbreath'] = { chance = 1.00, explosionScale = 1.0 },
            ['50bmg_api'] = { chance = 0.95, explosionScale = 1.5 },

            -- High-power rounds (added per request)
            ['50bmg_ball'] = { chance = 0.75, explosionScale = 1.3 },
            ['50bmg_boom'] = { chance = 1.00, explosionScale = 2.0 },
            ['12ga_slug'] = { chance = 0.60, explosionScale = 0.9 },

            -- AP rounds with sparks
            ['556_ap'] = { chance = 0.35, explosionScale = 0.8 },
            ['762x39_ap'] = { chance = 0.40, explosionScale = 0.9 },
            ['762x51_ap'] = { chance = 0.50, explosionScale = 1.0 },
            ['68x51_ap'] = { chance = 0.55, explosionScale = 1.1 },
        },

        -- Target objects
        targets = {
            gasPump = {
                models = {
                    'prop_gas_pump_1a', 'prop_gas_pump_1b', 'prop_gas_pump_1c',
                    'prop_gas_pump_1d', 'prop_gas_pump_old1', 'prop_gas_pump_old2',
                    'prop_gas_pump_old3', 'prop_vintage_pump',
                },
                explosionType = 'EXPLOSION_PETROL_PUMP',
                baseRadius = 8.0,
                baseDamage = 200,
                fireSpread = true,
                fireDuration = 15000,
            },
            propaneTank = {
                models = {
                    'prop_propane_tank01a', 'prop_propane_tank01b',
                    'prop_propane_tank02a', 'prop_propane_tank02b',
                    'ng_proc_tank_01', 'prop_gas_tank_01a',
                },
                explosionType = 'EXPLOSION_PROPANE',
                baseRadius = 6.0,
                baseDamage = 150,
                fireSpread = false,
            },
            gasCan = {
                models = {
                    'prop_jerrycan_01a', 'prop_ld_jerrycan_01',
                    'w_am_jerrycan', 'prop_barrel_exp_01a',
                },
                explosionType = 'EXPLOSION_MOLOTOV',
                baseRadius = 3.0,
                baseDamage = 50,
                fireSpread = true,
                fireDuration = 8000,
            },
            vehicleFuelTank = {
                -- Detected via entity type, not model
                explosionType = 'EXPLOSION_CAR',
                fireChance = 0.70,       -- Fire first, then explode
                fireToExplosionTime = 5000,
                baseRadius = 5.0,
            },
        },
    },

    -- ==========================================================================
    -- 2. ELECTRICAL INTERACTIONS
    -- ==========================================================================
    electrical = {
        enabled = true,

        -- Ammo types that affect electrical systems
        disruptionAmmo = {
            -- Sniper/high-power (added per request)
            ['762x51_fmj'] = { chance = 0.70, disableEngine = true },
            ['762x51_ap'] = { chance = 0.85, disableEngine = true },
            ['762x51_match'] = { chance = 0.70, disableEngine = true },
            ['300wm_fmj'] = { chance = 0.80, disableEngine = true },
            ['300wm_match'] = { chance = 0.80, disableEngine = true },
            ['50bmg_ball'] = { chance = 0.95, disableEngine = true },
            ['50bmg_api'] = { chance = 1.00, disableEngine = true },
            ['50bmg_boom'] = { chance = 1.00, disableEngine = true },

            -- Slugs (added per request)
            ['12ga_slug'] = { chance = 0.65, disableEngine = true },

            -- AP rounds
            ['556_ap'] = { chance = 0.50, disableEngine = false },
            ['762x39_ap'] = { chance = 0.55, disableEngine = false },
            ['9mm_ap'] = { chance = 0.30, disableEngine = false },
            ['57x28_ap'] = { chance = 0.40, disableEngine = false },

            -- Standard rifle FMJ
            ['556_fmj'] = { chance = 0.35, disableEngine = false },
            ['762x39_fmj'] = { chance = 0.40, disableEngine = false },
        },

        targets = {
            powerBox = {
                models = {
                    'prop_elecbox_01a', 'prop_elecbox_02a', 'prop_elecbox_02b',
                    'prop_elecbox_03a', 'prop_elecbox_04a', 'prop_elecbox_05a',
                    'prop_elecbox_06a', 'prop_elecbox_07a', 'prop_elecbox_08',
                    'prop_elecbox_09', 'prop_elecbox_10', 'prop_elecbox_11',
                    'prop_elecbox_12', 'prop_elecbox_13', 'prop_elecbox_14',
                    'prop_sub_trans_01a', 'prop_sub_trans_02a',
                },
                sparkDuration = 3000,
                blackoutRadius = 50.0,
                blackoutDuration = 30000,   -- 30 seconds
            },
            streetLight = {
                models = {
                    'prop_streetlight_01', 'prop_streetlight_01b',
                    'prop_streetlight_02', 'prop_streetlight_03a',
                    'prop_streetlight_03b', 'prop_streetlight_03c',
                    'prop_streetlight_03d', 'prop_streetlight_03e',
                    'prop_streetlight_04', 'prop_streetlight_05',
                    'prop_streetlight_06', 'prop_streetlight_07a',
                    'prop_streetlight_07b', 'prop_streetlight_08',
                    'prop_streetlight_09', 'prop_streetlight_10',
                    'prop_streetlight_11a', 'prop_streetlight_11b',
                    'prop_streetlight_11c', 'prop_streetlight_12a',
                    'prop_streetlight_12b', 'prop_streetlight_14a',
                    'prop_streetlight_15a', 'prop_streetlight_16a',
                },
                disableDuration = 0,        -- Permanent until respawn
            },
            neonSign = {
                models = {
                    'prop_neon_sign_01', 'prop_neon_sign_02',
                },
                sparkChance = 0.80,
                disableDuration = 0,
            },
            vehicleBattery = {
                -- Detected via hitting engine area of vehicle
                sparkChance = 0.60,
                disableElectronics = true,
                disableEnginePermanent = false,  -- Can restart after delay
                restartDelay = 15000,
            },
        },
    },

    -- ==========================================================================
    -- 3. GLASS/WINDOW INTERACTIONS
    -- ==========================================================================
    glass = {
        enabled = true,

        -- Shatter behavior by ammo type
        shatterBehavior = {
            -- HP/JHP = full shatter (expansion)
            ['hp'] = { fullShatter = true, holeSize = 0 },
            ['jhp'] = { fullShatter = true, holeSize = 0 },

            -- FMJ = penetration hole
            ['fmj'] = { fullShatter = false, holeSize = 0.05 },
            ['ball'] = { fullShatter = false, holeSize = 0.08 },

            -- AP = clean small hole
            ['ap'] = { fullShatter = false, holeSize = 0.03 },
            ['api'] = { fullShatter = false, holeSize = 0.04 },

            -- Shotgun
            ['00buck'] = { fullShatter = true, holeSize = 0 },
            ['slug'] = { fullShatter = true, holeSize = 0 },
            ['birdshot'] = { fullShatter = true, holeSize = 0 },
        },

        -- Bulletproof glass (banks, armored vehicles)
        bulletproofGlass = {
            hitsToBreak = {
                -- Pistol calibers
                ['9mm'] = 15,
                ['.45acp'] = 12,
                ['.40sw'] = 13,
                ['.357mag'] = 8,
                ['.44mag'] = 6,
                ['.500sw'] = 4,

                -- Rifle calibers
                ['5.56'] = 5,
                ['7.62x39'] = 4,
                ['7.62x51'] = 3,
                ['.300wm'] = 2,
                ['.50bmg'] = 1,   -- One shot

                -- AP modifier (halves hits required)
                apModifier = 0.5,
            },
        },
    },

    -- ==========================================================================
    -- 4. WATER/LIQUID INTERACTIONS
    -- ==========================================================================
    water = {
        enabled = true,

        -- Bullet velocity loss in water (per meter)
        velocityLossPerMeter = {
            -- Light/fast rounds lose velocity quickly
            ['5.56'] = 0.35,
            ['5.7x28'] = 0.40,
            ['9mm'] = 0.25,

            -- Heavy/slow rounds penetrate better
            ['.45acp'] = 0.20,
            ['.44mag'] = 0.18,
            ['.500sw'] = 0.15,
            ['7.62x51'] = 0.22,
            ['.50bmg'] = 0.12,

            -- Shotgun
            ['12ga'] = 0.45,    -- Pellets stop fast
        },

        -- Maximum underwater range (meters)
        maxUnderwaterRange = {
            ['9mm'] = 2.0,
            ['.45acp'] = 2.5,
            ['5.56'] = 1.5,
            ['7.62x51'] = 3.0,
            ['.50bmg'] = 5.0,
        },

        -- Fire hydrant interaction
        fireHydrant = {
            models = {
                'prop_fire_hydrant_1', 'prop_fire_hydrant_2',
                'prop_fire_hydrant_3', 'prop_fire_hydrant_4',
            },
            minCaliberPower = 0.65,     -- Magnum+ or rifle
            waterSprayDuration = 60000, -- 1 minute
            slipperyRadius = 5.0,
            slipperyDuration = 45000,
        },

        -- Water tower
        waterTower = {
            models = {
                'prop_watertower02', 'prop_watertower03a',
            },
            hitsToLeak = 5,
            hitsToCollapse = 15,
            leakParticle = 'water_cannon_jet',
        },
    },

    -- ==========================================================================
    -- 5. COVER DESTRUCTION (Extends penetration system)
    -- ==========================================================================
    coverDestruction = {
        enabled = true,

        -- Destructible cover objects
        destructibles = {
            woodenFurniture = {
                models = {
                    'prop_chair_01a', 'prop_chair_01b', 'prop_chair_02',
                    'prop_chair_03', 'prop_chair_04a', 'prop_chair_04b',
                    'prop_table_01', 'prop_table_02', 'prop_table_03',
                    'prop_table_04', 'prop_table_05', 'prop_table_06',
                    'v_ilev_fos_sofa', 'v_ilev_fos_sofa2',
                },
                hitsToDestroy = 8,
                materialType = 'wood_thin',
                debrisOnDestroy = true,
            },
            thinWalls = {
                -- Detected via material, not model
                materialHashes = { -1903687135 }, -- PLASTER/drywall
                penetrationThreshold = 0.40,
                leaveHoles = true,
                holeDecal = 'BulletHole_Plaster',
            },
            concreteBarrier = {
                models = {
                    'prop_barrier_work01a', 'prop_barrier_work02a',
                    'prop_mp_barrier_01', 'prop_mp_barrier_02',
                },
                hitsToChip = 3,
                hitsToBreak = 20,     -- Only .50 BMG realistically
                chipDecal = 'BulletHole_Concrete',
            },
        },
    },

    -- ==========================================================================
    -- 6. FIRE SPREAD
    -- ==========================================================================
    fireSpread = {
        enabled = true,

        -- Surfaces that can catch fire
        flammableSurfaces = {
            dryGrass = {
                materialHashes = { 1109728704, -461750719 }, -- GRASS_DRY
                spreadRate = 2.0,          -- Meters per second
                maxSpreadRadius = 15.0,
                burnDuration = 20000,
            },
            trash = {
                models = {
                    'prop_rub_binbag_01', 'prop_rub_binbag_03',
                    'prop_rub_binbag_04', 'prop_rub_binbag_05',
                    'prop_dumpster_01a', 'prop_dumpster_02a',
                },
                spreadRate = 0.5,
                maxSpreadRadius = 3.0,
                burnDuration = 30000,
            },
            oilSpill = {
                -- Created dynamically or from vehicle damage
                spreadRate = 5.0,
                maxSpreadRadius = 8.0,
                burnDuration = 15000,
                explosionChance = 0.20,
            },
        },

        -- Incendiary ammo types
        incendiaryAmmo = {
            ['12ga_dragonsbreath'] = { spreadChance = 0.90, intensity = 1.5 },
            ['50bmg_api'] = { spreadChance = 0.70, intensity = 1.2 },
        },
    },

    -- ==========================================================================
    -- 7. RICOCHET SYSTEM
    -- ==========================================================================
    ricochet = {
        enabled = true,

        -- Surface ricochet properties
        surfaces = {
            metal = {
                materialHashes = { 488148577, -1833215086, -1913017724 },
                ricochetChance = 0.45,
                maxAngle = 30,              -- Degrees from surface
                damageRetention = 0.35,
                sparkEffect = true,
            },
            concrete = {
                materialHashes = { -1595148316, 1109728704, -1942898710 },
                ricochetChance = 0.25,
                maxAngle = 20,
                damageRetention = 0.25,
                sparkEffect = false,
                dustEffect = true,
            },
            armorPlate = {
                -- Vehicle armor, ballistic shields
                ricochetChance = 0.70,
                maxAngle = 45,
                damageRetention = 0.20,
                sparkEffect = true,
                loudDeflection = true,
            },
        },

        -- Ammo types that don't ricochet
        noRicochet = {
            ['hp'] = true,      -- Expansion prevents
            ['jhp'] = true,
            ['00buck'] = true,  -- Pellets
            ['birdshot'] = true,
            ['dragonsbreath'] = true,
        },

        -- AP rounds have reduced ricochet (designed to penetrate)
        apRicochetModifier = 0.30,
    },

    -- ==========================================================================
    -- 8. SPECIAL ENVIRONMENT OBJECTS
    -- ==========================================================================
    specialObjects = {
        enabled = true,

        fireExtinguisher = {
            models = {
                'prop_fire_exting_1a', 'prop_fire_exting_1b',
                'prop_fire_exting_2a', 'prop_fire_exting_3a',
            },
            sprayDuration = 5000,
            sprayRadius = 4.0,
            visionObscure = true,
            extinguishesFire = true,
        },

        acUnit = {
            models = {
                'prop_ac_unit_01', 'prop_ac_unit_02',
                'prop_ac_unit_03', 'prop_ac_unit_04',
            },
            steamDuration = 8000,
            steamRadius = 3.0,
            minDamageToTrigger = 50,
        },

        barrel = {
            models = {
                'prop_barrel_01a', 'prop_barrel_02a',
                'prop_barrel_02b', 'prop_barrel_03a',
                'prop_barrel_04a', 'prop_barrel_05',
            },
            knockbackForce = {
                -- Force based on caliber power
                ['.22lr'] = 0,
                ['9mm'] = 50,
                ['.45acp'] = 80,
                ['.357mag'] = 120,
                ['.44mag'] = 180,
                ['5.56'] = 150,
                ['7.62x51'] = 250,
                ['.50bmg'] = 500,
            },
        },

        tire = {
            -- Enhanced tire deflation (GTA handles base, we add sound/effects)
            deflateSound = 'TYRE_BURST',
            slowLeakChance = 0.40,  -- Partial deflation over time
            slowLeakDuration = 30000,
        },
    },
}

-- =============================================================================
-- ENVIRONMENTAL HELPER FUNCTIONS
-- =============================================================================

--- Check if ammo can ignite fuel
-- @param ammoKey string Full ammo key (e.g., '50bmg_api')
-- @return boolean, table Whether it can ignite and the properties
function CanIgniteFuel(ammoKey)
    local ignition = Config.EnvironmentalEffects.fuel.ignitionAmmo[ammoKey]
    if ignition then
        return true, ignition
    end
    return false, nil
end

--- Check if ammo can disrupt electrical
-- @param ammoKey string Full ammo key
-- @return boolean, table Whether it can disrupt and the properties
function CanDisruptElectrical(ammoKey)
    local disruption = Config.EnvironmentalEffects.electrical.disruptionAmmo[ammoKey]
    if disruption then
        return true, disruption
    end
    return false, nil
end

--- Get glass shatter behavior
-- @param ammoType string The ammo type (fmj, hp, ap, etc.)
-- @return table Shatter behavior
function GetGlassShatterBehavior(ammoType)
    return Config.EnvironmentalEffects.glass.shatterBehavior[ammoType] or
           { fullShatter = false, holeSize = 0.05 }
end

--- Calculate ricochet chance
-- @param materialHash number GTA material hash
-- @param bulletAngle number Angle of impact (degrees from surface)
-- @param ammoType string The ammo type
-- @return boolean, number, number Whether ricochet occurs, reflected angle, damage retention
function CalculateRicochet(materialHash, bulletAngle, ammoType)
    if not Config.EnvironmentalEffects.ricochet.enabled then
        return false, 0, 0
    end

    -- Check if ammo type can ricochet
    if Config.EnvironmentalEffects.ricochet.noRicochet[ammoType] then
        return false, 0, 0
    end

    -- Find matching surface
    local surfaceData = nil
    for surfaceType, data in pairs(Config.EnvironmentalEffects.ricochet.surfaces) do
        if data.materialHashes then
            for _, hash in ipairs(data.materialHashes) do
                if hash == materialHash then
                    surfaceData = data
                    break
                end
            end
        end
        if surfaceData then break end
    end

    if not surfaceData then
        return false, 0, 0
    end

    -- Check angle threshold
    if bulletAngle > surfaceData.maxAngle then
        return false, 0, 0
    end

    -- Calculate ricochet chance
    local chance = surfaceData.ricochetChance

    -- AP rounds less likely to ricochet
    if ammoType == 'ap' or ammoType == 'api' then
        chance = chance * Config.EnvironmentalEffects.ricochet.apRicochetModifier
    end

    -- Steeper angles = higher ricochet chance
    local angleModifier = 1.0 - (bulletAngle / surfaceData.maxAngle)
    chance = chance * (0.5 + angleModifier * 0.5)

    if math.random() < chance then
        local reflectedAngle = bulletAngle -- Simplified reflection
        return true, reflectedAngle, surfaceData.damageRetention
    end

    return false, 0, 0
end

--- Get barrel knockback force for caliber
-- @param caliber string The caliber
-- @return number Knockback force
function GetBarrelKnockback(caliber)
    return Config.EnvironmentalEffects.specialObjects.barrel.knockbackForce[caliber] or 0
end

-- =============================================================================
-- EXPORTS
-- =============================================================================

exports('GetAmmoModifier', GetAmmoModifier)
exports('GetDefaultAmmoType', GetDefaultAmmoType)
exports('IsValidAmmoType', IsValidAmmoType)
exports('GetAmmoTypesForCaliber', GetAmmoTypesForCaliber)
exports('GetOverpenetrationStats', GetOverpenetrationStats)
exports('CanPenetrateMaterial', CanPenetrateMaterial)
exports('GetMaterialFromHash', GetMaterialFromHash)
exports('GetEffectivePenetration', GetEffectivePenetration)
exports('CalculateRangeFalloff', CalculateRangeFalloff)
exports('GetSuppressorModifiers', GetSuppressorModifiers)
exports('GetBodyRegion', GetBodyRegion)
exports('CalculateLimbDamage', CalculateLimbDamage)
exports('GetArmorEffectiveness', GetArmorEffectiveness)
exports('CalculateArmorDegradation', CalculateArmorDegradation)
exports('CanIgniteFuel', CanIgniteFuel)
exports('CanDisruptElectrical', CanDisruptElectrical)
exports('GetGlassShatterBehavior', GetGlassShatterBehavior)
exports('CalculateRicochet', CalculateRicochet)
exports('GetBarrelKnockback', GetBarrelKnockback)
