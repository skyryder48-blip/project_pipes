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
-- EXPORTS
-- =============================================================================

exports('GetAmmoModifier', GetAmmoModifier)
exports('GetDefaultAmmoType', GetDefaultAmmoType)
exports('IsValidAmmoType', IsValidAmmoType)
exports('GetAmmoTypesForCaliber', GetAmmoTypesForCaliber)
