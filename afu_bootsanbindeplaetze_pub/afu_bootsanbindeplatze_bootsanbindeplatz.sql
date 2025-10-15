WITH

gebuehren AS (
	SELECT 
		100::NUMERIC AS betrag_boot_ruderboot,
		150::NUMERIC AS betrag_boot_b_6kw,
		250::NUMERIC AS betrag_boot_u_6kw,
		120::NUMERIC AS betrag_pfosten
),

platzdaten AS (
	SELECT
		t_id,
		platznummer,
		pfostenabstand,
		datum_bewilligung,
		datum_bewilligungsablauf,
		zufahrtsbewilligung,
		CASE 
			WHEN zufahrtsbewilligung IS TRUE
				THEN 'vorhanden'
			ELSE 'nicht vorhanden'
		END AS zufahrtsbewilligung_txt,
		steggebuehr,
		miete,
		pfosten_anz,
		geometrie,
		bemerkung,
		bootsdaten_r,
		nutzer_bootsanbindeplatz,
		CASE
			WHEN nutzer_bootsanbindeplatz IS NOT NULL
				THEN TRUE
			ELSE FALSE
		END AS vermietung,
		CASE
			WHEN nutzer_bootsanbindeplatz IS NOT NULL
				THEN 'vermietet'
			ELSE 'nicht vermietet'
		END AS vermietung_txt,
		rechnungsstelle_steggebuehr,
		standort_r
	FROM
		afu_bootsanbindeplaetze_v1.bootsanbindeplatz
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

bootsdaten AS (
	SELECT 
		t_id,
		'SO ' || bootskennzeichen AS bootskennzeichen,
		bootstyp,
		bk.dispname AS bootstyp_txt,
		bootsbreite,
		bootslaenge
	FROM 
		afu_bootsanbindeplaetze_v1.bootsdaten AS bd
	LEFT JOIN afu_bootsanbindeplaetze_v1.bootskategorie AS bk 
		ON bd.bootstyp = bk.ilicode
),

standortdaten AS (
	SELECT 
		t_id,
		privatvermietung,
		geometrie,
		hauptstandort_r,
		bezeichnung,
		kennnummer,
		bemerkung
	FROM
		afu_bootsanbindeplaetze_v1.standort
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

gebuehren_berechnet AS (
	SELECT 
		pd.t_id AS platz_id,
		CASE 
			WHEN bd.bootstyp = 'Ruderboot'
				THEN g.betrag_boot_ruderboot
			WHEN bd.bootstyp = 'bis_6_kW'
				THEN g.betrag_boot_b_6kw
			WHEN bd.bootstyp = 'ueber_6_kW'
				THEN g.betrag_boot_u_6kw
			WHEN bd.bootstyp IS NULL
				THEN NULL
			ELSE 0
		END AS bootsgebuehr,
		pd.pfosten_anz * g.betrag_pfosten AS pfostengebuehr
	FROM 
		platzdaten AS pd
	LEFT JOIN bootsdaten AS bd 
		ON pd.bootsdaten_r = bd.t_id
	CROSS JOIN gebuehren AS g
),

kontaktdaten_json AS (
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

dokumente_nutzer_json AS (
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
    	kontaktdaten_r
    FROM
        dokumentdaten
    GROUP BY
        kontaktdaten_r		
)

SELECT 
	pd.platznummer,
	pd.pfostenabstand,
	pd.vermietung,
	pd.vermietung_txt,
	bd.bootskennzeichen,
	bd.bootstyp,
	bd.bootstyp_txt,
	bd.bootsbreite,
	bd.bootslaenge,
	pd.datum_bewilligung,
	pd.datum_bewilligungsablauf,
	pd.zufahrtsbewilligung,
	pd.zufahrtsbewilligung_txt,
	gb.bootsgebuehr,
	pd.miete AS mietkosten,
	gb.pfostengebuehr,
	pd.steggebuehr,
	sd.kennnummer || ' ' || sd.bezeichnung AS standort,
	dj.dokumente::JSON AS dokumente,
	nb.personendaten::JSON AS nutzer,
	nb.personendaten::JSON AS rechnungsstelle_nutzungsgebuehr,
	CASE 
		WHEN pd.rechnungsstelle_steggebuehr IS NOT NULL
			THEN sgb.personendaten::JSON
		ELSE nb.personendaten::JSON
	END AS rechnungsstelle_steggebuehr,
	pd.pfosten_anz,
	pd.geometrie,
	pd.bemerkung
FROM 
	platzdaten AS pd
LEFT JOIN bootsdaten AS bd 
	ON pd.bootsdaten_r = bd.t_id
LEFT JOIN gebuehren_berechnet AS gb 
	ON pd.t_id = gb.platz_id
LEFT JOIN standortdaten AS sd 
	ON pd.standort_r = sd.t_id
LEFT JOIN kontaktdaten_json AS nb 
	ON pd.nutzer_bootsanbindeplatz = nb.t_id
LEFT JOIN kontaktdaten_json AS sgb
	ON pd.rechnungsstelle_steggebuehr = sgb.t_id
LEFT JOIN dokumente_nutzer_json AS dj 
	ON pd.nutzer_bootsanbindeplatz = dj.kontaktdaten_r