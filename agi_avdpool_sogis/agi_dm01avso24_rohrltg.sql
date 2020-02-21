SELECT
    linienelement.geometrie AS wkb_geometry,
    CASE
        WHEN leitungsobjekt.art = 'Oel'
            THEN 0
        WHEN leitungsobjekt.art = 'Gas'
            THEN 1
        WHEN leitungsobjekt.art = 'weitere'
            THEN 2
    END AS art,
    CAST(linienelement.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    0 AS los
FROM
    agi_dm01avso24.rohrleitungen_linienelement AS linienelement
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON linienelement.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.rohrleitungen_leitungsobjekt AS leitungsobjekt
        ON linienelement.linienelement_von = leitungsobjekt.t_id
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
