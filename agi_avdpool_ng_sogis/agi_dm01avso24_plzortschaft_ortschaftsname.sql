SELECT
    ortschaftsname.t_id AS tid,
    ortschaftsname.ortschaftsname_von,
    ortschaftsname.atext AS text,
    ortschaftsname.kurztext,
    ortschaftsname.indextext,
    sprachtyp.itfcode AS sprache,
    ortschaftsname.sprache AS sprache_txt,
    cast(ortschaftsname.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.plzortschaft_ortschaftsname AS ortschaftsname
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON ortschaftsname.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.sprachtyp AS sprachtyp
        ON ortschaftsname.sprache = sprachtyp.ilicode
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
