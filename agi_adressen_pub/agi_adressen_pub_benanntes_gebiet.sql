SELECT
    gebaeudeadressen_benanntesgebiet.t_id,
    gebaeudeadressen_benanntesgebiet.flaeche AS geometrie,
    CAST(gebaeudeadressen_lokalisation.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum,
    gebaeudeadressen_lokalisationsname.atext AS name_benanntes_gebiet
FROM
    agi_dm01avso24.gebaeudeadressen_benanntesgebiet
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisation
        ON gebaeudeadressen_benanntesgebiet.benanntesgebiet_von = gebaeudeadressen_lokalisation.t_id
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisationsname
        ON gebaeudeadressen_lokalisationsname.benannte = gebaeudeadressen_lokalisation.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gebaeudeadressen_lokalisation.t_basket = basket.t_id
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
WHERE
    gebaeudeadressen_lokalisation.art = 'BenanntesGebiet'
;
