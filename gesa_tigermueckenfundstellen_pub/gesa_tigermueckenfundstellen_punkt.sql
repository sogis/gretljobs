WITH

ovitraps AS (
	SELECT
		*
	FROM (
		SELECT 
			trapid,
			typ,
			kanton,
			plz || ' ' || ort AS gemeinde,
			standort,
			lv95_e,
			lv95_n,
			jahr,
			woche,
			TO_DATE(datumsetfirst, 'MM.DD.YYYY') AS datumsetfirst,
			TO_DATE(datumsetlast, 'MM.DD.YYYY') AS datumsetlast,
			TO_DATE(datumsam, 'MM.DD.YYYY') AS sammeldatum,
			
			ZeitraumSam AS Sammelzeitraum,
			SamMethode AS sammelmethode,
			CASE
				WHEN positiv IS NOT NULL 
					THEN positiv
				WHEN positiv IS NULL AND n_individuen > 0
					THEN 'Ja'
				ELSE 'Nein'
			END AS positiv,
			
			-- Anzahl positive und negative Funde
			COUNT(*) FILTER (WHERE positiv = 'Ja') OVER (PARTITION BY trapid) AS anzahl_positv,
			COUNT(*) FILTER (WHERE positiv = 'Nein') OVER (PARTITION BY trapid) AS anzahl_negativ,
			
			-- letztes positives Sammeldatum
			MAX(
				CASE 
					WHEN LOWER(TRIM(positiv)) = 'ja' 
					THEN TO_DATE(datumsam, 'MM.DD.YYYY')
				END
			) OVER (PARTITION BY trapid) AS datum_positiv,
			
			geschlecht,
			art,
			'-' AS sicherheit,
			n_MALDI_TOF_MS,
			fallenzustand,
			'-' AS einsender,
			TO_DATE(meldedatum, 'MM.DD.YYYY') AS meldedatum,
			ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie,

			-- neuester Datensatz bestimmen
			ROW_NUMBER() OVER (
				PARTITION BY trapid 
				ORDER BY TO_DATE(datumsam, 'MM.DD.YYYY') DESC
			) AS rn

		FROM 
			gesa_tigermueckenfundstellen_v1.csv_import
	) AS t
	WHERE
		rn = 1
	AND 
		t.sammelmethode = 'Ovitrap'
),

privatmeldungen AS (
	SELECT 
			'-' AS trapid,
			typ,
			kanton,
			ort AS gemeinde,
			standort,
			lv95_e,
			lv95_n,
			jahr,
			woche,
			TO_DATE(datumsetfirst, 'MM.DD.YYYY') AS datumsetfirst,
			TO_DATE(datumsetlast, 'MM.DD.YYYY') AS datumsetlast,
			TO_DATE(datumsam, 'MM.DD.YYYY') AS sammeldatum,
			
			ZeitraumSam AS Sammelzeitraum,
			'Privat' AS sammelmethode,
			positiv,
			
			-- Anzahl positive und negative Funde
			COUNT(*) FILTER (WHERE positiv = 'Ja') OVER (PARTITION BY ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056)) AS anzahl_positv,
			COUNT(*) FILTER (WHERE positiv = 'Nein') OVER (PARTITION BY ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056)) AS anzahl_negativ,
			
			-- letztes positives Sammeldatum
			MAX(
				CASE 
					WHEN LOWER(TRIM(positiv)) = 'ja' 
					THEN TO_DATE(datumsam, 'MM.DD.YYYY')
				END
			) OVER (PARTITION BY (ST_MakePoint(lv95_e, lv95_n), 2056)) AS datum_positiv,
			
			geschlecht,
			art,
			sicherheit,
			n_MALDI_TOF_MS,
			'-' AS fallenzustand,
			einsender,
			TO_DATE(meldedatum, 'MM.DD.YYYY') AS meldedatum,
			ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie
	FROM 
		gesa_tigermueckenfundstellen_v1.csv_import
	WHERE 
		SamMethode IS DISTINCT FROM 'Ovitrap'
	AND 
		lv95_e IS NOT NULL
),

fundstellen_zusammengefasst AS (
	SELECT 
		trapid,
		typ,
		kanton,
		gemeinde,
		standort,
		lv95_e,
		lv95_n,
		jahr,
		woche,
		datumsetfirst,
		datumsetlast,
		sammeldatum,
		Sammelzeitraum,
		sammelmethode,
		positiv,
		anzahl_positv,
		anzahl_negativ,
		datum_positiv,
		geschlecht,
		art,
		sicherheit,
		n_MALDI_TOF_MS,
		fallenzustand,
		einsender,
		meldedatum,
		geometrie
	FROM 
		ovitraps
	
	UNION ALL
	
	SELECT 
		pm.trapid,
		pm.typ,
		pm.kanton,
		plz.plz || ' ' || pm.gemeinde AS gemeinde,
		pm.standort,
		pm.lv95_e,
		pm.lv95_n,
		pm.jahr,
		pm.woche,
		pm.datumsetfirst,
		pm.datumsetlast,
		pm.sammeldatum,
		pm.Sammelzeitraum,
		pm.sammelmethode,
		pm.positiv,
		pm.anzahl_positv,
		pm.anzahl_negativ,
		pm.datum_positiv,
		pm.geschlecht,
		pm.art,
		pm.sicherheit,
		pm.n_MALDI_TOF_MS,
		pm.fallenzustand,
		pm.einsender,
		pm.meldedatum,
		pm.geometrie
	FROM 
		privatmeldungen AS pm
	LEFT JOIN agi_plz_ortschaften_pub.plzortschaften_postleitzahl AS plz
		ON ST_Intersects(pm.geometrie, plz.geometrie)
)

SELECT
	trapid,
	typ,
	kanton,
	gemeinde,
	standort,
	lv95_e,
	lv95_n,
	jahr,
	woche,
	datumsetfirst,
	datumsetlast,
	sammeldatum,
	Sammelzeitraum,
	sammelmethode,
	positiv,
	anzahl_positv,
	anzahl_negativ,
	datum_positiv,
	geschlecht,
	art,
	sicherheit,
	n_MALDI_TOF_MS,
	fallenzustand,
	einsender,
	meldedatum,
	geometrie
FROM 
	fundstellen_zusammengefasst
;
