SELECT
    lfp2pos.t_id AS tid,
    lfp2pos.lfp2pos_von,
    lfp2pos.pos,
    lfp2pos.ori,
    halignment.itfcode AS hali,
    lfp2pos.hali AS hali_txt,
    valignment.itfcode AS vali,
    lfp2pos.vali AS vali_txt,
    CAST(lfp2pos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie2_lfp2pos AS lfp2pos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp2pos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON lfp2pos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON lfp2pos.vali = valignment.ilicode
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
