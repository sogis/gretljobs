DELETE FROM awjf_waldplan_pub_v2.waldplan_waldnutzung;

WITH

waldnutzung_union AS (
	SELECT
		ST_UNION(geometrie) AS geometrie 
	FROM 
		awjf_waldplan_v2.waldplan_waldnutzung
),

waldnutzung_edit AS (
	SELECT
		wnz.t_datasetname AS bfsnr,
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
		wf.t_datasetname AS bfsnr,
		'Wald_bestockt' AS nutzungskategorie,
		'Mit Wald bestockt' AS nutzungskategorie_txt,
		(ST_Dump(
			CASE 
				WHEN wnu.geometrie IS NULL
					THEN wf.geometrie  -- Keine Überschneidung → ganze Fläche
				WHEN ST_Intersects(wf.geometrie, wnu.geometrie)
					THEN ST_Difference(wf.geometrie, wnu.geometrie)  -- Differenz
				ELSE wf.geometrie  -- Sicherheitsfall
			END
		)).geom AS geometrie,
		NULL AS bemerkung
	FROM
		awjf_waldplan_v2.waldplan_waldfunktion AS wf
    LEFT JOIN waldnutzung_union AS wnu
    	ON ST_Intersects(wf.geometrie, wnu.geometrie)
    WHERE
    	ST_IsValid(wf.geometrie)
    AND (
    	wnu.geometrie IS NULL  -- Keine Waldnutzung → ganze Fläche
   	OR NOT
   		ST_IsEmpty(ST_Difference(wf.geometrie, wnu.geometrie))  -- Differenz vorhanden
    )
),

waldnutzung_pub AS (
	SELECT
		bfsnr,
		nutzungskategorie,
		nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM
		waldnutzung_edit
	UNION ALL 
	SELECT
		bfsnr,
		nutzungskategorie,
		nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM
		wald_bestockt
)

INSERT INTO awjf_waldplan_pub_v2.waldplan_waldnutzung(
	bfsnr,
	nutzungskategorie,
	nutzungskategorie_txt,
	geometrie,
	bemerkung
)

SELECT
	bfsnr::INTEGER,
	nutzungskategorie,
	nutzungskategorie_txt,
	geometrie,
	bemerkung
FROM
	waldnutzung_pub