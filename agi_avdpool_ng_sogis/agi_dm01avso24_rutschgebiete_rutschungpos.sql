SELECT
    rutschungpos.t_id AS tid,
    rutschungpos.rutschungpos_von,
    rutschungpos.pos,
    rutschungpos.ori,
    halignment.itfcode AS hali,
    rutschungpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    rutschungpos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    rutschungpos.groesse AS groesse_txt,
    CAST(rutschungpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.rutschgebiete_rutschungpos AS rutschungpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON rutschungpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON rutschungpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON rutschungpos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON rutschungpos.groesse = schriftgroesse.ilicode
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
