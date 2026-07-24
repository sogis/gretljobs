WITH

-- Muss noch durch publizierte Daten ersetzt werden --
av_gebaeudegeometrien AS (
	SELECT
		bofla.t_id,
		gebnr.gwr_egid,				
		bofla.geometrie 
	FROM 
		agi_dm01avso24.bodenbedeckung_boflaeche AS bofla 
	LEFT JOIN agi_dm01avso24.bodenbedeckung_gebaeudenummer AS gebnr 
		ON bofla.t_id = gebnr.gebaeudenummer_von
	WHERE
		art = 'Gebaeude'
),


gebaeude_csv AS (
	SELECT
		egid,
		id_ge AS wirtschaftseinheit,
		gebaeude_bez AS bezeichnung,
		vermoegensart,
		prio AS prioritaet,
		baujahr_gruppe AS bauperiode,
		nutzung,
		CASE
			WHEN anmiete = 'AM'
				THEN TRUE
			ELSE FALSE
		END AS anmiete,
		CASE
			WHEN anmiete = 'AM'
				THEN 'Ja'
			ELSE 'Nein'
		END AS anmiete_txt,
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
			WHEN vermietet = 'vermietet'
				THEN TRUE
			ELSE false
		END AS vermietet,
		CASE
			WHEN vermietet = 'vermietet'
				THEN 'Ja'
			ELSE 'Nein'
		END AS vermietet_txt
	FROM 
		hba_immobilienportfolio_gebaeude_v2.csv_import_gebaeude
)

SELECT 
	egid,
	wirtschaftseinheit,
	bezeichnung,
	vermoegensart,
	prioritaet,
	bauperiode,
	nutzung,
	anmiete,
	anmiete_txt,
	eigenbedarf,
	eigenbedarf_txt,
	vermietet,
	vermietet_txt,
	gebgeo.geometrie
FROM 
	gebaeude_csv AS gebcsv
LEFT JOIN av_gebaeudegeometrien AS gebgeo
	ON gebcsv.egid = gebgeo.gwr_egid
;