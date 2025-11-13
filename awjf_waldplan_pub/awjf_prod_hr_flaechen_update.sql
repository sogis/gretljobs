-------------------------------------------------------------------------
------------------------ Setze Werte auf NULL ---------------------------
-------------------------------------------------------------------------
UPDATE
	awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck
SET
	produktive_flaeche = NULL
;

WITH

-------------------------------------------------------------------------
----------------------- Berechnung Waldflächen --------------------------
-------------------------------------------------------------------------
produktive_flaechen_berechnet AS (
	SELECT 
		gs.egrid,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wnz.geometrie)))::NUMERIC) AS flaeche
	FROM
		awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
	LEFT JOIN awjf_waldplan_pub_v2.waldplan_waldnutzung AS wnz
		ON ST_INTERSECTS(gs.geometrie, wnz.geometrie)
	WHERE
		wnz.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
	GROUP BY 
		gs.egrid
),

unproduktive_flaechen_berechnet AS (
	SELECT 
		gs.egrid,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wnz.geometrie)))::NUMERIC) AS flaeche
	FROM
		awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
	LEFT JOIN awjf_waldplan_pub_v2.waldplan_waldnutzung AS wnz
		ON ST_INTERSECTS(gs.geometrie, wnz.geometrie)
	WHERE
		wnz.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
	GROUP BY 
		gs.egrid
),

-------------------------------------------------------------------------
---------- Erstellung JSON-Attribute für berechnete Waldflächen ---------
-------------------------------------------------------------------------
produktive_flaechen_berechnet_json AS (
    SELECT
    	pfb.egrid,
        json_agg(
            json_build_object(
                'produktiv', pfb.flaeche,
                'unproduktiv', ufb.flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Waldplan.flaechen_produktiv'
            )
        ) AS flaechen_produktiv
    FROM 
        produktive_flaechen_berechnet AS pfb
	LEFT JOIN unproduktive_flaechen_berechnet AS ufb 
		ON pfb.egrid = ufb.egrid
    GROUP BY 
        pfb.egrid
)

-------------------------------------------------------------------------
------------------------ Update Flächenwerte ----------------------------
-------------------------------------------------------------------------
UPDATE
	awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS wwg
SET
	produktive_flaeche = pfj.flaechen_produktiv 
FROM 
	produktive_flaechen_berechnet_json AS pfj 
WHERE 
	wwg.egrid = pfj.egrid