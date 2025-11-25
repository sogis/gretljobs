-------------------------------------------------------------------------
------------------------ Setze Werte auf NULL ---------------------------
-------------------------------------------------------------------------
UPDATE
	awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck
SET
	produktive_flaeche = NULL,
	hiebsatzrelevante_flaeche = NULL
WHERE 
	bfsnr = ${bfsnr_param}
;

-------------------------------------------------------------------------
--------------------------- Erstelle Tabellen ---------------------------
-------------------------------------------------------------------------
DROP TABLE IF EXISTS 
	produktive_waldflaechen,
	produktive_waldflaechen_grundstueck,
	hiebsatzrelevante_waldflaechen_grundstueck
CASCADE
;

CREATE TABLE
	produktive_waldflaechen (
		t_id INTEGER,
		nutzungskategorie TEXT,
		geometrie GEOMETRY
);

CREATE TABLE 
	produktive_waldflaechen_grundstueck (
		egrid TEXT,
		waldflaeche INTEGER,
		produktiv INTEGER,
		unproduktiv INTEGER,
		geometrie GEOMETRY
);

CREATE TABLE
	hiebsatzrelevante_waldflaechen_grundstueck (
		egrid TEXT,
		relevant INTEGER,
		irrelevant INTEGER
);

-------------------------------------------------------------------------
------------------ Berechnung produktive Waldflächen --------------------
-------------------------------------------------------------------------
INSERT INTO produktive_waldflaechen
	SELECT 
		t_id,
		nutzungskategorie,
		geometrie
	FROM
		awjf_waldplan_pub_v2.waldplan_waldnutzung
	WHERE 
		nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
	AND
		bfsnr = ${bfsnr_param}
;

CREATE INDEX 
	ON produktive_waldflaechen
	USING gist (geometrie)
;

INSERT INTO produktive_waldflaechen_grundstueck
	SELECT 
		gs.egrid,
		gs.waldflaeche,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, pwf.geometrie)))::NUMERIC) AS produktiv,
		gs.waldflaeche - ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, pwf.geometrie)))::NUMERIC) AS unproduktiv,
		ST_UNION(ST_Intersection(gs.geometrie, pwf.geometrie)) AS geometrie
	FROM
		awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
	INNER JOIN produktive_waldflaechen AS pwf
		ON ST_INTERSECTS(gs.geometrie, pwf.geometrie)
	WHERE 
		gs.bfsnr = ${bfsnr_param}
	GROUP BY 
		gs.egrid,
		gs.waldflaeche
;

CREATE INDEX 
	ON produktive_waldflaechen_grundstueck
	USING gist (geometrie)
;

CREATE INDEX
	ON produktive_waldflaechen_grundstueck(egrid)
;
-------------------------------------------------------------------------
-------------- Berechnung hiebsatzrelevante Waldflächen -----------------
-------------------------------------------------------------------------
INSERT INTO hiebsatzrelevante_waldflaechen_grundstueck
	SELECT
		pwf.egrid,
		ROUND(SUM(ST_Area(ST_Intersection(pwf.geometrie, wwf.geometrie)))::NUMERIC) AS relevant,
		pwf.waldflaeche - ROUND(SUM(ST_Area(ST_Intersection(pwf.geometrie, wwf.geometrie)))::NUMERIC) AS irrelevant
	FROM 
		produktive_waldflaechen_grundstueck AS pwf 
	INNER JOIN awjf_waldplan_pub_v2.waldplan_waldfunktion AS wwf
		ON ST_INTERSECTS(pwf.geometrie, wwf.geometrie)
	WHERE
		wwf.funktion IN ('Wirtschaftswald', 'Schutzwald', 'Erholungswald', 'Biodiversitaet', 'Schutzwald_Biodiversitaet')
	AND
		(wwf.funktion <> 'Biodiversitaet' OR wwf.biodiversitaet_objekt NOT IN ('Waldreservat','Altholzinsel'))
	AND 
		wwf.bfsnr = ${bfsnr_param}
	GROUP BY 
		pwf.egrid,
		pwf.waldflaeche
;

CREATE INDEX
	ON hiebsatzrelevante_waldflaechen_grundstueck(egrid)
;


-------------------------------------------------------------------------
---------- Erstellung JSON-Attribute für berechnete Waldflächen ---------
-------------------------------------------------------------------------
WITH

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
),

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

-------------------------------------------------------------------------
------------------------ Update Flächenwerte ----------------------------
-------------------------------------------------------------------------
UPDATE
	awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS wwg
SET
	produktive_flaeche = pwfj.flaechen_produktiv,
	hiebsatzrelevante_flaeche = hwfj.flaechen_hiebsatzrelevant
FROM 
	produktive_waldflaechen_grundstueck_json AS pwfj,
	hiebsatzrelevante_waldflaechen_grundstueck_json AS hwfj 
WHERE 
	wwg.egrid = pwfj.egrid
AND 
	wwg.egrid = hwfj.egrid
;
