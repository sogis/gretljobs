SELECT
    planpos.t_id AS tid,
    planpos.planpos_von,
    planpos.pos,
    planpos.ori,
    halignment.itfcode AS hali,
    planpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    planpos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    planpos.groesse AS groesse_txt,
    CAST(planpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.planeinteilungen_planpos AS planpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON planpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON planpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON planpos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON planpos.groesse = schriftgroesse.ilicode
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
