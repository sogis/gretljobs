SELECT
    hoehenpunkt.t_id AS tid,
    hoehenpunkt.entstehung,
    hoehenpunkt.geometrie,
    qualitaetsstandard.itfcode AS qualitaet,
    hoehenpunkt.qualitaet AS qualitaet_txt,
    CAST(hoehenpunkt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.hoehen_hoehenpunkt AS hoehenpunkt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hoehenpunkt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.qualitaetsstandard AS qualitaetsstandard
        ON hoehenpunkt.qualitaet = qualitaetsstandard.ilicode
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
