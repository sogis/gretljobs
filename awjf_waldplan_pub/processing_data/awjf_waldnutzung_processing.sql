DELETE FROM awjf_waldplan_pub_v2.waldplan_waldnutzung;

WITH

-- =========================================================
-- 1) Waldnutzung unverändert für Publikation übernehmen
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

-- =========================================================
-- 2) Zusammenfassung Waldfunktionsflaeche
-- =========================================================
waldfunktion_union AS (
	SELECT
		ST_Union(geometrie) AS geometrie
	FROM
		awjf_waldplan_v2.waldplan_waldfunktion
	WHERE
		t_datasetname::int4 = ${bfsnr_param}
),

-- =========================================================
-- 3) Zusammenfassung Waldnutzungsflaeche
-- =========================================================
waldnutzung_union AS (
	SELECT
		ST_Union(geometrie) AS geometrie
	FROM
		awjf_waldplan_v2.waldplan_waldnutzung
	WHERE
		t_datasetname::int4 = ${bfsnr_param}
),

-- =========================================================
-- 4) Differenz Waldfunktion und Waldnutzung = "Wald_bestockt"
-- =========================================================
wald_bestockt_roh AS (
	SELECT
		ST_Difference(
			(SELECT geometrie FROM waldfunktion_union),
			(SELECT geometrie FROM waldnutzung_union)
		) AS geometrie
),

-- =========================================================
-- 5) CLIP: Neue Flächen in ursprüngliche Waldfunktionen einpassen
-- =========================================================
wald_bestockt AS (
	SELECT
		basket.t_id AS t_basket,
		wf.t_datasetname,
		'Wald_bestockt' AS nutzungskategorie,
		'Mit Wald bestockt' AS nutzungskategorie_txt,
		dg.geom AS geometrie,
		NULL AS bemerkung
	FROM
		awjf_waldplan_v2.waldplan_waldfunktion AS wf
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
		ON wf.t_datasetname = dataset.datasetname
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_basket AS basket
		ON dataset.t_id = basket.dataset
	CROSS JOIN LATERAL (
		SELECT (
			ST_Dump(ST_Intersection(wf.geometrie,wbr.geometrie
		))).geom
		FROM
			wald_bestockt_roh AS wbr
	) AS dg
	WHERE
		wf.t_datasetname::int4 = ${bfsnr_param}
	AND
		ST_Area(dg.geom) > 0
),


-- =========================================================
-- 6) Zusammenführen für Publikation
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

-- =========================================================
-- 7) Einfügen in Publikationstabelle
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
	waldnutzung_pub;