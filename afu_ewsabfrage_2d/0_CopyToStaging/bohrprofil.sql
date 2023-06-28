WITH
profil_vorkommnisse AS (
	SELECT  
		profil AS profil_id,
		array_agg(concat_ws(', ', vorkommnis_text, ' T: ' || tiefe  || 'm', ' B: ' || nullif(bemerkung, '')) ORDER BY coalesce(tiefe, 0)) AS vorkommnisse
	FROM 
		afu_grundlagendaten_ews_v1.vorkommnis
	GROUP BY 
		profil
)

SELECT
	concat(b.bezeichnung, ' in ', s.gemeinde, ', GB-NR ' || nullif(s.gbnummer, ''), ': ', array_to_string(vorkommnisse, ' | ')) AS hinweistext,
	'EWS_Bohrung' AS hinweis,
	FALSE AS hinweis_oeffentlich,
	st_buffer(b.geometrie, 101) AS mpoly
FROM
	afu_grundlagendaten_ews_v1.bohrprofil p
    JOIN	
	afu_grundlagendaten_ews_v1.bohrung b ON p.bohrung_bohrprofil = b.t_id
    JOIN	
	afu_grundlagendaten_ews_v1.standort s ON b.standort_bohrung = s.t_id
    JOIN
	profil_vorkommnisse v ON p.t_id = v.profil_id
;
