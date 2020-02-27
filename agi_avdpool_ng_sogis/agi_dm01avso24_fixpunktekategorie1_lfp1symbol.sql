SELECT
    lfp1symbol.t_id AS tid,
    lfp1symbol.lfp1symbol_von,
    lfp1symbol.ori,
    CAST(lfp1symbol.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie1_lfp1symbol AS lfp1symbol
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp1symbol.t_basket = basket.t_id
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
