SELECT
    lfp3symbol.t_id AS tid,
    lfp3symbol.lfp3symbol_von,
    lfp3symbol.ori,
    CAST(lfp3symbol.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie3_lfp3symbol AS lfp3symbol
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp3symbol.t_basket = basket.t_id
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
