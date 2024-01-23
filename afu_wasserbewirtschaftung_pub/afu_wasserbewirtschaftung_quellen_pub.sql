SELECT
	 TRUE AS gefasst,
	 NULL AS eigentuemer,
	 minimale_schuettung AS min_schuettung,
	 maximale_schuettung AS max_schuettung,
	 schutzzone,
	 CASE nutzungsart
	 	WHEN 'Oeffentliche_Fassung' THEN 'oeffentlich'
	 	WHEN 'Private_Fassung' THEN 'privat'
	 	WHEN 'Private_Fassung_von_oeffentlichem_Interesse' THEN 'privat_oeffentliches_Interesse'
	 	ELSE NULL
	 END AS nutzungstyp,
	 CASE verwendung 
	 	WHEN 'Trinkwasser' THEN 'Trinkwasser'
	 	WHEN 'Brauchwasser' THEN 'Brauchwasser'
	 	WHEN 'Notbrunnen' THEN 'Notbrunnen'
	 	ELSE NULL
	 END AS verwendungszweck,
	 CASE nutzungsart 
	 	WHEN 'Oeffentliche_Fassung' THEN 'Gefasste Quelle für die öffentliche Wasserversorgung'
	 	WHEN 'Private_Fassung' THEN 'Gefasste Quelle mit privater Nutzung'
	 	WHEN 'Private_Fassung_von_oeffentlichem_Interesse' THEN 'Gefasste Quelle mit privater Nutzung von öffentlichem Interesse'
	 	ELSE 'Gefasste Quelle'
	 END AS objekttyp_anzeige,
	 bezeichnung AS objektname,
	 objekt_id AS objektnummer,
	 beschreibung AS technische_angabe,
	 bemerkung,
	 geometrie
FROM afu_wasserversorg_obj_v1.quelle_gefasst;