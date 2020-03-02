SELECT
    liegenschaft.t_id AS tid,
    liegenschaft.liegenschaft_von,
    liegenschaft.nummerteilgrundstueck,
    liegenschaft.geometrie,
    liegenschaft.flaechenmass,
    CAST(liegenschaft.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.liegenschaften_liegenschaft AS liegenschaft
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON liegenschaft.t_basket = basket.t_id
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
