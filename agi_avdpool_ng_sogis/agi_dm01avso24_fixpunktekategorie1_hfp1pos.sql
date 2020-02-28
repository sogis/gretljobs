SELECT
    hfp1pos.t_id AS tid,
    hfp1pos.hfp1pos_von,
    hfp1pos.pos,
    hfp1pos.ori,
    halignment.itfcode AS hali,
    hfp1pos.hali AS hali_txt,
    valignment.itfcode AS vali,
    hfp1pos.vali AS vali_txt,
    CAST(hfp1pos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie1_hfp1pos AS hfp1pos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp1pos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON hfp1pos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON hfp1pos.vali = valignment.ilicode
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
