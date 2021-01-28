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
    aname.atext AS strassenname,
    strasse.ordnung,
    CAST(strasse.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    strasse.geometrie AS geometrie 
FROM
    agi_lro_auflage.gebaeudeadressen_strassenstueck AS strasse
    LEFT JOIN agi_lro_auflage.gebaeudeadressen_lokalisation AS lokalisation
        ON strasse.strassenstueck_von = lokalisation.t_id
    LEFT JOIN agi_lro_auflage.gebaeudeadressen_lokalisationsname AS aname
        ON aname.benannte = lokalisation.t_id
    LEFT JOIN agi_lro_auflage.gebaeudeadressen_gebnachfuehrung AS nachfuehrung 
        ON nachfuehrung.t_id = lokalisation.entstehung
    LEFT JOIN agi_lro_auflage.t_ili2db_basket AS basket
        ON strasse.t_basket = basket.t_id    
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
;
