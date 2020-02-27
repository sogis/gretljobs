SELECT
    boflaechesymb.t_id AS tid,
    boflaechesymb.boflaechesymbol_von,
    boflaechesymb.pos,
    boflaechesymb.ori,
    cast(boflaechesymb.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bodenbedeckung_boflaechesymbol AS boflaechesymb
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON boflaechesymb.t_basket = basket.t_id
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
