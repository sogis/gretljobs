SELECT
    hoheitsgrenzpunktpos.t_id AS tid,
    hoheitsgrenzpunktpos.hoheitsgrenzpunktpos_von,
    hoheitsgrenzpunktpos.pos,
    hoheitsgrenzpunktpos.ori,
    halignment.itfcode AS hali,
    hoheitsgrenzpunktpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    hoheitsgrenzpunktpos.vali AS vali_txt,
    CAST(hoheitsgrenzpunktpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gemeindegrenzen_hoheitsgrenzpunktpos AS hoheitsgrenzpunktpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hoheitsgrenzpunktpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON hoheitsgrenzpunktpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON hoheitsgrenzpunktpos.vali = valignment.ilicode
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
