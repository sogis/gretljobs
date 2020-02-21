SELECT
    selbstrecht.geometrie AS wkb_geometry,
    selbstrecht.flaechenmass AS flaechen,
    CASE 
        WHEN grundstueck.art = 'SelbstRecht.Baurecht'
            THEN 1
        WHEN grundstueck.art = 'SelbstRecht.Quellenrecht'
            THEN 2
        WHEN grundstueck.art = 'SelbstRecht.Konzessionsrecht'
            THEN 1
    END AS art,
    grundstueck.nummer,
    CAST(selbstrecht.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.liegenschaften_selbstrecht AS selbstrecht
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON selbstrecht.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
        ON grundstueck.t_id = selbstrecht.selbstrecht_von
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
