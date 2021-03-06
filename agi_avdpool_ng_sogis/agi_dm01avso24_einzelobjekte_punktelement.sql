SELECT
    punktelement.t_id AS tid,
    punktelement.punktelement_von,
    punktelement.geometrie,
    punktelement.ori,
    CAST(punktelement.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.einzelobjekte_punktelement AS punktelement
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON punktelement.t_basket = basket.t_id
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
