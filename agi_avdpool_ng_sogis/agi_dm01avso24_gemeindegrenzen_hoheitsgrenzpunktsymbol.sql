SELECT
    hoheitsgrenzpunktsymb.t_id AS tid,
    hoheitsgrenzpunktsymb.hoheitsgrenzpunktsymbol_von,
    hoheitsgrenzpunktsymb.ori,
    cast(hoheitsgrenzpunktsymb.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunktsymbol AS hoheitsgrenzpunktsymb
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hoheitsgrenzpunktsymb.t_basket = basket.t_id
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
