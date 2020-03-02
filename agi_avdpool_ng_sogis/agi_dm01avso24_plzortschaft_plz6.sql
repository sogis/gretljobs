SELECT
    plz6.t_id AS tid,
    plz6.entstehung,
    plz6.plz6_von,
    plz6.flaeche,
    status_ga.itfcode AS status,
    plz6.astatus AS status_txt,
    plz_inaenderung.itfcode AS inaenderung,
    plz6.inaenderung AS inaenderung_txt,
    plz6.plz,
    plz6.zusatzziffern,
    CAST(plz6.t_datasetname AS INT) AS gem_bfs,
    0 AS los,
    aimport.importdate AS lieferdatum
FROM
    agi_dm01avso24.plzortschaft_plz6 AS plz6
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON plz6.t_basket = basket.t_id
    LEFT JOIN agi_dm01avso24.status_ga AS status_ga
        ON plz6.astatus = status_ga.ilicode
    LEFT JOIN agi_dm01avso24.plzortschaft_plz6_inaenderung AS plz_inaenderung
        ON plz6.inaenderung = plz_inaenderung.ilicode
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
