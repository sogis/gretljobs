WITH

-- Muss noch durch publizierte Daten ersetzt werden --
av_grundstueckgeometrie AS (
	SELECT
		liegenschaft.t_id,
		grundstueck.egris_egrid,
		grundstueck.nummer,
		liegenschaft.flaechenmass,
		liegenschaft.geometrie 
	FROM 
		agi_dm01avso24.liegenschaften_liegenschaft AS liegenschaft
	LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS grundstueck 
		ON liegenschaft.liegenschaft_von = grundstueck.t_id 
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
		fach_verantw_bez AS fachverantwortung,
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
	egrid,
	grugeo.nummer AS grundstuecknummer,
	grugeo.flaechenmass,
	wirtschaftseinheit,
	prioritaet,
	vermoegensart,
	eigenbedarf,
	eigenbedarf_txt,
	baurecht,
	baurecht_txt,
	fachverantwortung,
	veraeusserungsjahr,
	veraeusserung,
	veraeusserung_txt,
	grugeo.geometrie
FROM 
	grundstuecke_csv AS grucsv
LEFT JOIN av_grundstueckgeometrie AS grugeo
	ON grucsv.egrid = grugeo.egris_egrid
WHERE
	grugeo.geometrie IS NOT NULL
;