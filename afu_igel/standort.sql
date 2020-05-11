WITH 

raw_columns AS (
	select
		rowdef.*
	from 
		afu_igel.standort s
	CROSS JOIN LATERAL
		jsonb_to_record(s.content::jsonb) as rowdef(
			"IdStao" int,
			"IsAktiv" boolean, 
			"IgelPid" int,
			"GelanPid" int,
			"HdaNr" int,
			"Typ" text, 
			"Name" text,
			"Adresse" text,
			"Gemeinde" text, 
			"GveTotal" numeric(9,3),
			"MistIst" numeric(9,3),
			"MistSoll" numeric(9,3),		
			"GuelleIst" numeric(9,3), 
			"GuelleSoll" numeric(9,3), 
			"TypBetrieb" int,
			"BewirtschafterName" text, 
			"HaushaltAbwasserTotal" numeric(9,3), 
			"DatumAktuellsteErhebung" text, 
			"HaushaltAbwasserAbleitungen" jsonb,
			"KoordinateE" int,
			"KoordinateN" int
		)
),

mapped_records AS (
	SELECT
		"IdStao" AS id,
		"Name" AS aname,
		"IsAktiv" AS aktiv,
		"Typ" AS typ_standort,
		"TypBetrieb" AS typ_betrieb_code,
		"TypBetrieb"::text AS typ_betrieb_text, --todo case...
		"Adresse" AS adresse,
		"Gemeinde" AS gemeinde,
		"HdaNr" AS hda_nr,
		"GelanPid" AS gelan_pid,
		"IgelPid" AS igel_pid,
		"BewirtschafterName" AS name_bewirtschafter,
		to_date("DatumAktuellsteErhebung", 'DD.MM.YYYY') AS aktuellsteerhebung,
		jsonb_array_elements_text("HaushaltAbwasserAbleitungen") AS abwasserableitung_codes,
		jsonb_array_elements_text("HaushaltAbwasserAbleitungen") AS abwasserableitung_texte, --todo aufloesen
		"HaushaltAbwasserTotal" AS abwasser_total,
		"GuelleIst" AS guelle_ist,
		"GuelleSoll" AS guelle_soll,
		"MistIst" AS mist_ist,
		"MistSoll" AS mist_soll,
		"GveTotal" AS gve_total,
		st_setsrid(st_makepoint("KoordinateE", "KoordinateN"), 2056) AS geometrie
	FROM 
		raw_columns
	WHERE
		"KoordinateE" IS NOT NULL AND "KoordinateN" IS NOT NULL
)

SELECT * FROM mapped_records