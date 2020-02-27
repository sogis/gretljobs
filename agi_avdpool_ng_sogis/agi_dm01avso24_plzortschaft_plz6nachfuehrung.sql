SELECT
    plz6nachfuehrung.t_id AS tid,
    plz6nachfuehrung.nbident,
    plz6nachfuehrung.identifikator,
    plz6nachfuehrung.beschreibung,
    plz6nachfuehrung.perimeter,
    status.itfcode AS gueltigkeit,
    plz6nachfuehrung.gueltigkeit AS gueltigkeit_txt,
    to_char(plz6nachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    cast(plz6nachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.plzortschaft_plz6nachfuehrung AS plz6nachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON plz6nachfuehrung.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.astatus AS status
        ON plz6nachfuehrung.gueltigkeit = status.ilicode
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
