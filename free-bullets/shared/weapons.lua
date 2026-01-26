--[[
    Weapon to Caliber Mapping
    ==========================

    Maps weapon hashes to their caliber and component base name.

    Structure:
    Config.Weapons[weaponHash] = {
        caliber = 'caliber_key',       -- Must match key in Config.AmmoTypes
        componentBase = 'COMPONENT_X', -- Base name for components (suffix added)
        clipSize = 17,                 -- Standard magazine capacity
    }
]]

Config.Weapons = {
    -- ======================================================================
    -- BATCH 2: FULL-SIZE 9mm PISTOLS
    -- ======================================================================

    -- Glock 17 Gen 4 (17 rounds)
    [`WEAPON_G17`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G17',
        clipSize = 17,
    },

    -- Glock 17 Black (17 rounds)
    [`WEAPON_G17_BLK`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G17_BLK',
        clipSize = 17,
    },

    -- Glock 17 Gen 5 (17 rounds)
    [`WEAPON_G17_GEN5`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G17_GEN5',
        clipSize = 17,
    },

    -- Glock 19 (15 rounds)
    [`WEAPON_G19`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G19',
        clipSize = 15,
    },

    -- Glock 19X (17 rounds)
    [`WEAPON_G19X`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G19X',
        clipSize = 17,
    },

    -- Glock 19X with Switch (33 rounds, full-auto)
    [`WEAPON_G19X_SWITCH`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G19X_SWITCH',
        clipSize = 33,
    },

    -- Glock 19XD (17 rounds)
    [`WEAPON_G19XD`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G19XD',
        clipSize = 17,
    },

    -- Glock 45 (17 rounds)
    [`WEAPON_G45`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G45',
        clipSize = 17,
    },

    -- Glock 45 Tan (17 rounds)
    [`WEAPON_G45_TAN`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G45_TAN',
        clipSize = 17,
    },

    -- Beretta M9 (15 rounds)
    [`WEAPON_M9`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_M9',
        clipSize = 15,
    },

    -- Beretta M9A3 (17 rounds)
    [`WEAPON_M9A3`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_M9A3',
        clipSize = 17,
    },

    -- Beretta PX4 Storm (17 rounds)
    [`WEAPON_PX4`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_PX4',
        clipSize = 17,
    },

    -- SIG Sauer P320 (17 rounds)
    [`WEAPON_P320`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_P320',
        clipSize = 17,
    },

    -- Canik TP9SF (18 rounds)
    [`WEAPON_TP9SF`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_TP9SF',
        clipSize = 18,
    },

    -- FN 509 (17 rounds)
    [`WEAPON_FN509`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_FN509',
        clipSize = 17,
    },

    -- Walther P88 - Premium German 9mm (16 rounds, 4.0" barrel)
    -- Best accuracy of any 9mm, heavy frame absorbs recoil
    [`WEAPON_WALTHERP88`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_WALTHERP88',
        clipSize = 16,
    },

    -- ======================================================================
    -- BATCH 1: COMPACT 9mm PISTOLS
    -- ======================================================================

    -- Glock 26 Gen 5 (10 rounds)
    [`WEAPON_G26`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G26',
        clipSize = 10,
    },

    -- Glock 26 with Switch (33 rounds, full-auto)
    [`WEAPON_G26_SWITCH`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G26_SWITCH',
        clipSize = 33,
    },

    -- Glock 43X (10 rounds)
    [`WEAPON_G43X`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G43X',
        clipSize = 10,
    },

    -- Taurus GX4 (11 rounds)
    [`WEAPON_GX4`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_GX4',
        clipSize = 11,
    },

    -- Springfield Hellcat (11 rounds)
    [`WEAPON_HELLCAT`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_HELLCAT',
        clipSize = 11,
    },

    -- ======================================================================
    -- BATCH 3: .45 ACP PISTOLS
    -- ======================================================================

    -- Colt M45A1 CQBP - Military 1911 (8 rounds)
    [`WEAPON_M45A1`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_M45A1',
        clipSize = 8,
    },

    -- Glock 21 Gen 4 - Full-Size .45 (13 rounds)
    [`WEAPON_G21`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_G21',
        clipSize = 13,
    },

    -- Glock 30 Gen 4 - Subcompact .45 (10 rounds)
    [`WEAPON_G30`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_G30',
        clipSize = 10,
    },

    -- Glock 41 Gen 4 MOS - Competition .45 (13 rounds)
    [`WEAPON_G41`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_G41',
        clipSize = 13,
    },

    -- Kimber Custom II 1911 - Premium .45 (7 rounds)
    [`WEAPON_KIMBER1911`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_KIMBER1911',
        clipSize = 7,
    },

    -- Kimber Eclipse Custom II - Target 1911 (8 rounds)
    [`WEAPON_KIMBER_ECLIPSE`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_KIMBER_ECLIPSE',
        clipSize = 8,
    },

    -- Junk 1911 - Degraded .45 (7 rounds)
    [`WEAPON_JUNK1911`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_JUNK1911',
        clipSize = 7,
    },

    -- SIG Sauer P220 - Classic .45 ACP (8 rounds, 4.4" barrel)
    [`WEAPON_SIGP220`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_SIGP220',
        clipSize = 8,
    },

    -- ======================================================================
    -- BATCH 4: .40 S&W PISTOLS
    -- ======================================================================

    -- Glock 22 Gen 4 - Law Enforcement Standard (15 rounds)
    [`WEAPON_G22_GEN4`] = {
        caliber = '.40sw',
        componentBase = 'COMPONENT_G22_GEN4',
        clipSize = 15,
    },

    -- Glock 22 Gen 5 - Enhanced Duty Pistol (15 rounds)
    [`WEAPON_G22_GEN5`] = {
        caliber = '.40sw',
        componentBase = 'COMPONENT_G22_GEN5',
        clipSize = 15,
    },

    -- Glock Demon - Full-Auto Street Weapon (13 rounds)
    [`WEAPON_GLOCK_DEMON`] = {
        caliber = '.40sw',
        componentBase = 'COMPONENT_GLOCK_DEMON',
        clipSize = 13,
    },

    -- ======================================================================
    -- BATCH 5: .357 MAGNUM & .38 SPECIAL REVOLVERS
    -- ======================================================================

    -- Colt King Cobra - .357 Magnum (6 rounds, 4.25" barrel)
    [`WEAPON_KINGCOBRA`] = {
        caliber = '.357mag',
        componentBase = 'COMPONENT_KINGCOBRA',
        clipSize = 6,
    },

    -- Colt King Cobra Snub - .357 Magnum (6 rounds, 2" barrel)
    [`WEAPON_KINGCOBRA_SNUB`] = {
        caliber = '.357mag',
        componentBase = 'COMPONENT_KINGCOBRA_SNUB',
        clipSize = 6,
    },

    -- Colt King Cobra Target - .357 Magnum (6 rounds, 3" barrel)
    [`WEAPON_KINGCOBRA_TARGET`] = {
        caliber = '.357mag',
        componentBase = 'COMPONENT_KINGCOBRA_TARGET',
        clipSize = 6,
    },

    -- Colt Python - .357 Magnum (6 rounds, 6" barrel) - Premium Revolver
    [`WEAPON_PYTHON`] = {
        caliber = '.357mag',
        componentBase = 'COMPONENT_PYTHON',
        clipSize = 6,
    },

    -- S&W Model 15 "Combat Masterpiece" - .38 Special (6 rounds, 4" barrel)
    [`WEAPON_SW_MODEL15`] = {
        caliber = '.38spl',
        componentBase = 'COMPONENT_SW_MODEL15',
        clipSize = 6,
    },

    -- ======================================================================
    -- BATCH 6: .44 MAGNUM & .500 S&W MAGNUM REVOLVERS
    -- ======================================================================

    -- S&W Model 29 "Dirty Harry" - .44 Magnum (6 rounds, 6.5" barrel)
    [`WEAPON_SWMODEL29`] = {
        caliber = '.44mag',
        componentBase = 'COMPONENT_SWMODEL29',
        clipSize = 6,
    },

    -- Taurus Raging Bull - .44 Magnum Ported (6 rounds, 6.5" barrel)
    -- Factory porting reduces recoil, slightly lower velocity
    [`WEAPON_RAGINGBULL`] = {
        caliber = '.44mag',
        componentBase = 'COMPONENT_RAGINGBULL',
        clipSize = 6,
    },

    -- S&W 657 - .41 Magnum (uses .357 ammo, 6 rounds, 6" barrel)
    -- The "forgotten magnum" - .41 Mag ballistics, .357 Mag ammo system
    [`WEAPON_SW657`] = {
        caliber = '.357mag',
        componentBase = 'COMPONENT_SW657',
        clipSize = 6,
    },

    -- S&W Model 500 - .500 S&W Magnum (5 rounds, 6.5" barrel)
    -- THE MOST POWERFUL PRODUCTION REVOLVER - rifle-equivalent energy
    [`WEAPON_SW500`] = {
        caliber = '.500sw',
        componentBase = 'COMPONENT_SW500',
        clipSize = 5,
    },

    -- ======================================================================
    -- BATCH 7: 5.7x28mm PDW PISTOLS
    -- ======================================================================

    -- FN Five-seveN - Premium 5.7x28mm (20 rounds, 4.8" barrel)
    -- Original PDW pistol, lightweight polymer frame, fast handling
    [`WEAPON_FN57`] = {
        caliber = '5.7x28',
        componentBase = 'COMPONENT_FIVESEVEN',
        clipSize = 20,
    },

    -- Ruger-57 - Value 5.7x28mm (20 rounds, 4.94" barrel)
    -- American alternative, heavier frame, superior accuracy
    [`WEAPON_RUGER57`] = {
        caliber = '5.7x28',
        componentBase = 'COMPONENT_RUGER57',
        clipSize = 20,
    },

    -- ======================================================================
    -- BATCH 8: .22 LR RIMFIRE PISTOLS
    -- Lowest power handgun cartridge: 80-115 ft-lbs from pistol barrels
    -- Compensated by: Minimal recoil, high capacity, high headshot multipliers
    -- ======================================================================

    -- Walther P22 Standard - Budget Trainer (10 rounds, 3.42" barrel)
    -- DA/SA operation, zinc slide, entry-level rimfire
    [`WEAPON_P22`] = {
        caliber = '.22lr',
        componentBase = 'COMPONENT_P22',
        clipSize = 10,
    },

    -- SIG P22 (Walther P22 Budget) - Entry Trainer (10 rounds, 3.42" barrel)
    -- Budget variant with slightly lower performance
    [`WEAPON_SIGP22`] = {
        caliber = '.22lr',
        componentBase = 'COMPONENT_SIGP22',
        clipSize = 10,
    },

    -- FN 502 Tactical - Premium Precision (15 rounds, 4.6" barrel)
    -- Best accuracy in .22 LR, optics-ready, threaded barrel
    [`WEAPON_FN502`] = {
        caliber = '.22lr',
        componentBase = 'COMPONENT_FN502',
        clipSize = 15,
    },

    -- Kel-Tec PMR-30 - High-Capacity Magnum (30 rounds, 4.3" barrel)
    -- .22 WMR ballistics (160 ft-lbs), ultra-light, significant muzzle flash
    [`WEAPON_PMR30`] = {
        caliber = '.22lr',
        componentBase = 'COMPONENT_PMR30',
        clipSize = 30,
    },

    -- ======================================================================
    -- BATCH 11: MISC FULL-SIZE 9mm & AR-9 PLATFORMS
    -- ======================================================================

    -- SIG Sauer P226 - Classic Combat Pistol (15 rounds, 4.4" barrel)
    [`WEAPON_SIGP226`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_SIGP226',
        clipSize = 15,
    },

    -- SIG Sauer P226 MK25 - Navy SEAL Sidearm (15 rounds, 4.4" barrel)
    [`WEAPON_SIGP226MK25`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_SIGP226MK25',
        clipSize = 15,
    },

    -- SIG Sauer P210 Target - Swiss Precision (8 rounds, 5.0" barrel)
    [`WEAPON_SIGP210`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_SIGP210',
        clipSize = 8,
    },

    -- SIG Sauer P229 - Compact Federal Agency (15 rounds, 3.9" barrel)
    [`WEAPON_SIGP229`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_SIGP229',
        clipSize = 15,
    },

    -- SIG Sauer P320 (Batch 11) - Modular Military (17 rounds, 4.7" barrel)
    [`WEAPON_SIGP320`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_SIGP320_B11',
        clipSize = 17,
    },

    -- Beretta PX4 Storm (Batch 11) - Rotating Barrel (17 rounds, 4.0" barrel)
    [`WEAPON_PX4STORM`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_PX4STORM',
        clipSize = 17,
    },

    -- PSA Dagger - Budget Glock Clone (15 rounds, 3.9" barrel)
    [`WEAPON_PSADAGGER`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_PSADAGGER',
        clipSize = 15,
    },

    -- Ruger SR9 - Slim-Grip Striker-Fired (17 rounds, 4.14" barrel)
    [`WEAPON_RUGERSR9`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_RUGERSR9',
        clipSize = 17,
    },

    -- Angstadt Arms UDP-9 - Premium AR-9 Pistol (17 rounds, 6.0" barrel)
    [`WEAPON_UDP9`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_UDP9',
        clipSize = 17,
    },

    -- Blue ARP - Budget AR-9 Platform (17 rounds, 4-6" barrel)
    [`WEAPON_BLUEARP`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_BLUEARP',
        clipSize = 17,
    },

    -- ======================================================================
    -- BATCH 10: HIGH-POWER & FULL-AUTO PISTOLS
    -- 10mm AUTO: FBI-spec (~400 ft-lbs) vs Full-power (~650 ft-lbs)
    -- Glock 18: Factory select-fire 9mm machine pistol
    -- ======================================================================

    -- Glock 20 Gen 4 - Full-Size 10mm (15+1 rounds, 4.61" barrel)
    -- .357 Magnum energy with semi-auto capacity and reload speed
    [`WEAPON_GLOCK20`] = {
        caliber = '10mm',
        componentBase = 'COMPONENT_GLOCK20',
        clipSize = 16,
    },

    -- Glock 18 Gen 4 - Select-Fire Machine Pistol (17+1 rounds, 4.49" barrel)
    -- FACTORY FULL-AUTO: 1,100-1,200 RPM, extreme recoil without stock
    -- Only Glock with factory select-fire capability (semi/full-auto switch)
    -- Compensated slide reduces muzzle rise, 33rd stick mag recommended
    [`WEAPON_G18`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_G18',
        clipSize = 18,
    },

    -- ======================================================================
    -- BATCH 14: 6.8x51mm & .300 BLACKOUT RIFLES
    -- ======================================================================

    -- SIG MCX SPEAR - 6.8x51mm NGSW Rifle (20 rounds, 13" barrel)
    [`WEAPON_SIG_SPEAR`] = {
        caliber = '6.8x51',
        componentBase = 'COMPONENT_SIG_SPEAR',
        clipSize = 20,
    },

    -- XM7 - 6.8x51mm NGSW Rifle (20 rounds, 13" barrel)
    [`WEAPON_M7`] = {
        caliber = '6.8x51',
        componentBase = 'COMPONENT_M7',
        clipSize = 20,
    },

    -- SIG MCX .300 BLK - Integrally Suppressed (30 rounds, 9" barrel)
    [`WEAPON_MCX300`] = {
        caliber = '.300blk',
        componentBase = 'COMPONENT_MCX300',
        clipSize = 30,
    },

    -- ======================================================================
    -- BATCH 15: 9mm SMG PLATFORMS
    -- ======================================================================

    -- H&K MP5K - Compact Roller-Delayed SMG (30 rounds, 4.53" barrel)
    [`WEAPON_MICRO_MP5`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_MICRO_MP5',
        clipSize = 30,
    },

    -- SIG MPX - Gas-Piston SMG (30 rounds, 4.5" barrel)
    [`WEAPON_SIG_MPX`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_SIG_MPX',
        clipSize = 30,
    },

    -- CZ Scorpion EVO 3 - High-RPM Blowback SMG (30 rounds, 7.72" barrel)
    [`WEAPON_SCORPION`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_SCORPION',
        clipSize = 30,
    },

    -- AR-9 Platform (RAM 9 Desert) - Precision 9mm PCC (33 rounds, 8" barrel)
    [`WEAPON_RAM9_DESERT`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_RAM9_DESERT',
        clipSize = 33,
    },

    -- Intratec TEC-9 - Budget Machine Pistol (32 rounds, 5" barrel)
    [`WEAPON_TEC9`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_TEC9',
        clipSize = 32,
    },

    -- Masterpiece Arms MPA30 - Improved MAC-Style PDW (30 rounds, 5.5" barrel)
    [`WEAPON_MPA30`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_MPA30',
        clipSize = 30,
    },

    -- Kel-Tec SUB-2000 - Folding 9mm Carbine (33 rounds, 16.25" barrel)
    [`WEAPON_SUB2000`] = {
        caliber = '9mm',
        componentBase = 'COMPONENT_SUB2000',
        clipSize = 33,
    },

    -- ======================================================================
    -- BATCH 16: .45 ACP SMG PLATFORMS (MAC variants)
    -- ======================================================================

    -- Ingram MAC-10 - Classic Machine Pistol (30 rounds, 5.75" barrel, 1,100 RPM)
    -- Extreme fire rate, poor accuracy, devastating in CQB
    [`WEAPON_MAC10`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_MAC10',
        clipSize = 30,
    },

    -- MAC-4A1 - Modernized Tactical SMG (30 rounds, 9" barrel, 650 RPM)
    -- Lage MAX-10/45 mk2 slow-fire upper, controlled and accurate
    [`WEAPON_MAC4A1`] = {
        caliber = '.45acp',
        componentBase = 'COMPONENT_MAC4A1',
        clipSize = 30,
    },

    -- ======================================================================
    -- BATCH 17: 5.56 NATO AR PISTOLS / SHORT BARREL RIFLES
    -- ======================================================================

    -- Mk18 CQBR - Military 10.3" Close Quarters Battle Receiver (30 rounds)
    -- SOCOM minimum barrel length, professional CQB platform
    [`WEAPON_MK18`] = {
        caliber = '5.56',
        componentBase = 'COMPONENT_MK18',
        clipSize = 30,
    },

    -- 7.5" AR Pistol with Bumpstock - Full-Auto Chaos (30 rounds)
    -- Extreme muzzle flash, uncontrollable spray, devastating at point-blank
    [`WEAPON_ARP_BUMPSTOCK`] = {
        caliber = '5.56',
        componentBase = 'COMPONENT_ARP_BUMPSTOCK',
        clipSize = 30,
    },

    -- 9" SBR Custom Build - Illegal Street Rifle (30 rounds)
    -- Unregistered NFA item, custom tuned, criminal roleplay
    [`WEAPON_SBR9`] = {
        caliber = '5.56',
        componentBase = 'COMPONENT_SBR9',
        clipSize = 30,
    },

    -- ======================================================================
    -- BATCH 18: 12 GAUGE SHOTGUNS
    -- Multi-pellet damage modeling with severe damage falloff beyond effective range
    -- 8 ammo types: 00 Buck, #1 Buck, Slug, Birdshot, Pepperball, Dragon's Breath, Beanbag, Breach
    -- ======================================================================

    -- Mini Shotty - Illegal Sawn-Off (4 rounds, 10-12" barrel)
    -- Devastating close range, useless beyond 15m, hip-fire only
    [`WEAPON_MINISHOTTY`] = {
        caliber = '12ga',
        componentBase = 'COMPONENT_MINISHOTTY',
        clipSize = 4,
    },

    -- Model 680 - Budget Pump (5 rounds, 18" barrel)
    -- Entry-level shotgun, widest spread, prone to binding
    [`WEAPON_MODEL680`] = {
        caliber = '12ga',
        componentBase = 'COMPONENT_MODEL680',
        clipSize = 5,
    },

    -- Remington 870 Express - Standard Pump (5 rounds, 18" barrel)
    -- Most-produced pump shotgun (13M+ units), dual action bars
    [`WEAPON_REMINGTON870`] = {
        caliber = '12ga',
        componentBase = 'COMPONENT_REMINGTON870',
        clipSize = 5,
    },

    -- Mossberg 500 - MIL-SPEC Pump (6 rounds, 18" barrel)
    -- Military-certified MIL-SPEC 3443E, tang-mounted safety
    [`WEAPON_MOSSBERG500`] = {
        caliber = '12ga',
        componentBase = 'COMPONENT_MOSSBERG500',
        clipSize = 6,
    },

    -- Browning Auto-5 - Classic Semi-Auto (5 rounds, 18-20" barrel)
    -- John Browning's 1898 long-recoil design, lowest recoil, double fire rate
    [`WEAPON_BROWNINGAUTO5`] = {
        caliber = '12ga',
        componentBase = 'COMPONENT_BROWNINGAUTO5',
        clipSize = 5,
    },

    -- Beretta 1301 Tactical - Fast Semi-Auto (8 rounds, 18.5" barrel)
    -- Competition-grade gas system, 140 RPM, fastest follow-up shots
    [`WEAPON_BERETTA1301`] = {
        caliber = '12ga',
        componentBase = 'COMPONENT_BERETTA1301',
        clipSize = 8,
    },

    -- Mossberg 590 Shockwave - Stockless "Firearm" (6 rounds, 14.375" barrel)
    -- Bird's head grip, hip-fire only, devastating CQB, legal loophole
    [`WEAPON_SHOCKWAVE`] = {
        caliber = '12ga',
        componentBase = 'COMPONENT_SHOCKWAVE',
        clipSize = 6,
    },

    -- ======================================================================
    -- BATCH 13: 7.62x39mm AK-PLATFORM RIFLES
    -- Soviet intermediate cartridge: +14% damage vs 5.56 NATO
    -- Superior short-barrel performance, excellent barrier penetration
    -- ======================================================================

    -- Micro Draco - Ultra-Compact AK Pistol (30 rounds, 6.25" barrel)
    -- "Fire-breathing dragon" - massive muzzle flash, extreme recoil
    -- Fastest ADS of any rifle, worst accuracy, devastating CQB
    [`WEAPON_MINI_AK47`] = {
        caliber = '7.62x39',
        componentBase = 'COMPONENT_MINI_AK47',
        clipSize = 30,
    },

    -- CMMG Mk47 Mutant - Precision AK/AR Hybrid (30 rounds, 16.1" barrel)
    -- AR ergonomics + AK magazine compatibility, sub-2 MOA accuracy
    -- Best 7.62x39 platform - moderate recoil, excellent accuracy
    [`WEAPON_MK47`] = {
        caliber = '7.62x39',
        componentBase = 'COMPONENT_MK47',
        clipSize = 30,
    },

    -- ======================================================================
    -- BATCH 19: PRECISION RIFLES & ANTI-MATERIEL PLATFORMS
    -- Four caliber tiers: 5.56 → .308 → .300 WM → .50 BMG
    -- Energy range: 1,300 ft-lbs to 13,200 ft-lbs (10x spread)
    -- ======================================================================

    -- SIG 550 (Stgw 90) - Swiss Assault Rifle (20 rounds, 20.8" barrel)
    -- Swiss military standard since 1990, exceptional 0.72 MOA accuracy
    [`WEAPON_SIG550`] = {
        caliber = '5.56',
        componentBase = 'COMPONENT_SIG550',
        clipSize = 20,
    },

    -- Remington 700 - Civilian Bolt-Action (4 rounds, 22-24" barrel)
    -- America's most popular bolt-action, 1.0 MOA production accuracy
    [`WEAPON_REMINGTON700`] = {
        caliber = '7.62x51',
        componentBase = 'COMPONENT_REMINGTON700',
        clipSize = 4,
    },

    -- Sauer 101 - German Precision Rifle (5 rounds, 22" barrel)
    -- J.P. Sauer & Sohn since 1751, sub-MOA factory guarantee
    -- 60° bolt throw = fastest .308 bolt cycle
    [`WEAPON_SAUER101`] = {
        caliber = '7.62x51',
        componentBase = 'COMPONENT_SAUER101',
        clipSize = 5,
    },

    -- Remington M24 SWS - Military Sniper (5 rounds, 24" barrel)
    -- U.S. Army sniper rifle 1988-2014, ≤0.35 MOA machine rest
    [`WEAPON_REMINGTONM24`] = {
        caliber = '7.62x51',
        componentBase = 'COMPONENT_REMINGTONM24',
        clipSize = 5,
    },

    -- NEMO Omen Watchman - .300 WM Semi-Auto (14 rounds, 24" barrel)
    -- World's first reliable .300 WM AR, 0.5-1.0 MOA
    -- HIGH CAPACITY magnum platform - 14 rounds of .300 Win Mag
    [`WEAPON_NEMOWATCHMAN`] = {
        caliber = '.300wm',
        componentBase = 'COMPONENT_NEMOWATCHMAN',
        clipSize = 14,
    },

    -- Victus XMR - .50 BMG Precision Bolt (5 rounds, 27" barrel)
    -- Sub-MOA with match ammo, 30-33 lbs, extreme range precision
    [`WEAPON_VICTUSXMR`] = {
        caliber = '.50bmg',
        componentBase = 'COMPONENT_VICTUSXMR',
        clipSize = 5,
    },

    -- Barrett M82A1 - .50 BMG Semi-Auto Original (10 rounds, 29" barrel)
    -- Original Barrett .50 cal, short-recoil semi-auto, 1.5-2.0 MOA
    -- Anti-materiel capability: 9" concrete penetration
    [`WEAPON_BARRETTM82A1`] = {
        caliber = '.50bmg',
        componentBase = 'COMPONENT_BARRETTM82A1',
        clipSize = 10,
    },

    -- Barrett M107A1 - .50 BMG Semi-Auto Upgraded (10 rounds, 29" barrel)
    -- Improved M82A1: lighter (28.7 lbs), better accuracy (1.0-1.5 MOA)
    -- Hydraulic buffer, suppressor-ready, best overall .50 platform
    [`WEAPON_BARRETTM107A1`] = {
        caliber = '.50bmg',
        componentBase = 'COMPONENT_BARRETTM107A1',
        clipSize = 10,
    },

    -- ======================================================================
    -- BATCH 20: .38 SPECIAL REVOLVERS & TRANQUILIZER DART GUN
    -- .38 Special +P: 64-93% of 9mm energy depending on barrel
    -- Final batch - concealed carry and non-lethal options
    -- ======================================================================

    -- S&W Model 60 - Premium 3" J-Frame (5 rounds, 3.0" barrel)
    -- First all-stainless revolver (1965), DA/SA, adjustable sights
    [`WEAPON_SWMODEL60`] = {
        caliber = '.38spl',
        componentBase = 'COMPONENT_SWMODEL60',
        clipSize = 5,
    },

    -- S&W Model 10 - Police Service Revolver (6 rounds, 4.0" barrel)
    -- Most produced S&W (6M+ units), K-frame, maximum .38 performance
    [`WEAPON_SWMODEL10`] = {
        caliber = '.38spl',
        componentBase = 'COMPONENT_SWMODEL10',
        clipSize = 6,
    },

    -- S&W Model 442 Airweight - Black DAO Snub (5 rounds, 1.875" barrel)
    -- "Centennial" internal hammer, 14.7 oz, deep concealment
    [`WEAPON_SWMODEL442`] = {
        caliber = '.38spl',
        componentBase = 'COMPONENT_SWMODEL442',
        clipSize = 5,
    },

    -- S&W Model 642 Airweight - Stainless DAO Snub (5 rounds, 1.875" barrel)
    -- S&W's best-selling J-frame, 14.6 oz, matte silver finish
    [`WEAPON_SWMODEL642`] = {
        caliber = '.38spl',
        componentBase = 'COMPONENT_SWMODEL642',
        clipSize = 5,
    },

    -- Ruger LCR - Modern Polymer Snub (5 rounds, 1.87" barrel)
    -- Revolutionary 2009 design, LIGHTEST in class (13.5 oz)
    -- Friction-reducing cam trigger feels lighter than it is
    [`WEAPON_RUGERLCR`] = {
        caliber = '.38spl',
        componentBase = 'COMPONENT_RUGERLCR',
        clipSize = 5,
    },

    -- Taurus Defender 856 - Budget 6-Shot (6 rounds, 3.0" barrel)
    -- Value alternative with extra capacity, tritium sights standard
    [`WEAPON_TAURUS856`] = {
        caliber = '.38spl',
        componentBase = 'COMPONENT_TAURUS856',
        clipSize = 6,
    },

    -- Tranquilizer Dart Gun - Non-Lethal Special Weapon (3 darts)
    -- 30-second incapacitation: stumble → ragdoll → freeze
    -- Very quiet (15m AI detection), slow projectile (76 m/s)
    [`WEAPON_DARTGUN`] = {
        caliber = 'dart',
        componentBase = 'COMPONENT_DARTGUN',
        clipSize = 3,
    },
}

-- Helper function to get weapon info
function GetWeaponInfo(weaponHash)
    return Config.Weapons[weaponHash]
end

-- Helper function to check if weapon is supported
function IsWeaponSupported(weaponHash)
    return Config.Weapons[weaponHash] ~= nil
end

-- Helper function to get component name for a weapon and ammo type
function GetComponentName(weaponHash, ammoType)
    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo then return nil end

    local caliber = weaponInfo.caliber
    local ammoConfig = Config.AmmoTypes[caliber] and Config.AmmoTypes[caliber][ammoType]
    if not ammoConfig then return nil end

    return weaponInfo.componentBase .. ammoConfig.componentSuffix
end

-- Helper function to get all component names for a weapon
function GetAllComponentNames(weaponHash)
    local weaponInfo = Config.Weapons[weaponHash]
    if not weaponInfo then return {} end

    local components = {}
    local caliber = weaponInfo.caliber
    local ammoTypes = Config.AmmoTypes[caliber]

    if ammoTypes then
        for ammoType, ammoConfig in pairs(ammoTypes) do
            components[ammoType] = weaponInfo.componentBase .. ammoConfig.componentSuffix
        end
    end

    return components
end
