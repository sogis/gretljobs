WITH

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


email_geb AS (
	SELECT
		egid,
		'<a href="mailto:' || email_geb ||
		'?subject=' ||
		regexp_replace(
			encode(convert_to('Kontaktanfrage Gebäude: ' || gebaeude_bez, 'UTF8'), 'hex'),
			'(..)', '%\1', 'g'
		) ||
		'&amp;body=' ||
		regexp_replace(
			encode(convert_to(
				E'Guten Tag,\n\nIch habe eine Anfrage zum Gebäude "' || gebaeude_bez || E'"\n\nFreundliche Grüsse',
				'UTF8'
			), 'hex'),
			'(..)', '%\1', 'g'
		) ||
		'">' || name_geb || '</a>' AS gebaeudeverantwortung
	FROM
		hba_immobilienportfolio_v2.gebaeude_csv_import
),

email_hw AS (
	SELECT
		egid,
		'<a href="mailto:' || email_hw ||
		'?subject=' ||
		regexp_replace(
			encode(convert_to('Kontaktanfrage Gebäude: ' || gebaeude_bez, 'UTF8'), 'hex'),
			'(..)', '%\1', 'g'
		) ||
		'&amp;body=' ||
		regexp_replace(
			encode(convert_to(
				E'Guten Tag,\n\nIch habe eine Anfrage zum Gebäude "' || gebaeude_bez || E'"\n\nFreundliche Grüsse',
				'UTF8'
			), 'hex'),
			'(..)', '%\1', 'g'
		) ||
		'">' || name_hw || '</a>' AS hauswartung
	FROM
		hba_immobilienportfolio_v2.gebaeude_csv_import
),

gebaeude_csv AS (
	SELECT
		egid,
		we AS immobilienschluessel,
		id_ge AS schluessel_wirtschaftseinheit,
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
		END AS vermietet_txt,
		link,
		NULL AS gebaeudeverantwortung,
		NULL AS hauswartung
	FROM 
		hba_immobilienportfolio_v2.gebaeude_csv_import
	WHERE
		anmiete IS NOT NULL
	OR
		vermietet IS NOT NULL	
)

SELECT 
	gebcsv.egid,
	immobilienschluessel,
	schluessel_wirtschaftseinheit,
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
	link,
	email_geb.gebaeudeverantwortung,
	email_hw.hauswartung,
	gebgeo.geometrie
FROM 
	gebaeude_csv AS gebcsv
LEFT JOIN email_geb AS email_geb
	ON gebcsv.egid = email_geb.egid
LEFT JOIN email_hw AS email_hw
	ON gebcsv.egid = email_hw.egid
LEFT JOIN av_gebaeudegeometrien AS gebgeo
	ON gebcsv.egid = gebgeo.gwr_egid
;