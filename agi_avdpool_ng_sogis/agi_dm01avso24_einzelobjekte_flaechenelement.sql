SELECT
    flaechenelement.t_id AS tid,
    flaechenelement.flaechenelement_von,
    flaechenelement.geometrie,
    cast(flaechenelement.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.einzelobjekte_flaechenelement AS flaechenelement
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON flaechenelement.t_basket = basket.t_id
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
