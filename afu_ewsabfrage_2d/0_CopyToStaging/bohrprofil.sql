WITH

vorkommnis AS (
	SELECT DISTINCT -- distinct, damit gleich lautende vorkommnisse verschiedener profile nur einmal ausgegeben werden
		p.bohrung_bohrprofil AS bohrung_id,
		concat_ws(', ', vorkommnis_text, ' T: ' || tiefe  || 'm', ' B: ' || nullif(v.bemerkung, '')) AS vorkommnis_txt,
		tiefe
	FROM 
		afu_grundlagendaten_ews_v1.vorkommnis v
	JOIN
		afu_grundlagendaten_ews_v1.bohrprofil p on v.profil = p.t_id
),

bohrung_vorkommnisse AS (
	SELECT  
		bohrung_id,
		array_agg(vorkommnis_txt ORDER BY coalesce(v.tiefe, 0), vorkommnis_txt) AS vorkommnisse
	FROM 
		vorkommnis v
	GROUP BY 
		bohrung_id
)

SELECT
	concat(b.bezeichnung, ' in ', s.gemeinde, ', GB-NR ' || nullif(s.gbnummer, ''), ': ', array_to_string(vorkommnisse, ' | ')) AS hinweistext,
	'EWS_Bohrung' AS hinweis,
	FALSE AS hinweis_oeffentlich,
	ST_MULTI(st_buffer(b.geometrie, 101)) AS mpoly
FROM	
	afu_grundlagendaten_ews_v1.bohrung b
JOIN	
	afu_grundlagendaten_ews_v1.standort s ON b.standort_bohrung = s.t_id
JOIN
	bohrung_vorkommnisse v ON b.t_id = v.bohrung_id
;
