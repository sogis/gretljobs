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
hiebsatzrelevante_waldflaechen AS (
    SELECT
        ST_Intersection(hwff.geometrie, pwf.geometrie) AS geometrie
    FROM 
        awjf_waldplan_pub_v2.waldplan_waldfunktion hwff
    JOIN 
        awjf_waldplan_pub_v2.waldplan_waldnutzung pwf
        ON hwff.geometrie && pwf.geometrie
       AND ST_Intersects(hwff.geometrie, pwf.geometrie)
    WHERE
        hwff.funktion IN ('Wirtschaftswald', 'Schutzwald', 'Erholungswald', 'Biodiversitaet', 'Schutzwald_Biodiversitaet')
        AND (hwff.funktion <> 'Biodiversitaet' OR hwff.biodiversitaet_objekt NOT IN ('Waldreservat','Altholzinsel'))
        AND pwf.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
),

-- SQL-Optimierung: Geometrien in Tiles zerlegen
hrwf_tiled AS (
    SELECT (ST_Dump(ST_Subdivide(geometrie, 256))).geom AS geometrie
    FROM hiebsatzrelevante_waldflaechen
),

-- 3) Jetzt Grundstücke schneiden – aber nur gegen die Kacheln
hiebsatzrelevante_waldflaechen_grundstueck AS (
	SELECT 
		gs.egrid,
		gs.waldflaeche,
		SUM(ST_Area(ST_Intersection(gs.geometrie, hsw.geometrie))) AS relevant
	FROM
		awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
	LEFT JOIN hrwf_tiled hsw
		ON gs.geometrie && hsw.geometrie
	   AND ST_Intersects(gs.geometrie, hsw.geometrie)
	GROUP BY 
		gs.egrid,
		gs.waldflaeche
),

-------------------------------------------------------------------------
---------- Erstellung JSON-Attribute für berechnete Waldflächen ---------
-------------------------------------------------------------------------
hiebsatzrelevante_waldflaechen_grundstueck_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'relevant', COALESCE(ROUND(relevant::numeric),0),
                'irrelevant', COALESCE(ROUND(waldflaeche - ROUND(relevant::numeric)), 0),
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Waldplan.flaechen_hiebsatzrelevant'
            )
        ) AS flaechen_hiebsatzrelevant
    FROM 
        hiebsatzrelevante_waldflaechen_grundstueck
    GROUP BY 
        egrid
)

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
