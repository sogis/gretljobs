SELECT
    linienelement.t_id AS tid,
    linienelement.linienelement_von,
    linienelement.geometrie,
    cast(linienelement.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.einzelobjekte_linienelement AS linienelement
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON linienelement.t_basket = basket.t_id
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
