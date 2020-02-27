SELECT
    gebaeudename.t_id AS tid,
    gebaeudename.gebaeudename_von,
    gebaeudename.atext AS text,
    gebaeudename.kurztext,
    gebaeudename.indextext,
    sprachtyp.itfcode AS sprache,
    gebaeudename.sprache AS sprache_txt,
    cast(gebaeudename.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gebaeudeadressen_gebaeudename AS gebaeudename
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gebaeudename.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.sprachtyp AS sprachtyp
        ON gebaeudename.sprache = sprachtyp.ilicode
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
