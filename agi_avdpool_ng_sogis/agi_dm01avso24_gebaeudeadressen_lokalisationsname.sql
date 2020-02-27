SELECT
    lokalisationsname.t_id AS tid,
    lokalisationsname.benannte,
    lokalisationsname.atext AS text,
    lokalisationsname.kurztext,
    lokalisationsname.indextext,
    sprachtyp.itfcode AS sprache,
    lokalisationsname.sprache AS sprache_txt,
    cast(lokalisationsname.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gebaeudeadressen_lokalisationsname AS lokalisationsname
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lokalisationsname.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.sprachtyp AS sprachtyp
        ON lokalisationsname.sprache = sprachtyp.ilicode
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
