SELECT
    projliegenschaft.geometrie AS wkb_geometry,
    0 AS art,
    projgrundstueck.nummer,
    CAST(projliegenschaft.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.liegenschaften_projliegenschaft AS projliegenschaft
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON projliegenschaft.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.liegenschaften_projgrundstueck AS projgrundstueck
        ON projgrundstueck.t_id = projliegenschaft.projliegenschaft_von
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
