WITH 

raw_columns AS (
	SELECT
		rowdef.*
	FROM 
		afu_igel.igel_standort s
	CROSS JOIN LATERAL
		jsonb_to_record(s.content::jsonb) AS rowdef(
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

mapped_columns AS (
	SELECT
		"IdStao" AS id,
		"Name" AS aname,
		"IsAktiv" AS aktiv,
		"Typ" AS typ_standort_code,
		"TypBetrieb" AS typ_betrieb_code,
		"Adresse" AS strasse_hausnr,
		"Gemeinde" AS plz_ort,
		"HdaNr" AS hda_nr,
		"GelanPid" AS gelan_pid,
		"IgelPid" AS igel_pid,
		"BewirtschafterName" AS name_bewirtschafter,
		to_date("DatumAktuellsteErhebung", 'DD.MM.YYYY') AS aktuellsteerhebung,
		"HaushaltAbwasserAbleitungen" AS  abwasserableitungen_codes, 
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
),


abwasser_code AS ( -- Erstellt für jeden Abwasserableitungs-Code eines Standortes eine Zeile mit Spalten [id, abwasser_code]
	SELECT 
		id,
		jsonb_array_elements(abwasserableitungen_codes)::int AS abwasser_code
	FROM 
		mapped_columns
),

abwasser_lookup AS ( -- Codetabelle gemäss softec.ch
	SELECT 
		* 
	FROM (
		VALUES 
			(0, 'Güllegrube'), 
			(1, 'Ara'), 
			(2, 'Klara'), 
			(3, 'Abflusslose Hausgrube'),
			(4, 'Andere'),
			(5, 'Klärgrube')
	) 
	AS t (code, val)
),

abwasser_code_value AS (
	SELECT
		id,
		abwasser_code,
		val as abwasser_value
	FROM 
		abwasser_code
	LEFT JOIN
		abwasser_lookup
			ON abwasser_code.abwasser_code = abwasser_lookup.code
),

abwasser_values AS (
	SELECT 
		id,
		array_to_json(
			array_agg(abwasser_value)
		) as abwasser_values
	FROM
		abwasser_code_value
	GROUP BY
		id
),

betrieb_lookup AS ( -- Codetabelle gemäss softec.ch
	SELECT 
		* 
	FROM (
		VALUES 
			('LbvNachDz',  1),
			('Betriebsgemeinschaft', 2),
			('Gemeinschaftsweidebetriebe', 3),
			('LbvOhneDz', 4),
			('NichtKommerzielleTierhaltung', 5),
			('NichtLbvUebrige', 6),
			('GsBetrieb', 7),
			('Schlachthof', 8),
			('Betriebszweiggemeinschaft', 9),
			('ÖlnGemeinschaft', 10),
			('Viehhandelsunternehmen', 11),
			('Kompostieranlage', 12),
			('Biogasanlage', 13),
			('Soemmerungsbetrieb', 14),
			('KeinLandwirtschaftsbetrieb', 99)
	) 
	AS t (val, code)
),

stall_ids_raw AS (
	SELECT
		rowdef.*
	FROM 
		afu_igel.igel_stall s
	CROSS JOIN LATERAL
		jsonb_to_record(s.content::jsonb) as rowdef(
			"idStall"int,
			"idStao" int,
			"koordinateE" int,
			"koordinateN" int
		)
),

stall_ids AS (
	SELECT
		"idStao" AS id,
		to_json(array_agg("idStall")) AS stall_ids
	FROM
		stall_ids_raw
	WHERE
		"koordinateE" IS NOT NULL 
		AND 
		"koordinateN" IS NOT NULL 
	GROUP BY 
		"idStao"
)

SELECT 
	mapped_columns.id,
	aname,
	aktiv,
	typ_standort_code,
	strasse_hausnr,
	plz_ort,
	hda_nr,
	gelan_pid,
	igel_pid,
	name_bewirtschafter,
	aktuellsteerhebung,
	abwasser_total,
	guelle_ist,
	guelle_soll,
	mist_ist,
	mist_soll,
	gve_total,
	geometrie,
	abwasserableitungen_codes,
	abwasser_values AS abwasserableitungen_texte,
	typ_betrieb_code,
	val AS typ_betrieb_text,
	stall_ids
FROM 
	mapped_columns
LEFT JOIN
	abwasser_values
		ON mapped_columns.id = abwasser_values.id
LEFT JOIN
	betrieb_lookup
		ON mapped_columns.typ_betrieb_code = betrieb_lookup.code
LEFT JOIN 
	stall_ids
		ON mapped_columns.id = stall_ids.id