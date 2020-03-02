SELECT
    gebaeudenamepos.t_id AS tid,
    gebaeudenamepos.gebaeudenamepos_von,
    gebaeudenamepos.pos,
    gebaeudenamepos.ori,
    halignment.itfcode AS hali,
    gebaeudenamepos.hali AS hali_txt,
    valignment.itfcode AS vali,
    gebaeudenamepos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    gebaeudenamepos.groesse AS groesse_txt,
    gebaeudenamepos.hilfslinie,
    CAST(gebaeudenamepos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gebaeudeadressen_gebaeudenamepos AS gebaeudenamepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gebaeudenamepos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON gebaeudenamepos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON gebaeudenamepos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON gebaeudenamepos.groesse = schriftgroesse.ilicode
   
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
