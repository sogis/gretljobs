SELECT
    objektnummer.t_id AS tid,
    objektnummer.objektnummer_von,
    objektnummer.nummer,
    objektnummer.gwr_egid,
    CAST(objektnummer.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.einzelobjekte_objektnummer AS objektnummer
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON objektnummer.t_basket = basket.t_id
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
