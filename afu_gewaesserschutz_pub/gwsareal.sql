
WITH 

docs_gesamttitel AS (
	SELECT
		t_id AS dok_id,
		CASE titel
			WHEN 'Regierungsratsbeschluss' THEN concat('RRB ', date_part('year', publiziertab), '/', offiziellenr, ': ',  offiziellertitel)
			WHEN 'Schutzzonenreglement' THEN concat('Reglement: ', offiziellertitel)
			WHEN 'Schutzzonenplan' THEN concat('Plan: ', offiziellertitel)
			ELSE offiziellertitel
		END AS titel,
		CASE titel
			WHEN 'Regierungsratsbeschluss' THEN 1
			WHEN 'Schutzzonenreglement' THEN 2
			WHEN 'Schutzzonenplan' THEN 3
			ELSE 4
		END AS sort,
		textimweb AS url,
		rechtsstatus
	FROM 
		afu_gewaesserschutz.gwszonen_dokument
),

docs_json AS (
	SELECT
		CASE rechtsstatus
			WHEN 'inKraft' THEN 0
			ELSE 1
		END AS nicht_in_kraft,
		dok_id,
		sort,
		json_build_object('titel', titel,'url', url) AS json_rec
	FROM
		docs_gesamttitel
),

areal_docs AS (
	SELECT 
		gwsareal AS areal_id,
		array_to_json(array_agg(json_rec ORDER BY sort)) AS dokumente
	FROM
		docs_json
	JOIN afu_gewaesserschutz.gwszonen_rechtsvorschriftgwsareal
		ON docs_json.dok_id = gwszonen_rechtsvorschriftgwsareal.rechtsvorschrift
	GROUP BY 
		gwsareal
	HAVING 
		sum(nicht_in_kraft) < 1 --Nur areale publizieren, bei denen alle Dokumente in Kraft sind.
),

areal_and_status AS (
	SELECT 
		gwszonen_gwsareal.t_id, 
		typ,
		istaltrechtlich,
		NOT istaltrechtlich AS gesetzeskonform,
		rechtskraftdatum,
		geometrie AS apolygon
	FROM afu_gewaesserschutz.gwszonen_gwsareal
		INNER JOIN afu_gewaesserschutz.gwszonen_status
			ON gwszonen_gwsareal.astatus = gwszonen_status.t_id
	WHERE
		rechtsstatus = 'inKraft'
)

SELECT
	t_id, 
	typ,
	gesetzeskonform,
	rechtskraftdatum,
	dokumente,
	apolygon
FROM
	areal_and_status
		INNER JOIN areal_docs
			ON areal_and_status.t_id = areal_docs.areal_id
