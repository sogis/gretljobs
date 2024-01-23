WITH

sondierungsbohrung AS (
	SELECT 
		'Grundwasserbeobachtung.Sondierung.Bohrung' AS objektart,
		'Sondierungsbohrung' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		geometrie
	FROM
		afu_grundwasserschutz_obj_v1.bohrung
		WHERE piezometer = FALSE
),

piezometerbohrung AS (
	SELECT 
		'Grundwasserbeobachtung.Piezometer.Bohrung' AS objektart,
		'Bohrung mit Piezometer' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		geometrie
	FROM
		afu_grundwasserschutz_obj_v1.bohrung
		WHERE piezometer = TRUE
),

einbaute AS (
	SELECT 
		'weitere_Einbauten' AS objektart,
		'Weitere Einbauten' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		geometrie
	FROM
		afu_grundwasserschutz_obj_v1.einbaute
),

baggerschlitz AS (
	SELECT 
		'Grundwasserbeobachtung.Sondierung.Baggerschlitz' AS objektart,
		'Sondierungsbaggerschlitz' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		geometrie
	FROM
		afu_grundwasserschutz_obj_v1.baggerschlitz
),

piezometer_gerammt AS (
	SELECT 
		'Grundwasserbeobachtung.Piezometer.Gerammt' AS objektart,
		'Piezometer gerammt' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		geometrie
	FROM
		afu_grundwasserschutz_obj_v1.piezometer_gerammt
),

versickerungsschacht AS (
	SELECT 
		'Versickerungsschacht' AS objektart,
		'Versickerungsschacht' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		geometrie
	FROM
		afu_grundwasserschutz_obj_v1.grundwasserwaermepumpe
		WHERE schachttyp = 'Rueckgabe'
),

grundwassereinbauten AS (
	SELECT * FROM sondierungsbohrung
	UNION ALL
	SELECT * FROM piezometerbohrung
	UNION ALL
	SELECT * FROM einbaute
	UNION ALL
	SELECT * FROM baggerschlitz
	UNION ALL
	SELECT * FROM piezometer_gerammt
	UNION ALL
	SELECT * FROM versickerungsschacht
)

SELECT * FROM grundwassereinbauten;
