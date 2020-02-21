SELECT
    lokalisationsnamepos.pos AS wkb_geometry,
    lokalisationsnamepos.ori AS namori,
    CASE 
        WHEN lokalisationsnamepos.hali = 'Left'
            THEN 0   
        WHEN lokalisationsnamepos.hali = 'Center'
            THEN 1   
        WHEN lokalisationsnamepos.hali = 'Right'
            THEN 2   
    END AS namhali,
    CASE 
        WHEN lokalisationsnamepos.vali = 'Top'
            THEN 0   
        WHEN lokalisationsnamepos.vali = 'Cap'
            THEN 1   
        WHEN lokalisationsnamepos.vali = 'Half'
            THEN 2   
        WHEN lokalisationsnamepos.vali = 'Base'
            THEN 3   
        WHEN lokalisationsnamepos.vali = 'Bottom'
            THEN 4   
    END AS namvali,
    CASE
        WHEN lokalisationsnamepos.ori >= 0 AND lokalisationsnamepos.ori < 100
            THEN (100-lokalisationsnamepos.ori)*0.9
        WHEN lokalisationsnamepos.ori = 100
            THEN 360
        WHEN lokalisationsnamepos.ori > 100 AND lokalisationsnamepos.ori <= 400
            THEN ((100-lokalisationsnamepos.ori)*0.9)+360
    END AS txt_rot,
    CAST(lokalisationsnamepos.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    lokalisationsname.atext AS strasse1,
    0 AS los
FROM
    agi_dm01avso24.gebaeudeadressen_lokalisationsnamepos AS lokalisationsnamepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lokalisationsnamepos.t_basket = basket.t_id
     LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisationsname AS lokalisationsname
        ON lokalisationsname.t_id = lokalisationsnamepos.lokalisationsnamepos_von
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
