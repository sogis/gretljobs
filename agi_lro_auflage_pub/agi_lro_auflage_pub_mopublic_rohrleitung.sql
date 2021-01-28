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
    objekt.art AS art_txt,
    objekt.betreiber,
    CAST(objekt.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    linie.geometrie AS geometrie 
FROM
    agi_lro_auflage.rohrleitungen_linienelement AS linie  
    LEFT JOIN agi_lro_auflage.rohrleitungen_leitungsobjekt AS objekt 
        ON linie.linienelement_von = objekt.t_id
    LEFT JOIN agi_lro_auflage.rohrleitungen_rlnachfuehrung AS nachfuehrung
        ON objekt.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_lro_auflage.t_ili2db_basket AS basket
        ON objekt.t_basket = basket.t_id    
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
;
