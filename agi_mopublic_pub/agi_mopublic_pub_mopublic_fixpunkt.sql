WITH aimport AS
(
    SELECT
        max(importdate) AS importdate, dataset
    FROM
        agi_dm01avso24.t_ili2db_import
    GROUP BY
        dataset 
)
SELECT
    'LFP1' AS typ_txt,
    lagefixpunkt.nbident, 
    lagefixpunkt.nummer,
    lagefixpunkt.hoehegeom AS hoehe,
    CAST(SUBSTRING(lagefixpunkt.t_datasetname,1,4) AS INT) AS bfs_nr,
    lagefixpunkt.lagegen AS lagegenauigkeit,
    lagefixpunkt.hoehegen AS hoehengenauigkeit,
    CASE 
        WHEN lagefixpunkt.punktzeichen IS NULL 
            THEN 'weitere' -- should not reach here
        ELSE lagefixpunkt.punktzeichen
    END AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali IS NULL 
            THEN 'Left'
        ELSE pos.hali
    END AS hali,
    CASE 
        WHEN pos.vali IS NULL 
            THEN 'Bottom'
        ELSE pos.vali
    END AS vali,
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    lagefixpunkt.geometrie,
    pos.pos,
    trim(to_char(ST_X(lagefixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(lagefixpunkt.geometrie), '9999999.000')) AS koordinate
FROM
    agi_dm01avso24.fixpunktekatgrie1_lfp1 AS lagefixpunkt
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie1_lfp1pos AS pos 
        ON pos.lfp1pos_von = lagefixpunkt.t_id
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie1_lfp1nachfuehrung AS nachfuehrung
        ON lagefixpunkt.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lagefixpunkt.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
        
UNION ALL

SELECT
    'LFP2' AS typ_txt,
    lagefixpunkt.nbident, 
    lagefixpunkt.nummer,
    lagefixpunkt.hoehegeom AS hoehe,
    CAST(lagefixpunkt.t_datasetname AS INT) AS bfs_nr,    
    lagefixpunkt.lagegen AS lagegenauigkeit,
    lagefixpunkt.hoehegen AS hoehengenauigkeit,
    CASE 
        WHEN lagefixpunkt.punktzeichen IS NULL 
            THEN 'weitere' -- should not reach here
        ELSE lagefixpunkt.punktzeichen
    END AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali IS NULL 
            THEN 'Left'
        ELSE pos.hali
    END AS hali,
    CASE 
        WHEN pos.vali IS NULL 
            THEN 'Bottom'
        ELSE pos.vali
    END AS vali,
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    lagefixpunkt.geometrie,
    pos.pos,
    trim(to_char(ST_X(lagefixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(lagefixpunkt.geometrie), '9999999.000')) AS koordinate
FROM
    agi_dm01avso24.fixpunktekatgrie2_lfp2 AS lagefixpunkt
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie2_lfp2pos AS pos 
        ON pos.lfp2pos_von = lagefixpunkt.t_id
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie2_lfp2nachfuehrung AS nachfuehrung
        ON lagefixpunkt.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lagefixpunkt.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    

UNION ALL

SELECT
    'LFP3' AS typ_txt,
    lagefixpunkt.nbident, 
    lagefixpunkt.nummer,
    lagefixpunkt.hoehegeom AS hoehe,
    CAST(lagefixpunkt.t_datasetname AS INT) AS bfs_nr,    
    lagefixpunkt.lagegen AS lagegenauigkeit,
    lagefixpunkt.hoehegen AS hoehengenauigkeit,
    CASE 
        WHEN lagefixpunkt.punktzeichen IS NULL 
            THEN 'weitere' -- should not reach here
        ELSE lagefixpunkt.punktzeichen
    END AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali IS NULL 
            THEN 'Left'
        ELSE pos.hali
    END AS hali,
    CASE 
        WHEN pos.vali IS NULL 
            THEN 'Bottom'
        ELSE pos.vali
    END AS vali,
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    lagefixpunkt.geometrie,
    pos.pos,
    trim(to_char(ST_X(lagefixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(lagefixpunkt.geometrie), '9999999.000')) AS koordinate
FROM
    agi_dm01avso24.fixpunktekatgrie3_lfp3 AS lagefixpunkt
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie3_lfp3pos AS pos 
        ON pos.lfp3pos_von = lagefixpunkt.t_id
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie3_lfp3nachfuehrung AS nachfuehrung
        ON lagefixpunkt.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lagefixpunkt.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    

UNION ALL

SELECT
    'HFP1' AS typ_txt,
    hoehenfixpunkt.nbident, 
    hoehenfixpunkt.nummer,
    hoehenfixpunkt.hoehegeom AS hoehe,
    CAST(hoehenfixpunkt.t_datasetname AS INT) AS bfs_nr,    
    hoehenfixpunkt.lagegen AS lagegenauigkeit,
    hoehenfixpunkt.hoehegen AS hoehengenauigkeit,
    'weitere' AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali IS NULL 
            THEN 'Left'
        ELSE pos.hali
    END AS hali,
    CASE 
        WHEN pos.vali IS NULL 
            THEN 'Bottom'
        ELSE pos.vali
    END AS vali,
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    hoehenfixpunkt.geometrie,
    pos.pos,
    trim(to_char(ST_X(hoehenfixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(hoehenfixpunkt.geometrie), '9999999.000')) AS koordinate
FROM
    agi_dm01avso24.fixpunktekatgrie1_hfp1 AS hoehenfixpunkt
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie1_hfp1pos AS pos 
        ON pos.hfp1pos_von = hoehenfixpunkt.t_id
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie1_hfp1nachfuehrung AS nachfuehrung
        ON hoehenfixpunkt.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hoehenfixpunkt.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    

UNION ALL

SELECT
    'HFP2' AS typ_txt,
    hoehenfixpunkt.nbident, 
    hoehenfixpunkt.nummer,
    hoehenfixpunkt.hoehegeom AS hoehe,
    CAST(hoehenfixpunkt.t_datasetname AS INT) AS bfs_nr,    
    hoehenfixpunkt.lagegen AS lagegenauigkeit,
    hoehenfixpunkt.hoehegen AS hoehengenauigkeit,
    'weitere' AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali IS NULL 
            THEN 'Left'
        ELSE pos.hali
    END AS hali,
    CASE 
        WHEN pos.vali IS NULL 
            THEN 'Bottom'
        ELSE pos.vali
    END AS vali,
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    hoehenfixpunkt.geometrie,
    pos.pos,
    trim(to_char(ST_X(hoehenfixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(hoehenfixpunkt.geometrie), '9999999.000')) AS koordinate
FROM
    agi_dm01avso24.fixpunktekatgrie2_hfp2 AS hoehenfixpunkt
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie2_hfp2pos AS pos 
        ON pos.hfp2pos_von = hoehenfixpunkt.t_id
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie2_hfp2nachfuehrung AS nachfuehrung
        ON hoehenfixpunkt.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hoehenfixpunkt.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    

UNION ALL
    
SELECT
    'HFP3' AS typ_txt,
    hoehenfixpunkt.nbident, 
    hoehenfixpunkt.nummer,
    hoehenfixpunkt.hoehegeom AS hoehe,
    CAST(hoehenfixpunkt.t_datasetname AS INT) AS bfs_nr,    
    hoehenfixpunkt.lagegen AS lagegenauigkeit,
    hoehenfixpunkt.hoehegen AS hoehengenauigkeit,
    'weitere' AS punktzeichen_txt,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali IS NULL 
            THEN 'Left'
        ELSE pos.hali
    END AS hali,
    CASE 
        WHEN pos.vali IS NULL 
            THEN 'Bottom'
        ELSE pos.vali
    END AS vali,
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    hoehenfixpunkt.geometrie,
    pos.pos,
    trim(to_char(ST_X(hoehenfixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(hoehenfixpunkt.geometrie), '9999999.000')) AS koordinate
FROM
    agi_dm01avso24.fixpunktekatgrie3_hfp3 AS hoehenfixpunkt
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie3_hfp3pos AS pos 
        ON pos.hfp3pos_von = hoehenfixpunkt.t_id
    LEFT JOIN agi_dm01avso24.fixpunktekatgrie3_hfp3nachfuehrung AS nachfuehrung
        ON hoehenfixpunkt.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hoehenfixpunkt.t_basket = basket.t_id
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
;
