SELECT
    lfp1nachfuehrung.t_id AS tid,
    lfp1nachfuehrung.nbident,
    lfp1nachfuehrung.identifikator,
    lfp1nachfuehrung.beschreibung,
    lfp1nachfuehrung.perimeter,
    to_char(lfp1nachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(lfp1nachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(lfp1nachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie1_lfp1nachfuehrung AS lfp1nachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON lfp1nachfuehrung.t_basket = basket.t_id
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
