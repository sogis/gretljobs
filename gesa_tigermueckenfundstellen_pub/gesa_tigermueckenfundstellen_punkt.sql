WITH

-- aufgestellte Fallen --
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
			SamMethode AS SamMethode,
			CASE
				WHEN positiv IS NOT NULL 
					THEN positiv
				WHEN positiv IS NULL AND n_individuen > 0
					THEN 'Ja'
				ELSE 'Nein'
			END AS positiv,
			n_individuen,
			geschlecht,
			art,
			'-' AS sicherheit, -- nur bei Privatmeldungen relevant
			n_MALDI_TOF_MS,
			fallenzustand,
			'-' AS einsender, -- nur bei Privatmeldungen relevant
			TO_DATE(meldedatum, 'MM.DD.YYYY') AS meldedatum,
			kommentar,
			-- Anzahl positive und negative Funde
			COUNT(*) FILTER (WHERE positiv = 'Ja') OVER (PARTITION BY trapid) AS positiv_anzahl,
			COUNT(*) FILTER (WHERE positiv = 'Nein') OVER (PARTITION BY trapid) AS negativ_anzahl,
			-- letztes positives Sammeldatum
			MAX(
				CASE 
					WHEN LOWER(TRIM(positiv)) = 'ja' 
					THEN TO_DATE(datumsam, 'MM.DD.YYYY')
				END
			) OVER (PARTITION BY trapid) AS sammeldatum_positiv,
			ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie,
			-- neuesten Datensatz nach Kalenderwoche bestimmen
			ROW_NUMBER() OVER (
				PARTITION BY trapid 
				ORDER BY woche DESC
			) AS rn
		FROM 
			gesa_tigermueckenfundstellen_v1.csv_import
	) AS t
	WHERE
		rn = 1
	AND 
		t.SamMethode = 'Ovitrap'
	AND 
		t.art = 'Aedes albopictus' -- Nur Tigermücken
	AND
		t.positiv_anzahl > 0
),

-- Meldungen von Privatpersonen --
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
			'Privat' AS SamMethode,
			positiv,
			n_individuen,
			geschlecht,
			art,
			sicherheit,
			n_MALDI_TOF_MS,
			'-' AS fallenzustand, -- Bei Privatmeldungen nicht relevant
			einsender,
			TO_DATE(meldedatum, 'MM.DD.YYYY') AS meldedatum,
			kommentar,
			-- Anzahl positive und negative Funde
			COUNT(*) FILTER (WHERE positiv = 'Ja') OVER (PARTITION BY ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056)) AS positiv_anzahl,
			COUNT(*) FILTER (WHERE positiv = 'Nein') OVER (PARTITION BY ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056)) AS negativ_anzahl,
			-- letztes positives Sammeldatum
			MAX(
				CASE 
					WHEN LOWER(TRIM(positiv)) = 'ja' 
					THEN TO_DATE(datumsam, 'MM.DD.YYYY')
				END
			) OVER (PARTITION BY (ST_MakePoint(lv95_e, lv95_n), 2056)) AS sammeldatum_positiv,
			ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie
	FROM 
		gesa_tigermueckenfundstellen_v1.csv_import
	WHERE 
		SamMethode IS DISTINCT FROM 'Ovitrap'
	AND
		art = 'Aedes albopictus' -- Nur Tigermücken
	AND 
		sicherheit = 'Sicher' -- Nur sichere Funde
	AND 
		lv95_e IS NOT NULL -- Meldungen ohne geografische Angaben sind nicht brauchbar
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
		SamMethode,
		positiv,
		n_individuen,
		geschlecht,
		art,
		sicherheit,
		n_MALDI_TOF_MS,
		fallenzustand,
		einsender,
		meldedatum,
		kommentar,
		positiv_anzahl,
		negativ_anzahl,
		sammeldatum_positiv,
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
		pm.SamMethode,
		pm.positiv,
		pm.n_individuen,
		pm.geschlecht,
		pm.art,
		pm.sicherheit,
		pm.n_MALDI_TOF_MS,
		pm.fallenzustand,
		pm.einsender,
		pm.meldedatum,
		pm.kommentar,
		pm.positiv_anzahl,
		pm.negativ_anzahl,
		pm.sammeldatum_positiv,
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
	SamMethode,
	positiv,
	n_individuen,
	geschlecht,
	art,
	sicherheit,
	n_MALDI_TOF_MS,
	fallenzustand,
	einsender,
	meldedatum,
	kommentar,
	positiv_anzahl,
	negativ_anzahl,
	sammeldatum_positiv,
	geometrie
FROM 
	fundstellen_zusammengefasst
;
