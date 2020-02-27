SELECT
    einzelpunkt.t_id AS tid,
    einzelpunkt.entstehung,
    einzelpunkt.identifikator,
    einzelpunkt.geometrie,
    einzelpunkt.lagegen,
    lagezuv.itfcode AS lagezuv,
    einzelpunkt.lagezuv AS lagezuv_txt,
    exaktdefiniert.itfcode AS exaktdefiniert,
    einzelpunkt.exaktdefiniert AS exaktdefiniert_txt,
    CAST(einzelpunkt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bodenbedeckung_einzelpunkt AS einzelpunkt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON einzelpunkt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS lagezuv
        ON einzelpunkt.lagezuv = lagezuv.ilicode
    LEFT JOIN agi_dm01avso24.bodenbedeckung_einzelpunkt_exaktdefiniert AS exaktdefiniert
        ON einzelpunkt.lagezuv = exaktdefiniert.ilicode
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
