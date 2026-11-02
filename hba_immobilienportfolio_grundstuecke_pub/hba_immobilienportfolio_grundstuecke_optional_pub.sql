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

grundstuecke_csv AS (
	SELECT
		egrid,
		id_gr AS schluessel_wirtschaftseinheit,
		we AS immobilienschluessel,
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
		hba_immobilienportfolio_v2.grundstuecke_csv_import
	WHERE
		baurecht = 'Baurecht'
	OR
		jahr_veraeussert IS NOT NULL
)

SELECT
	av.egris_egrid AS egrid,
	av.nummer AS grundstuecknummer,
	av.flaechenmass,
	csv.schluessel_wirtschaftseinheit,
	csv.immobilienschluessel,
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
	av.geometrie
FROM
	grundstuecke_csv AS csv
LEFT JOIN av_grundstueckgeometrie AS av
	ON csv.egrid = av.egris_egrid
WHERE
	av.geometrie IS NOT NULL;
;