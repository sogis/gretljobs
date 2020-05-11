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
    ortsname.aname AS ortsname,
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
    CAST(ortsname.t_datasetname AS INT) AS bfs_nr,    
    aimport.importdate AS importdatum,
    nachfuehrung.gueltigereintrag AS nachfuehrung,
    ortsname.geometrie AS geometrie,    
    pos.pos
FROM
    agi_dm01avso24.nomenklatur_ortsname AS ortsname 
    LEFT JOIN agi_dm01avso24.nomenklatur_ortsnamepos AS pos
        ON pos.ortsnamepos_von = ortsname.t_id
    LEFT JOIN agi_dm01avso24.nomenklatur_nknachfuehrung AS nachfuehrung
        ON ortsname.entstehung = nachfuehrung.t_id
    LEFT JOIN agi_dm01avso24.t_ili2db_basket AS basket
        ON ortsname.t_basket = basket.t_id    
    LEFT JOIN aimport
        ON basket.dataset = aimport.dataset    
;
