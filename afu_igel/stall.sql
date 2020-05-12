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

mapped_records AS (
	SELECT
		"idStall" AS id,
		"idStao" AS standort_id,
		"name" AS aname,
		"tierart" AS tierart,
		"anzahl" AS anzahl_tiere,
		"aufstallung" AS aufstallung,
		"aufenthaltWochen" AS aufenthalt_wochen, 
		"winterfuetterungWochen" AS winterfuetterung_wochen,
		"mistplatzflaeche" AS mistplatzflaeche,
		"guellevolumen" AS guelle_volumen,
		"bemerkungen" AS bemerkungen,
		st_setsrid(st_makepoint("koordinateE", "koordinateN"), 2056) AS geometrie
	FROM 
		raw_columns
	WHERE
		"koordinateE" IS NOT NULL AND "koordinateN" IS NOT NULL
)

SELECT * FROM mapped_records