WITH

-- sucht das neuste Jahr aus den Daten --
max_jahr AS (
	SELECT
		MAX(jahr) AS jahr
	FROM gesa_tigermueckenfundstellen_v1.csv_import
),

-- nur Daten aus dem neusten Jahr sollen publiziert werden --
daten_aktuelles_jahr AS (
	SELECT
		t_id,
		t_ili_tid,
		auid,
		trapid,
		typ,
		kanton,
		plz,
		ort,
		standort,
		lv95_e,
		lv95_n,
		jahr,
		woche,
		datumsetfirst,
		datumsetlast,
		datumsam,
		zeitraumsam,
		sammethode,
		positiv,
		n_individuen,
		geschlecht,
		art,
		sicherheit,
		n_maldi_tof_ms,
		fallenzustand,
		einsender,
		meldedatum,
		kommentar
	FROM
		gesa_tigermueckenfundstellen_v1.csv_import
	WHERE 
		jahr = (SELECT jahr FROM max_jahr)
),

-- aufgestellte Fallen --
ovitraps_punkte AS (
	SELECT
		*
	FROM (
		SELECT
			auid,
			trapid,
			SamMethode,
			art,
			-- Anzahl positive Funde
			COUNT(*) FILTER (WHERE positiv = 'Ja') OVER (PARTITION BY trapid) AS anzahl_positiv,
			ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie,
			-- neuesten Datensatz nach Kalenderwoche bestimmen
			ROW_NUMBER() OVER (
				PARTITION BY trapid 
				ORDER BY woche DESC
			) AS rn
		FROM 
			daten_aktuelles_jahr
	) AS t
	WHERE
		rn = 1
	AND 
		t.SamMethode = 'Ovitrap'
	AND 
		t.art = 'Aedes albopictus'
	AND
		t.anzahl_positiv > 0
),

-- Meldungen von Privatpersonen --
privatmeldungen_punkte AS (
	SELECT
		auid,
		ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie
	FROM 
		daten_aktuelles_jahr
	WHERE 
		SamMethode IS DISTINCT FROM 'Ovitrap'
	AND
		art = 'Aedes albopictus'
	AND 
		sicherheit = 'Sicher'
	AND 
		lv95_e IS NOT NULL
),

punktgeometrie_zusammengefasst AS (
	SELECT 
		auid,
		geometrie
	FROM 
		ovitraps_punkte
	
	UNION ALL
	
	SELECT 
		auid,
		geometrie
	FROM 
		privatmeldungen_punkte
),

-- Punktgeometrie wird aus Sicherheitsgründen zufällig um 0-10 m verschieben
punktgeometrie_verwackelt AS (
	SELECT
		auid,
		geometrie AS geometrie_original,
		ST_Translate(
			geometrie,
			(random() * 20 - 10), -- x-Koordinate um -10 bis + 10 m verschieben
			(random() * 20 - 10)  -- y-Koordinate um -10 bis + 10 m verschieben
		) AS geometrie_shifted
	FROM 
		punktgeometrie_zusammengefasst	
),

-- Buffer um verwackelten Punkt erstellen --
buffer150 AS (
	SELECT 
		ST_Buffer(geometrie_shifted,150) AS geometrie
	FROM 
		punktgeometrie_verwackelt
),

-- Aneinander grenzende Polygone vereinen --
polygon_union AS (
	SELECT
		ST_UNION(geometrie)AS geometrie
	FROM 
		buffer150
),

-- Doppelbuffer um Lücken zu schliessen und nicht zusammenhängende Geometrien wieder aufteilen --
polygon_filled AS (
    SELECT
        (ST_Dump(ST_Buffer(ST_Buffer(geometrie, 0.5), -0.5))).geom AS geometrie
    FROM
        polygon_union
),

-- an Kantonsgrenze schneiden --
polygon_cut AS (
	SELECT 
		ST_Intersection(pf.geometrie, kg.geometrie) AS geometrie
	FROM 
		polygon_filled AS pf
	LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze AS kg 
		ON ST_Intersects(pf.geometrie, kg.geometrie)
)

SELECT
	'https://so.ch/verwaltung/departement-des-innern/gesundheitsamt/erkrankungen-und-impfungen/klima-und-gesundheit/asiatische-tigermuecke/' AS URL,
	'https://so.ch/fileadmin/internet/ddi/ddi-gesa/PDF/Erkrankungen_und_Impfungen/Klima/2026-04_Merktblatt_Asiatische_Tigermuecke_final.pdf' AS Merkblatt,
	geometrie
FROM
	polygon_cut