SELECT
    1 AS typ,
    'LFP1' AS typ_txt,
    lfp.nbident, 
    lfp.nummer,
    lfp.hoehegeom AS hoehe,
    lfp.gem_bfs AS bfs_nr,
    lfp.lagegen AS lagegenauigkeit,
    lfp.hoehegen AS hoehengenauigkeit,
    CASE 
        WHEN lfp.punktzeichen IS NULL THEN 7 -- should not reach here
        ELSE lfp.punktzeichen
    END AS punktzeichen,
    CASE 
        WHEN lfp.punktzeichen_txt IS NULL THEN 'weitere' -- should not reach here
        ELSE lfp.punktzeichen_txt
    END AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    lfp.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    lfp.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie1_lfp1 AS lfp
    LEFT JOIN av_avdpool_ng.fixpunktekategorie1_lfp1pos AS pos 
    ON pos.lfp1pos_von = lfp.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie1_lfp1nachfuehrung AS nf
    ON lfp.entstehung = nf.tid

UNION ALL

SELECT
    2 AS typ,
    'LFP2' AS typ_txt,
    lfp.nbident, 
    lfp.nummer,
    lfp.hoehegeom AS hoehe,
    lfp.gem_bfs AS bfs_nr,
    lfp.lagegen AS lagegenauigkeit,
    lfp.hoehegen AS hoehengenauigkeit,
    CASE 
        WHEN lfp.punktzeichen IS NULL THEN 7 -- should not reach here
        ELSE lfp.punktzeichen
    END AS punktzeichen,
    CASE 
        WHEN lfp.punktzeichen_txt IS NULL THEN 'weitere' -- should not reach here
        ELSE lfp.punktzeichen_txt
    END AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    lfp.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    lfp.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie2_lfp2 AS lfp
    LEFT JOIN av_avdpool_ng.fixpunktekategorie2_lfp2pos AS pos 
    ON pos.lfp2pos_von = lfp.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie2_lfp2nachfuehrung AS nf
    ON lfp.entstehung = nf.tid

UNION ALL

SELECT
    3 AS typ,
    'LFP3' AS typ_txt,
    lfp.nbident, 
    lfp.nummer,
    lfp.hoehegeom AS hoehe,
    lfp.gem_bfs AS bfs_nr,
    lfp.lagegen AS lagegenauigkeit,
    lfp.hoehegen AS hoehengenauigkeit,
    CASE 
        WHEN lfp.punktzeichen IS NULL THEN 7 -- should not reach here
        ELSE lfp.punktzeichen
    END AS punktzeichen,
    CASE 
        WHEN lfp.punktzeichen_txt IS NULL THEN 'weitere' -- should not reach here
        ELSE lfp.punktzeichen_txt
    END AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    lfp.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    lfp.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie3_lfp3 AS lfp
    LEFT JOIN av_avdpool_ng.fixpunktekategorie3_lfp3pos AS pos 
    ON pos.lfp3pos_von = lfp.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie3_lfp3nachfuehrung AS nf
    ON lfp.entstehung = nf.tid
    
UNION ALL

SELECT
    4 AS typ,
    'HFP1' AS typ_txt,
    hfp.nbident, 
    hfp.nummer,
    hfp.hoehegeom AS hoehe,
    hfp.gem_bfs AS bfs_nr,
    hfp.lagegen AS lagegenauigkeit,
    hfp.hoehegen AS hoehengenauigkeit,
    7 AS punktzeichen,
    'weitere' AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    hfp.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    hfp.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie1_hfp1 AS hfp
    LEFT JOIN av_avdpool_ng.fixpunktekategorie1_hfp1pos AS pos 
    ON pos.hfp1pos_von = hfp.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie1_hfp1nachfuehrung AS nf
    ON hfp.entstehung = nf.tid

UNION ALL

SELECT
    5 AS typ,
    'HFP2' AS typ_txt,
    hfp.nbident, 
    hfp.nummer,
    hfp.hoehegeom AS hoehe,
    hfp.gem_bfs AS bfs_nr,
    hfp.lagegen AS lagegenauigkeit,
    hfp.hoehegen AS hoehengenauigkeit,
    7 AS punktzeichen,
    'weitere' AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    hfp.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    hfp.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie2_hfp2 AS hfp
    LEFT JOIN av_avdpool_ng.fixpunktekategorie2_hfp2pos AS pos 
    ON pos.hfp2pos_von = hfp.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie2_hfp2nachfuehrung AS nf
    ON hfp.entstehung = nf.tid

UNION ALL
    
SELECT
    6 AS typ,
    'HFP3' AS typ_txt,
    hfp.nbident, 
    hfp.nummer,
    hfp.hoehegeom AS hoehe,
    hfp.gem_bfs AS bfs_nr,
    hfp.lagegen AS lagegenauigkeit,
    hfp.hoehegen AS hoehengenauigkeit,
    7 AS punktzeichen,
    'weitere' AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    hfp.lieferdatum AS importdatum,
    to_date(nf.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    hfp.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie3_hfp3 AS hfp
    LEFT JOIN av_avdpool_ng.fixpunktekategorie3_hfp3pos AS pos 
    ON pos.hfp3pos_von = hfp.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie3_hfp3nachfuehrung AS nf
    ON hfp.entstehung = nf.tid;