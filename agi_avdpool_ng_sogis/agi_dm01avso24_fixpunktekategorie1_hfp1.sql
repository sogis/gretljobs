SELECT
    hfp1.t_id AS tid,
    hfp1.entstehung,
    hfp1.nbident,
    hfp1.nummer,
    hfp1.geometrie,
    hfp1.hoehegeom,
    hfp1.lagegen,
    lagezuv.itfcode AS lagezuv,
    hfp1.lagezuv AS lagezuv_txt,
    hfp1.hoehegen,
    hoehezuv.itfcode AS hoehezuv,
    hfp1.hoehezuv AS hoehezuv_txt,
    CAST(hfp1.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie1_hfp1 AS hfp1
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp1.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS lagezuv
        ON hfp1.lagezuv = lagezuv.ilicode
    LEFT JOIN agi_dm01avso24.zuverlaessigkeit AS hoehezuv
        ON hfp1.hoehezuv = hoehezuv.ilicode
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
