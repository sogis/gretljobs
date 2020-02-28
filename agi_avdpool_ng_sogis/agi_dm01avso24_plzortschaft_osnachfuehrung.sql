SELECT
    osnachfuehrung.t_id AS tid,
    osnachfuehrung.nbident,
    osnachfuehrung.identifikator,
    osnachfuehrung.beschreibung,
    osnachfuehrung.perimeter,
    status.itfcode AS gueltigkeit,
    osnachfuehrung.gueltigkeit AS gueltigkeit_txt,
    to_char(osnachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    cast(osnachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.plzortschaft_osnachfuehrung AS osnachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON osnachfuehrung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.astatus AS status
        ON osnachfuehrung.gueltigkeit = status.ilicode
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
