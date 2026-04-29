WITH

-- aufgestellte Fallen --
ovitraps_punkte AS (
	SELECT
		*
	FROM (
		SELECT
			auid,
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
		auid,
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


-- Punkte identifizieren, deren Abstand zwischen 300m und 500m liegt --
punkte_mit_nachbar AS (
	SELECT DISTINCT
		a.auid
	FROM
		punktgeometrie_verwackelt AS a
	JOIN punktgeometrie_verwackelt AS b
		ON a.auid <> b.auid
		AND ST_Distance(a.geometrie_shifted, b.geometrie_shifted) BETWEEN 300 AND 500
),

-- Adaptiver Buffer: 250m wenn 250m-Zonen sich berühren, sonst 150m --
buffer_adaptiv AS (
	SELECT
		CASE
			WHEN pn.auid IS NOT NULL
				THEN ST_Buffer(p.geometrie_shifted, 250)
			ELSE ST_Buffer(p.geometrie_shifted, 150)
		END AS geometrie
	FROM
		punktgeometrie_verwackelt p
	LEFT JOIN punkte_mit_nachbar pn
		ON p.auid = pn.auid
),

-- an Kantonsgrenze schneiden --
buffer_adaptiv_cut AS (
	SELECT
		ST_Intersection(b.geometrie, kg.geometrie) AS geometrie
	FROM
		buffer_adaptiv AS b
	LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze AS kg
		ON ST_Intersects(b.geometrie, kg.geometrie)
),

-- Aneinander grenzende Polygone vereinen und dann wieder in Einzelpolygone aufteilen --
polygon_oeffentlich AS (
	SELECT
		(ST_Dump(ST_UNION(geometrie))).geom AS geometrie
	FROM
		buffer_adaptiv_cut
)

SELECT
	'https://so.ch/verwaltung/departement-des-innern/gesundheitsamt/erkrankungen-und-impfungen/klima-und-gesundheit/asiatische-tigermuecke/' AS URL,
	'https://so.ch/fileadmin/internet/ddi/ddi-gesa/PDF/Erkrankungen_und_Impfungen/Klima/2026-04_Merktblatt_Asiatische_Tigermuecke_final.pdf' AS Merkblatt,
	geometrie
FROM
	polygon_oeffentlich
