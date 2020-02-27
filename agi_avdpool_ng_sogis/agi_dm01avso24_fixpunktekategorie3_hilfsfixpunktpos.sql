SELECT
    hilfsfixpunktpos.t_id AS tid,
    hilfsfixpunktpos.hilfsfixpunktpos_von,
    hilfsfixpunktpos.pos,
    hilfsfixpunktpos.ori,
    halignment.itfcode AS hali,
    hilfsfixpunktpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    hilfsfixpunktpos.vali AS vali_txt,
    CAST(hilfsfixpunktpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie3_hilfsfixpunktpos AS hilfsfixpunktpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hilfsfixpunktpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON hilfsfixpunktpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON hilfsfixpunktpos.vali = valignment.ilicode
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
