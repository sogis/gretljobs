SELECT
    ortschaft.t_id AS tid,
    ortschaft.entstehung,
    ortschaft.ortschaft_von,
    status_ga.itfcode AS status,
    ortschaft.astatus AS status_txt,
    is_inaenderung.itfcode AS inaenderung,
    ortschaft.inaenderung AS inaenderung_txt,
    ortschaft.flaeche,
    CAST(ortschaft.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.plzortschaft_ortschaft AS ortschaft
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON ortschaft.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.status_ga AS status_ga
        ON ortschaft.astatus = status_ga.ilicode
    LEFT JOIN agi_dm01avso24.plzortschaft_ortschaft_inaenderung AS is_inaenderung
        ON ortschaft.inaenderung = is_inaenderung.ilicode
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
