--[[
    Magazine Items for ox_inventory
    ================================

    Add these items to your ox_inventory/data/items.lua

    Magazine Metadata Structure (for loaded magazines):
    {
        ammoType = 'fmj',    -- Type of ammo loaded
        count = 33,          -- Current round count
        maxCount = 33,       -- Magazine capacity (for reference)
    }

    Empty magazines have no metadata (or metadata with count = 0)

    ITEM NAMES MATCH Config.Magazines keys in shared/magazines.lua
]]

-- ============================================================================
-- COMPACT 9mm PISTOLS (G26, G43X, GX4, Hellcat)
-- ============================================================================

['mag_g26_standard'] = {
    label = 'Glock 26 Magazine (10rd)',
    weight = 80,
    stack = true,
    close = true,
    description = 'Standard 10-round magazine for Glock 26/G43X',
    client = {
        image = 'mag_g26_standard.png',
    }
},

['mag_g26_extended'] = {
    label = 'Glock 26 Extended (17rd)',
    weight = 120,
    stack = true,
    close = true,
    description = 'Extended 17-round magazine with basepad for Glock 26',
    client = {
        image = 'mag_g26_extended.png',
    }
},

['mag_g26_stick'] = {
    label = 'Glock 9mm Stick (33rd)',
    weight = 185,
    stack = true,
    close = true,
    description = '33-round stick magazine for compact Glocks',
    client = {
        image = 'mag_g26_stick.png',
    }
},

['mag_compact9_standard'] = {
    label = 'Compact 9mm Magazine (11rd)',
    weight = 75,
    stack = true,
    close = true,
    description = 'Standard magazine for GX4/Hellcat',
    client = {
        image = 'mag_compact9_standard.png',
    }
},

['mag_compact9_extended'] = {
    label = 'Compact 9mm Extended (15rd)',
    weight = 100,
    stack = true,
    close = true,
    description = 'Extended magazine for GX4/Hellcat',
    client = {
        image = 'mag_compact9_extended.png',
    }
},

-- ============================================================================
-- FULL-SIZE GLOCK 9mm (G17, G19, G45 series)
-- ============================================================================

['mag_glock9_standard'] = {
    label = 'Glock 9mm Magazine (17rd)',
    weight = 95,
    stack = true,
    close = true,
    description = 'Standard 17-round magazine for full-size Glocks',
    client = {
        image = 'mag_glock9_standard.png',
    }
},

['mag_glock9_extended'] = {
    label = 'Glock 9mm Stick (33rd)',
    weight = 185,
    stack = true,
    close = true,
    description = '33-round stick magazine for Glock 9mm pistols',
    client = {
        image = 'mag_glock9_extended.png',
    }
},

['mag_glock9_drum'] = {
    label = 'Glock 9mm Drum (50rd)',
    weight = 460,
    stack = false,
    close = true,
    description = '50-round drum magazine for Glock 9mm pistols',
    client = {
        image = 'mag_glock9_drum.png',
    }
},

-- ============================================================================
-- BERETTA 9mm
-- ============================================================================

['mag_beretta_standard'] = {
    label = 'Beretta 9mm Magazine (15rd)',
    weight = 90,
    stack = true,
    close = true,
    description = 'Standard magazine for Beretta M9/PX4',
    client = {
        image = 'mag_beretta_standard.png',
    }
},

['mag_beretta_m9a3'] = {
    label = 'Beretta M9A3 Magazine (17rd)',
    weight = 100,
    stack = true,
    close = true,
    description = '17-round magazine for Beretta M9A3',
    client = {
        image = 'mag_beretta_m9a3.png',
    }
},

['mag_beretta_extended'] = {
    label = 'Beretta 9mm Extended (30rd)',
    weight = 175,
    stack = true,
    close = true,
    description = 'Extended magazine for Beretta pistols',
    client = {
        image = 'mag_beretta_extended.png',
    }
},

-- ============================================================================
-- SIG SAUER 9mm
-- ============================================================================

['mag_sig_p210'] = {
    label = 'SIG P210 Magazine (8rd)',
    weight = 75,
    stack = true,
    close = true,
    description = 'Premium Swiss magazine for SIG P210',
    client = {
        image = 'mag_sig_p210.png',
    }
},

['mag_sig_standard'] = {
    label = 'SIG 9mm Magazine (15rd)',
    weight = 92,
    stack = true,
    close = true,
    description = 'Standard magazine for SIG P226/P229/P320',
    client = {
        image = 'mag_sig_standard.png',
    }
},

['mag_sig_extended'] = {
    label = 'SIG 9mm Extended (21rd)',
    weight = 135,
    stack = true,
    close = true,
    description = 'Extended magazine for SIG 9mm pistols',
    client = {
        image = 'mag_sig_extended.png',
    }
},

-- ============================================================================
-- OTHER 9mm PISTOLS
-- ============================================================================

['mag_fn509_standard'] = {
    label = 'FN 509 Magazine (17rd)',
    weight = 95,
    stack = true,
    close = true,
    description = 'Standard magazine for FN 509',
    client = {
        image = 'mag_fn509_standard.png',
    }
},

['mag_fn509_extended'] = {
    label = 'FN 509 Extended (24rd)',
    weight = 140,
    stack = true,
    close = true,
    description = 'Extended magazine for FN 509',
    client = {
        image = 'mag_fn509_extended.png',
    }
},

['mag_tp9sf_standard'] = {
    label = 'Canik TP9SF Magazine (18rd)',
    weight = 98,
    stack = true,
    close = true,
    description = 'Standard magazine for Canik TP9SF',
    client = {
        image = 'mag_tp9sf_standard.png',
    }
},

['mag_walther_standard'] = {
    label = 'Walther P88 Magazine (15rd)',
    weight = 90,
    stack = true,
    close = true,
    description = 'Standard magazine for Walther P88',
    client = {
        image = 'mag_walther_standard.png',
    }
},

['mag_rugersr9_standard'] = {
    label = 'Ruger SR9 Magazine (17rd)',
    weight = 95,
    stack = true,
    close = true,
    description = 'Standard magazine for Ruger SR9',
    client = {
        image = 'mag_rugersr9_standard.png',
    }
},

['mag_psadagger_standard'] = {
    label = 'PSA Dagger Magazine (15rd)',
    weight = 88,
    stack = true,
    close = true,
    description = 'Budget Glock-compatible magazine',
    client = {
        image = 'mag_psadagger_standard.png',
    }
},

-- ============================================================================
-- GLOCK .45 ACP
-- ============================================================================

['mag_glock45_standard'] = {
    label = 'Glock .45 Magazine (13rd)',
    weight = 120,
    stack = true,
    close = true,
    description = 'Standard magazine for Glock 21/41',
    client = {
        image = 'mag_glock45_standard.png',
    }
},

['mag_glock45_compact'] = {
    label = 'Glock 30 Magazine (10rd)',
    weight = 100,
    stack = true,
    close = true,
    description = 'Compact magazine for Glock 30',
    client = {
        image = 'mag_glock45_compact.png',
    }
},

['mag_glock45_extended'] = {
    label = 'Glock .45 Extended (26rd)',
    weight = 220,
    stack = true,
    close = true,
    description = 'Extended magazine for Glock .45 pistols',
    client = {
        image = 'mag_glock45_extended.png',
    }
},

-- ============================================================================
-- 1911 .45 ACP
-- ============================================================================

['mag_1911_standard'] = {
    label = '1911 Magazine (7rd)',
    weight = 85,
    stack = true,
    close = true,
    description = 'Standard 7-round 1911 magazine',
    client = {
        image = 'mag_1911_standard.png',
    }
},

['mag_1911_8rd'] = {
    label = '1911 Magazine (8rd)',
    weight = 90,
    stack = true,
    close = true,
    description = '8-round 1911 magazine',
    client = {
        image = 'mag_1911_8rd.png',
    }
},

['mag_1911_extended'] = {
    label = '1911 Extended (10rd)',
    weight = 110,
    stack = true,
    close = true,
    description = 'Extended 10-round 1911 magazine',
    client = {
        image = 'mag_1911_extended.png',
    }
},

['mag_sigp220_standard'] = {
    label = 'SIG P220 Magazine (8rd)',
    weight = 95,
    stack = true,
    close = true,
    description = 'Standard magazine for SIG P220',
    client = {
        image = 'mag_sigp220_standard.png',
    }
},

-- ============================================================================
-- .40 S&W
-- ============================================================================

['mag_glock40_standard'] = {
    label = 'Glock .40 Magazine (15rd)',
    weight = 105,
    stack = true,
    close = true,
    description = 'Standard magazine for Glock 22',
    client = {
        image = 'mag_glock40_standard.png',
    }
},

['mag_glock40_compact'] = {
    label = 'Glock Demon Magazine (13rd)',
    weight = 95,
    stack = true,
    close = true,
    description = 'Compact magazine for Glock Demon',
    client = {
        image = 'mag_glock40_compact.png',
    }
},

['mag_glock40_extended'] = {
    label = 'Glock .40 Extended (22rd)',
    weight = 160,
    stack = true,
    close = true,
    description = 'Extended magazine for Glock .40 pistols',
    client = {
        image = 'mag_glock40_extended.png',
    }
},

-- ============================================================================
-- 5.7x28mm
-- ============================================================================

['mag_57_standard'] = {
    label = '5.7x28mm Magazine (20rd)',
    weight = 85,
    stack = true,
    close = true,
    description = 'Standard magazine for FN Five-seveN / Ruger-57',
    client = {
        image = 'mag_57_standard.png',
    }
},

['mag_57_extended'] = {
    label = '5.7x28mm Extended (30rd)',
    weight = 125,
    stack = true,
    close = true,
    description = 'Extended magazine for 5.7x28mm pistols',
    client = {
        image = 'mag_57_extended.png',
    }
},

-- ============================================================================
-- .22 LR
-- ============================================================================

['mag_22_standard'] = {
    label = '.22 LR Magazine (10rd)',
    weight = 45,
    stack = true,
    close = true,
    description = 'Standard magazine for .22 LR pistols',
    client = {
        image = 'mag_22_standard.png',
    }
},

['mag_fn502_standard'] = {
    label = 'FN 502 Magazine (15rd)',
    weight = 55,
    stack = true,
    close = true,
    description = 'Standard magazine for FN 502 Tactical',
    client = {
        image = 'mag_fn502_standard.png',
    }
},

['mag_pmr30_standard'] = {
    label = 'PMR-30 Magazine (30rd)',
    weight = 75,
    stack = true,
    close = true,
    description = '30-round magazine for Kel-Tec PMR-30',
    client = {
        image = 'mag_pmr30_standard.png',
    }
},

-- ============================================================================
-- 10mm AUTO
-- ============================================================================

['mag_10mm_standard'] = {
    label = 'Glock 20 Magazine (15rd)',
    weight = 125,
    stack = true,
    close = true,
    description = 'Standard 10mm magazine for Glock 20',
    client = {
        image = 'mag_10mm_standard.png',
    }
},

['mag_10mm_extended'] = {
    label = 'Glock 20 Extended (30rd)',
    weight = 230,
    stack = true,
    close = true,
    description = 'Extended 10mm magazine for Glock 20',
    client = {
        image = 'mag_10mm_extended.png',
    }
},

-- ============================================================================
-- 9mm SMGs
-- ============================================================================

['mag_mp5_standard'] = {
    label = 'MP5 Magazine (30rd)',
    weight = 165,
    stack = true,
    close = true,
    description = 'Standard curved magazine for H&K MP5',
    client = {
        image = 'mag_mp5_standard.png',
    }
},

['mag_mpx_standard'] = {
    label = 'MPX Magazine (30rd)',
    weight = 160,
    stack = true,
    close = true,
    description = 'Standard magazine for SIG MPX',
    client = {
        image = 'mag_mpx_standard.png',
    }
},

['mag_scorpion_standard'] = {
    label = 'Scorpion EVO Magazine (30rd)',
    weight = 155,
    stack = true,
    close = true,
    description = 'Standard magazine for CZ Scorpion EVO 3',
    client = {
        image = 'mag_scorpion_standard.png',
    }
},

['mag_scorpion_drum'] = {
    label = 'Scorpion EVO Drum (50rd)',
    weight = 380,
    stack = false,
    close = true,
    description = '50-round drum for CZ Scorpion EVO 3',
    client = {
        image = 'mag_scorpion_drum.png',
    }
},

['mag_tec9_standard'] = {
    label = 'TEC-9 Magazine (32rd)',
    weight = 170,
    stack = true,
    close = true,
    description = 'Standard magazine for Intratec TEC-9',
    client = {
        image = 'mag_tec9_standard.png',
    }
},

['mag_mpa30_standard'] = {
    label = 'MPA30 Magazine (30rd)',
    weight = 165,
    stack = true,
    close = true,
    description = 'Standard magazine for MasterPiece Arms MPA30',
    client = {
        image = 'mag_mpa30_standard.png',
    }
},

['mag_sub2000_standard'] = {
    label = 'SUB-2000 Magazine (33rd)',
    weight = 185,
    stack = true,
    close = true,
    description = 'Glock-compatible magazine for Kel-Tec SUB-2000',
    client = {
        image = 'mag_sub2000_standard.png',
    }
},

['mag_ram9_standard'] = {
    label = 'RAM-9 Magazine (33rd)',
    weight = 180,
    stack = true,
    close = true,
    description = 'Magazine for RAM-9 Desert',
    client = {
        image = 'mag_ram9_standard.png',
    }
},

-- ============================================================================
-- .45 ACP SMGs (MAC-10/MAC-4A1)
-- ============================================================================

['mag_mac_standard'] = {
    label = 'MAC .45 Magazine (30rd)',
    weight = 195,
    stack = true,
    close = true,
    description = 'Standard .45 ACP magazine for MAC-10',
    client = {
        image = 'mag_mac_standard.png',
    }
},

['mag_mac_extended'] = {
    label = 'MAC .45 Extended (50rd)',
    weight = 320,
    stack = true,
    close = true,
    description = 'Extended .45 ACP magazine for MAC-10',
    client = {
        image = 'mag_mac_extended.png',
    }
},

-- ============================================================================
-- 5.56 NATO RIFLES
-- ============================================================================

['mag_556_standard'] = {
    label = 'STANAG Magazine (30rd)',
    weight = 130,
    stack = true,
    close = true,
    description = 'Standard 5.56 NATO STANAG magazine',
    client = {
        image = 'mag_556_standard.png',
    }
},

['mag_556_extended'] = {
    label = 'STANAG Extended (40rd)',
    weight = 175,
    stack = true,
    close = true,
    description = 'Extended 5.56 NATO magazine',
    client = {
        image = 'mag_556_extended.png',
    }
},

['mag_556_drum'] = {
    label = '5.56 Drum Magazine (60rd)',
    weight = 520,
    stack = false,
    close = true,
    description = '60-round drum for 5.56 NATO rifles',
    client = {
        image = 'mag_556_drum.png',
    }
},

-- ============================================================================
-- 6.8x51mm RIFLES
-- ============================================================================

['mag_68x51_standard'] = {
    label = '6.8x51mm Magazine (20rd)',
    weight = 145,
    stack = true,
    close = true,
    description = 'Magazine for SIG SPEAR / XM7',
    client = {
        image = 'mag_68x51_standard.png',
    }
},

-- ============================================================================
-- .300 BLACKOUT RIFLES
-- ============================================================================

['mag_300blk_standard'] = {
    label = '.300 BLK Magazine (30rd)',
    weight = 155,
    stack = true,
    close = true,
    description = 'Magazine for .300 Blackout rifles',
    client = {
        image = 'mag_300blk_standard.png',
    }
},

-- ============================================================================
-- AR-9 PISTOLS/PCCs
-- ============================================================================

['mag_ar9_standard'] = {
    label = 'AR-9 Magazine (17rd)',
    weight = 95,
    stack = true,
    close = true,
    description = 'Glock-style magazine for AR-9 pistols',
    client = {
        image = 'mag_ar9_standard.png',
    }
},

['mag_ar9_extended'] = {
    label = 'AR-9 Extended (33rd)',
    weight = 185,
    stack = true,
    close = true,
    description = 'Extended magazine for AR-9 pistols',
    client = {
        image = 'mag_ar9_extended.png',
    }
},

-- ============================================================================
-- REVOLVER SPEEDLOADERS
-- ============================================================================
-- Note: Speedloaders have fixed capacity (cylinder size).
-- They only provide faster reload, not capacity increase.

['speedloader_357'] = {
    label = '.357 Magnum Speedloader',
    weight = 120,
    stack = true,
    close = true,
    description = '6-round speedloader for .357 Magnum revolvers',
    client = {
        image = 'speedloader_357.png',
    }
},

['speedloader_38'] = {
    label = '.38 Special Speedloader',
    weight = 95,
    stack = true,
    close = true,
    description = '6-round speedloader for .38 Special revolvers',
    client = {
        image = 'speedloader_38.png',
    }
},

['speedloader_44'] = {
    label = '.44 Magnum Speedloader',
    weight = 180,
    stack = true,
    close = true,
    description = '6-round speedloader for .44 Magnum revolvers',
    client = {
        image = 'speedloader_44.png',
    }
},

['speedloader_500'] = {
    label = '.500 S&W Speedloader',
    weight = 280,
    stack = true,
    close = true,
    description = '5-round speedloader for S&W 500',
    client = {
        image = 'speedloader_500.png',
    }
},
