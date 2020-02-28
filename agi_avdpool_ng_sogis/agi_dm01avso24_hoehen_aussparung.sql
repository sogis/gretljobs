SELECT
    aussparung.t_id AS tid,
    aussparung.entstehung,
    aussparung.geometrie,
    qualitaetsstandard.itfcode AS qualitaet,
    aussparung.qualitaet AS qualitaet_txt,
    aussparung_art.itfcode AS art,
    aussparung.art AS art_txt,
    CAST(aussparung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.hoehen_aussparung AS aussparung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON aussparung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.qualitaetsstandard AS qualitaetsstandard
        ON aussparung.qualitaet = qualitaetsstandard.ilicode
    LEFT JOIN agi_dm01avso24.hoehen_aussparung_art AS aussparung_art
        ON aussparung.art = aussparung_art.ilicode
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
