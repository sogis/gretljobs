WITH 

raw_columns AS (
	select
		rowdef.*
	from 
		afu_igel.igel_stall s
	CROSS JOIN LATERAL
		jsonb_to_record(s.content::jsonb) as rowdef(
			"idStall" int,
			"idStao" int,
			"name" text,
			"tierart" text,
			"anzahl" int,
			"aufstallung" text, 
			"aufenthaltWochen" int,
			"winterfuetterungWochen" int,			
			"guellevolumen" NUMERIC(9,3), 
			"mistplatzflaeche" NUMERIC(9,3), 						
			"bemerkungen" TEXT,			
			"koordinateE" int,
			"koordinateN" int
		)
),

stao_bewirtschafter AS (
	SELECT
		rowdef.*
	FROM 
		afu_igel.igel_standort s
	CROSS JOIN LATERAL
		jsonb_to_record(s.content::jsonb) AS rowdef(
			"IdStao" int,
			"BewirtschafterName" TEXT
		)
),

mapped_records AS (
	SELECT
		"idStall" AS id,
		"idStao" AS standort_id,
		"name" AS aname,
		"BewirtschafterName" AS stao_name_bewirtschafter,
		"tierart" AS tierart,
		"anzahl" AS anzahl_tiere,
		"aufstallung" AS aufstallung_code,
		"aufenthaltWochen" AS aufenthalt_wochen, 
		"winterfuetterungWochen" AS winterfuetterung_wochen,
		"mistplatzflaeche" AS mistplatzflaeche,
		"guellevolumen" AS guelle_volumen,
		"bemerkungen" AS bemerkungen,
		st_setsrid(st_makepoint("koordinateE", "koordinateN"), 2056) AS geometrie
	FROM 
		raw_columns
	LEFT JOIN 
		stao_bewirtschafter
			ON raw_columns."idStao" = stao_bewirtschafter."IdStao"
	WHERE
		"koordinateE" IS NOT NULL AND "koordinateN" IS NOT NULL
)


SELECT * FROM mapped_records