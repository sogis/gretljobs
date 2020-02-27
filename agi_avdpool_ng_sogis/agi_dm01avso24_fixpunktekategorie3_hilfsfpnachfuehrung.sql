SELECT
    hilfsfpnachfuehrung.t_id AS tid,
    hilfsfpnachfuehrung.nbident,
    hilfsfpnachfuehrung.identifikator,
    hilfsfpnachfuehrung.beschreibung,
    hilfsfpnachfuehrung.perimeter,
    to_char(hilfsfpnachfuehrung.gueltigereintrag,'YYYYMMDD') AS gueltigereintrag,
    to_char(hilfsfpnachfuehrung.datum1,'YYYYMMDD') AS datum1,
    cast(hilfsfpnachfuehrung.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.fixpunktekatgrie3_hilfsfpnachfuehrung AS hilfsfpnachfuehrung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON hilfsfpnachfuehrung.t_basket = basket.t_id
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
