SELECT
    gelaendekante.t_id AS tid,
    gelaendekante.entstehung,
    gelaendekante.geometrie,
    qualitaetsstandard.itfcode AS qualitaet,
    gelaendekante.qualitaet AS qualitaet_txt,
    gelaendekante_art.itfcode AS art,
    gelaendekante.art AS art_txt,
    CAST(gelaendekante.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.hoehen_gelaendekante AS gelaendekante
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gelaendekante.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.qualitaetsstandard AS qualitaetsstandard
        ON gelaendekante.qualitaet = qualitaetsstandard.ilicode
    LEFT JOIN agi_dm01avso24.hoehen_gelaendekante_art AS gelaendekante_art
        ON gelaendekante.art = gelaendekante_art.ilicode
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
