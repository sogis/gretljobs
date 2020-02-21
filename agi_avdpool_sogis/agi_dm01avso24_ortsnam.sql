SELECT
    ortsname.geometrie AS wkb_geometry,
    CAST(ortsname.t_datasetname AS INT) AS gem_bfs,
    0 AS archive,
    CAST('9999-01-01' AS timestamp) AS archive_date,
    aimport.importdate AS new_date,   
    ortsname.aname AS name,
    0 AS los
FROM
    agi_dm01avso24.nomenklatur_ortsname AS ortsname
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON ortsname.t_basket = basket.t_id
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
