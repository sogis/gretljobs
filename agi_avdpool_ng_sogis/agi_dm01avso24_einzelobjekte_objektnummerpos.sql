SELECT
    objektnummerpos.t_id AS tid,
    objektnummerpos.objektnummerpos_von,
    objektnummerpos.pos,
    objektnummerpos.ori,
    halignment.itfcode AS hali,
    objektnummerpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    objektnummerpos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    objektnummerpos.groesse AS groesse_txt,
    CAST(objektnummerpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.einzelobjekte_objektnummerpos AS objektnummerpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON objektnummerpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON objektnummerpos.hali = halignment.ilicode
     LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON objektnummerpos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON objektnummerpos.groesse = schriftgroesse.ilicode
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
