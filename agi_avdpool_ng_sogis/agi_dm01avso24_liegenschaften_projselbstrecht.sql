SELECT
    projselbstrecht.t_id AS tid,
    projselbstrecht.projselbstrecht_von,
    projselbstrecht.nummerteilgrundstueck,
    projselbstrecht.geometrie,
    projselbstrecht.flaechenmass,
    CAST(projselbstrecht.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.liegenschaften_projselbstrecht AS projselbstrecht
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON projselbstrecht.t_basket = basket.t_id
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
