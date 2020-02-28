SELECT
    hausnummerpos.t_id AS tid,
    hausnummerpos.hausnummerpos_von,
    hausnummerpos.pos,
    hausnummerpos.ori,
    halignment.itfcode AS hali,
    hausnummerpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    hausnummerpos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    hausnummerpos.groesse AS groesse_txt,
    CAST(hausnummerpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gebaeudeadressen_hausnummerpos AS hausnummerpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hausnummerpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON hausnummerpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON hausnummerpos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON hausnummerpos.groesse = schriftgroesse.ilicode
   
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
