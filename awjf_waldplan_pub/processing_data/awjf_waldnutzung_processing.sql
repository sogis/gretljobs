DELETE FROM awjf_waldplan_pub_v2.waldplan_waldnutzung;

WITH

waldnutzung_union AS (
	SELECT
		ST_UNION(geometrie) AS geometrie 
	FROM 
		awjf_waldplan_v2.waldplan_waldnutzung
	WHERE 
		t_datasetname = ${bfsnr_param}
),

waldnutzung_edit AS (
	SELECT
		basket.t_id AS t_basket,
		wnz.t_datasetname,
		nutzungskategorie,
		wnk.dispname AS nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM 
		awjf_waldplan_v2.waldplan_waldnutzung AS wnz
	LEFT JOIN awjf_waldplan_v2.waldnutzungskategorie AS wnk
		ON wnz.nutzungskategorie = wnk.ilicode
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
		ON wnz.t_datasetname = dataset.datasetname
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_basket AS basket
		ON dataset.t_id = basket.dataset
	WHERE 
		wnz.t_datasetname = ${bfsnr_param}
),

wald_bestockt AS (
	SELECT
		basket.t_id AS t_basket,
		wf.t_datasetname,
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
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
		ON wf.t_datasetname = dataset.datasetname
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_basket AS basket
		ON dataset.t_id = basket.dataset
    WHERE
    	ST_IsValid(wf.geometrie)
    AND 
    	wf.t_datasetname = ${bfsnr_param}
    AND (
    	wnu.geometrie IS NULL  -- Keine Waldnutzung → ganze Fläche
   	OR NOT
   		ST_IsEmpty(ST_Difference(wf.geometrie, wnu.geometrie))  -- Differenz vorhanden
    )
),

waldnutzung_pub AS (
	SELECT
		t_basket,
		t_datasetname,
		nutzungskategorie,
		nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM
		waldnutzung_edit
	UNION ALL 
	SELECT
		t_basket,
		t_datasetname,
		nutzungskategorie,
		nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM
		wald_bestockt
)

INSERT INTO awjf_waldplan_pub_v2.waldplan_waldnutzung(
	t_basket,
	t_datasetname,
	nutzungskategorie,
	nutzungskategorie_txt,
	geometrie,
	bemerkung
)

SELECT
	t_basket,
	t_datasetname,
	nutzungskategorie,
	nutzungskategorie_txt,
	geometrie,
	bemerkung
FROM
	waldnutzung_pub