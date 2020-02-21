SELECT
    ortsnamepos.pos AS wkb_geometry,
    ortsnamepos.ori AS namori,
    CASE 
        WHEN ortsnamepos.hali = 'Left'
            THEN 0   
        WHEN ortsnamepos.hali = 'Center'
            THEN 1   
        WHEN ortsnamepos.hali = 'Right'
            THEN 2   
    END AS namhali,
    CASE 
        WHEN ortsnamepos.vali = 'Top'
            THEN 0   
        WHEN ortsnamepos.vali = 'Cap'
            THEN 1   
        WHEN ortsnamepos.vali = 'Half'
            THEN 2   
        WHEN ortsnamepos.vali = 'Base'
            THEN 3   
        WHEN ortsnamepos.vali = 'Bottom'
            THEN 4   
    END AS namvali,
    CASE 
        WHEN ortsnamepos.groesse = 'klein'
            THEN 0
        WHEN ortsnamepos.groesse = 'mittel'
            THEN 1
        WHEN ortsnamepos.groesse = 'gross'
            THEN 2
    END AS namhoehe,       
    ortsname.aname AS name,
    CAST(ortsnamepos.t_datasetname AS INT) AS gem_bfs,
    CASE
        WHEN ortsnamepos.ori >= 0 AND ortsnamepos.ori < 100
            THEN (100-ortsnamepos.ori)*0.9
        WHEN ortsnamepos.ori = 100
            THEN 360
        WHEN ortsnamepos.ori > 100 AND ortsnamepos.ori <= 400
            THEN ((100-ortsnamepos.ori)*0.9)+360
    END AS txt_rot,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.nomenklatur_ortsnamepos AS ortsnamepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON ortsnamepos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.nomenklatur_ortsname AS ortsname
        ON ortsname.t_id = ortsnamepos.ortsnamepos_von
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
