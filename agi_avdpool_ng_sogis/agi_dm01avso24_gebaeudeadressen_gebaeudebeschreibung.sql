SELECT
    gebaeudebeschreibung.t_id AS tid,
    gebaeudebeschreibung.gebaeudebeschreibung_von,
    gebaeudebeschreibung.atext AS text,
    sprachtyp.itfcode AS sprache,
    gebaeudebeschreibung.sprache AS sprache_txt,
    cast(gebaeudebeschreibung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gebaeudeadressen_gebaeudebeschreibung AS gebaeudebeschreibung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gebaeudebeschreibung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.sprachtyp AS sprachtyp
        ON gebaeudebeschreibung.sprache = sprachtyp.ilicode
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
