SELECT
    strassenstueck.geometrie AS wkb_geometry,
    strassenstueck.ordnung,
    lokalisationsname.atext AS TEXT,
    CAST(strassenstueck.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    0 AS los
FROM
    agi_dm01avso24.gebaeudeadressen_strassenstueck AS strassenstueck
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON strassenstueck.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisation AS lokalisation
        ON lokalisation.t_id = strassenstueck.strassenstueck_von
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisationsname AS lokalisationsname
        ON lokalisation.t_id = lokalisationsname.benannte
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
