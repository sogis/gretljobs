SELECT
    ortschaftsverbtext.t_id AS tid,
    ortschaftsverbtext.ortschaftsverbundtext_von,
    ortschaftsverbtext.atext AS text,
    sprachtyp.itfcode AS sprache,
    ortschaftsverbtext.sprache AS sprache_txt,
    cast(ortschaftsverbtext.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.plzortschaft_ortschaftsverbundtext AS ortschaftsverbtext
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON ortschaftsverbtext.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.sprachtyp AS sprachtyp
        ON ortschaftsverbtext.sprache = sprachtyp.ilicode
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
