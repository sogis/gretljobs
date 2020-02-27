SELECT
    objektnamepos.t_id AS tid,
    objektnamepos.objektnamepos_von,
    objektnamepos.pos,
    objektnamepos.ori,
    halignment.itfcode AS hali,
    objektnamepos.hali AS hali_txt,
    valignment.itfcode AS vali,
    objektnamepos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    objektnamepos.groesse AS groesse_txt,
    CAST(objektnamepos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.einzelobjekte_objektnamepos AS objektnamepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON objektnamepos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON objektnamepos.hali = halignment.ilicode
     LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON objektnamepos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON objektnamepos.groesse = schriftgroesse.ilicode
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
