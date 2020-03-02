SELECT
    leitungsobjekt.t_id AS tid,
    leitungsobjekt.entstehung,
    leitungsobjekt.betreiber,
    qualitaetsstandard.itfcode AS qualitaet,
    leitungsobjekt.qualitaet AS qualitaet_txt,
    rl_medium.itfcode AS art,
    leitungsobjekt.art AS art_txt,
    cast(leitungsobjekt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.rohrleitungen_leitungsobjekt AS leitungsobjekt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON leitungsobjekt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.rohrleitungen_medium AS rl_medium
        ON leitungsobjekt.art = rl_medium.ilicode
    LEFT JOIN agi_dm01avso24.qualitaetsstandard AS qualitaetsstandard
        ON leitungsobjekt.qualitaet = qualitaetsstandard.ilicode
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
