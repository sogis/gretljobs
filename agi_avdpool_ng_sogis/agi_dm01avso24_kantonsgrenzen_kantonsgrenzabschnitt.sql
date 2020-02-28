SELECT
    kantonsgrenzabschnitt.t_id AS tid,
    kantonsgrenzabschnitt.geometrie,
    kg_gueltigkeit.itfcode AS gueltigkeit,
    kantonsgrenzabschnitt.gueltigkeit AS gueltigkeit_txt,
    CAST(kantonsgrenzabschnitt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.kantonsgrenzen_kantonsgrenzabschnitt AS kantonsgrenzabschnitt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON kantonsgrenzabschnitt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.kantonsgrenzen_kantonsgrenzabschnitt_gueltigkeit AS kg_gueltigkeit
        ON kantonsgrenzabschnitt.gueltigkeit = kg_gueltigkeit.ilicode
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
