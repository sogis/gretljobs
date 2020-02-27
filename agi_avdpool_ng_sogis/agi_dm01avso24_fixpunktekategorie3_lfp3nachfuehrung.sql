SELECT
    lfp3nachfuehrung.t_id AS tid,
    lfp3nachfuehrung.nbident,
    lfp3nachfuehrung.identifikator,
    lfp3nachfuehrung.beschreibung,
    lfp3nachfuehrung.perimeter,
    to_char(lfp3nachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(lfp3nachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(lfp3nachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie3_lfp3nachfuehrung AS lfp3nachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp3nachfuehrung.t_basket = basket.t_id
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
