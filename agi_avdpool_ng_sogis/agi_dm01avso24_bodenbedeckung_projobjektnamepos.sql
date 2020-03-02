SELECT
    projobjektnamepos.t_id AS tid,
    projobjektnamepos.projobjektnamepos_von,
    projobjektnamepos.pos,
    projobjektnamepos.ori,
    halignment.itfcode AS hali,
    projobjektnamepos.hali AS hali_txt,
    valignment.itfcode AS vali,
    projobjektnamepos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    projobjektnamepos.groesse AS groesse_txt,
    CAST(projobjektnamepos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bodenbedeckung_projobjektnamepos AS projobjektnamepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON projobjektnamepos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON projobjektnamepos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON projobjektnamepos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON projobjektnamepos.groesse = schriftgroesse.ilicode
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
