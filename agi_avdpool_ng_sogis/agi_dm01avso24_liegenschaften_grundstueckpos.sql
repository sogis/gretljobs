SELECT
    grundstueckpos.t_id AS tid,
    grundstueckpos.grundstueckpos_von,
    grundstueckpos.pos,
    grundstueckpos.ori,
    halignment.itfcode AS hali,
    grundstueckpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    grundstueckpos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    grundstueckpos.groesse AS groesse_txt,
    grundstueckpos.hilfslinie,
    CAST(grundstueckpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.liegenschaften_grundstueckpos AS grundstueckpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON grundstueckpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON grundstueckpos.hali = halignment.ilicode
     LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON grundstueckpos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON grundstueckpos.groesse = schriftgroesse.ilicode
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
