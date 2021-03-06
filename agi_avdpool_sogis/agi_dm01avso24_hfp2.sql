SELECT
    hfp2.geometrie AS wkb_geometry,
    hfp2.nummer,
    hfp2.hoehegeom AS hoehegeo,
    CAST(hfp2.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    0 AS los
FROM
    agi_dm01avso24.fixpunktekatgrie2_hfp2 AS hfp2
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp2.t_basket = basket.t_id
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
