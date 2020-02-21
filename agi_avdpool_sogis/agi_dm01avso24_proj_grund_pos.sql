SELECT
    projgrundstueckpos.pos AS wkb_geometry,
    projgrundstueckpos.ori AS numori,
    CASE 
        WHEN projgrundstueckpos.hali = 'Left'
            THEN 0   
        WHEN projgrundstueckpos.hali = 'Center'
            THEN 1   
        WHEN projgrundstueckpos.hali = 'Right'
            THEN 2   
    END AS numhali,
    CASE 
        WHEN projgrundstueckpos.vali = 'Top'
            THEN 0   
        WHEN projgrundstueckpos.vali = 'Cap'
            THEN 1   
        WHEN projgrundstueckpos.vali = 'Half'
            THEN 2   
        WHEN projgrundstueckpos.vali = 'Base'
            THEN 3   
        WHEN projgrundstueckpos.vali = 'Bottom'
            THEN 4   
    END AS numvali,
    projgrundstueck.nummer,
    CAST(projgrundstueckpos.t_datasetname AS INT) AS gem_bfs,
    CASE
        WHEN projgrundstueckpos.ori >= 0 AND projgrundstueckpos.ori < 100
            THEN (100-projgrundstueckpos.ori)*0.9
        WHEN projgrundstueckpos.ori = 100
            THEN 360
        WHEN projgrundstueckpos.ori > 100 AND projgrundstueckpos.ori <= 400
            THEN ((100-projgrundstueckpos.ori)*0.9)+360
    END AS txt_rot,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.liegenschaften_projgrundstueckpos AS projgrundstueckpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON projgrundstueckpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.liegenschaften_projgrundstueck AS projgrundstueck
        ON projgrundstueckpos.projgrundstueckpos_von = projgrundstueck.t_id
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
