SELECT
    hoheitsgrenzpunkt.t_id AS tid,
    hoheitsgrenzpunkt.entstehung,
    hoheitsgrenzpunkt.identifikator,
    hoheitsgrenzpunkt.geometrie,
    hoheitsgrenzpunkt.lagegen,
    lagezuv.itfcode AS lagezuv,
    hoheitsgrenzpunkt.lagezuv AS lagezuv_txt,
    versicherungsart.itfcode AS punktzeichen,
    hoheitsgrenzpunkt.punktzeichen AS punktzeichen_txt,
    hgp_hoheitsgrenzsteint.itfcode AS hoheitsgrenzstein,
    hoheitsgrenzpunkt.hoheitsgrenzstein AS hoheitsgrenzstein_txt,
    hgp_exaktdefiniert.itfcode AS exaktdefiniert,
    hoheitsgrenzpunkt.exaktdefiniert AS exaktdefiniert_txt,
    hoheitsgrenzpunkt.nbident,
    CAST(hoheitsgrenzpunkt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunkt AS hoheitsgrenzpunkt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hoheitsgrenzpunkt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS lagezuv
        ON hoheitsgrenzpunkt.lagezuv = lagezuv.ilicode
    LEFT JOIN agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunkt_exaktdefiniert AS hgp_exaktdefiniert
        ON hoheitsgrenzpunkt.exaktdefiniert = hgp_exaktdefiniert.ilicode
    LEFT JOIN agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunkt_hoheitsgrenzstein AS hgp_hoheitsgrenzsteint
        ON hoheitsgrenzpunkt.hoheitsgrenzstein = hgp_hoheitsgrenzsteint.ilicode
    LEFT JOIN agi_dm01avso24.versicherungsart AS versicherungsart
        ON hoheitsgrenzpunkt.punktzeichen = versicherungsart.ilicode
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
