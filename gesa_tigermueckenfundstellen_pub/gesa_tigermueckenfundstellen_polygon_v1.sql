WITH

-- aufgestellte Fallen --
ovitraps_punkte AS (
	SELECT
		*
	FROM (
		SELECT 
			trapid,
			SamMethode AS sammelmethode,
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
			gesa_tigermueckenfundstellen_v1.csv_import
	) AS t
	WHERE
		rn = 1
	AND 
		t.sammelmethode = 'Ovitrap'
	AND 
		t.art = 'Aedes albopictus'
	AND
		t.anzahl_positiv > 0
),

-- Meldungen von Privatpersonen --
privatmeldungen_punkte AS (
	SELECT 
			ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie
	FROM 
		gesa_tigermueckenfundstellen_v1.csv_import
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
		geometrie
	FROM 
		ovitraps_punkte
	
	UNION ALL
	
	SELECT 
		geometrie
	FROM 
		privatmeldungen_punkte
),

-- Punktgeometrie wird aus Sicherheitsgründen zufällig um 0-10 m verschieben
punktgeometrie_verwackelt AS (
	SELECT 
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
buffer200 AS (
	SELECT 
		ST_Buffer(geometrie_shifted,200) AS geometrie
	FROM 
		punktgeometrie_verwackelt
),

-- an Kantonsgrenze schneiden --
buffer200_cut AS (
	SELECT 
		ST_Intersection(b.geometrie, kg.geometrie) AS geometrie
	FROM 
		buffer200 AS b
	LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze AS kg 
		ON ST_Intersects(b.geometrie, kg.geometrie)
),

-- Aneinander grenzende Polygone vereinen und dann wieder in Einzelpolygone aufteilen --
polygon_oeffentlich AS (
	SELECT
		(ST_Dump(ST_UNION(geometrie))).geom AS geometrie
	FROM 
		buffer200_cut
)

SELECT
	'https://so.ch/verwaltung/bau-und-justizdepartement/amt-fuer-umwelt/wasserbau/gebietsfremde-organismen/artenportraits/asiatische-tigermuecke/' AS URL,
	'https://so.ch/fileadmin/internet/ddi/ddi-gesa/PDF/Erkrankungen_und_Impfungen/Klima/2026-04_Merktblatt_Asiatische_Tigermuecke_final.pdf' AS Merkblatt,
	geometrie
FROM 
	polygon_oeffentlich