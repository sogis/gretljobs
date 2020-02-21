SELECT
    grundstueckpos.pos AS wkb_geometry,
    grundstueckpos.ori AS numori,
    CASE 
        WHEN grundstueckpos.hali = 'Left'
            THEN 0   
        WHEN grundstueckpos.hali = 'Center'
            THEN 1   
        WHEN grundstueckpos.hali = 'Right'
            THEN 2   
    END AS numhali,
    CASE 
        WHEN grundstueckpos.vali = 'Top'
            THEN 0   
        WHEN grundstueckpos.vali = 'Cap'
            THEN 1   
        WHEN grundstueckpos.vali = 'Half'
            THEN 2   
        WHEN grundstueckpos.vali = 'Base'
            THEN 3   
        WHEN grundstueckpos.vali = 'Bottom'
            THEN 4   
    END AS numvali,
    grundstueck.nummer,
    CAST(grundstueckpos.t_datasetname AS INT) AS gem_bfs,
    CASE
        WHEN grundstueckpos.ori >= 0 AND grundstueckpos.ori < 100
            THEN (100-grundstueckpos.ori)*0.9
        WHEN grundstueckpos.ori = 100
            THEN 360
        WHEN grundstueckpos.ori > 100 AND grundstueckpos.ori <= 400
            THEN ((100-grundstueckpos.ori)*0.9)+360
    END AS txt_rot,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.liegenschaften_grundstueckpos AS grundstueckpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON grundstueckpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
        ON grundstueckpos.grundstueckpos_von = grundstueck.t_id
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
