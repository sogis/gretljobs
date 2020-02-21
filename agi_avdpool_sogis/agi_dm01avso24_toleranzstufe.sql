SELECT
    toleranzstufe.geometrie AS wkb_geometry,
    CASE
        WHEN toleranzstufe.art = 'TS1'
            THEN 0
        WHEN toleranzstufe.art = 'TS2'
            THEN 1
        WHEN toleranzstufe.art = 'TS3'
            THEN 2
        WHEN toleranzstufe.art = 'TS4'
            THEN 3
        WHEN toleranzstufe.art = 'TS5'
            THEN 4
    END AS art,
    CAST(toleranzstufe.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    0 AS los
FROM
    agi_dm01avso24.tseinteilung_toleranzstufe AS toleranzstufe
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON toleranzstufe.t_basket = basket.t_id
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
