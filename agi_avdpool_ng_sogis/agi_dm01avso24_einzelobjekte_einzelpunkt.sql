SELECT
    einzelpunkt.t_id AS tid,
    einzelpunkt.entstehung,
    einzelpunkt.identifikator,
    einzelpunkt.geometrie,
    einzelpunkt.lagegen,
    zuverlaessigkeit.itfcode AS lagezuv,
    einzelpunkt.lagezuv AS lagezuv_txt,
    exaktdefiniert.itfcode AS exaktdefiniert,
    einzelpunkt.exaktdefiniert AS exaktdefiniert_txt,
    cast(einzelpunkt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.einzelobjekte_einzelpunkt AS einzelpunkt
    LEFT JOIN agi_dm01avso24.einzelobjekte_einzelpunkt_exaktdefiniert AS exaktdefiniert
        ON einzelpunkt.exaktdefiniert = exaktdefiniert.ilicode
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON einzelpunkt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS zuverlaessigkeit
        ON einzelpunkt.lagezuv = zuverlaessigkeit.ilicode
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
