SELECT
    projgebaeudenummerpos.t_id AS tid,
    projgebaeudenummerpos.projgebaeudenummerpos_von,
    projgebaeudenummerpos.pos,
    projgebaeudenummerpos.ori,
    halignment.itfcode AS hali,
    projgebaeudenummerpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    projgebaeudenummerpos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    projgebaeudenummerpos.groesse AS groesse_txt,
    CAST(projgebaeudenummerpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bodenbedeckung_projgebaeudenummerpos AS projgebaeudenummerpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON projgebaeudenummerpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON projgebaeudenummerpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON projgebaeudenummerpos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON projgebaeudenummerpos.groesse = schriftgroesse.ilicode
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
