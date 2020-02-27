SELECT
    lfp3.t_id AS tid,
    lfp3.entstehung,
    lfp3.nbident,
    lfp3.nummer,
    lfp3.geometrie,
    lfp3.hoehegeom,
    lfp3.lagegen,
    lagezuv.itfcode AS lagezuv,
    lfp3.lagezuv AS lagezuv_txt,
    lfp3.hoehegen,
    hoehezuv.itfcode AS hoehezuv,
    lfp3.hoehezuv AS hoehezuv_txt,
    versicherungsart.itfcode AS punktzeichen,
    lfp3.punktzeichen AS punktzeichen_txt,
    lfp3_protokoll.itfcode AS protokoll,
    lfp3.protokoll AS protokoll_txt,
    CAST(lfp3.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie3_lfp3 AS lfp3
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp3.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS lagezuv
        ON lfp3.lagezuv = lagezuv.ilicode
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS hoehezuv
        ON lfp3.hoehezuv = hoehezuv.ilicode
    LEFT JOIN agi_dm01avso24.versicherungsart AS versicherungsart
        ON lfp3.punktzeichen = versicherungsart.ilicode
    LEFT JOIN agi_dm01avso24.fixpunktktgrie3_lfp3_protokoll AS lfp3_protokoll
        ON lfp3.protokoll = lfp3_protokoll.ilicode
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
