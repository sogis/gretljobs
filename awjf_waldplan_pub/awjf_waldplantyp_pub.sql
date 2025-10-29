WITH

waldplantyp_union AS (
	SELECT
		ST_UNION(geometrie) AS geometrie 
	FROM 
		awjf_waldplan_v2.waldplan_waldplantyp
),

waldplantyp_edit AS (
	SELECT
		nutzungskategorie,
		typ_nk.dispname AS nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM 
		awjf_waldplan_v2.waldplan_waldplantyp AS wt
	LEFT JOIN awjf_waldplan_v2.typ_nutzungskategorie AS typ_nk
		ON wt.nutzungskategorie = typ_nk.ilicode
),

wald_bestockt AS (
	SELECT
    	'Wald_bestockt' AS nutzungskategorie,
    	'Mit Wald bestockt' AS nutzungskategorie_txt,
    	(ST_Dump(ST_Difference(wf.geometrie, wpu.geometrie))).geom AS geometrie,
    	NULL AS bemerkung
	FROM
    	awjf_waldplan_v2.waldplan_waldfunktion AS wf,
    	waldplantyp_union AS wpu
	WHERE
   		ST_IsValid(wf.geometrie)
    AND
    	ST_Intersects(wf.geometrie, wpu.geometrie)
    AND NOT
    	ST_IsEmpty(ST_Difference(wf.geometrie, wpu.geometrie))
),

waldplantyp_pub AS (
	SELECT 
		nutzungskategorie,
		nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM
		waldplantyp_edit
	UNION ALL 
	SELECT 
		nutzungskategorie,
		nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM
		wald_bestockt
)

SELECT 
	nutzungskategorie,
	nutzungskategorie_txt,
	geometrie,
	bemerkung
FROM
	waldplantyp_pub