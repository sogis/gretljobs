SELECT
    hfp1nachfuehrung.t_id AS tid,
    hfp1nachfuehrung.nbident,
    hfp1nachfuehrung.identifikator,
    hfp1nachfuehrung.beschreibung,
    hfp1nachfuehrung.perimeter,
    to_char(hfp1nachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(hfp1nachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(hfp1nachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie1_hfp1nachfuehrung AS hfp1nachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp1nachfuehrung.t_basket = basket.t_id
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
