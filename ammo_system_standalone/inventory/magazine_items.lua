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
]]

-- ============================================================================
-- PISTOL MAGAZINES
-- ============================================================================

-- Glock 26 (Compact 9mm)
['mag_g26_standard'] = {
    label = 'Glock 26 Magazine (10rd)',
    weight = 80,
    stack = true, -- Empty mags stack
    close = true,
    description = 'Standard 10-round magazine for Glock 26',
    client = {
        image = 'mag_g26_standard.png',
    }
},

['mag_g26_extended'] = {
    label = 'Glock 26 Extended Mag (33rd)',
    weight = 180,
    stack = true,
    close = true,
    description = 'Extended 33-round stick magazine for Glock 26',
    client = {
        image = 'mag_g26_extended.png',
    }
},

['mag_g26_drum'] = {
    label = 'Glock 26 Drum (50rd)',
    weight = 450,
    stack = false, -- Drums don't stack due to size
    close = true,
    description = '50-round drum magazine for Glock 26',
    client = {
        image = 'mag_g26_drum.png',
    }
},

['mag_g26switch_extended'] = {
    label = 'Glock 26 Switch Mag (33rd)',
    weight = 180,
    stack = true,
    close = true,
    description = '33-round magazine for Glock 26 with switch',
    client = {
        image = 'mag_g26_extended.png',
    }
},

-- Glock Full-Size 9mm (17/19/45 series)
['mag_glock_standard'] = {
    label = 'Glock 9mm Magazine (17rd)',
    weight = 95,
    stack = true,
    close = true,
    description = 'Standard 17-round magazine for full-size Glocks',
    client = {
        image = 'mag_glock_standard.png',
    }
},

['mag_glock_extended'] = {
    label = 'Glock 9mm Extended (33rd)',
    weight = 185,
    stack = true,
    close = true,
    description = '33-round stick magazine for Glock 9mm pistols',
    client = {
        image = 'mag_glock_extended.png',
    }
},

['mag_glock_drum'] = {
    label = 'Glock 9mm Drum (50rd)',
    weight = 460,
    stack = false,
    close = true,
    description = '50-round drum magazine for Glock 9mm pistols',
    client = {
        image = 'mag_glock_drum.png',
    }
},

['mag_g19x_switch'] = {
    label = 'G19X Switch Magazine (33rd)',
    weight = 185,
    stack = true,
    close = true,
    description = '33-round magazine for Glock 19X with switch',
    client = {
        image = 'mag_glock_extended.png',
    }
},

-- Glock .45 ACP
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

-- 1911 .45 ACP
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

['mag_1911_extended'] = {
    label = '1911 Extended Mag (10rd)',
    weight = 110,
    stack = true,
    close = true,
    description = 'Extended 10-round 1911 magazine',
    client = {
        image = 'mag_1911_extended.png',
    }
},

-- Beretta 9mm
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

-- SIG Sauer 9mm
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

-- ============================================================================
-- REVOLVER SPEEDLOADERS
-- ============================================================================

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

-- ============================================================================
-- PDW / SPECIALTY MAGAZINES
-- ============================================================================

['mag_fiveseven_standard'] = {
    label = 'FN 5.7 Magazine (20rd)',
    weight = 85,
    stack = true,
    close = true,
    description = 'Standard magazine for FN Five-seveN / Ruger-57',
    client = {
        image = 'mag_fiveseven_standard.png',
    }
},

['mag_fiveseven_extended'] = {
    label = 'FN 5.7 Extended (30rd)',
    weight = 125,
    stack = true,
    close = true,
    description = 'Extended magazine for 5.7x28mm pistols',
    client = {
        image = 'mag_fiveseven_extended.png',
    }
},

['mag_22lr_standard'] = {
    label = '.22 LR Magazine (10rd)',
    weight = 45,
    stack = true,
    close = true,
    description = 'Standard magazine for .22 LR pistols',
    client = {
        image = 'mag_22lr_standard.png',
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

['mag_glock20_standard'] = {
    label = 'Glock 20 Magazine (15rd)',
    weight = 125,
    stack = true,
    close = true,
    description = 'Standard 10mm magazine for Glock 20',
    client = {
        image = 'mag_glock20_standard.png',
    }
},

['mag_glock20_extended'] = {
    label = 'Glock 20 Extended (30rd)',
    weight = 230,
    stack = true,
    close = true,
    description = 'Extended 10mm magazine for Glock 20',
    client = {
        image = 'mag_glock20_extended.png',
    }
},

-- ============================================================================
-- SMG MAGAZINES
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

['mag_scorpion_extended'] = {
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

['mag_mac10_standard'] = {
    label = 'MAC-10 Magazine (30rd)',
    weight = 195,
    stack = true,
    close = true,
    description = 'Standard .45 ACP magazine for MAC-10',
    client = {
        image = 'mag_mac10_standard.png',
    }
},

['mag_mac10_extended'] = {
    label = 'MAC-10 Extended (50rd)',
    weight = 320,
    stack = true,
    close = true,
    description = 'Extended .45 ACP magazine for MAC-10',
    client = {
        image = 'mag_mac10_extended.png',
    }
},

-- ============================================================================
-- RIFLE MAGAZINES
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
