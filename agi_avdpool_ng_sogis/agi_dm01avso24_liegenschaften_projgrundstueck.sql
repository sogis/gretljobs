SELECT
    projgrundstueck.t_id AS tid,
    projgrundstueck.entstehung,
    projgrundstueck.nbident,
    projgrundstueck.nummer,
    projgrundstueck.egris_egrid,
    gs_gueltigkeit.itfcode AS gueltigkeit,
    projgrundstueck.gueltigkeit AS gueltigkeit_txt,
    gs_vollstaendigkeit.itfcode AS vollstaendigkeit,
    projgrundstueck.vollstaendigkeit AS vollstaendigkeit_txt,
    grundstuecksart.itfcode AS art,
    projgrundstueck.art AS art_txt,
    projgrundstueck.gesamteflaechenmass,
    CAST(projgrundstueck.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.liegenschaften_projgrundstueck AS projgrundstueck
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON projgrundstueck.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck_vollstaendigkeit AS gs_vollstaendigkeit
        ON projgrundstueck.vollstaendigkeit = gs_vollstaendigkeit.ilicode
    LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck_gueltigkeit AS gs_gueltigkeit
        ON projgrundstueck.gueltigkeit = gs_gueltigkeit.ilicode
    LEFT JOIN agi_dm01avso24.liegenschaften_grundstuecksart AS grundstuecksart
        ON projgrundstueck.art = grundstuecksart.ilicode
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
