WITH 

aimport AS
(
    SELECT
        max(importdate) AS importdate, dataset
    FROM
        agi_dm01avso24.t_ili2db_import
    GROUP BY
        dataset 
),

lfp1 AS (
    SELECT
        'LFP1' AS typ_txt,
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
        pos.posX,
        pos.posY,
        trim(to_char(ST_X(lagefixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(lagefixpunkt.geometrie), '9999999.000')) AS koordinate,
        trim(to_char(ST_X(pos.pos), '9999999.000'))::NUMERIC AS posX,
        trim(to_char(ST_Y(pos.pos), '9999999.000'))::NUMERIC AS posY
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
),

lfp2 AS (
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
        trim(to_char(ST_X(lagefixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(lagefixpunkt.geometrie), '9999999.000')) AS koordinate,
        trim(to_char(ST_X(pos.pos), '9999999.000'))::NUMERIC AS posX,
        trim(to_char(ST_Y(pos.pos), '9999999.000'))::NUMERIC AS posY
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
),

lfp3 AS (
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
        trim(to_char(ST_X(lagefixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(lagefixpunkt.geometrie), '9999999.000')) AS koordinate,
        trim(to_char(ST_X(pos.pos), '9999999.000'))::NUMERIC AS posX,
        trim(to_char(ST_Y(pos.pos), '9999999.000'))::NUMERIC AS posY
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
),

hfp1 AS (
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
        trim(to_char(ST_X(hoehenfixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(hoehenfixpunkt.geometrie), '9999999.000')) AS koordinate,
        trim(to_char(ST_X(pos.pos), '9999999.000'))::NUMERIC AS posX,
        trim(to_char(ST_Y(pos.pos), '9999999.000'))::NUMERIC AS posY
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
),

hfp2 AS (
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
        trim(to_char(ST_X(hoehenfixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(hoehenfixpunkt.geometrie), '9999999.000')) AS koordinate,
        trim(to_char(ST_X(pos.pos), '9999999.000'))::NUMERIC AS posX,
        trim(to_char(ST_Y(pos.pos), '9999999.000'))::NUMERIC AS posY
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
),

hfp3 AS (    
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
        trim(to_char(ST_X(hoehenfixpunkt.geometrie), '9999999.000'))||' / '||trim(to_char(ST_Y(hoehenfixpunkt.geometrie), '9999999.000')) AS koordinate,
        trim(to_char(ST_X(pos.pos), '9999999.000'))::NUMERIC AS posX,
        trim(to_char(ST_Y(pos.pos), '9999999.000'))::NUMERIC AS posY
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
),

fp_union_all AS (
    SELECT typ_txt, nbident, nummer, hoehe, bfs_nr, lagegenauigkeit, hoehengenauigkeit, punktzeichen_txt, orientierung, hali, vali, importdatum, nachfuehrung, geometrie, koordinate, posX, posY FROM lfp1
    UNION ALL 
    SELECT typ_txt, nbident, nummer, hoehe, bfs_nr, lagegenauigkeit, hoehengenauigkeit, punktzeichen_txt, orientierung, hali, vali, importdatum, nachfuehrung, geometrie, koordinate, posX, posY FROM lfp2
    UNION ALL 
    SELECT typ_txt, nbident, nummer, hoehe, bfs_nr, lagegenauigkeit, hoehengenauigkeit, punktzeichen_txt, orientierung, hali, vali, importdatum, nachfuehrung, geometrie, koordinate, posX, posY FROM lfp3
    UNION ALL
    SELECT typ_txt, nbident, nummer, hoehe, bfs_nr, lagegenauigkeit, hoehengenauigkeit, punktzeichen_txt, orientierung, hali, vali, importdatum, nachfuehrung, geometrie, koordinate, posX, posY FROM hfp1
    UNION ALL
    SELECT typ_txt, nbident, nummer, hoehe, bfs_nr, lagegenauigkeit, hoehengenauigkeit, punktzeichen_txt, orientierung, hali, vali, importdatum, nachfuehrung, geometrie, koordinate, posX, posY FROM hfp2
    UNION ALL 
    SELECT typ_txt, nbident, nummer, hoehe, bfs_nr, lagegenauigkeit, hoehengenauigkeit, punktzeichen_txt, orientierung, hali, vali, importdatum, nachfuehrung, geometrie, koordinate, posX, posY FROM hfp3
)

SELECT 
    ${basket_tid} AS t_basket,
    fp.*
FROM 
    fp_union_all fp
;
