(SELECT 
	TRUE AS gefasst,
	NULL AS eigentuemer, 
	qg.minimale_schuettung AS min_schuettung, 
	qg.maximale_schuettung AS max_schuettung,
	qg.schutzzone,
	CASE 
		WHEN qg.nutzungsart = 'Private_Fassung' THEN 'privat'
		WHEN qg.nutzungsart = 'Private_Fasung_von_oeffentlichem_Interesse' THEN 'privat_oeffentliches_Interesse'
		WHEN qg.nutzungsart = 'Private_Fassung_von_oeffentlichem_Interesse' THEN 'privat_oeffentliches_Interesse'
		WHEN qg.nutzungsart = 'Oeffentliche_Fassung' THEN 'oeffentlich'
	END AS nutzungstyp,
	verwendung AS verwendungszweck,
	CASE
		WHEN qg.nutzungsart = 'Private_Fassung' THEN 'Gefasste Quelle mit privater Nutzung'
		WHEN qg.nutzungsart = 'Private_Fassung_von_oeffentlichem_Interesse' THEN 'Gefasste Quelle mit privater Nutzung von öffentlichem Interesse'
		WHEN qg.nutzungsart = 'Private_Fasung_von_oeffentlichem_Interesse' THEN 'Gefasste Quelle mit privater Nutzung von öffentlichem Interesse'
		WHEN qg.nutzungsart = 'Oeffentliche_Fassung' THEN 'Gefasste Quelle für die öffentliche Wasserversorgung' 
		WHEN qg.nutzungsart = 'keine Angabe' THEN 'Gefasste Quelle'
	END AS objekttyp_anzeige,
	qg.bezeichnung AS objektname, 
	qg.objekt_id AS objektnummer,
	qg.beschreibung AS technische_angabe,
	qg.bemerkung,
	array_to_json(dokumente.dokumente) AS dokumente, 
	qg.geometrie
FROM afu_wasserversorg_obj_v1.quelle_gefasst qg
LEFT JOIN 
	(SELECT
		qgd.quelle_gefasst_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.wasserversorgung\','https://geo.so.ch/docs/ch.so.afu.wasserversorgung/')) AS dokumente
	FROM 
		afu_wasserversorg_obj_v1.quelle_gefasst__dokument qgd, 
		afu_wasserversorg_obj_v1.dokument d 
	WHERE qgd.dokument_r = d.t_id
	GROUP BY qgd.quelle_gefasst_r) dokumente ON qg.t_id = dokumente.quelle_gefasst_r)
;
