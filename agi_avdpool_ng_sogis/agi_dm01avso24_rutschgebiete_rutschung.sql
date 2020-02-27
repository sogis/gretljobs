SELECT
    rutschung.t_id AS tid,
    rutschung.nbident,
    rutschung.identifikator,
    rutschung.aname AS name,
    rutschung.geometrie,
    to_char(rutschung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,    
    CAST(rutschung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.rutschgebiete_rutschung AS rutschung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON rutschung.t_basket = basket.t_id
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
