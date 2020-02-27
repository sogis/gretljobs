SELECT
    hoehenpunktpos.t_id AS tid,
    hoehenpunktpos.hoehenpunktpos_von,
    hoehenpunktpos.pos,
    hoehenpunktpos.ori,
    halignment.itfcode AS hali,
    hoehenpunktpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    hoehenpunktpos.vali AS vali_txt,
    CAST(hoehenpunktpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.hoehen_hoehenpunktpos AS hoehenpunktpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hoehenpunktpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON hoehenpunktpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON hoehenpunktpos.vali = valignment.ilicode
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
