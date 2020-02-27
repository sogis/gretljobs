SELECT
    rlnachfuehrung.t_id AS tid,
    rlnachfuehrung.nbident,
    rlnachfuehrung.identifikator,
    rlnachfuehrung.beschreibung,
    rlnachfuehrung.perimeter,
    status.itfcode AS gueltigkeit,
    rlnachfuehrung.gueltigkeit AS gueltigkeit_txt,
    to_char(rlnachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(rlnachfuehrung.datum1,'YYYYMMDD') AS datum1,
   cast(rlnachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.rohrleitungen_rlnachfuehrung AS rlnachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON rlnachfuehrung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.astatus AS status
        ON rlnachfuehrung.gueltigkeit = status.ilicode
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
