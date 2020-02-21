SELECT
    lfp3.geometrie AS wkb_geometry,
    lfp3.nummer,
    lfp3pos.ori AS numori,
    CASE 
        WHEN lfp3pos.hali = 'Left'
            THEN 0   
        WHEN lfp3pos.hali = 'Center'
            THEN 1   
        WHEN lfp3pos.hali = 'Right'
            THEN 2   
    END AS numhali,
    CASE 
        WHEN lfp3pos.vali = 'Top'
            THEN 0   
        WHEN lfp3pos.vali = 'Cap'
            THEN 1   
        WHEN lfp3pos.vali = 'Half'
            THEN 2   
        WHEN lfp3pos.vali = 'Base'
            THEN 3   
        WHEN lfp3pos.vali = 'Bottom'
            THEN 4   
    END AS numvali,
    lfp3.hoehegeom AS hoehegeo,
    CASE
        WHEN lfp3pos.ori >= 0 AND lfp3pos.ori < 100
            THEN (100-lfp3pos.ori)*0.9
        WHEN lfp3pos.ori = 100
            THEN 360
        WHEN lfp3pos.ori > 100 AND lfp3pos.ori <= 400
            THEN ((100-lfp3pos.ori)*0.9)+360
    END AS txt_rot,
    CAST(lfp3.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    CASE 
        WHEN lfp3.punktzeichen = 'Stein'
            THEN 0   
        WHEN lfp3.punktzeichen = 'Kunststoffzeichen'
            THEN 0   
        WHEN lfp3.punktzeichen = 'Bolzen'
            THEN 1   
        WHEN lfp3.punktzeichen = 'Rohr'
            THEN 1   
        WHEN lfp3.punktzeichen = 'Pfahl'
            THEN 1   
        WHEN lfp3.punktzeichen = 'Kreuz'
            THEN 2   
        WHEN lfp3.punktzeichen = 'unversichert'
            THEN 3   
        WHEN lfp3.punktzeichen = 'weitere'
            THEN 3   
    END AS punktzeich,
    0 AS los
FROM
    agi_dm01avso24.fixpunktekatgrie3_lfp3 AS lfp3
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp3.t_basket = basket.t_id
     LEFT JOIN agi_dm01avso24.fixpunktekatgrie3_lfp3pos AS lfp3pos
        ON lfp3pos.lfp3pos_von = lfp3.t_id
   LEFT JOIN 
    (
        SELECT
            max(importdate) AS importdate,
            dataset
        FROM
            agi_dm01avso24.t_ili2db_import
        GROUP BY
            dataset 
    ) AS  aimport
        ON basket.dataset = aimport.dataset
;
