(SELECT 
    'Kontrollschacht' AS trinkwasserobjektart,
    'Kontrollschacht' AS objekttyp_anzeige,
	ks.bezeichnung AS objektname, 
	ks.objekt_id AS objektnummer,
	ks.beschreibung AS technische_angabe,
	ks.bemerkung,
	array_to_json(dokumente.dokumente) AS dokumente, 
	ks.geometrie
FROM afu_wasserversorg_obj_v1.kontrollschacht ks
LEFT JOIN 
	(SELECT
		ksd.kontrollschacht_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.wasserversorgung\','https://geo.so.ch/docs/ch.so.afu.wasserversorgung/')) AS dokumente
	FROM 
		afu_wasserversorg_obj_v1.kontrollschacht__dokument ksd, 
		afu_wasserversorg_obj_v1.dokument d 
	WHERE ksd.dokument_r = d.t_id
	GROUP BY ksd.kontrollschacht_r) dokumente ON ks.t_id = dokumente.kontrollschacht_r)
UNION ALL
(SELECT 
    'Sammelbrunnenstube' AS trinkwasserobjektart,
    'Sammelbrunnenstube' AS objekttyp_anzeige,
	sbs.bezeichnung AS objektname, 
	sbs.objekt_id AS objektnummer,
	sbs.beschreibung AS technische_angabe,
	sbs.bemerkung,
	array_to_json(dokumente.dokumente) AS dokumente, 
	sbs.geometrie
FROM afu_wasserversorg_obj_v1.sammelbrunnstube sbs
LEFT JOIN 
	(SELECT
		sbsd.sammelbrunnstube_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.wasserversorgung\','https://geo.so.ch/docs/ch.so.afu.wasserversorgung/')) AS dokumente
	FROM 
		afu_wasserversorg_obj_v1.sammelbrunnstube__dokument sbsd, 
		afu_wasserversorg_obj_v1.dokument d 
	WHERE sbsd.dokument_r = d.t_id
	GROUP BY sbsd.sammelbrunnstube_r) dokumente ON sbs.t_id = dokumente.sammelbrunnstube_r)
UNION ALL
(SELECT 
    'Quellwasserbehaelter' AS trinkwasserobjektart,
    'Quellwasserbehälter' AS objekttyp_anzeige,
	qwb.bezeichnung AS objektname, 
	qwb.objekt_id AS objektnummer,
	qwb.beschreibung AS technische_angabe,
	qwb.bemerkung,
	array_to_json(dokumente.dokumente) AS dokumente, 
	qwb.geometrie
FROM afu_wasserversorg_obj_v1.quellwasserbehaelter qwb
LEFT JOIN 
	(SELECT
		qwbd.quellwasserbehaelter_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.wasserversorgung\','https://geo.so.ch/docs/ch.so.afu.wasserversorgung/')) AS dokumente
	FROM 
		afu_wasserversorg_obj_v1.quellwasserbehaelter__dokument qwbd, 
		afu_wasserversorg_obj_v1.dokument d 
	WHERE qwbd.dokument_r = d.t_id
	GROUP BY qwbd.quellwasserbehaelter_r) dokumente ON qwb.t_id = dokumente.quellwasserbehaelter_r)
UNION ALL
(SELECT 
    'Pumpwerk' AS trinkwasserobjektart,
    'Pumpwerk' AS objekttyp_anzeige,
	pw.bezeichnung AS objektname, 
	pw.objekt_id AS objektnummer,
	pw.beschreibung AS technische_angabe,
	pw.bemerkung,
	array_to_json(dokumente.dokumente) AS dokumente, 
	pw.geometrie
FROM afu_wasserversorg_obj_v1.pumpwerk pw
LEFT JOIN 
	(SELECT
		qwbd.pumpwerk_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.wasserversorgung\','https://geo.so.ch/docs/ch.so.afu.wasserversorgung/')) AS dokumente
	FROM 
		afu_wasserversorg_obj_v1.pumpwerk__dokument qwbd, 
		afu_wasserversorg_obj_v1.dokument d 
	WHERE qwbd.dokument_r = d.t_id
	GROUP BY qwbd.pumpwerk_r) dokumente ON pw.t_id = dokumente.pumpwerk_r)
UNION ALL
(SELECT 
    'Reservoir' AS trinkwasserobjektart,
    'Reservoir' AS objekttyp_anzeige,
	r.bezeichnung AS objektname, 
	r.objekt_id AS objektnummer,
	r.beschreibung AS technische_angabe,
	r.bemerkung,
	array_to_json(dokumente.dokumente) AS dokumente, 
	r.geometrie
FROM afu_wasserversorg_obj_v1.reservoir r
LEFT JOIN 
	(SELECT
		rd.reservoir_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.wasserversorgung\','https://geo.so.ch/docs/ch.so.afu.wasserversorgung/')) AS dokumente
	FROM 
		afu_wasserversorg_obj_v1.reservoir__dokument rd, 
		afu_wasserversorg_obj_v1.dokument d 
	WHERE rd.dokument_r = d.t_id
	GROUP BY rd.reservoir_r) dokumente ON r.t_id = dokumente.reservoir_r)
;
