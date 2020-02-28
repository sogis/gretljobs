SELECT
    gelaendename.t_id AS tid,
    gelaendename.entstehung,
    gelaendename.aname AS name,
    CAST(gelaendename.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.nomenklatur_gelaendename AS gelaendename
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gelaendename.t_basket = basket.t_id
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
