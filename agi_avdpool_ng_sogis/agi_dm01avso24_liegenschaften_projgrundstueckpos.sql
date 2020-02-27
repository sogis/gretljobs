SELECT
    projgrundstueckpos.t_id AS tid,
    projgrundstueckpos.projgrundstueckpos_von,
    projgrundstueckpos.pos,
    projgrundstueckpos.ori,
    halignment.itfcode AS hali,
    projgrundstueckpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    projgrundstueckpos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    projgrundstueckpos.groesse AS groesse_txt,
    projgrundstueckpos.hilfslinie,
    CAST(projgrundstueckpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.liegenschaften_projgrundstueckpos AS projgrundstueckpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON projgrundstueckpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON projgrundstueckpos.hali = halignment.ilicode
     LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON projgrundstueckpos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON projgrundstueckpos.groesse = schriftgroesse.ilicode
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
