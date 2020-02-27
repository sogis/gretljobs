SELECT
    honachfuehrung.t_id AS tid,
    honachfuehrung.nbident,
    honachfuehrung.identifikator,
    honachfuehrung.beschreibung,
    honachfuehrung.perimeter,
    status.itfcode AS gueltigkeit,
    honachfuehrung.gueltigkeit AS gueltigkeit_txt,
    to_char(honachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(honachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(honachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.hoehen_honachfuehrung AS honachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON honachfuehrung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.astatus AS status
        ON honachfuehrung.gueltigkeit = status.ilicode
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
