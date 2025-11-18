-------------------------------------------------------------------------
------------------------ Setze Werte auf NULL ---------------------------
-------------------------------------------------------------------------
UPDATE
	awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck
SET
	hiebsatzrelevante_flaeche = NULL
;

WITH

-------------------------------------------------------------------------
-------------- Berechnung hiebsatzrelevante Waldflächen -----------------
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

hiebsatzrelevante_waldfunktionsflaechen AS (
	SELECT
		funktion,
		geometrie
	FROM 
		awjf_waldplan_pub_v2.waldplan_waldfunktion
	WHERE funktion IN ('Wirtschaftswald', 'Schutzwald', 'Erholungswald', 'Biodiversitaet', '')
	AND biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel')
),

hiebsatzrelevante_waldflaechen AS (
	SELECT
		ST_Intersection(hwff.geometrie,pwf.geometrie) AS geometrie
	FROM
		hiebsatzrelevante_waldfunktionsflaechen AS hwff
	LEFT JOIN produktive_waldflaechen AS pwf 
		ON ST_Intersects(hwff.geometrie, pwf.geometrie)
	WHERE ST_Area(ST_Intersection(hwff.geometrie,pwf.geometrie)) > 0.5
),

hiebsatzrelevante_waldflaechen_grundstueck AS (
	SELECT 
		gs.egrid,
		gs.waldflaeche,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, hrwf.geometrie)))::NUMERIC) AS relevant,
		gs.waldflaeche - ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, hrwf.geometrie)))::NUMERIC) AS irrelevant
	FROM
		awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
	LEFT JOIN hiebsatzrelevante_waldflaechen AS hrwf
		ON ST_INTERSECTS(gs.geometrie, hrwf.geometrie)
	GROUP BY 
		gs.egrid,
		gs.waldflaeche
),

-------------------------------------------------------------------------
---------- Erstellung JSON-Attribute für berechnete Waldflächen ---------
-------------------------------------------------------------------------
hiebsatzrelevante_waldflaechen_grundstueck_json AS (
    SELECT
    	hwg.egrid,
        json_agg(
            json_build_object(
                'relevant', hwg.relevant,
                'irrelevant', hwg.irrelevant,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Waldplan.flaechen_hiebsatzrelevant'
            )
        ) AS flaechen_hiebsatzrelevant
    FROM 
        hiebsatzrelevante_waldflaechen_grundstueck AS hwg
    GROUP BY 
        hwg.egrid
)

SELECT * FROM hiebsatzrelevante_waldflaechen_grundstueck_json

-------------------------------------------------------------------------
------------------------ Update Flächenwerte ----------------------------
-------------------------------------------------------------------------
UPDATE
	awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS wwg
SET
	hiebsatzrelevante_flaeche = hwfj.flaechen_hiebsatzrelevant
FROM 
	hiebsatzrelevante_waldflaechen_grundstueck_json AS hwfj 
WHERE 
	wwg.egrid = hwfj.egrid
;
