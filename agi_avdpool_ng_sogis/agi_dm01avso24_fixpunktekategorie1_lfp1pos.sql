SELECT
    lfp1pos.t_id AS tid,
    lfp1pos.lfp1pos_von,
    lfp1pos.pos,
    lfp1pos.ori,
    halignment.itfcode AS hali,
    lfp1pos.hali AS hali_txt,
    valignment.itfcode AS vali,
    lfp1pos.vali AS vali_txt,
    CAST(lfp1pos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie1_lfp1pos AS lfp1pos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp1pos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON lfp1pos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON lfp1pos.vali = valignment.ilicode
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
