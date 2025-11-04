WITH

waldnutzung_union AS (
	SELECT
		ST_UNION(geometrie) AS geometrie 
	FROM 
		awjf_waldplan_v2.waldplan_waldnutzung
),

waldnutzung_edit AS (
	SELECT
		nutzungskategorie,
		wnk.dispname AS nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM 
		awjf_waldplan_v2.waldplan_waldnutzung AS wnz
	LEFT JOIN awjf_waldplan_v2.waldnutzungskategorie AS wnk
		ON wnz.nutzungskategorie = wnk.ilicode
),

wald_bestockt AS (
	SELECT
		'Wald_bestockt' AS nutzungskategorie,
		'Mit Wald bestockt' AS nutzungskategorie_txt,
		(ST_Dump(
			CASE 
				WHEN wpu.geometrie IS NULL
					THEN wf.geometrie  -- Keine Überschneidung → ganze Fläche
				WHEN ST_Intersects(wf.geometrie, wpu.geometrie)
					THEN ST_Difference(wf.geometrie, wpu.geometrie)  -- Differenz
				ELSE wf.geometrie  -- Sicherheitsfall
			END
		)).geom AS geometrie,
		NULL AS bemerkung
	FROM
		awjf_waldplan_v2.waldplan_waldfunktion AS wf
    LEFT JOIN waldnutzung_union AS wpu
    	ON ST_Intersects(wf.geometrie, wpu.geometrie)
    WHERE
    	ST_IsValid(wf.geometrie)
    AND (
    	wpu.geometrie IS NULL  -- Keine Waldnutzung → ganze Fläche
   	OR NOT
   		ST_IsEmpty(ST_Difference(wf.geometrie, wpu.geometrie))  -- Differenz vorhanden
    )
),

waldnutzung_pub AS (
	SELECT 
		nutzungskategorie,
		nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM
		waldnutzung_edit
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
	waldnutzung_pub