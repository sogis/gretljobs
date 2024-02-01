WITH

http_dokument AS (
    SELECT
	    concat(
		    'https://geo.so.ch/docs/ch.so.afu.wasserversorgung/', 
		    split_part(
			    dateiname, 
			    'ch.so.afu.wasserversorgung\', 
			    2
		    )
	    ) AS url,
	    t_id
    FROM 
	    afu_wasserversorg_obj_v1.dokument d
),

dokumente_quelle_gefasst AS (
    SELECT
 	    qgd.quelle_gefasst_r,   
	    json_agg(d.url ORDER BY url) AS dokumente
    FROM 
	    http_dokument d
    JOIN
	    afu_wasserversorg_obj_v1.quelle_gefasst__dokument qgd ON d.t_id = qgd.dokument_r
    GROUP BY
	    quelle_gefasst_r
)

SELECT
	 TRUE AS gefasst,
	 NULL AS eigentuemer,
	 minimale_schuettung AS min_schuettung,
	 maximale_schuettung AS max_schuettung,
	 schutzzone,
	 CASE nutzungsart
	 	WHEN 'Oeffentliche_Fassung'
	 		THEN 'oeffentlich'
	 	WHEN 'Private_Fassung'
	 		THEN 'privat'
	 	WHEN 'Private_Fassung_von_oeffentlichem_Interesse'
	 		THEN 'privat_oeffentliches_Interesse'
	 	ELSE
	 		NULL
	 END AS nutzungstyp,
	 CASE verwendung 
	 	WHEN 'keine_Angabe'
	 		THEN NULL
	 	ELSE
	 		verwendung 
	 END AS verwendungszweck,
	 CASE nutzungsart 
	 	WHEN 'Oeffentliche_Fassung'
	 		THEN 'Gefasste Quelle für die öffentliche Wasserversorgung'
	 	WHEN 'Private_Fassung'
	 		THEN 'Gefasste Quelle mit privater Nutzung'
	 	WHEN 'Private_Fassung_von_oeffentlichem_Interesse'
	 		THEN 'Gefasste Quelle mit privater Nutzung von öffentlichem Interesse'
	 	ELSE
	 		'Gefasste Quelle'
	 END AS objekttyp_anzeige,
	 bezeichnung AS objektname,
	 objekt_id AS objektnummer,
	 beschreibung AS technische_angabe,
	 bemerkung,
	 dqg.dokumente,
	 geometrie
FROM
	afu_wasserversorg_obj_v1.quelle_gefasst
LEFT JOIN
	dokumente_quelle_gefasst dqg ON t_id = dqg.quelle_gefasst_r
;