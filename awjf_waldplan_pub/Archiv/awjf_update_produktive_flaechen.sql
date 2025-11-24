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
------------------ Berechnung produktive Waldflächen --------------------
-------------------------------------------------------------------------
produktive_waldflaechen AS (
	SELECT 
		t_id,
		nutzungskategorie,
		geometrie
	FROM
		awjf_waldplan_pub_v2.waldplan_waldnutzung
	WHERE 
		nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
),

produktive_waldflaechen_grundstueck AS (
	SELECT 
		gs.egrid,
		gs.waldflaeche,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, pwf.geometrie)))::NUMERIC) AS produktiv,
		gs.waldflaeche - ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, pwf.geometrie)))::NUMERIC) AS unproduktiv
	FROM
		awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
	LEFT JOIN produktive_waldflaechen AS pwf
		ON ST_INTERSECTS(gs.geometrie, pwf.geometrie)
	GROUP BY 
		gs.egrid,
		gs.waldflaeche
),

-------------------------------------------------------------------------
---------- Erstellung JSON-Attribute für berechnete Waldflächen ---------
-------------------------------------------------------------------------
produktive_waldflaechen_grundstueck_json AS (
    SELECT
    	pfb.egrid,
        json_agg(
            json_build_object(
                'produktiv', pfb.produktiv,
                'unproduktiv', pfb.unproduktiv,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Waldplan.flaechen_produktiv'
            )
        ) AS flaechen_produktiv
    FROM 
        produktive_waldflaechen_grundstueck AS pfb
    GROUP BY 
        pfb.egrid
)

-------------------------------------------------------------------------
------------------------ Update Flächenwerte ----------------------------
-------------------------------------------------------------------------
UPDATE
	awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS wwg
SET
	produktive_flaeche = pwfj.flaechen_produktiv
FROM 
	produktive_waldflaechen_grundstueck_json AS pwfj
WHERE 
	wwg.egrid = pwfj.egrid
;
