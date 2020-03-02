SELECT
    signalpunktpos.t_id AS tid,
    signalpunktpos.signalpunktpos_von,
    signalpunktpos.pos,
    signalpunktpos.ori,
    halignment.itfcode AS hali,
    signalpunktpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    signalpunktpos.vali AS vali_txt,
    CAST(signalpunktpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.rohrleitungen_signalpunktpos AS signalpunktpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON signalpunktpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON signalpunktpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON signalpunktpos.vali = valignment.ilicode
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
