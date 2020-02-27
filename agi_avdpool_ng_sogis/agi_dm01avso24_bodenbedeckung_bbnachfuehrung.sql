SELECT
    bbnachfuehrung.t_id AS tid,
    bbnachfuehrung.nbident,
    bbnachfuehrung.identifikator,
    bbnachfuehrung.beschreibung,
    bbnachfuehrung.perimeter,
    status.itfcode AS gueltigkeit,
    bbnachfuehrung.gueltigkeit AS gueltigkeit_txt,
    to_char(bbnachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(bbnachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(bbnachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.bodenbedeckung_bbnachfuehrung AS bbnachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON bbnachfuehrung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.astatus AS status
        ON bbnachfuehrung.gueltigkeit = status.ilicode
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
