SELECT
    hfp2.t_id AS tid,
    hfp2.entstehung,
    hfp2.nbident,
    hfp2.nummer,
    hfp2.geometrie,
    hfp2.hoehegeom,
    hfp2.lagegen,
    lagezuv.itfcode AS lagezuv,
    hfp2.lagezuv AS lagezuv_txt,
    hfp2.hoehegen,
    hoehezuv.itfcode AS hoehezuv,
    hfp2.hoehezuv AS hoehezuv_txt,
    CAST(hfp2.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie2_hfp2 AS hfp2
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp2.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS lagezuv
        ON hfp2.lagezuv = lagezuv.ilicode
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS hoehezuv
        ON hfp2.hoehezuv = hoehezuv.ilicode
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
