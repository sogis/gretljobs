WITH

nvoranfrage AS (
	SELECT 
	'neue_Voranfrage' AS verfahrensstand,
	'Grundwasserwärmepumpen Entnahmeschacht' AS objekttyp_anzeige,
	bezeichnung AS objektname,
	objekt_id AS objektnummer,
	beschreibung AS technische_angabe,
	bemerkung,
	geometrie
	FROM afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe
	WHERE schachttyp != 'Rueckgabe'
	AND
	zustand = 'Voranfrage'
	AND
	aufnahmedatum >= current_date - INTERVAL '5 years'
),

avoranfrage AS (
	SELECT  
	'alte_Voranfrage' AS verfahrensstand,
	'Grundwasserwärmepumpen Entnahmeschacht' AS objekttyp_anzeige,
	bezeichnung AS objektname,
	objekt_id AS objektnummer,
	beschreibung AS technische_angabe,
	bemerkung,
	geometrie	
	FROM afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe
	WHERE schachttyp != 'Rueckgabe'
	AND
	zustand = 'Voranfrage'
	AND
	aufnahmedatum < current_date - INTERVAL '5 years'
),

bewilligt AS (
	SELECT
	'bewilligt' AS verfahrensstand,
	'Grundwasserwärmepumpen Entnahmeschacht' AS objekttyp_anzeige,
	bezeichnung AS objektname,
	objekt_id AS objektnummer,
	beschreibung AS technische_angabe,
	bemerkung,
	geometrie	
	FROM afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe
	WHERE schachttyp != 'Rueckgabe'
	AND zustand = 'in_Betrieb'
),

gwwpumpe_entnahme AS(
	SELECT * FROM nvoranfrage
	UNION ALL
	SELECT * FROM avoranfrage
	UNION ALL
	SELECT * from bewilligt
)

SELECT * FROM gwwpumpe_entnahme