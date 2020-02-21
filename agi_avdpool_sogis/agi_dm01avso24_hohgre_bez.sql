SELECT
    bezirksgrenzabschnitt.geometrie AS wkb_geometry,
    0 AS art,
    CAST(bezirksgrenzabschnitt.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.bezirksgrenzen_bezirksgrenzabschnitt AS bezirksgrenzabschnitt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON bezirksgrenzabschnitt.t_basket = basket.t_id
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
