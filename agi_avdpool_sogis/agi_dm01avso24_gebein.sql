SELECT
    gebaeudeeingang.lage AS wkb_geometry,
    lokalisationsname.atext AS strasse1,
    gebaeudeeingang.hausnummer AS polizein,
    gebaeudeeingang.gwr_egid AS egid,
    gebaeudeeingang.gwr_edid AS edid,
    CASE 
        WHEN gebaeudeeingang.astatus = 'projektiert'
            THEN 0   
        WHEN gebaeudeeingang.astatus = 'real'
            THEN 1   
        WHEN gebaeudeeingang.astatus = 'vergangen'
            THEN 2   
    END AS status,
    CAST(gebaeudeeingang.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,    
    0 AS los
FROM
    agi_dm01avso24.gebaeudeadressen_gebaeudeeingang AS gebaeudeeingang
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gebaeudeeingang.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisation AS lokalisation
        ON  lokalisation.t_id = gebaeudeeingang.gebaeudeeingang_von
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisationsname AS lokalisationsname
        ON  lokalisationsname.benannte = lokalisation.t_id
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
