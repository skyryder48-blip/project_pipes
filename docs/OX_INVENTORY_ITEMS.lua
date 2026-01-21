--[[
    OX_INVENTORY ITEMS CONFIGURATION
    ================================

    Copy these items to your ox_inventory/data/items.lua file.

    Categories:
    1. AMMUNITION (55 items)
    2. MAGAZINES (70 items)
    3. SPEEDLOADERS (6 items)
    4. MODIFICATION COMPONENTS (4 items)
]]

-- ============================================================================
-- AMMUNITION ITEMS
-- ============================================================================

-- 9mm Ammunition
['ammo_9mm_fmj'] = {
    label = '9mm FMJ',
    weight = 12,
    stack = true,
    close = true,
    description = '9mm Full Metal Jacket ammunition. Standard defensive load.',
},

['ammo_9mm_hp'] = {
    label = '9mm Hollow Point',
    weight = 12,
    stack = true,
    close = true,
    description = '9mm Hollow Point. +10% damage to unarmored targets.',
},

['ammo_9mm_ap'] = {
    label = '9mm Armor Piercing',
    weight = 14,
    stack = true,
    close = true,
    description = '9mm AP rounds. Bypasses body armor, reduced capacity.',
},

-- .45 ACP Ammunition
['ammo_45acp_fmj'] = {
    label = '.45 ACP FMJ',
    weight = 21,
    stack = true,
    close = true,
    description = '.45 ACP Full Metal Jacket. Heavy subsonic round.',
},

['ammo_45acp_jhp'] = {
    label = '.45 ACP JHP',
    weight = 21,
    stack = true,
    close = true,
    description = '.45 ACP Jacketed Hollow Point. +15% damage.',
},

-- .40 S&W Ammunition
['ammo_40sw_fmj'] = {
    label = '.40 S&W FMJ',
    weight = 18,
    stack = true,
    close = true,
    description = '.40 S&W Full Metal Jacket. Law enforcement standard.',
},

['ammo_40sw_jhp'] = {
    label = '.40 S&W JHP',
    weight = 18,
    stack = true,
    close = true,
    description = '.40 S&W Jacketed Hollow Point. +20% damage.',
},

-- .357 Magnum Ammunition
['ammo_357mag_fmj'] = {
    label = '.357 Magnum FMJ',
    weight = 16,
    stack = true,
    close = true,
    description = '.357 Magnum Full Metal Jacket. High-velocity revolver round.',
},

['ammo_357mag_jhp'] = {
    label = '.357 Magnum JHP',
    weight = 16,
    stack = true,
    close = true,
    description = '.357 Magnum JHP. Legendary stopping power.',
},

-- .38 Special Ammunition
['ammo_38spl_fmj'] = {
    label = '.38 Special FMJ',
    weight = 13,
    stack = true,
    close = true,
    description = '.38 Special Full Metal Jacket. Classic revolver round.',
},

['ammo_38spl_jhp'] = {
    label = '.38 Special +P JHP',
    weight = 13,
    stack = true,
    close = true,
    description = '.38 Special +P JHP. Enhanced defensive load.',
},

-- .44 Magnum Ammunition
['ammo_44mag_fmj'] = {
    label = '.44 Magnum FMJ',
    weight = 24,
    stack = true,
    close = true,
    description = '.44 Magnum Full Metal Jacket. Heavy magnum round.',
},

['ammo_44mag_jhp'] = {
    label = '.44 Magnum JHP',
    weight = 24,
    stack = true,
    close = true,
    description = '.44 Magnum JHP. Devastating terminal performance.',
},

-- .500 S&W Ammunition
['ammo_500sw_fmj'] = {
    label = '.500 S&W FMJ',
    weight = 42,
    stack = true,
    close = true,
    description = '.500 S&W FMJ. Most powerful production handgun round.',
},

['ammo_500sw_jhp'] = {
    label = '.500 S&W JHP',
    weight = 42,
    stack = true,
    close = true,
    description = '.500 S&W JHP. Extreme stopping power.',
},

-- 5.7x28mm Ammunition
['ammo_57x28_fmj'] = {
    label = '5.7x28mm FMJ',
    weight = 6,
    stack = true,
    close = true,
    description = '5.7x28mm FMJ. High-velocity PDW round.',
},

['ammo_57x28_jhp'] = {
    label = '5.7x28mm JHP',
    weight = 6,
    stack = true,
    close = true,
    description = '5.7x28mm JHP. Best defensive choice.',
},

['ammo_57x28_ap'] = {
    label = '5.7x28mm AP',
    weight = 7,
    stack = true,
    close = true,
    description = '5.7x28mm AP. Defeats Level IIIA armor.',
},

-- 10mm Auto Ammunition
['ammo_10mm_fbi'] = {
    label = '10mm FBI Service',
    weight = 18,
    stack = true,
    close = true,
    description = '10mm FBI-spec load. Equivalent to .40 S&W.',
},

['ammo_10mm_fullpower'] = {
    label = '10mm Full Power',
    weight = 18,
    stack = true,
    close = true,
    description = '10mm Full Power. Equivalent to .357 Magnum.',
},

['ammo_10mm_bear'] = {
    label = '10mm Bear Defense',
    weight = 20,
    stack = true,
    close = true,
    description = '10mm Hard Cast. Maximum penetration for large game.',
},

-- .22 LR Ammunition
['ammo_22lr_fmj'] = {
    label = '.22 LR FMJ',
    weight = 3,
    stack = true,
    close = true,
    description = '.22 LR Standard. Training and plinking ammunition.',
},

['ammo_22lr_jhp'] = {
    label = '.22 LR JHP',
    weight = 3,
    stack = true,
    close = true,
    description = '.22 LR Hollow Point. Slightly enhanced damage.',
},

-- 5.56 NATO Ammunition
['ammo_556_fmj'] = {
    label = '5.56 NATO FMJ',
    weight = 12,
    stack = true,
    close = true,
    description = '5.56 NATO M193 ball. Standard rifle ammunition.',
},

['ammo_556_sp'] = {
    label = '5.56 NATO Soft Point',
    weight = 12,
    stack = true,
    close = true,
    description = '5.56 NATO SP. +10% damage, hunting/defense load.',
},

['ammo_556_ap'] = {
    label = '5.56 NATO AP',
    weight = 14,
    stack = true,
    close = true,
    description = '5.56 NATO AP. Enhanced barrier penetration.',
},

-- 6.8x51mm Ammunition
['ammo_68x51_fmj'] = {
    label = '6.8x51mm FMJ',
    weight = 18,
    stack = true,
    close = true,
    description = '6.8x51mm NGSW ball. Next-gen military round.',
},

['ammo_68x51_ap'] = {
    label = '6.8x51mm AP',
    weight = 20,
    stack = true,
    close = true,
    description = '6.8x51mm AP. Defeats Level IV armor.',
},

-- .300 Blackout Ammunition
['ammo_300blk_super'] = {
    label = '.300 BLK Supersonic',
    weight = 16,
    stack = true,
    close = true,
    description = '.300 Blackout supersonic. Standard load.',
},

['ammo_300blk_sub'] = {
    label = '.300 BLK Subsonic',
    weight = 18,
    stack = true,
    close = true,
    description = '.300 Blackout subsonic. Suppressor-optimized.',
},

-- 7.62x39mm Ammunition
['ammo_762x39_fmj'] = {
    label = '7.62x39mm FMJ',
    weight = 17,
    stack = true,
    close = true,
    description = '7.62x39 ball. Soviet intermediate round.',
},

['ammo_762x39_sp'] = {
    label = '7.62x39mm Soft Point',
    weight = 17,
    stack = true,
    close = true,
    description = '7.62x39 SP. +15% soft tissue damage.',
},

['ammo_762x39_ap'] = {
    label = '7.62x39mm AP',
    weight = 19,
    stack = true,
    close = true,
    description = '7.62x39 7N23 AP. Enhanced armor penetration.',
},

-- 7.62x51mm / .308 Winchester Ammunition
['ammo_308_fmj'] = {
    label = '7.62 NATO FMJ',
    weight = 25,
    stack = true,
    close = true,
    description = '7.62 NATO M80 ball. Standard sniper/DMR round.',
},

['ammo_308_match'] = {
    label = '7.62 NATO Match',
    weight = 25,
    stack = true,
    close = true,
    description = '7.62 NATO Match. Sub-MOA precision ammunition.',
},

['ammo_308_ap'] = {
    label = '7.62 NATO AP',
    weight = 27,
    stack = true,
    close = true,
    description = '7.62 NATO M993 AP. Defeats Level III+ armor.',
},

-- .300 Win Mag Ammunition
['ammo_300wm_fmj'] = {
    label = '.300 Win Mag FMJ',
    weight = 32,
    stack = true,
    close = true,
    description = '.300 Win Mag hunting load. Long-range precision.',
},

['ammo_300wm_match'] = {
    label = '.300 Win Mag Match',
    weight = 32,
    stack = true,
    close = true,
    description = '.300 Win Mag Match. Competition precision load.',
},

-- .50 BMG Ammunition
['ammo_50bmg_ball'] = {
    label = '.50 BMG Ball',
    weight = 115,
    stack = true,
    close = true,
    description = '.50 BMG M33 ball. Anti-materiel round.',
},

['ammo_50bmg_api'] = {
    label = '.50 BMG API',
    weight = 115,
    stack = true,
    close = true,
    description = '.50 BMG AP Incendiary. Ignites on armor impact.',
},

['ammo_50bmg_boom'] = {
    label = '.50 BMG BOOM',
    weight = 120,
    stack = true,
    close = true,
    description = '.50 BMG Explosive. Devastating vs vehicles.',
},

-- 12 Gauge Shotgun Ammunition
['ammo_12ga_00buck'] = {
    label = '12ga 00 Buckshot',
    weight = 48,
    stack = true,
    close = true,
    description = '12 gauge 00 buckshot. Standard combat load.',
},

['ammo_12ga_1buck'] = {
    label = '12ga #1 Buckshot',
    weight = 45,
    stack = true,
    close = true,
    description = '12 gauge #1 buckshot. More pellets, less damage each.',
},

['ammo_12ga_slug'] = {
    label = '12ga Slug',
    weight = 50,
    stack = true,
    close = true,
    description = '12 gauge slug. Single projectile, precision accuracy.',
},

['ammo_12ga_birdshot'] = {
    label = '12ga Birdshot',
    weight = 42,
    stack = true,
    close = true,
    description = '12 gauge birdshot. Wide spread, crowd control.',
},

['ammo_12ga_pepperball'] = {
    label = '12ga Pepperball',
    weight = 35,
    stack = true,
    close = true,
    description = '12 gauge pepperball. Causes coughing and vision blur.',
},

['ammo_12ga_dragonsbreath'] = {
    label = '12ga Dragon\'s Breath',
    weight = 52,
    stack = true,
    close = true,
    description = '12 gauge incendiary. Magnesium fire trail.',
},

['ammo_12ga_beanbag'] = {
    label = '12ga Beanbag',
    weight = 40,
    stack = true,
    close = true,
    description = '12 gauge beanbag. Less-lethal, causes knockback.',
},

['ammo_12ga_breach'] = {
    label = '12ga Breaching',
    weight = 55,
    stack = true,
    close = true,
    description = '12 gauge breaching slug. For door locks/hinges.',
},

-- Tranquilizer Dart
['ammo_dart_tranq'] = {
    label = 'Tranquilizer Dart',
    weight = 15,
    stack = true,
    close = true,
    description = 'Sedative dart. 30-second incapacitation.',
},

-- ============================================================================
-- MAGAZINE ITEMS
-- ============================================================================

-- Compact 9mm Magazines (G26, G43X)
['mag_g26_standard'] = {
    label = 'Glock 26 Magazine (10rd)',
    weight = 80,
    stack = false,
    close = true,
    description = 'Standard 10-round magazine for Glock 26/43X.',
},

['mag_g26_extended'] = {
    label = 'Glock 26 Extended (17rd)',
    weight = 120,
    stack = false,
    close = true,
    description = 'Extended 17-round magazine for Glock 26/43X.',
},

['mag_g26_stick'] = {
    label = 'Glock 9mm Stick (33rd)',
    weight = 185,
    stack = false,
    close = true,
    description = '33-round stick magazine for compact Glocks.',
},

['mag_compact9_standard'] = {
    label = 'Compact 9mm Magazine (11rd)',
    weight = 75,
    stack = false,
    close = true,
    description = 'Standard magazine for GX4/Hellcat.',
},

['mag_compact9_extended'] = {
    label = 'Compact 9mm Extended (15rd)',
    weight = 100,
    stack = false,
    close = true,
    description = 'Extended magazine for GX4/Hellcat.',
},

-- Full-Size Glock 9mm Magazines
['mag_glock9_standard'] = {
    label = 'Glock 9mm Magazine (17rd)',
    weight = 95,
    stack = false,
    close = true,
    description = 'Standard 17-round Glock 9mm magazine.',
},

['mag_glock9_extended'] = {
    label = 'Glock 9mm Stick (33rd)',
    weight = 185,
    stack = false,
    close = true,
    description = '33-round stick magazine for full-size Glocks.',
},

['mag_glock9_drum'] = {
    label = 'Glock 9mm Drum (50rd)',
    weight = 460,
    stack = false,
    close = true,
    description = '50-round drum magazine for Glocks.',
},

-- Beretta 9mm Magazines
['mag_beretta_standard'] = {
    label = 'Beretta 9mm Magazine (15rd)',
    weight = 90,
    stack = false,
    close = true,
    description = 'Standard 15-round Beretta magazine.',
},

['mag_beretta_m9a3'] = {
    label = 'Beretta M9A3 Magazine (17rd)',
    weight = 100,
    stack = false,
    close = true,
    description = '17-round M9A3 magazine.',
},

['mag_beretta_extended'] = {
    label = 'Beretta 9mm Extended (30rd)',
    weight = 175,
    stack = false,
    close = true,
    description = '30-round extended Beretta magazine.',
},

-- SIG 9mm Magazines
['mag_sig_p210'] = {
    label = 'SIG P210 Magazine (8rd)',
    weight = 75,
    stack = false,
    close = true,
    description = 'Standard 8-round P210 magazine.',
},

['mag_sig_standard'] = {
    label = 'SIG 9mm Magazine (15rd)',
    weight = 92,
    stack = false,
    close = true,
    description = 'Standard SIG 9mm magazine.',
},

['mag_sig_extended'] = {
    label = 'SIG 9mm Extended (21rd)',
    weight = 135,
    stack = false,
    close = true,
    description = '21-round extended SIG magazine.',
},

-- Other 9mm Pistol Magazines
['mag_fn509_standard'] = {
    label = 'FN 509 Magazine (17rd)',
    weight = 95,
    stack = false,
    close = true,
    description = 'Standard 17-round FN 509 magazine.',
},

['mag_fn509_extended'] = {
    label = 'FN 509 Extended (24rd)',
    weight = 140,
    stack = false,
    close = true,
    description = '24-round extended FN 509 magazine.',
},

['mag_tp9sf_standard'] = {
    label = 'Canik TP9SF Magazine (18rd)',
    weight = 98,
    stack = false,
    close = true,
    description = 'Standard 18-round TP9SF magazine.',
},

['mag_walther_standard'] = {
    label = 'Walther P88 Magazine (15rd)',
    weight = 90,
    stack = false,
    close = true,
    description = 'Standard 15-round P88 magazine.',
},

['mag_rugersr9_standard'] = {
    label = 'Ruger SR9 Magazine (17rd)',
    weight = 95,
    stack = false,
    close = true,
    description = 'Standard 17-round SR9 magazine.',
},

['mag_psadagger_standard'] = {
    label = 'PSA Dagger Magazine (15rd)',
    weight = 88,
    stack = false,
    close = true,
    description = 'Standard 15-round Dagger magazine.',
},

-- Glock .45 ACP Magazines
['mag_glock45_standard'] = {
    label = 'Glock .45 Magazine (13rd)',
    weight = 120,
    stack = false,
    close = true,
    description = 'Standard 13-round Glock .45 magazine.',
},

['mag_glock45_compact'] = {
    label = 'Glock 30 Magazine (10rd)',
    weight = 100,
    stack = false,
    close = true,
    description = 'Standard 10-round Glock 30 magazine.',
},

['mag_glock45_extended'] = {
    label = 'Glock .45 Extended (26rd)',
    weight = 220,
    stack = false,
    close = true,
    description = '26-round extended Glock .45 magazine.',
},

-- 1911 .45 ACP Magazines
['mag_1911_standard'] = {
    label = '1911 Magazine (7rd)',
    weight = 85,
    stack = false,
    close = true,
    description = 'Standard 7-round 1911 magazine.',
},

['mag_1911_8rd'] = {
    label = '1911 Magazine (8rd)',
    weight = 90,
    stack = false,
    close = true,
    description = '8-round 1911 magazine.',
},

['mag_1911_extended'] = {
    label = '1911 Extended (10rd)',
    weight = 110,
    stack = false,
    close = true,
    description = '10-round extended 1911 magazine.',
},

['mag_sigp220_standard'] = {
    label = 'SIG P220 Magazine (8rd)',
    weight = 95,
    stack = false,
    close = true,
    description = 'Standard 8-round P220 magazine.',
},

-- Glock .40 S&W Magazines
['mag_glock40_standard'] = {
    label = 'Glock .40 Magazine (15rd)',
    weight = 105,
    stack = false,
    close = true,
    description = 'Standard 15-round Glock .40 magazine.',
},

['mag_glock40_compact'] = {
    label = 'Glock Demon Magazine (13rd)',
    weight = 95,
    stack = false,
    close = true,
    description = 'Standard 13-round Demon magazine.',
},

['mag_glock40_extended'] = {
    label = 'Glock .40 Extended (22rd)',
    weight = 160,
    stack = false,
    close = true,
    description = '22-round extended Glock .40 magazine.',
},

-- 5.7x28mm Magazines
['mag_57_standard'] = {
    label = '5.7x28mm Magazine (20rd)',
    weight = 85,
    stack = false,
    close = true,
    description = 'Standard 20-round 5.7 magazine.',
},

['mag_57_extended'] = {
    label = '5.7x28mm Extended (30rd)',
    weight = 125,
    stack = false,
    close = true,
    description = '30-round extended 5.7 magazine.',
},

-- .22 LR Magazines
['mag_22_standard'] = {
    label = '.22 LR Magazine (10rd)',
    weight = 45,
    stack = false,
    close = true,
    description = 'Standard 10-round .22 LR magazine.',
},

['mag_fn502_standard'] = {
    label = 'FN 502 Magazine (15rd)',
    weight = 55,
    stack = false,
    close = true,
    description = 'Standard 15-round FN 502 magazine.',
},

['mag_pmr30_standard'] = {
    label = 'PMR-30 Magazine (30rd)',
    weight = 75,
    stack = false,
    close = true,
    description = 'Standard 30-round PMR-30 magazine.',
},

-- 10mm Auto Magazines
['mag_10mm_standard'] = {
    label = 'Glock 20 Magazine (15rd)',
    weight = 125,
    stack = false,
    close = true,
    description = 'Standard 15-round Glock 20 magazine.',
},

['mag_10mm_extended'] = {
    label = 'Glock 20 Extended (30rd)',
    weight = 230,
    stack = false,
    close = true,
    description = '30-round extended Glock 20 magazine.',
},

-- 9mm SMG Magazines
['mag_mp5_standard'] = {
    label = 'MP5 Magazine (30rd)',
    weight = 165,
    stack = false,
    close = true,
    description = 'Standard 30-round MP5 magazine.',
},

['mag_mpx_standard'] = {
    label = 'MPX Magazine (30rd)',
    weight = 160,
    stack = false,
    close = true,
    description = 'Standard 30-round MPX magazine.',
},

['mag_scorpion_standard'] = {
    label = 'Scorpion EVO Magazine (30rd)',
    weight = 155,
    stack = false,
    close = true,
    description = 'Standard 30-round Scorpion magazine.',
},

['mag_scorpion_drum'] = {
    label = 'Scorpion EVO Drum (50rd)',
    weight = 380,
    stack = false,
    close = true,
    description = '50-round drum for Scorpion EVO.',
},

['mag_tec9_standard'] = {
    label = 'TEC-9 Magazine (32rd)',
    weight = 170,
    stack = false,
    close = true,
    description = 'Standard 32-round TEC-9 magazine.',
},

['mag_mpa30_standard'] = {
    label = 'MPA30 Magazine (30rd)',
    weight = 165,
    stack = false,
    close = true,
    description = 'Standard 30-round MPA30 magazine.',
},

['mag_sub2000_standard'] = {
    label = 'SUB-2000 Magazine (33rd)',
    weight = 185,
    stack = false,
    close = true,
    description = 'Standard 33-round SUB-2000 magazine.',
},

['mag_ram9_standard'] = {
    label = 'RAM-9 Magazine (33rd)',
    weight = 180,
    stack = false,
    close = true,
    description = 'Standard 33-round RAM-9 magazine.',
},

-- .45 ACP SMG Magazines (MAC)
['mag_mac_standard'] = {
    label = 'MAC .45 Magazine (30rd)',
    weight = 195,
    stack = false,
    close = true,
    description = 'Standard 30-round MAC magazine.',
},

['mag_mac_extended'] = {
    label = 'MAC .45 Extended (50rd)',
    weight = 320,
    stack = false,
    close = true,
    description = '50-round extended MAC magazine.',
},

-- 5.56 NATO Rifle Magazines
['mag_556_standard'] = {
    label = 'STANAG Magazine (30rd)',
    weight = 130,
    stack = false,
    close = true,
    description = 'Standard 30-round STANAG magazine.',
},

['mag_556_extended'] = {
    label = 'STANAG Extended (40rd)',
    weight = 175,
    stack = false,
    close = true,
    description = '40-round extended STANAG magazine.',
},

['mag_556_drum'] = {
    label = '5.56 Drum Magazine (60rd)',
    weight = 520,
    stack = false,
    close = true,
    description = '60-round 5.56 drum magazine.',
},

-- 6.8x51mm Rifle Magazines
['mag_68x51_standard'] = {
    label = '6.8x51mm Magazine (20rd)',
    weight = 145,
    stack = false,
    close = true,
    description = 'Standard 20-round NGSW magazine.',
},

-- .300 Blackout Magazines
['mag_300blk_standard'] = {
    label = '.300 BLK Magazine (30rd)',
    weight = 155,
    stack = false,
    close = true,
    description = 'Standard 30-round .300 BLK magazine.',
},

-- AR-9 Magazines
['mag_ar9_standard'] = {
    label = 'AR-9 Magazine (17rd)',
    weight = 95,
    stack = false,
    close = true,
    description = 'Standard 17-round AR-9 magazine.',
},

['mag_ar9_extended'] = {
    label = 'AR-9 Extended (33rd)',
    weight = 185,
    stack = false,
    close = true,
    description = '33-round extended AR-9 magazine.',
},

-- 7.62x39mm AK Magazines
['mag_762x39_standard'] = {
    label = 'AK Magazine (30rd)',
    weight = 350,
    stack = false,
    close = true,
    description = 'Standard 30-round AK magazine.',
},

['mag_762x39_extended'] = {
    label = 'AK Extended Magazine (40rd)',
    weight = 480,
    stack = false,
    close = true,
    description = '40-round extended AK magazine.',
},

['mag_762x39_drum'] = {
    label = 'AK Drum Magazine (75rd)',
    weight = 1200,
    stack = false,
    close = true,
    description = '75-round AK drum magazine.',
},

-- SIG 550 Magazines
['mag_sig550_standard'] = {
    label = 'SIG 550 Magazine (20rd)',
    weight = 140,
    stack = false,
    close = true,
    description = 'Standard 20-round SIG 550 magazine.',
},

['mag_sig550_extended'] = {
    label = 'SIG 550 Magazine (30rd)',
    weight = 195,
    stack = false,
    close = true,
    description = '30-round SIG 550 magazine.',
},

-- .300 Win Mag Magazines
['mag_300wm_standard'] = {
    label = '.300 WM Magazine (14rd)',
    weight = 320,
    stack = false,
    close = true,
    description = 'Standard 14-round NEMO Watchman magazine.',
},

-- .50 BMG Magazines
['mag_50bmg_barrett'] = {
    label = 'Barrett .50 BMG Magazine (10rd)',
    weight = 850,
    stack = false,
    close = true,
    description = 'Standard 10-round Barrett magazine.',
},

['mag_50bmg_victus'] = {
    label = 'Victus .50 BMG Magazine (5rd)',
    weight = 480,
    stack = false,
    close = true,
    description = 'Standard 5-round Victus magazine.',
},

-- Tranquilizer Dart Magazine
['mag_dart_standard'] = {
    label = 'Dart Gun Magazine (3rd)',
    weight = 45,
    stack = false,
    close = true,
    description = '3-dart magazine for tranquilizer gun.',
},

-- ============================================================================
-- SPEEDLOADERS
-- ============================================================================

['speedloader_357'] = {
    label = '.357 Magnum Speedloader',
    weight = 120,
    stack = false,
    close = true,
    description = '6-round .357 Magnum speedloader.',
},

['speedloader_38'] = {
    label = '.38 Special Speedloader (6rd)',
    weight = 95,
    stack = false,
    close = true,
    description = '6-round .38 Special speedloader.',
},

['speedloader_38_5rd'] = {
    label = '.38 Special Speedloader (5rd)',
    weight = 85,
    stack = false,
    close = true,
    description = '5-round .38 Special speedloader for J-frames.',
},

['speedloader_taurus856'] = {
    label = 'Taurus 856 Speedloader',
    weight = 90,
    stack = false,
    close = true,
    description = '6-round Taurus 856 speedloader.',
},

['speedloader_44'] = {
    label = '.44 Magnum Speedloader',
    weight = 180,
    stack = false,
    close = true,
    description = '6-round .44 Magnum speedloader.',
},

['speedloader_500'] = {
    label = '.500 S&W Speedloader',
    weight = 280,
    stack = false,
    close = true,
    description = '5-round .500 S&W speedloader.',
},

-- ============================================================================
-- MODIFICATION COMPONENTS
-- ============================================================================

['glock_switch'] = {
    label = 'Glock Auto Sear',
    weight = 50,
    stack = false,
    close = true,
    description = 'Universal auto sear for Glock pistols. Enables full-auto fire.',
},

['bump_stock'] = {
    label = 'AR-15 Bump Stock',
    weight = 450,
    stack = false,
    close = true,
    description = 'Universal bump stock for AR-15 platform rifles.',
},

['smg_switch'] = {
    label = 'SMG Auto Conversion',
    weight = 65,
    stack = false,
    close = true,
    description = 'Auto conversion for compatible SMGs.',
},

['ak_bumpstock'] = {
    label = 'AK Bump Stock',
    weight = 480,
    stack = false,
    close = true,
    description = 'Bump stock for AK platform rifles.',
},
