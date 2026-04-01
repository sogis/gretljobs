WITH

punktgeometrie AS (
	SELECT 
		trapid,
		plz || ' ' || ort AS Ort,
		standort,
		lv95_e,
		lv95_n,
		positiv,
		n_individuen,
		art,
		ST_SetSRID(ST_MakePoint(lv95_e, lv95_n), 2056) AS geometrie
	FROM 
		gesa_tigermueckenfundstellen_v1.csv_import
),

punktgeometrie_verwackelt AS (
	SELECT 
		trapid,
		Ort,
		standort,
		lv95_e,
		lv95_n,
		positiv,
		n_individuen,
		art,
		geometrie AS geometrie_original,
		ST_Translate(
			geometrie,
			(random() * 20 - 10), -- x-Koordinate um -10 bis + 10 m verschieben
			(random() * 20 - 10)  -- y-Koordinate um -10 bis + 10 m verschieben
		) AS geometrie_shifted
	FROM 
		punktgeometrie
),

buffer200 AS (
	SELECT 
		trapid,
		Ort,
		standort,
		lv95_e,
		lv95_n,
		positiv,
		n_individuen,
		art,
		ST_Buffer(geometrie_shifted,200) AS geometrie
	FROM 
		punktgeometrie_verwackelt
),

buffer200_cut AS (
	SELECT 
		b.trapid,
		b.Ort,
		b.standort,
		b.lv95_e,
		b.lv95_n,
		b.positiv,
		b.n_individuen,
		b.art,
		ST_Intersection(b.geometrie, kg.geometrie) AS geometrie
	FROM 
		buffer200 AS b
	LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze AS kg 
		ON ST_Intersects(b.geometrie, kg.geometrie)
),

polygon_oeffentlich AS (
	SELECT
		trapid,
		standort,
		positiv,
		ST_UNION(geometrie) AS geometrie
	FROM 
		buffer200_cut
	GROUP BY 
		trapid,
		standort,
		positiv
),

polygon_oeffentlich_v2 AS (
	SELECT
		(ST_Dump(ST_UNION(geometrie))).geom AS geometrie
	FROM 
		buffer200_cut
	WHERE
		positiv = 'Ja'
)

SELECT
	ROW_NUMBER() OVER () AS id,
	*
FROM 
	polygon_oeffentlich