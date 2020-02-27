SELECT
    flurname.t_id AS tid,
    flurname.entstehung,
    flurname.aname AS name,
    flurname.geometrie,
    CAST(flurname.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.nomenklatur_flurname AS flurname
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON flurname.t_basket = basket.t_id
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
