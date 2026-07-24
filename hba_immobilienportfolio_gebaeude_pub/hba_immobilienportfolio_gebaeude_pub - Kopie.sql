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
		ver.dispname AS vermoegensart_txt,
		prio AS prioritaet,
		prio.dispname AS prioritaet_txt,
		baujahr_gruppe AS bauperiode,
		nutzung,
		nutzung.dispname AS nutzung_txt,
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
		hba_immobilienportfolio_gebaeude_v2.csv_import_gebaeude AS geb
	LEFT JOIN hba_immobilienportfolio_gebaeude_v2.vermoegensart AS ver
		ON geb.vermoegensart = ver.ilicode
	LEFT JOIN hba_immobilienportfolio_gebaeude_v2.prioritaetsstufe AS prio
		ON geb.prio = prio.ilicode
	LEFT JOIN hba_immobilienportfolio_gebaeude_v2.nutzungsart AS nutzung
		ON geb.nutzung = nutzung.ilicode
)


SELECT 
	*
FROM 
	hba_immobilienportfolio_gebaeude_v2.csv_import_gebaeude