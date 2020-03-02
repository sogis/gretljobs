SELECT
    lfp2nachfuehrung.t_id AS tid,
    lfp2nachfuehrung.nbident,
    lfp2nachfuehrung.identifikator,
    lfp2nachfuehrung.beschreibung,
    lfp2nachfuehrung.perimeter,
    to_char(lfp2nachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(lfp2nachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(lfp2nachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie2_lfp2nachfuehrung AS lfp2nachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp2nachfuehrung.t_basket = basket.t_id
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
