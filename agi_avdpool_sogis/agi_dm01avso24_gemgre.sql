SELECT
    gemeindegrenze.geometrie AS wkb_geometry,
    gemeinde.aname AS name,
    CAST(gemeinde.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.gemeindegrenzen_gemeinde AS gemeinde
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gemeinde.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.gemeindegrenzen_gemeindegrenze AS gemeindegrenze
        ON  gemeindegrenze.gemeindegrenze_von = gemeinde.t_id
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
