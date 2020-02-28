SELECT
    lsnachfuehrung.t_id AS tid,
    lsnachfuehrung.nbident,
    lsnachfuehrung.identifikator,
    lsnachfuehrung.beschreibung,
    lsnachfuehrung.perimeter,
    status.itfcode AS gueltigkeit,
    lsnachfuehrung.gueltigkeit AS gueltigkeit_txt,
    to_char(lsnachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(lsnachfuehrung.gbeintrag,'YYYYMMDD') AS gbeintrag,
    to_char(lsnachfuehrung.datum1,'YYYYMMDD') AS datum1,
    to_char(lsnachfuehrung.datum2,'YYYYMMDD') AS datum2,
    cast(lsnachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.liegenschaften_lsnachfuehrung AS lsnachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lsnachfuehrung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.astatus AS status
        ON lsnachfuehrung.gueltigkeit = status.ilicode
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
