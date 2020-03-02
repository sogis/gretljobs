SELECT
    gebaeudeeingang.lage AS wkb_geometry,
    gebaeudeeingang.hausnummer as polizein,
    hausnummerpos.ori AS numori,
    CASE 
        WHEN hausnummerpos.hali = 'Left'
            THEN 0   
        WHEN hausnummerpos.hali = 'Center'
            THEN 1   
        WHEN hausnummerpos.hali = 'Right'
            THEN 2   
    END AS numhali,
    CASE 
        WHEN hausnummerpos.vali = 'Top'
            THEN 0   
        WHEN hausnummerpos.vali = 'Cap'
            THEN 1   
        WHEN hausnummerpos.vali = 'Half'
            THEN 2   
        WHEN hausnummerpos.vali = 'Base'
            THEN 3   
        WHEN hausnummerpos.vali = 'Bottom'
            THEN 4   
    END AS numvali,
    lokalisationsname.atext AS strasse1,
    CAST(hausnummerpos.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CASE
        WHEN hausnummerpos.ori >= 0 AND hausnummerpos.ori < 100
           THEN (100-hausnummerpos.ori)*0.9
        WHEN hausnummerpos.ori = 100
            THEN 360
        WHEN hausnummerpos.ori > 100 AND hausnummerpos.ori <= 400
            THEN ((100-hausnummerpos.ori)*0.9)+360
    END AS txt_rot,
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
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_hausnummerpos AS hausnummerpos
        ON gebaeudeeingang.t_id = hausnummerpos.hausnummerpos_von
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
