SELECT
    hilfsfixpunkt.t_id AS tid,
    hilfsfixpunkt.entstehung,
    hilfsfixpunkt.nbident,
    hilfsfixpunkt.nummer,
    hilfsfixpunkt.geometrie,
    hilfsfixpunkt.hoehegeom,
    hilfsfixpunkt.lagegen,
    lagezuv.itfcode AS lagezuv,
    hilfsfixpunkt.lagezuv AS lagezuv_txt,
    hilfsfixpunkt.hoehegen,
    hoehezuv.itfcode AS hoehezuv,
    hilfsfixpunkt.hoehezuv AS hoehezuv_txt,
    versicherungsart.itfcode AS punktzeichen,
    hilfsfixpunkt.punktzeichen AS punktzeichen_txt,
    hilfsfixpunkt_protokoll.itfcode AS protokoll,
    hilfsfixpunkt.protokoll AS protokoll_txt,
    CAST(hilfsfixpunkt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie3_hilfsfixpunkt AS hilfsfixpunkt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hilfsfixpunkt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS lagezuv
        ON hilfsfixpunkt.lagezuv = lagezuv.ilicode
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS hoehezuv
        ON hilfsfixpunkt.hoehezuv = hoehezuv.ilicode
    LEFT JOIN agi_dm01avso24.versicherungsart AS versicherungsart
        ON hilfsfixpunkt.punktzeichen = versicherungsart.ilicode
    LEFT JOIN agi_dm01avso24.fixpunktktgrie3_hilfsfixpunkt_protokoll AS hilfsfixpunkt_protokoll
        ON hilfsfixpunkt.protokoll = hilfsfixpunkt_protokoll.ilicode
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
