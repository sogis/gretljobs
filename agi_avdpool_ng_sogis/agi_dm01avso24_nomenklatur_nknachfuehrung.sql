SELECT
    nknachfuehrung.t_id AS tid,
    nknachfuehrung.nbident,
    nknachfuehrung.identifikator,
    nknachfuehrung.beschreibung,
    nknachfuehrung.perimeter,
    to_char(nknachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(nknachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(nknachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.nomenklatur_nknachfuehrung AS nknachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON nknachfuehrung.t_basket = basket.t_id
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
