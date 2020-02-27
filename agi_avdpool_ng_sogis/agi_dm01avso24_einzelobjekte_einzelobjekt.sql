SELECT
    einzelobjekt.t_id AS tid,
    einzelobjekt.entstehung,
    qualitaetsstandard.itfcode AS qualitaet,
    einzelobjekt.qualitaet AS qualitaet_txt,
    eoart.itfcode AS art,
    einzelobjekt.art AS art_txt,
    cast(einzelobjekt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.einzelobjekte_einzelobjekt AS einzelobjekt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON einzelobjekt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.einzelobjekte_eoart AS eoart
        ON einzelobjekt.art = eoart.ilicode
    LEFT JOIN agi_dm01avso24.qualitaetsstandard AS qualitaetsstandard
        ON einzelobjekt.qualitaet = qualitaetsstandard.ilicode
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
