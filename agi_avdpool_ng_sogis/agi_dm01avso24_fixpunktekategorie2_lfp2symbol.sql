SELECT
    lfp2symbol.t_id AS tid,
    lfp2symbol.lfp2symbol_von,
    lfp2symbol.ori,
    CAST(lfp2symbol.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie2_lfp2symbol AS lfp2symbol
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp2symbol.t_basket = basket.t_id
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
