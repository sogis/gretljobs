SELECT
    gelaendenamepos.pos AS wkb_geometry,
    gelaendenamepos.ori AS namori,
    CASE 
        WHEN gelaendenamepos.hali = 'Left'
            THEN 0   
        WHEN gelaendenamepos.hali = 'Center'
            THEN 1   
        WHEN gelaendenamepos.hali = 'Right'
            THEN 2   
    END AS namhali,
    CASE 
        WHEN gelaendenamepos.vali = 'Top'
            THEN 0   
        WHEN gelaendenamepos.vali = 'Cap'
            THEN 1   
        WHEN gelaendenamepos.vali = 'Half'
            THEN 2   
        WHEN gelaendenamepos.vali = 'Base'
            THEN 3   
        WHEN gelaendenamepos.vali = 'Bottom'
            THEN 4   
    END AS namvali,
    CASE 
        WHEN gelaendenamepos.groesse = 'klein'
            THEN 0
        WHEN gelaendenamepos.groesse = 'mittel'
            THEN 1
        WHEN gelaendenamepos.groesse = 'gross'
            THEN 2
    END AS namhoehe, 
    CASE
        WHEN gelaendenamepos.ori >= 0 AND gelaendenamepos.ori < 100
            THEN (100-gelaendenamepos.ori)*0.9
        WHEN gelaendenamepos.ori = 100
            THEN 360
        WHEN gelaendenamepos.ori > 100 AND gelaendenamepos.ori <= 400
            THEN ((100-gelaendenamepos.ori)*0.9)+360
    END AS txt_rot,
    CAST(gelaendename.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    gelaendename.aname AS name,
    0 AS los
FROM
    agi_dm01avso24.nomenklatur_gelaendename AS gelaendename
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gelaendename.t_basket = basket.t_id
     LEFT JOIN agi_dm01avso24.nomenklatur_gelaendenamepos AS gelaendenamepos
        ON gelaendenamepos.gelaendenamepos_von = gelaendename.t_id
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
