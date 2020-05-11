WITH aimport AS
(
	SELECT
		max(importdate) AS importdate, dataset
	FROM
		agi_dm01avso24.t_ili2db_import
	GROUP BY
		dataset 
)
SELECT 
    aname.atext AS strassenname,
    CASE
        WHEN pos.ori IS NULL 
            THEN (100 - 100) * 0.9
        ELSE (100 - pos.ori) * 0.9 
    END AS orientierung,
    CASE 
        WHEN pos.hali IS NULL 
            THEN 'Center'
        ELSE pos.hali
    END AS hali,
    CASE 
        WHEN pos.vali IS NULL 
            THEN 'Half'
        ELSE pos.vali
    END AS vali,
    CAST(aname.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    pos.pos
FROM
    agi_dm01avso24.gebaeudeadressen_lokalisationsname AS aname 
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisationsnamepos AS pos 
        ON pos.lokalisationsnamepos_von = aname.t_id
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_lokalisation AS lokalisation
        ON aname.benannte = lokalisation.t_id
    LEFT JOIN agi_dm01avso24.gebaeudeadressen_gebnachfuehrung AS nachfuehrung
        ON lokalisation.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON aname.t_basket = basket.t_id    
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
WHERE
    pos.pos IS NOT NULL
;
