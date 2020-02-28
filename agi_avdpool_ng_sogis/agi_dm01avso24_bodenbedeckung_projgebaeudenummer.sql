SELECT
    projgebaeudenummer.t_id AS tid,
    projgebaeudenummer.projgebaeudenummer_von,
    projgebaeudenummer.nummer,
    projgebaeudenummer.gwr_egid,
    CAST(projgebaeudenummer.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bodenbedeckung_projgebaeudenummer AS projgebaeudenummer
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON projgebaeudenummer.t_basket = basket.t_id
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
