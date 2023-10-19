(SELECT 
    CASE 
        WHEN (gwwp.aufnahmedatum < (SELECT date('now') - interval '5 years') AND gwwp.zustand = 'Voranfrage') 
            THEN 'alte_Voranfrage' 
        WHEN (gwwp.aufnahmedatum >= (SELECT date('now') - interval '5 years') AND gwwp.zustand = 'Voranfrage') 
            THEN 'neue_Voranfrage' 
        WHEN (gwwp.schachttyp != 'Rueckgabe' AND gwwp.zustand != 'Voranfrage') 
            THEN 'bewilligt'
        ELSE 'unbekannter_Verfahrensstand'
    END AS verfahrensstand, 
	'Grundwasserwärmepumpen Entnahmeschacht' AS objekttyp_anzeige,
	gwwp.bezeichnung AS objektname, 
	gwwp.objekt_id AS objektnummer, 
	gwwp.beschreibung AS technische_angabe, 
	bemerkung, 
	array_to_json(dokumente.dokumente) AS dokumente, 
	gwwp.geometrie
FROM afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe gwwp
LEFT JOIN 
	(SELECT
		gwwpd.grundwasserwaermepumpe_r,
		array_agg(REPLACE(d.dateiname,'G:\documents\ch.so.afu.grundwasserschutz\','https://geo.so.ch/docs/ch.so.afu.grundwasserschutz/')) AS dokumente
	FROM 
		afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe__dokument gwwpd, 
		afu_grundwasserschutz_obj_v1.dokument d 
	WHERE gwwpd.dokument_r = d.t_id
	GROUP BY gwwpd.grundwasserwaermepumpe_r) dokumente ON gwwp.t_id = dokumente.grundwasserwaermepumpe_r)
;
