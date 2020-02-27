SELECT
    flurnamepos.t_id AS tid,
    flurnamepos.flurnamepos_von,
    flurnamepos.pos,
    flurnamepos.ori,
    halignment.itfcode AS hali,
    flurnamepos.hali AS hali_txt,
    valignment.itfcode AS vali,
    flurnamepos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    flurnamepos.groesse AS groesse_txt,
    schriftstil.itfcode AS stil,
    flurnamepos.stil AS stil_txt,
    CAST(flurnamepos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.nomenklatur_flurnamepos AS flurnamepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON flurnamepos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON flurnamepos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON flurnamepos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON flurnamepos.groesse = schriftgroesse.ilicode
    LEFT JOIN agi_dm01avso24.schriftstil AS schriftstil
        ON flurnamepos.stil = schriftstil.ilicode
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
