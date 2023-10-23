(SELECT 
	'Sodbrunnen' AS fassungstyp,
	sb.konzessionsmenge, 
	FALSE AS schutzzone, 
	NULL AS nutzungstyp,
	'Sodbrunnen' AS objekttyp_anzeige,
	CASE
		WHEN sb.verwendung = 'keine_Angabe' THEN NULL
		ELSE sb.verwendung
	END AS verwendungszweck,
	sb.bezeichnung AS objektname, 
	sb.objekt_id AS objektnummer,
	sb.beschreibung AS technische_angabe,
	sb.bemerkung,
	array_to_json(dokumente.dokumente) AS dokumente, 
	sb.geometrie
FROM afu_grundwasserschutz_obj_v1.sodbrunnen sb
LEFT JOIN 
	(SELECT
		sbd.sodbrunnen_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.grundwasserschutz\','https://geo.so.ch/docs/ch.so.afu.grundwasserschutz/')) AS dokumente
	FROM 
		afu_grundwasserschutz_obj_v1.sodbrunnen__dokument sbd, 
		afu_grundwasserschutz_obj_v1.dokument d 
	WHERE sbd.dokument_r = d.t_id
	GROUP BY sbd.sodbrunnen_r) dokumente ON sb.t_id = dokumente.sodbrunnen_r)
UNION ALL 
(SELECT 
	CASE
		WHEN fb.typ = 'vertikal' THEN 'Vertikalfilterbrunnen'
		WHEN fb.typ = 'horizontal' THEN 'Horizontalfilterbrunnen'
	END AS fassungstyp, 
    	fb.konzessionsmenge,
 	fb.schutzzone, 
	CASE 
		WHEN fb.nutzungsart = 'Private_Fassung' THEN 'privat'
		WHEN fb.nutzungsart = 'Private_Fassung_von_oeffentlichem_Interesse' THEN 'privat_oeffentliches_Interesse'
		WHEN fb.nutzungsart = 'Oeffentliche_Fassung' THEN 'oeffentlich'
		ELSE NULL
	END AS nutzungstyp, 
	CASE
		WHEN fb.typ = 'vertikal' THEN
			CASE 
				WHEN fb.nutzungsart = 'Private_Fassung' THEN 'Vertikalfilterbrunnen mit privater Nutzung'
				WHEN fb.nutzungsart = 'Private_Fassung_von_oeffentlichem_Interesse' THEN 'Vertikalfilterbrunnen mit privater Nutzung von öffentlichem Interesse'
				WHEN fb.nutzungsart = 'Oeffentliche_Fassung' THEN 'Vertikalfilterbrunnen für die öffentliche Wasserversorgung' 
				WHEN fb.nutzungsart = 'keine_Angabe' THEN 'Vertikalfilterbrunnen'
			END
		WHEN fb.typ = 'horizontal' THEN 
			CASE 
				WHEN fb.nutzungsart = 'Private_Fassung' THEN 'Horizontalfilterbrunnen mit privater Nutzung'
				WHEN fb.nutzungsart = 'Private_Fassung_von_oeffentlichem_Interesse' THEN 'Horizontalfilterbrunnen mit privater Nutzung von öffentlichem Interesse'
				WHEN fb.nutzungsart = 'Oeffentliche_Fassung' THEN 'Horizontalfilterbrunnen für die öffentliche Wasserversorgung' 
				WHEN fb.nutzungsart = 'keine_Angabe' THEN 'Horizontalfilterbrunnen'
			END
	END AS objekttyp_anzeige,
	CASE
		WHEN fb.verwendung = 'keine_Angabe' THEN NULL
		ELSE fb.verwendung
	END AS verwendungszweck,
    	fb.bezeichnung AS objektname, 
	fb.objekt_id AS objektnummer,
	fb.beschreibung AS technische_angabe,
	fb.bemerkung,
	array_to_json(dokumente.dokumente) AS dokumente, 
	fb.geometrie
 FROM afu_wasserversorg_obj_v1.filterbrunnen fb
 LEFT JOIN 
	(SELECT
		fbd.filterbrunnen_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.wasserversorgung\','https://geo.so.ch/docs/ch.so.afu.wasserversorgung/')) AS dokumente
	FROM 
		afu_wasserversorg_obj_v1.filterbrunnen__dokument fbd, 
		afu_wasserversorg_obj_v1.dokument d 
	WHERE fbd.dokument_r = d.t_id
	GROUP BY fbd.filterbrunnen_r) dokumente ON fb.t_id = dokumente.filterbrunnen_r)
;
