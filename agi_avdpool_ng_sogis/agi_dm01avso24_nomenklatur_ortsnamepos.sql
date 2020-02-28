SELECT
    ortsnamepos.t_id AS tid,
    ortsnamepos.ortsnamepos_von,
    ortsnamepos.pos,
    ortsnamepos.ori,
    halignment.itfcode AS hali,
    ortsnamepos.hali AS hali_txt,
    valignment.itfcode AS vali,
    ortsnamepos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    ortsnamepos.groesse AS groesse_txt,
    schriftstil.itfcode AS stil,
    ortsnamepos.stil AS stil_txt,
    CAST(ortsnamepos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.nomenklatur_ortsnamepos AS ortsnamepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON ortsnamepos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON ortsnamepos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON ortsnamepos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON ortsnamepos.groesse = schriftgroesse.ilicode
    LEFT JOIN agi_dm01avso24.schriftstil AS schriftstil
        ON ortsnamepos.stil = schriftstil.ilicode
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
