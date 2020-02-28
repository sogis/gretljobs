SELECT
    hfp3nachfuehrung.t_id AS tid,
    hfp3nachfuehrung.nbident,
    hfp3nachfuehrung.identifikator,
    hfp3nachfuehrung.beschreibung,
    hfp3nachfuehrung.perimeter,
    to_char(hfp3nachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(hfp3nachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(hfp3nachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie3_hfp3nachfuehrung AS hfp3nachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hfp3nachfuehrung.t_basket = basket.t_id
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
