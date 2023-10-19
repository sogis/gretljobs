(SELECT 
	'weitere_Einbauten' AS objektart, 
	'Weitere Einbauten' AS objekttyp_anzeige,
	eb.bezeichnung AS objektname, 
	eb.objekt_id AS objektnummer, 
	eb.beschreibung AS technische_angabe, 
	eb.bemerkung AS bemerkung, 
	array_to_json(dokumente.dokumente) AS dokumente, 
	eb.geometrie
FROM afu_grundwasserschutz_obj_v1.einbaute eb
LEFT JOIN 
	(SELECT
		ebd.einbaute_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.grundwasserschutz\','https://geo.so.ch/docs/ch.so.afu.grundwasserschutz/')) AS dokumente
	FROM 
		afu_grundwasserschutz_obj_v1.einbaute__dokument ebd, 
		afu_grundwasserschutz_obj_v1.dokument d 
	WHERE ebd.dokument_r = d.t_id
	GROUP BY ebd.einbaute_r) dokumente ON eb.t_id = dokumente.einbaute_r)
UNION ALL 
(SELECT 
	'Versickerungsschacht' AS objektart, 
	'Versickerungsschacht' AS objekttyp_anzeige,
	vs.bezeichnung AS objektname, 
	vs.objekt_id AS objektnummer, 
	vs.beschreibung AS technische_angabe, 
	bemerkung, 
	array_to_json(dokumente.dokumente) AS dokumente, 
	vs.geometrie
FROM (SELECT * FROM afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe WHERE schachttyp = 'Rueckgabe' AND zustand != 'Voranfrage') vs
LEFT JOIN 
	(SELECT
		gwwpd.grundwasserwaermepumpe_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.grundwasserschutz\','https://geo.so.ch/docs/ch.so.afu.grundwasserschutz/')) AS dokumente
	FROM 
		afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe__dokument gwwpd, 
		afu_grundwasserschutz_obj_v1.dokument d 
	WHERE gwwpd.dokument_r = d.t_id
	GROUP BY gwwpd.grundwasserwaermepumpe_r) dokumente ON vs.t_id = dokumente.grundwasserwaermepumpe_r)
UNION ALL 
(SELECT 
	'Grundwasserbeobachtung.Piezometer.Bohrung' AS objektart,
	'Bohrung mit Piezometer' AS objekttyp_anzeige, 
	bohrung.bezeichnung AS objektname, 
	bohrung.objekt_id AS objektnummer,
	bohrung.beschreibung AS technische_angabe,
	bohrung.bemerkung, 
	array_to_json(dokumente.dokumente) AS dokumente, 
	bohrung.geometrie
FROM (SELECT * FROM afu_grundwasserschutz_obj_v1.bohrung WHERE piezometer IS TRUE) bohrung 
LEFT JOIN 
	(SELECT
		bd.bohrung_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.grundwasserschutz\','https://geo.so.ch/docs/ch.so.afu.grundwasserschutz/')) AS dokumente
	FROM 
		afu_grundwasserschutz_obj_v1.bohrung__dokument bd, 
		afu_grundwasserschutz_obj_v1.dokument d 
	WHERE bd.dokument_r = d.t_id
	GROUP BY bd.bohrung_r) dokumente ON bohrung.t_id = dokumente.bohrung_r)
UNION ALL 
(SELECT 
	'Grundwasserbeobachtung.Piezometer.Gerammt' AS objektart,
	'Piezometer gerammt' AS objekttyp_anzeige, 
	gerammt.bezeichnung AS objektname, 
	gerammt.objekt_id AS objektnummer,
	gerammt.beschreibung AS technische_angabe,
	gerammt.bemerkung, 
	array_to_json(dokumente.dokumente) AS dokumente, 
	gerammt.geometrie
FROM afu_grundwasserschutz_obj_v1.piezometer_gerammt gerammt
LEFT JOIN 
	(SELECT
		pg.piezometer_gerammt_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.grundwasserschutz\','https://geo.so.ch/docs/ch.so.afu.grundwasserschutz/')) AS dokumente
	FROM 
		afu_grundwasserschutz_obj_v1.piezometer__dokument pg, 
		afu_grundwasserschutz_obj_v1.dokument d 
	WHERE pg.dokument_r = d.t_id
	GROUP BY pg.piezometer_gerammt_r) dokumente ON gerammt.t_id = dokumente.piezometer_gerammt_r)
UNION ALL 
(SELECT 
	'Grundwasserbeobachtung.Sondierung.Bohrung' AS objektart,
	'Sondierungsbohrung' AS objekttyp_anzeige, 
	sondierung.bezeichnung AS objektname, 
	sondierung.objekt_id AS objektnummer,
	sondierung.beschreibung AS technische_angabe,
	sondierung.bemerkung, 
	array_to_json(dokumente.dokumente) AS dokumente, 
	sondierung.geometrie
FROM (SELECT * FROM afu_grundwasserschutz_obj_v1.bohrung WHERE piezometer IS FALSE) sondierung 
LEFT JOIN 
	(SELECT
		s.bohrung_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.grundwasserschutz\','https://geo.so.ch/docs/ch.so.afu.grundwasserschutz/')) AS dokumente
	FROM 
		afu_grundwasserschutz_obj_v1.bohrung__dokument s, 
		afu_grundwasserschutz_obj_v1.dokument d 
	WHERE s.dokument_r = d.t_id
	GROUP BY s.bohrung_r) dokumente ON sondierung.t_id = dokumente.bohrung_r)
UNION ALL
(SELECT 
	'Grundwasserbeobachtung.Sondierung.Baggerschlitz' AS objektart,
	'Sondierungsbaggerschlitz' AS objekttyp_anzeige, 
	baggerschlitz.bezeichnung AS objektname, 
	baggerschlitz.objekt_id AS objektnummer,
	baggerschlitz.beschreibung AS technische_angabe,
	baggerschlitz.bemerkung, 
	array_to_json(dokumente.dokumente) AS dokumente, 
	baggerschlitz.geometrie
FROM afu_grundwasserschutz_obj_v1.baggerschlitz baggerschlitz 
LEFT JOIN 
	(SELECT
		s.baggerschlitz_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.grundwasserschutz\','https://geo.so.ch/docs/ch.so.afu.grundwasserschutz/')) AS dokumente
	FROM 
		afu_grundwasserschutz_obj_v1.baggerschlitz__dokument s, 
		afu_grundwasserschutz_obj_v1.dokument d 
	WHERE s.dokument_r = d.t_id
	GROUP BY s.baggerschlitz_r) dokumente ON baggerschlitz.t_id = dokumente.baggerschlitz_r)
;
