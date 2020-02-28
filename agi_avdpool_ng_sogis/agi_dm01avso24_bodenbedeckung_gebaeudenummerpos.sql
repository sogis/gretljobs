SELECT
    gebaeudenummerpos.t_id AS tid,
    gebaeudenummerpos.gebaeudenummerpos_von,
    gebaeudenummerpos.pos,
    gebaeudenummerpos.ori,
    halignment.itfcode AS hali,
    gebaeudenummerpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    gebaeudenummerpos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    gebaeudenummerpos.groesse,
    CAST(gebaeudenummerpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bodenbedeckung_gebaeudenummerpos AS gebaeudenummerpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gebaeudenummerpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON gebaeudenummerpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON gebaeudenummerpos.vali = valignment.ilicode
     LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON gebaeudenummerpos.groesse = schriftgroesse.ilicode
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
