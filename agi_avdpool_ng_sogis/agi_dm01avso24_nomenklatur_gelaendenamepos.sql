SELECT
    gelaendenamepos.t_id AS tid,
    gelaendenamepos.gelaendenamepos_von,
    gelaendenamepos.pos,
    gelaendenamepos.ori,
    halignment.itfcode AS hali,
    gelaendenamepos.hali AS hali_txt,
    valignment.itfcode AS vali,
    gelaendenamepos.vali AS vali_txt,
    schriftgroesse.itfcode AS groesse,
    gelaendenamepos.groesse AS groesse_txt,
    schriftstil.itfcode AS stil,
    gelaendenamepos.stil AS stil_txt,
    CAST(gelaendenamepos.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.nomenklatur_gelaendenamepos AS gelaendenamepos
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gelaendenamepos.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.halignment AS halignment
        ON gelaendenamepos.hali = halignment.ilicode
    LEFT JOIN agi_dm01avso24.valignment AS valignment
        ON gelaendenamepos.vali = valignment.ilicode
    LEFT JOIN agi_dm01avso24.schriftgroesse AS schriftgroesse
        ON gelaendenamepos.groesse = schriftgroesse.ilicode
    LEFT JOIN agi_dm01avso24.schriftstil AS schriftstil
        ON gelaendenamepos.stil = schriftstil.ilicode
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
