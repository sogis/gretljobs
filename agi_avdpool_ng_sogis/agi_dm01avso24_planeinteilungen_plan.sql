SELECT
    plan.t_id AS tid,
    plan.nbident,
    plan.nummer,
    plan.techdossier,
    to_char(plan.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,    
    CAST(plan.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.planeinteilungen_plan AS plan
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON plan.t_basket = basket.t_id
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
