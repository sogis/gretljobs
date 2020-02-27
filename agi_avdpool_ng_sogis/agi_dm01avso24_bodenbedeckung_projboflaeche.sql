SELECT
    projboflaeche.t_id AS tid,
    projboflaeche.entstehung,
    projboflaeche.geometrie,
    qualitaetsstandard.itfcode AS qualitaet,
    projboflaeche.qualitaet AS qualitaet_txt,
    bbart.itfcode AS art,
    projboflaeche.art AS art_txt,
    cast(projboflaeche.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bodenbedeckung_projboflaeche AS projboflaeche
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON projboflaeche.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.bodenbedeckung_bbart AS bbart
        ON projboflaeche.art = bbart.ilicode
    LEFT JOIN agi_dm01avso24.qualitaetsstandard AS qualitaetsstandard
        ON projboflaeche.qualitaet = qualitaetsstandard.ilicode
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
