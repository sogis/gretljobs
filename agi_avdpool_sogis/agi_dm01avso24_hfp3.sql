SELECT
    hfp3.geometrie AS wkb_geometry,
    hfp3.nummer,
    hfp3.hoehegeom AS hoehegeo,
    hfp3pos.ori AS numori,
    CASE 
        WHEN hfp3pos.hali = 'Left'
            THEN 0   
        WHEN hfp3pos.hali = 'Center'
            THEN 1   
        WHEN hfp3pos.hali = 'Right'
            THEN 2   
    END AS numhali,
    CASE 
        WHEN hfp3pos.vali = 'Top'
            THEN 0   
        WHEN hfp3pos.vali = 'Cap'
            THEN 1   
        WHEN hfp3pos.vali = 'Half'
            THEN 2   
        WHEN hfp3pos.vali = 'Base'
            THEN 3   
        WHEN hfp3pos.vali = 'Bottom'
            THEN 4   
    END AS numvali,
    CASE
        WHEN hfp3pos.ori >= 0 AND hfp3pos.ori < 100
            THEN (100-hfp3pos.ori)*0.9
        WHEN hfp3pos.ori = 100
            THEN 360
        WHEN hfp3pos.ori > 100 AND hfp3pos.ori <= 400
            THEN ((100-hfp3pos.ori)*0.9)+360
    END AS txt_rot,
    CAST(hfp3.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    0 AS los
FROM
    agi_dm01avso24.fixpunktekatgrie3_hfp3 AS hfp3
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp3.t_basket = basket.t_id
     LEFT JOIN agi_dm01avso24.fixpunktekatgrie3_hfp3pos AS hfp3pos
        ON hfp3pos.hfp3pos_von = hfp3.t_id
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
