SELECT
    aname.atext AS strassenname,
    strasse.ordnung,
    CAST(strasse.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    ST_CurveToLine(strasse.geometrie, 0.002, 1, 1) AS geometrie 
FROM
    agi_dm01avso24.gebaeudeadressen_strassenstueck AS strasse
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisation AS lokalisation
        ON strasse.strassenstueck_von = lokalisation.t_id
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisationsname AS aname
        ON aname.benannte = lokalisation.t_id
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_gebnachfuehrung AS nachfuehrung 
        ON nachfuehrung.t_id = lokalisation.entstehung
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON strasse.t_basket = basket.t_id    
    LEFT JOIN 
    (
        SELECT
            max(importdate) AS importdate, dataset
        FROM
            agi_dm01avso24.t_ili2db_import
        GROUP BY
            dataset 
    ) AS aimport
        ON basket.dataset = aimport.dataset    
;