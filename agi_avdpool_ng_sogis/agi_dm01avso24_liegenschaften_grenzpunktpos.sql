SELECT
    grenzpunktpos.t_id AS tid,
    grenzpunktpos.grenzpunktpos_von,
    grenzpunktpos.pos,
    grenzpunktpos.ori,
    halignment.itfcode AS hali,
    grenzpunktpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    grenzpunktpos.vali AS vali_txt,
    CAST(grenzpunktpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.liegenschaften_grenzpunktpos AS grenzpunktpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON grenzpunktpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON grenzpunktpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON grenzpunktpos.vali = valignment.ilicode
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
