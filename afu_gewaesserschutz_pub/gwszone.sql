
WITH 

docs_gesamttitel AS (
	SELECT
		t_id AS dok_id,
		CASE titel
			WHEN 'Regierungsratsbeschluss' THEN concat('RRB ', date_part('year', publiziertab), '/', offiziellenr)
			WHEN 'Schutzzonenreglement' THEN 'Reglement'
			WHEN 'Schutzzonenplan' THEN 'Plan'
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
		dok_id,
		sort,
		json_build_object('titel', titel,'url', url) AS json_rec
	FROM
		docs_gesamttitel
	WHERE 
		rechtsstatus = 'inKraft'
),

zone_docs AS (
	SELECT 
		gwszone AS zone_id,
		array_to_json(array_agg(json_rec ORDER BY sort)) AS dokumente
	FROM
		docs_json
	JOIN afu_gewaesserschutz.gwszonen_rechtsvorschriftgwszone
		ON docs_json.dok_id = gwszonen_rechtsvorschriftgwszone.rechtsvorschrift
	GROUP BY 
		gwszone
),

zone_and_status AS (
	SELECT 
		gwszonen_gwszone.t_id, 
		COALESCE(typ, kantonaletypbezeichnung) AS typ,
		istaltrechtlich,
		NOT istaltrechtlich AS gesetzeskonform,
		rechtskraftdatum,
		geometrie AS apolygon
	FROM afu_gewaesserschutz.gwszonen_gwszone
		INNER JOIN afu_gewaesserschutz.gwszonen_status
			ON gwszonen_gwszone.astatus = gwszonen_status.t_id
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
	zone_and_status
		LEFT JOIN zone_docs
			ON zone_and_status.t_id = zone_docs.zone_id