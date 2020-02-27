SELECT
    hfp3.t_id AS tid,
    hfp3.entstehung,
    hfp3.nbident,
    hfp3.nummer,
    hfp3.geometrie,
    hfp3.hoehegeom,
    hfp3.lagegen,
    lagezuv.itfcode AS lagezuv,
    hfp3.lagezuv AS lagezuv_txt,
    hfp3.hoehegen,
    hoehezuv.itfcode AS hoehezuv,
    hfp3.hoehezuv AS hoehezuv_txt,
    CAST(hfp3.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie3_hfp3 AS hfp3
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp3.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS lagezuv
        ON hfp3.lagezuv = lagezuv.ilicode
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS hoehezuv
        ON hfp3.hoehezuv = hoehezuv.ilicode
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
