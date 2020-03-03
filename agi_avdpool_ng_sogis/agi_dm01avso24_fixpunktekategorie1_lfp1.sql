SELECT
    lfp1.t_id AS tid,
    lfp1.entstehung,
    lfp1.nbident,
    lfp1.nummer,
    lfp1.geometrie,
    lfp1.hoehegeom,
    lfp1.lagegen,
    lagezuv.itfcode AS lagezuv,
    lfp1.lagezuv AS lagezuv_txt,
    lfp1.hoehegen,
    hoehezuv.itfcode AS hoehezuv,
    lfp1.hoehezuv AS hoehezuv_txt,
    lfp1_begehbarkeit.itfcode AS begehbarkeit,
    lfp1.begehbarkeit AS begehbarkeit_txt,
    versicherungsart.itfcode AS punktzeichen,
    lfp1.punktzeichen AS punktzeichen_txt,
    CAST(lfp1.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie1_lfp1 AS lfp1
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp1.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS lagezuv
        ON lfp1.lagezuv = lagezuv.ilicode
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS hoehezuv
        ON lfp1.hoehezuv = hoehezuv.ilicode
    LEFT JOIN agi_dm01avso24.fixpunktktgrie1_lfp1_begehbarkeit AS lfp1_begehbarkeit
        ON lfp1.begehbarkeit = lfp1_begehbarkeit.ilicode
    LEFT JOIN agi_dm01avso24.versicherungsart AS versicherungsart
        ON lfp1.punktzeichen = versicherungsart.ilicode
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
