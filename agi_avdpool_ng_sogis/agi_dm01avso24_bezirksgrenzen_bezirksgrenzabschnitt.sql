SELECT
    bezirk.t_id AS tid,
    bezirk.geometrie,
    bezirk.gueltigkeit AS gueltigkeit_txt,
    gueltig.itfcode AS gueltigkeit,
    CAST(bezirk.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bezirksgrenzen_bezirksgrenzabschnitt AS bezirk
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON bezirk.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.bezirksgrenzen_bezirksgrenzabschnitt_gueltigkeit AS gueltig
        ON bezirk.gueltigkeit = gueltig.ilicode
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
