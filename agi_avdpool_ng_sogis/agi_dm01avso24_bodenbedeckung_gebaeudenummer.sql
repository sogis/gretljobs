SELECT
    gebaeudenummer.t_id AS tid,
    gebaeudenummer.gebaeudenummer_von,
    gebaeudenummer.nummer,
    gebaeudenummer.gwr_egid,
    CAST(gebaeudenummer.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bodenbedeckung_gebaeudenummer AS gebaeudenummer
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gebaeudenummer.t_basket = basket.t_id
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
