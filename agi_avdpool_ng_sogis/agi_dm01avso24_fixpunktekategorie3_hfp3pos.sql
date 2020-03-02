SELECT
    hfp3pos.t_id AS tid,
    hfp3pos.hfp3pos_von,
    hfp3pos.pos,
    hfp3pos.ori,
    halignment.itfcode AS hali,
    hfp3pos.hali AS hali_txt,
    valignment.itfcode AS vali,
    hfp3pos.vali AS vali_txt,
    CAST(hfp3pos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie3_hfp3pos AS hfp3pos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp3pos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON hfp3pos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON hfp3pos.vali = valignment.ilicode
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
