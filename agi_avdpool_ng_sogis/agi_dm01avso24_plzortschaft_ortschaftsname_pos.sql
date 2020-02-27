SELECT
    ortschaftsname_pos.t_id AS tid,
    ortschaftsname_pos.ortschaftsname_pos_von,
    ortschaftsname_pos.pos,
    ortschaftsname_pos.ori,
    halignment.itfcode AS hali,
    ortschaftsname_pos.hali AS hali_txt,
    valignment.itfcode AS vali,
    ortschaftsname_pos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    ortschaftsname_pos.groesse AS groesse_txt,
    CAST(ortschaftsname_pos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.plzortschaft_ortschaftsname_pos AS ortschaftsname_pos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON ortschaftsname_pos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON ortschaftsname_pos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON ortschaftsname_pos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON ortschaftsname_pos.groesse = schriftgroesse.ilicode
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
