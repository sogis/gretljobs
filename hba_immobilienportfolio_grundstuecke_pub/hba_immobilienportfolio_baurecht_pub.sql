WITH

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
)

SELECT
	baurecht.egris_egrid AS egrid,
	baurecht.nummer AS grundstuecknummer,
	baurecht.flaechenmass,
	csv.wirtschaftseinheit,
	csv.vermoegensart,
	baurecht.geometrie
FROM
	grundstuecke_csv AS csv
LEFT JOIN av_baurechtgeometrie AS baurecht
	ON csv.egrid = baurecht.egris_egrid
WHERE
	baurecht.geometrie IS NOT NULL
;