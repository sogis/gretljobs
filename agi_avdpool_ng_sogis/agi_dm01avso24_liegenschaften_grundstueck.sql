SELECT
    grundstueck.t_id AS tid,
    grundstueck.entstehung,
    grundstueck.nbident,
    grundstueck.nummer,
    grundstueck.egris_egrid,
    gs_gueltigkeit.itfcode AS gueltigkeit,
    grundstueck.gueltigkeit AS gueltigkeit_txt,
    gs_vollstaendigkeit.itfcode AS vollstaendigkeit,
    grundstueck.vollstaendigkeit AS vollstaendigkeit_txt,
    grundstuecksart.itfcode AS art,
    grundstueck.art AS art_txt,
    grundstueck.gesamteflaechenmass,
    CAST(grundstueck.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON grundstueck.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck_vollstaendigkeit AS gs_vollstaendigkeit
        ON grundstueck.vollstaendigkeit = gs_vollstaendigkeit.ilicode
    LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck_gueltigkeit AS gs_gueltigkeit
        ON grundstueck.gueltigkeit = gs_gueltigkeit.ilicode
    LEFT JOIN agi_dm01avso24.liegenschaften_grundstuecksart AS grundstuecksart
        ON grundstueck.art = grundstuecksart.ilicode
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
