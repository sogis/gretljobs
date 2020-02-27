SELECT
    numbereich.t_id AS tid,
    kantonskuerzel.itfcode AS kt,
    numbereich.kt AS kt_txt,
    numbereich.nbnummer,
    numbereich.techdossier,
    to_char(numbereich.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    CAST(numbereich.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.nummerierngsbrche_nummerierungsbereich AS numbereich
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON numbereich.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.nummerierngsbrche_kantonskuerzel AS kantonskuerzel
        ON numbereich.kt = kantonskuerzel.ilicode
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
