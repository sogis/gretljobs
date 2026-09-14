WITH

av_grundstueckgeometrie AS (
	SELECT
		liegenschaft.t_id,
		grundstueck.egris_egrid,
		grundstueck.nummer,
		liegenschaft.flaechenmass,
		liegenschaft.geometrie,
		ST_PointOnSurface(liegenschaft.geometrie) AS point
	FROM
		agi_dm01avso24.liegenschaften_liegenschaft AS liegenschaft
	LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
		ON liegenschaft.liegenschaft_von = grundstueck.t_id
),

av_baurechtgeometrie AS (
	SELECT
		grundstueck.egris_egrid,
		grundstueck.nummer,
		selbstrecht.flaechenmass,
		selbstrecht.geometrie
	FROM
		agi_dm01avso24.liegenschaften_selbstrecht AS selbstrecht
	LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck
		ON selbstrecht.selbstrecht_von = grundstueck.t_id
	WHERE
		grundstueck.art = 'SelbstRecht.Baurecht'
),


grundstuecke_csv AS (
	SELECT
		egrid,
		id_gr AS wirtschaftseinheit,
		prio AS prioritaet,
		vermoegensart,
		CASE
			WHEN eigenbedarf = 'Eigenbedarf'
				THEN TRUE
			ELSE FALSE
		END AS eigenbedarf,
		CASE
			WHEN eigenbedarf = 'Eigenbedarf'
				THEN 'Ja'
			ELSE 'Nein'
		END AS eigenbedarf_txt,
		CASE
			WHEN baurecht = 'Baurecht'
				THEN TRUE
			ELSE FALSE
		END AS baurecht,
		CASE
			WHEN baurecht = 'Baurecht'
				THEN 'Ja'
			ELSE 'Nein'
		END AS baurecht_txt,
		fach_verantwortung AS fachverantwortung,
		jahr_veraeussert AS veraeusserungsjahr,
		CASE
			WHEN jahr_veraeussert IS NOT NULL
				THEN TRUE
			ELSE FALSE
		END AS veraeusserung,
		CASE
			WHEN jahr_veraeussert IS NOT NULL
				THEN 'Ja'
			ELSE 'Nein'
		END AS veraeusserung_txt
	FROM
		hba_immobilienportfolio_grundstuecke_v2.csv_import_grundstuecke
),

csv_baurechtgeometrie AS (
	SELECT
		baurecht.egris_egrid AS egrid,
		baurecht.nummer AS grundstuecknummer,
		baurecht.flaechenmass,
		csv.wirtschaftseinheit,
		csv.prioritaet,
		csv.vermoegensart,
		csv.eigenbedarf,
		csv.eigenbedarf_txt,
		csv.baurecht,
		csv.baurecht_txt,
		csv.fachverantwortung,
		csv.veraeusserungsjahr,
		csv.veraeusserung,
		csv.veraeusserung_txt,
		baurecht.geometrie
	FROM
		grundstuecke_csv AS csv
	LEFT JOIN av_baurechtgeometrie AS baurecht
		ON csv.egrid = baurecht.egris_egrid
	WHERE
		baurecht.geometrie IS NOT NULL
)

SELECT
	av.egris_egrid AS egrid,
	av.nummer AS grundstuecknummer,
	av.flaechenmass,
	csv.wirtschaftseinheit,
	csv.prioritaet,
	csv.vermoegensart,
	csv.eigenbedarf,
	csv.eigenbedarf_txt,
	CASE
		WHEN EXISTS (
			SELECT 1
			FROM csv_baurechtgeometrie AS baurecht
			WHERE ST_Intersects(
				av.geometrie,
				baurecht.geometrie
			)
			AND ST_Area(
				ST_Intersection(
					av.geometrie,
					baurecht.geometrie
				)
			) > 1
		)
		THEN TRUE
		ELSE FALSE
	END AS baurecht,
	CASE
		WHEN EXISTS (
			SELECT 1
			FROM csv_baurechtgeometrie AS baurecht
			WHERE ST_Intersects(
				av.geometrie,
				baurecht.geometrie
			)
			AND ST_Area(
				ST_Intersection(
					av.geometrie,
					baurecht.geometrie
				)
			) > 1
		)
		THEN 'Ja'
		ELSE 'Nein'
	END AS baurecht_txt,
	csv.fachverantwortung,
	csv.veraeusserungsjahr,
	csv.veraeusserung,
	csv.veraeusserung_txt,
	av.geometrie
FROM
	grundstuecke_csv AS csv
LEFT JOIN av_grundstueckgeometrie AS av
	ON csv.egrid = av.egris_egrid
WHERE
	av.geometrie IS NOT NULL;
;