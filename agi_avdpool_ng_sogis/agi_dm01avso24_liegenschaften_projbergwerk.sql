SELECT
    projbergwerk.t_id AS tid,
    projbergwerk.projbergwerk_von,
    projbergwerk.nummerteilgrundstueck,
    projbergwerk.geometrie,
    projbergwerk.flaechenmass,
    CAST(projbergwerk.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.liegenschaften_projbergwerk AS projbergwerk
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON projbergwerk.t_basket = basket.t_id
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
