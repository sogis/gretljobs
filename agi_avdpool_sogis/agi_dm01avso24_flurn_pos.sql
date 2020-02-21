SELECT
    flurnamepos.pos AS wkb_geometry,
    flurnamepos.ori AS namori,
    CASE 
        WHEN flurnamepos.hali = 'Left'
            THEN 0   
        WHEN flurnamepos.hali = 'Center'
            THEN 1   
        WHEN flurnamepos.hali = 'Right'
            THEN 2   
    END AS namhali,
    CASE 
        WHEN flurnamepos.vali = 'Top'
            THEN 0   
        WHEN flurnamepos.vali = 'Cap'
            THEN 1   
        WHEN flurnamepos.vali = 'Half'
            THEN 2   
        WHEN flurnamepos.vali = 'Base'
            THEN 3   
        WHEN flurnamepos.vali = 'Bottom'
            THEN 4   
    END AS namvali,
    CASE 
        WHEN flurnamepos.groesse = 'klein'
            THEN 0
        WHEN flurnamepos.groesse = 'mittel'
            THEN 1
        WHEN flurnamepos.groesse = 'gross'
            THEN 2
    END AS namhoehe,       
    flurname.aname AS name,
    CAST(flurnamepos.t_datasetname AS INT) AS gem_bfs,
    CASE
        WHEN flurnamepos.ori >= 0 AND flurnamepos.ori < 100
            THEN (100-flurnamepos.ori)*0.9
        WHEN flurnamepos.ori = 100
            THEN 360
        WHEN flurnamepos.ori > 100 AND flurnamepos.ori <= 400
            THEN ((100-flurnamepos.ori)*0.9)+360
    END AS txt_rot,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.nomenklatur_flurnamepos AS flurnamepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON flurnamepos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.nomenklatur_flurname AS flurname
        ON flurnamepos.flurnamepos_von = flurname.t_id
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
