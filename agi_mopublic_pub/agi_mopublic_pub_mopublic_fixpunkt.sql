SELECT
    0 AS typ,
    'LFP1' AS typ_txt,
    lagefixpunkt.nbident, 
    lagefixpunkt.nummer,
    lagefixpunkt.hoehegeom AS hoehe,
    lagefixpunkt.gem_bfs AS bfs_nr,
    lagefixpunkt.lagegen AS lagegenauigkeit,
    lagefixpunkt.hoehegen AS hoehengenauigkeit,
    CASE 
        WHEN lagefixpunkt.punktzeichen IS NULL 
            THEN 7 -- should not reach here
        ELSE lagefixpunkt.punktzeichen
    END AS punktzeichen,
    CASE 
        WHEN lagefixpunkt.punktzeichen_txt IS NULL 
            THEN 'weitere' -- should not reach here
        ELSE lagefixpunkt.punktzeichen_txt
    END AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL 
            THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL 
            THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    lagefixpunkt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    lagefixpunkt.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie1_lfp1 AS lagefixpunkt
    LEFT JOIN av_avdpool_ng.fixpunktekategorie1_lfp1pos AS pos 
        ON pos.lfp1pos_von = lagefixpunkt.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie1_lfp1nachfuehrung AS nachfuehrung
        ON lagefixpunkt.entstehung = nachfuehrung.tid

UNION ALL

SELECT
    1 AS typ,
    'LFP2' AS typ_txt,
    lagefixpunkt.nbident, 
    lagefixpunkt.nummer,
    lagefixpunkt.hoehegeom AS hoehe,
    lagefixpunkt.gem_bfs AS bfs_nr,
    lagefixpunkt.lagegen AS lagegenauigkeit,
    lagefixpunkt.hoehegen AS hoehengenauigkeit,
    CASE 
        WHEN lagefixpunkt.punktzeichen IS NULL 
            THEN 7 -- should not reach here
        ELSE lagefixpunkt.punktzeichen
    END AS punktzeichen,
    CASE 
        WHEN lagefixpunkt.punktzeichen_txt IS NULL 
            THEN 'weitere' -- should not reach here
        ELSE lagefixpunkt.punktzeichen_txt
    END AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL 
            THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL 
            THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    lagefixpunkt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    lagefixpunkt.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie2_lfp2 AS lagefixpunkt
    LEFT JOIN av_avdpool_ng.fixpunktekategorie2_lfp2pos AS pos 
        ON pos.lfp2pos_von = lagefixpunkt.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie2_lfp2nachfuehrung AS nachfuehrung
        ON lagefixpunkt.entstehung = nachfuehrung.tid

UNION ALL

SELECT
    2 AS typ,
    'LFP3' AS typ_txt,
    lagefixpunkt.nbident, 
    lagefixpunkt.nummer,
    lagefixpunkt.hoehegeom AS hoehe,
    lagefixpunkt.gem_bfs AS bfs_nr,
    lagefixpunkt.lagegen AS lagegenauigkeit,
    lagefixpunkt.hoehegen AS hoehengenauigkeit,
    CASE 
        WHEN lagefixpunkt.punktzeichen IS NULL 
            THEN 7 -- should not reach here
        ELSE lagefixpunkt.punktzeichen
    END AS punktzeichen,
    CASE 
        WHEN lagefixpunkt.punktzeichen_txt IS NULL 
            THEN 'weitere' -- should not reach here
        ELSE lagefixpunkt.punktzeichen_txt
    END AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL 
            THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL 
            THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    lagefixpunkt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    lagefixpunkt.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie3_lfp3 AS lagefixpunkt
    LEFT JOIN av_avdpool_ng.fixpunktekategorie3_lfp3pos AS pos 
        ON pos.lfp3pos_von = lagefixpunkt.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie3_lfp3nachfuehrung AS nachfuehrung
        ON lagefixpunkt.entstehung = nachfuehrung.tid
    
UNION ALL

SELECT
    3 AS typ,
    'HFP1' AS typ_txt,
    hoehenfixpunkt.nbident, 
    hoehenfixpunkt.nummer,
    hoehenfixpunkt.hoehegeom AS hoehe,
    hoehenfixpunkt.gem_bfs AS bfs_nr,
    hoehenfixpunkt.lagegen AS lagegenauigkeit,
    hoehenfixpunkt.hoehegen AS hoehengenauigkeit,
    7 AS punktzeichen,
    'weitere' AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL 
            THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL 
            THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    hoehenfixpunkt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    hoehenfixpunkt.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie1_hfp1 AS hoehenfixpunkt
    LEFT JOIN av_avdpool_ng.fixpunktekategorie1_hfp1pos AS pos 
        ON pos.hfp1pos_von = hoehenfixpunkt.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie1_hfp1nachfuehrung AS nachfuehrung
        ON hoehenfixpunkt.entstehung = nachfuehrung.tid

UNION ALL

SELECT
    4 AS typ,
    'HFP2' AS typ_txt,
    hoehenfixpunkt.nbident, 
    hoehenfixpunkt.nummer,
    hoehenfixpunkt.hoehegeom AS hoehe,
    hoehenfixpunkt.gem_bfs AS bfs_nr,
    hoehenfixpunkt.lagegen AS lagegenauigkeit,
    hoehenfixpunkt.hoehegen AS hoehengenauigkeit,
    7 AS punktzeichen,
    'weitere' AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL 
            THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL 
            THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    hoehenfixpunkt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    hoehenfixpunkt.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie2_hfp2 AS hoehenfixpunkt
    LEFT JOIN av_avdpool_ng.fixpunktekategorie2_hfp2pos AS pos 
        ON pos.hfp2pos_von = hoehenfixpunkt.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie2_hfp2nachfuehrung AS nachfuehrung
        ON hoehenfixpunkt.entstehung = nachfuehrung.tid

UNION ALL
    
SELECT
    5 AS typ,
    'HFP3' AS typ_txt,
    hoehenfixpunkt.nbident, 
    hoehenfixpunkt.nummer,
    hoehenfixpunkt.hoehegeom AS hoehe,
    hoehenfixpunkt.gem_bfs AS bfs_nr,
    hoehenfixpunkt.lagegen AS lagegenauigkeit,
    hoehenfixpunkt.hoehegen AS hoehengenauigkeit,
    7 AS punktzeichen,
    'weitere' AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali_txt IS NULL 
            THEN 'Left'
        ELSE pos.hali_txt
    END AS hali,
    CASE 
        WHEN pos.vali_txt IS NULL 
            THEN 'Bottom'
        ELSE pos.vali_txt
    END AS vali,
    hoehenfixpunkt.lieferdatum AS importdatum,
    to_date(nachfuehrung.gueltigereintrag, 'YYYYMMDD') AS nachfuehrung,
    hoehenfixpunkt.geometrie,
    pos.pos
FROM
    av_avdpool_ng.fixpunktekategorie3_hfp3 AS hoehenfixpunkt
    LEFT JOIN av_avdpool_ng.fixpunktekategorie3_hfp3pos AS pos 
        ON pos.hfp3pos_von = hoehenfixpunkt.tid
    LEFT JOIN av_avdpool_ng.fixpunktekategorie3_hfp3nachfuehrung AS nachfuehrung
        ON hoehenfixpunkt.entstehung = nachfuehrung.tid
;