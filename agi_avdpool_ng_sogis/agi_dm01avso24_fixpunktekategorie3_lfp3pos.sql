SELECT
    lfp3pos.t_id AS tid,
    lfp3pos.lfp3pos_von,
    lfp3pos.pos,
    lfp3pos.ori,
    halignment.itfcode AS hali,
    lfp3pos.hali AS hali_txt,
    valignment.itfcode AS vali,
    lfp3pos.vali AS vali_txt,
    CAST(lfp3pos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie3_lfp3pos AS lfp3pos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp3pos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON lfp3pos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON lfp3pos.vali = valignment.ilicode
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
