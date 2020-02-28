SELECT
    hfp2nachfuehrung.t_id AS tid,
    hfp2nachfuehrung.nbident,
    hfp2nachfuehrung.identifikator,
    hfp2nachfuehrung.beschreibung,
    hfp2nachfuehrung.perimeter,
    to_char(hfp2nachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(hfp2nachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(hfp2nachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie2_hfp2nachfuehrung AS hfp2nachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp2nachfuehrung.t_basket = basket.t_id
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
