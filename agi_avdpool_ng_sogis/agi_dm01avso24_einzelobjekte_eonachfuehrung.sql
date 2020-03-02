SELECT
    eonachfuehrung.t_id AS tid,
    eonachfuehrung.nbident,
    eonachfuehrung.identifikator,
    eonachfuehrung.beschreibung,
    eonachfuehrung.perimeter,
    status.itfcode AS gueltigkeit,
    eonachfuehrung.gueltigkeit AS gueltigkeit_txt,
    to_char(eonachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(eonachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(eonachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.einzelobjekte_eonachfuehrung AS eonachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON eonachfuehrung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.astatus AS status
        ON eonachfuehrung.gueltigkeit = status.ilicode
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
