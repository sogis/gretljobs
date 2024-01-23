WITH

sodbrunnen AS (
	SELECT 
		'Sodbrunnen' AS fassungstyp,
		konzessionsmenge,
		FALSE AS schutzzone,
		NULL AS nutzungstyp,
		verwendung AS verwendungszweck,
		'Sodbrunnen' AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		geometrie
	FROM
		afu_grundwasserschutz_obj_v1.sodbrunnen
),

horizontalfilterbrunnen AS (
	SELECT 
		'Horizontalfilterbrunnen' AS fassungstyp,
		konzessionsmenge,
		schutzzone,
	 	CASE nutzungsart
	 		WHEN 'Oeffentliche_Fassung' THEN 'oeffentlich'
	 		WHEN 'Private_Fassung' THEN 'privat'
	 		WHEN 'Private_Fassung_von_oeffentlichem_Interesse' THEN 'privat_oeffentliches_Interesse'
	 		ELSE NULL
	 	END AS nutzungstyp,
		verwendung AS verwendungszweck,
	 	CASE nutzungsart
	 		WHEN 'Oeffentliche_Fassung' THEN 'Horizontalfilterbrunnen für die öffentliche Wasserversorgung'
	 		WHEN 'Private_Fassung' THEN 'Horizontalfilterbrunnen mit privater Nutzung'
	 		WHEN 'Private_Fassung_von_oeffentlichem_Interesse' THEN 'Horizontalfilterbrunnen mit privater Nutzung von öffentlichem Interesse'
	 		ELSE 'Horizontalfilterbrunnen'
	 	END AS objekttyp_anzeige,
		bezeichnung AS objektname,
		objekt_id AS objektnummer,
		beschreibung AS technische_angabe,
		bemerkung,
		geometrie
	FROM
		afu_wasserversorg_obj_v1.filterbrunnen
		WHERE typ = 'horizontal'
),

fassung AS (
	SELECT * FROM sodbrunnen
	UNION ALL
	SELECT * FROM horizontalfilterbrunnen
)

SELECT * FROM fassung;
