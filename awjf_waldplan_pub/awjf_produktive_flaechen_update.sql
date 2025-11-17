-------------------------------------------------------------------------
------------------------ Setze Werte auf NULL ---------------------------
-------------------------------------------------------------------------
UPDATE
	awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck
SET
	produktive_flaeche = NULL
;

WITH

produktive_waldflaechen AS (
	SELECT 
		* 
	FROM
		awjf_waldplan_pub_v2.waldplan_waldnutzung
	WHERE 
		nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
)

-------------------------------------------------------------------------
------------------ Berechnung produktive Waldflächen --------------------
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
-------------- Berechnung hiebsatzrelevante Waldflächen -----------------
-------------------------------------------------------------------------

/*
waldfunktionsflaechen AS (
	SELECT 
		gs.egrid,
		(elem->> 'flaeche')::NUMERIC AS flaeche_waldfunktion,
		elem->> 'funktion' AS funktion
	FROM
		awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs,
		jsonb_array_elements(gs.waldfunktion_flaechen) AS elem
),



waldfunktionsflaechen_produktiv AS (
	SELECT
		wff.egrid,
		wff.funktion,
		wff.flaeche_waldfunktion,
		CASE
			WHEN pfb.flaeche > 0
				THEN
					TRUE
				ELSE
					FALSE 
		END AS produktiv
	FROM 
		waldfunktionsflaechen AS wff
	LEFT JOIN produktive_flaechen_berechnet AS pfb 
		ON wff.egrid = pfb.egrid
	ORDER BY 
		wff.egrid ASC
		
)
*/
hiebsatzrelevante_flaechen AS (
    SELECT 
        gs.egrid,
        COALESCE(
            SUM(
                ST_Area(
                    ST_Intersection(wf.geometrie, wn.geometrie)
                )
            ),
            0
        ) AS hiebsatzrelevante_flaeche
    FROM 
        awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
    LEFT JOIN 
        awjf_waldplan_pub_v2.waldplan_waldfunktion AS wf 
        ON ST_Intersects(gs.geometrie, wf.geometrie)
        AND wf.funktion IN ('Wirtschaftswald', 'Schutzwald', 'Erholungswald', 'Biodiversitaet')
        AND ST_IsValid(wf.geometrie)
    LEFT JOIN 
        awjf_waldplan_pub_v2.waldplan_waldnutzung AS wn 
        ON ST_Intersects(gs.geometrie, wn.geometrie)
        AND ST_Intersects(wf.geometrie, wn.geometrie)
        AND wn.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
        AND ST_IsValid(wn.geometrie)
    WHERE 
        ST_IsValid(gs.geometrie)
    GROUP BY 
        gs.egrid
),

gesamte_waldflaechen AS (
    SELECT 
        gs.egrid,
        COALESCE(
            SUM(
                ST_Area(
                    ST_Intersection(gs.geometrie, wf.geometrie)
                )
            ),
            0
        ) AS gesamte_waldflaeche
    FROM 
        awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
    LEFT JOIN 
        awjf_waldplan_pub_v2.waldplan_waldfunktion AS wf
        ON ST_Intersects(gs.geometrie, wf.geometrie)
        AND ST_IsValid(wf.geometrie)
    WHERE 
        ST_IsValid(gs.geometrie)
    GROUP BY 
        gs.egrid
)
SELECT 
    gs.egrid,
    COALESCE(gw.gesamte_waldflaeche, 0) AS gesamte_waldflaeche,
    COALESCE(hf.hiebsatzrelevante_flaeche, 0) AS hiebsatzrelevante_flaeche,
    COALESCE(gw.gesamte_waldflaeche, 0) - COALESCE(hf.hiebsatzrelevante_flaeche, 0) AS nicht_hiebsatzrelevante_flaeche
FROM 
    awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
LEFT JOIN 
    gesamte_waldflaechen gw ON gs.egrid = gw.egrid
LEFT JOIN 
    hiebsatzrelevante_flaechen hf ON gs.egrid = hf.egrid;
	


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