WITH aimport AS
(
    SELECT
        max(importdate) AS importdate, dataset
    FROM
        agi_lro_auflage.t_ili2db_import
    GROUP BY
        dataset 
)
SELECT
    gemeinde.aname AS gemeindename,
    CAST(gemeinde.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    grenze.geometrie AS geometrie
FROM
    agi_lro_auflage.gemeindegrenzen_gemeinde AS gemeinde  
    RIGHT JOIN agi_lro_auflage.gemeindegrenzen_gemeindegrenze AS grenze
        ON grenze.gemeindegrenze_von = gemeinde.t_id
    LEFT JOIN agi_lro_auflage.gemeindegrenzen_gemnachfuehrung AS nachfuehrung
        ON nachfuehrung.t_id = grenze.entstehung
    LEFT JOIN agi_lro_auflage.t_ili2db_basket AS basket
        ON gemeinde.t_basket = basket.t_id    
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
;
