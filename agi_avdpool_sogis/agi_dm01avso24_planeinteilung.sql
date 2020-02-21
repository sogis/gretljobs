SELECT
    plangeometrie.geometrie AS wkb_geometry,
    plan.nummer,
    CAST(plan.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    0 AS los
FROM
    agi_dm01avso24.planeinteilungen_plan AS plan
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON plan.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.planeinteilungen_plangeometrie AS plangeometrie
        ON plan.t_id = plangeometrie.plangeometrie_von
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
