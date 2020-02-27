SELECT
    grenzpunkt.t_id AS tid,
    grenzpunkt.entstehung,
    grenzpunkt.identifikator,
    grenzpunkt.geometrie,
    grenzpunkt.lagegen,
    lagezuv.itfcode AS lagezuv,
    grenzpunkt.lagezuv AS lagezuv_txt,
    versicherungsart.itfcode AS punktzeichen,
    grenzpunkt.punktzeichen AS punktzeichen_txt,
    gp_exaktdefiniert.itfcode AS exaktdefiniert,
    grenzpunkt.exaktdefiniert AS exaktdefiniert_txt,
    gp_hoheitsgrenzsteint.itfcode AS hoheitsgrenzsteinalt,
    grenzpunkt.hoheitsgrenzsteinalt AS hoheitsgrenzsteinalt_txt,
    CAST(grenzpunkt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.liegenschaften_grenzpunkt AS grenzpunkt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON grenzpunkt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS lagezuv
        ON grenzpunkt.lagezuv = lagezuv.ilicode
    LEFT JOIN agi_dm01avso24.liegenschaften_grenzpunkt_exaktdefiniert AS gp_exaktdefiniert
        ON grenzpunkt.exaktdefiniert = gp_exaktdefiniert.ilicode
    LEFT JOIN agi_dm01avso24.liegenschaften_grenzpunkt_hoheitsgrenzsteinalt AS gp_hoheitsgrenzsteint
        ON grenzpunkt.hoheitsgrenzsteinalt = gp_hoheitsgrenzsteint.ilicode
    LEFT JOIN agi_dm01avso24.versicherungsart AS versicherungsart
        ON grenzpunkt.punktzeichen = versicherungsart.ilicode
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
