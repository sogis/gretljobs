SELECT
    hfp2pos.t_id AS tid,
    hfp2pos.hfp2pos_von,
    hfp2pos.pos,
    hfp2pos.ori,
    halignment.itfcode AS hali,
    hfp2pos.hali AS hali_txt,
    valignment.itfcode AS vali,
    hfp2pos.vali AS vali_txt,
    CAST(hfp2pos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie2_hfp2pos AS hfp2pos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp2pos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON hfp2pos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON hfp2pos.vali = valignment.ilicode
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
