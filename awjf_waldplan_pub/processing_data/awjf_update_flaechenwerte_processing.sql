-- =========================================================
-- 1) Setze Werte auf NULL
-- =========================================================
UPDATE
	awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck
SET
	produktive_flaeche = NULL,
	hiebsatzrelevante_flaeche = NULL
WHERE 
	t_datasetname::int4 = ${bfsnr_param}
;

-- =========================================================
-- 2) Erstelle Tabellen
-- =========================================================
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

-- =========================================================
-- 3) Berechnung produktive Waldflächen
-- =========================================================
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
		t_datasetname::int4 = ${bfsnr_param}
;

CREATE INDEX 
	ON produktive_waldflaechen
	USING gist (geometrie)
;

INSERT INTO produktive_waldflaechen_grundstueck
	SELECT 
		gs.egrid,
		wfbp.flaeche AS waldflaeche,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, pwf.geometrie)))::BIGINT) AS produktiv,
		wfbp.flaeche - ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, pwf.geometrie)))::BIGINT) AS unproduktiv,
		ST_UNION(ST_Intersection(gs.geometrie, pwf.geometrie)) AS geometrie
	FROM
		awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS gs
	INNER JOIN produktive_waldflaechen AS pwf
		ON ST_INTERSECTS(gs.geometrie, pwf.geometrie)
	LEFT JOIN waldflaechen_berechnet_plausibilisiert AS wfbp
		ON gs.egrid = wfbp.egrid
	WHERE 
		gs.t_datasetname::int4 = ${bfsnr_param}
	GROUP BY 
		gs.egrid,
		gs.waldflaeche,
		wfbp.flaeche
;

CREATE INDEX 
	ON produktive_waldflaechen_grundstueck
	USING gist (geometrie)
;

CREATE INDEX
	ON produktive_waldflaechen_grundstueck(egrid)
;

-- =========================================================
-- 4) Berechnung hiebsatzrelevante Waldflächen
-- =========================================================
INSERT INTO hiebsatzrelevante_waldflaechen_grundstueck
SELECT
    pwf.egrid,
    ROUND(
        SUM(
            CASE
                WHEN
                    wwf.funktion IN ('Wirtschaftswald','Schutzwald','Erholungswald','Schutzwald_Biodiversitaet')
                OR (
    				wwf.funktion = 'Biodiversitaet'
                AND wwf.biodiversitaet_objekt NOT IN ('Waldreservat','Altholzinsel')
                    )
                THEN
                    ST_Area(
                        ST_Intersection(pwf.geometrie, wwf.geometrie)
                    )
                ELSE
                    0
            END
        )::BIGINT
    ) AS relevant,
    pwf.waldflaeche -
	ROUND(
        SUM(
            CASE
                WHEN
                    wwf.funktion IN ('Wirtschaftswald','Schutzwald','Erholungswald','Schutzwald_Biodiversitaet')
                OR (
    				wwf.funktion = 'Biodiversitaet'
                AND wwf.biodiversitaet_objekt NOT IN ('Waldreservat','Altholzinsel')
                    )
                THEN
                    ST_Area(
                        ST_Intersection(pwf.geometrie, wwf.geometrie)
                    )
                ELSE
                    0
            END
        )::BIGINT
    ) AS irrelevant
FROM produktive_waldflaechen_grundstueck pwf
LEFT JOIN awjf_waldplan_pub_v2.waldplan_waldfunktion wwf
    ON ST_Intersects(pwf.geometrie, wwf.geometrie)
GROUP BY
    pwf.egrid,
    pwf.waldflaeche
;

CREATE INDEX
	ON hiebsatzrelevante_waldflaechen_grundstueck(egrid)
;

-- =========================================================
-- 5) Erstellung JSON-Attribute für berechnete Waldflächen
-- =========================================================
WITH

produktive_waldflaechen_grundstueck_json AS (
    SELECT
    	pfb.egrid,
        json_agg(
            json_build_object(
                'Produktiv', pfb.produktiv,
                'Unproduktiv', pfb.unproduktiv,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Produktiv'
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
                'Relevant', hwg.relevant,
                'Irrelevant', hwg.irrelevant,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Hiebsatzrelevant'
            )
        ) AS flaechen_hiebsatzrelevant
    FROM 
        hiebsatzrelevante_waldflaechen_grundstueck AS hwg
    GROUP BY 
        hwg.egrid
)

-- =========================================================
-- 6) Update Flächenwerte
-- =========================================================
UPDATE awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck AS wwg
SET
    produktive_flaeche = pwfj.flaechen_produktiv::JSON,
    hiebsatzrelevante_flaeche = hwfj.flaechen_hiebsatzrelevant::JSON
FROM
	produktive_waldflaechen_grundstueck_json AS pwfj
LEFT JOIN hiebsatzrelevante_waldflaechen_grundstueck_json AS hwfj
	ON pwfj.egrid = hwfj.egrid
WHERE
	wwg.egrid = pwfj.egrid
;