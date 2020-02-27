SELECT
    numbereichpos.t_id AS tid,
    numbereichpos.nummerierungsbereichpos_von,
    numbereichpos.pos,
    numbereichpos.ori,
    halignment.itfcode AS hali,
    numbereichpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    numbereichpos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    numbereichpos.groesse AS groesse_txt,
    CAST(numbereichpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.nummerierngsbrche_nummerierungsbereichpos AS numbereichpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON numbereichpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON numbereichpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON numbereichpos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON numbereichpos.groesse = schriftgroesse.ilicode
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
