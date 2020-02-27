SELECT
    gemnachfuehrung.t_id AS tid,
    gemnachfuehrung.nbident,
    gemnachfuehrung.identifikator,
    gemnachfuehrung.beschreibung,
    gemnachfuehrung.perimeter,
    status.itfcode AS gueltigkeit,
    gemnachfuehrung.gueltigkeit AS gueltigkeit_txt,
    to_char(gemnachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(gemnachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(gemnachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gemeindegrenzen_gemnachfuehrung AS gemnachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gemnachfuehrung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.astatus AS status
        ON gemnachfuehrung.gueltigkeit = status.ilicode
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
