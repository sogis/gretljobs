SELECT
    kantonsgrenzabschnitt.geometrie AS wkb_geometry,
    1 AS art,
    CAST(kantonsgrenzabschnitt.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.kantonsgrenzen_kantonsgrenzabschnitt AS kantonsgrenzabschnitt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON kantonsgrenzabschnitt.t_basket = basket.t_id
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
