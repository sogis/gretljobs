SELECT
    leitungsobjektpos.t_id AS tid,
    leitungsobjektpos.leitungsobjektpos_von,
    leitungsobjektpos.pos,
    leitungsobjektpos.ori,
    halignment.itfcode AS hali,
    leitungsobjektpos.hali AS hali_txt,
    valignment.itfcode AS vali,
    leitungsobjektpos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    leitungsobjektpos.groesse AS groesse_txt,
    CAST(leitungsobjektpos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.rohrleitungen_leitungsobjektpos AS leitungsobjektpos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON leitungsobjektpos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON leitungsobjektpos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON leitungsobjektpos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON leitungsobjektpos.groesse = schriftgroesse.ilicode
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
