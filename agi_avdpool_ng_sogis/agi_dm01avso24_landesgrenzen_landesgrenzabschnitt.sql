SELECT
    landesgrenzabschnitt.t_id AS tid,
    landesgrenzabschnitt.geometrie,
    lg_gueltigkeit.itfcode AS gueltigkeit,
    landesgrenzabschnitt.gueltigkeit AS gueltigkeit_txt,
    CAST(landesgrenzabschnitt.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.landesgrenzen_landesgrenzabschnitt AS landesgrenzabschnitt
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON landesgrenzabschnitt.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.landesgrenzen_landesgrenzabschnitt_gueltigkeit AS lg_gueltigkeit
        ON landesgrenzabschnitt.gueltigkeit = lg_gueltigkeit.ilicode
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
