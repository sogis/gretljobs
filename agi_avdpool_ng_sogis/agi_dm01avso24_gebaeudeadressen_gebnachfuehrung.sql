SELECT
    gebnachfuehrung.t_id AS tid,
    gebnachfuehrung.nbident,
    gebnachfuehrung.identifikator,
    gebnachfuehrung.beschreibung,
    gebnachfuehrung.perimeter,
    status.itfcode AS gueltigkeit,
    gebnachfuehrung.gueltigkeit AS gueltigkeit_txt,
    to_char(gebnachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    cast(gebnachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.gebaeudeadressen_gebnachfuehrung AS gebnachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON gebnachfuehrung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.astatus AS status
        ON gebnachfuehrung.gueltigkeit = status.ilicode
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
