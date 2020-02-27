SELECT
    toleranzstufepos.t_id AS tid,
    toleranzstufepos.toleranzstufepos_von,
    toleranzstufepos.pos,
    toleranzstufepos.ori,
    halignment.itfcode AS hali,
    toleranzstufepos.hali AS hali_txt,
    valignment.itfcode AS vali,
    toleranzstufepos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    toleranzstufepos.groesse AS groesse_txt,
    CAST(toleranzstufepos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.tseinteilung_toleranzstufepos AS toleranzstufepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON toleranzstufepos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON toleranzstufepos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON toleranzstufepos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON toleranzstufepos.groesse = schriftgroesse.ilicode
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
