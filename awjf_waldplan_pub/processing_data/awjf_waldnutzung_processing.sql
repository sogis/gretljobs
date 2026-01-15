DELETE FROM awjf_waldplan_pub_v2.waldplan_waldnutzung;

WITH

-- =========================================================
-- 1) Bestehende Waldnutzung für Publikation
-- =========================================================
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
		wnz.t_datasetname::int4 = ${bfsnr_param}
),

waldnutzung_edit_clean AS (
    SELECT
        t_basket,
        t_datasetname,
        nutzungskategorie,
        nutzungskategorie_txt,
        ST_MakeValid(geometrie) AS geometrie,
        bemerkung
    FROM
    	waldnutzung_edit
    WHERE
    	ST_IsValid(geometrie)
    AND
    	ST_Area(geometrie) > 1.0
),

-- =========================================================
-- 2) Rohflächen für Wald_bestockt (Waldfunktion minus Waldnutzung)
-- =========================================================
wald_bestockt_roh AS (
	SELECT
		ST_Difference(
			(SELECT ST_Union(geometrie) FROM awjf_waldplan_v2.waldplan_waldfunktion WHERE t_datasetname::int4 = ${bfsnr_param}),
			(SELECT ST_Union(geometrie) FROM waldnutzung_edit_clean)
		) AS geometrie
),

-- =========================================================
-- 3) Bereinigung + ST_Dump
-- =========================================================
wald_bestockt_clean AS (
	SELECT
		ST_Difference(
			(SELECT geometrie FROM wald_bestockt_roh),
			(SELECT ST_Union(geometrie) FROM waldnutzung_edit_clean)
		) AS geometrie
),

wald_bestockt_final AS (
	SELECT
		(SELECT t_basket FROM waldnutzung_edit LIMIT 1) AS t_basket,
		(SELECT t_datasetname FROM waldnutzung_edit LIMIT 1) AS t_datasetname,
		'Wald_bestockt' AS nutzungskategorie,
		'Mit Wald bestockt' AS nutzungskategorie_txt,
		(ST_Dump(wbc.geometrie)).geom AS geometrie,
		NULL AS bemerkung
	FROM 
		wald_bestockt_clean AS wbc
    WHERE
    	ST_IsValid(wbc.geometrie)
   	AND
   		ST_Area(wbc.geometrie) > 1.0
),

-- =========================================================
-- 4) Zusammenführen für Publikation
-- =========================================================
waldnutzung_pub AS (
	SELECT
		t_basket,
		t_datasetname,
		nutzungskategorie,
		nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM
		waldnutzung_edit_clean
	UNION ALL
	SELECT
		t_basket,
		t_datasetname,
		nutzungskategorie,
		nutzungskategorie_txt,
		geometrie,
		bemerkung
	FROM
		wald_bestockt_final
),

waldnutzung_pub_clean AS (
	SELECT
		t_basket,
		t_datasetname,
		nutzungskategorie,
		nutzungskategorie_txt,
		ST_RemoveRepeatedPoints(geometrie, 0.001) AS geometrie,
		bemerkung
	FROM
		waldnutzung_pub
	WHERE
		ST_IsValid(geometrie)
	AND
		ST_Area(geometrie) > 1.0
)

-- =========================================================
-- 5) Insert in Publikationstabelle
-- =========================================================
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
	waldnutzung_pub_clean;
