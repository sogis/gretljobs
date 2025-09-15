WITH

standortdaten AS (
	SELECT 
		t_id,
		privatvermietung,
		CASE 
			WHEN privatvermietung IS TRUE
				THEN 'Privat'
			ELSE 'Kanton'
		END AS privatvermietung_txt,
		geometrie,
		hauptstandort_r,
		bezeichnung,
		kennnummer,
		bemerkung
	FROM
		afu_bootsanbindeplaetze_v1.standort
),

hauptstandortdaten AS (
	SELECT 
		t_id,
		gemeinde,
		bezeichnung,
		kennnummer,
		bemerkung
	FROM 
		afu_bootsanbindeplaetze_v1.hauptstandort
),

kontaktdaten AS (
	SELECT
		t_id,
		aname,
		vorname,
		organisation,
		strasse_nr,
		plz,
		ort,
		sap,
		telefon,
		email,
		kontokorrent,
		CASE 
			WHEN kontokorrent IS TRUE
				THEN 'ja'
			ELSE 'nein'
		END AS kontokorrent_txt,
		bemerkung
	FROM 
		afu_bootsanbindeplaetze_v1.kontaktdaten
),

stegflaeche AS (
	SELECT
		SUM (flaeche_schiffsteg) AS flaeche_schiffsteg_gesamt,
		standort_r
	FROM
		afu_bootsanbindeplaetze_v1.bootsanbindeplatz
	GROUP BY 
		standort_r
),

dokumentdaten AS (
	SELECT 
		t_id,
		aname,
		pfad,
		bemerkung,
		hauptstandort_r,
		kontaktdaten_r
	FROM 
		afu_bootsanbindeplaetze_v1.dokument
),

vermieter_json AS (
    SELECT
    	array_to_json(
    		array_agg(
    			row_to_json((
    				SELECT
    					nutzerdaten
    						FROM 
    						(
    						SELECT
    							aname AS "Name",
    							vorname AS "Vorname",
    							organisation AS "Organisation",
    							strasse_nr AS "Strasse_Nr",
    							plz AS "PLZ",
    							ort AS "Ort",
    							sap AS "SAP",
    							telefon AS "Telefon",
    							email AS "EMail",
    							kontokorrent AS "Kontokorrent",
    							bemerkung AS "Bemerkung",
    							'SO_AFU_Bootsanbindeplaetze_Publikation_20250604.Bootsanbindeplaetze.Kontaktdaten' AS "@type"
    						) nutzerdaten
    						))
    					)
    	) AS personendaten,
    	t_id
    FROM
        kontaktdaten
    GROUP BY
        t_id		
),

eigentumszuorndung AS (
	SELECT 
		e.standort_r,
		vj.personendaten
	FROM
		afu_bootsanbindeplaetze_v1.eigentum AS e
	LEFT JOIN vermieter_json AS vj
		ON e.kontaktdaten_r = vj.t_id	
),

dokumente_standort_json AS (
    SELECT
    	array_to_json(
    		array_agg(
    			row_to_json((
    				SELECT
    					docs
    						FROM 
    						(
    						SELECT
    							aname AS "Name",
    							pfad AS "Pfad",
    							bemerkung AS "Bemerkung",
    							'SO_AFU_Bootsanbindeplaetze_Publikation_20250604.Bootsanbindeplaetze.Dokument' AS "@type"
    						) docs
    						))
    					)
    	) AS dokumente,
    	hauptstandort_r
    FROM
        dokumentdaten
    GROUP BY
        hauptstandort_r		
)

SELECT 
	hd.kennnummer || ' ' || hd.bezeichnung || ' / ' || sd.kennnummer || ' ' || sd.bezeichnung AS bezeichnung,
	hd.kennnummer || ' ' || hd.bezeichnung AS hauptstandort,
	sd.kennnummer || ' ' || sd.bezeichnung AS standort,
	hd.gemeinde AS gemeinde,
	dj.dokumente::JSON AS dokumente,
	sd.privatvermietung,
	sd.privatvermietung_txt,
	ez.personendaten::JSON AS eigentuemerin,
	sf.flaeche_schiffsteg_gesamt,
	sd.bemerkung,
	sd.geometrie
FROM
	standortdaten AS sd
LEFT JOIN hauptstandortdaten AS hd 
	ON sd.hauptstandort_r = hd.t_id
LEFT JOIN dokumente_standort_json AS dj 
	ON hd.t_id = dj.hauptstandort_r
LEFT JOIN stegflaeche AS sf 
	ON sd.t_id = sf.standort_r
LEFT JOIN eigentumszuorndung AS ez 
	ON sd.t_id = ez.standort_r