SELECT
    grenzpunkt.geometrie,
    grenzpunkt.lagegen AS lagegenauigkeit,
    CASE
        WHEN lagezuv = 'ja' 
            THEN TRUE
        ELSE FALSE
    END AS lagezuverlaessigkeit,
    grenzpunkt.punktzeichen as punktzeichen_txt,
    CASE 
        WHEN symbol.ori IS NULL 
            THEN (100 - 0) * 0.9
        ELSE (100 - symbol.ori) * 0.9
    END AS symbolorientierung,
    CAST(grenzpunkt.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    nachfuehrung.gueltigkeit AS gueltigkeit
FROM
    agi_dm01avso24.liegenschaften_grenzpunkt AS grenzpunkt 
    LEFT JOIN agi_dm01avso24.liegenschaften_grenzpunktpos AS pos 
        ON pos.grenzpunktpos_von = grenzpunkt.t_id
    LEFT JOIN agi_dm01avso24.liegenschaften_grenzpunktsymbol AS symbol 
        ON symbol.grenzpunktsymbol_von = grenzpunkt.t_id 
    LEFT JOIN agi_dm01avso24.liegenschaften_lsnachfuehrung AS nachfuehrung  
        ON grenzpunkt.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON grenzpunkt.t_basket = basket.t_id    
    LEFT JOIN 
    (
        SELECT
            max(importdate) AS importdate, dataset
        FROM
            agi_dm01avso24.t_ili2db_import
        GROUP BY
            dataset 
    ) AS  aimport
        ON basket.dataset = aimport.dataset    
;