SELECT
    lokalisationsnamepos.t_id AS tid,
    lokalisationsnamepos.lokalisationsnamepos_von,
    lokalisationsnamepos.anfindex,
    lokalisationsnamepos.endindex,
    lokalisationsnamepos.pos,
    lokalisationsnamepos.ori,
    halignment.itfcode AS hali,
    lokalisationsnamepos.hali AS hali_txt,
    valignment.itfcode AS vali,
    lokalisationsnamepos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    lokalisationsnamepos.groesse AS groesse_txt,
    lokalisationsnamepos.hilfslinie,
    CAST(lokalisationsnamepos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gebaeudeadressen_lokalisationsnamepos AS lokalisationsnamepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lokalisationsnamepos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON lokalisationsnamepos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON lokalisationsnamepos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON lokalisationsnamepos.groesse = schriftgroesse.ilicode
   
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
