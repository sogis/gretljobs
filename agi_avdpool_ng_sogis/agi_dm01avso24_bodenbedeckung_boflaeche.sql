SELECT
    boflaeche.t_id AS tid,
    boflaeche.entstehung,
    boflaeche.geometrie,
    qualitaetsstandard.itfcode AS qualitaet,
    boflaeche.qualitaet AS qualitaet_txt,
    bbart.itfcode AS art,
    boflaeche.art AS art_txt,
    cast(boflaeche.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bodenbedeckung_boflaeche AS boflaeche
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON boflaeche.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.bodenbedeckung_bbart AS bbart
        ON boflaeche.art = bbart.ilicode
    LEFT JOIN agi_dm01avso24.qualitaetsstandard AS qualitaetsstandard
        ON boflaeche.qualitaet = qualitaetsstandard.ilicode
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
