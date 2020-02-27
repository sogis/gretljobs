SELECT
    flaechenelementsymbol.t_id AS tid,
    flaechenelementsymbol.flaechenelementsymbol_von,
    flaechenelementsymbol.pos,
    flaechenelementsymbol.ori,
    cast(flaechenelementsymbol.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.einzelobjekte_flaechenelementsymbol AS flaechenelementsymbol
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON flaechenelementsymbol.t_basket = basket.t_id
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
