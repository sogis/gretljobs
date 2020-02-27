SELECT
    lfp2.t_id AS tid,
    lfp2.entstehung,
    lfp2.nbident,
    lfp2.nummer,
    lfp2.geometrie,
    lfp2.hoehegeom,
    lfp2.lagegen,
    lagezuv.itfcode AS lagezuv,
    lfp2.lagezuv AS lagezuv_txt,
    lfp2.hoehegen,
    hoehezuv.itfcode AS hoehezuv,
    lfp2.hoehezuv AS hoehezuv_txt,
    lfp2_begehbarkeit.itfcode AS begehbarkeit,
    lfp2.begehbarkeit AS begehbarkeit_txt,
    versicherungsart.itfcode AS punktzeichen,
    lfp2.punktzeichen AS punktzeichen_txt,
    CAST(lfp2.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie2_lfp2 AS lfp2
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp2.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS lagezuv
        ON lfp2.lagezuv = lagezuv.ilicode
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS hoehezuv
        ON lfp2.hoehezuv = hoehezuv.ilicode
    LEFT JOIN agi_dm01avso24.fixpunktktgrie2_lfp2_begehbarkeit AS lfp2_begehbarkeit
        ON lfp2.begehbarkeit = lfp2_begehbarkeit.ilicode
    LEFT JOIN agi_dm01avso24.versicherungsart AS versicherungsart
        ON lfp2.punktzeichen = versicherungsart.ilicode
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
