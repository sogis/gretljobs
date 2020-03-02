SELECT
    einzelpunktpos.t_id AS tid,
    einzelpunktpos.einzelpunktpos_von,
    einzelpunktpos.pos,
    einzelpunktpos.ori,
    halignment.itfcode AS hali,
    einzelpunktpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    einzelpunktpos.vali AS vali_txt,
    CAST(einzelpunktpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.rohrleitungen_einzelpunktpos AS einzelpunktpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON einzelpunktpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON einzelpunktpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON einzelpunktpos.vali = valignment.ilicode
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
