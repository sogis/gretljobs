DELETE FROM awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck;

DROP TABLE IF EXISTS 
	grundstuecke,
	waldfunktion,
	waldnutzung,
	waldflaeche_grundstueck,
	waldflaeche_grundstueck_bereinigt,
	waldflaeche_grundstueck_final,
	waldflaechen_berechnet,
	waldflaechen_berechnet_plausibilisiert,
	wytweideflaechen_berechnet,
	waldfunktion_flaechen_berechnet,
	waldfunktion_flaechen_summen,
	waldfunktion_flaechen_berechnet_plausibilisiert,
	waldfunktion_funktion_flaechen_berechnet,
	waldnutzung_flaechen_berechnet,
	waldnutzung_flaechen_summen,
	waldnutzung_flaechen_berechnet_plausibilisiert,
	biodiversitaet_objekt_flaechen_berechnet
CASCADE
;

-- =========================================================
-- 1) Erstellung Grundtabellen
-- =========================================================
CREATE TABLE 
	grundstuecke (
		t_basket INTEGER,
		t_datasetname TEXT,
		egrid TEXT,
		gemeinde TEXT,
		forstbetrieb TEXT,
		forstkreis TEXT,
		forstkreis_txt TEXT,
		forstrevier TEXT,
		wirtschaftszone TEXT,
		wirtschaftszone_txt TEXT,
		grundstuecknummer TEXT,
		flaechenmass INTEGER,
		eigentuemerinformation TEXT,
		eigentuemer TEXT,
		eigentuemer_txt TEXT,
		grundbuch TEXT,
		ausserkantonal BOOLEAN,
		ausserkantonal_txt TEXT,
		geometrie GEOMETRY,
		bemerkung TEXT
);

CREATE TABLE
	waldfunktion (
		t_datasetname TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		biodiversitaet_id TEXT,
		biodiversitaet_objekt TEXT,
		biodiversitaet_objekt_txt TEXT,
		wytweide BOOLEAN,
		wytweide_txt TEXT,
		geometrie GEOMETRY,
		bemerkung TEXT
);

CREATE TABLE
	waldnutzung (
		t_datasetname TEXT,
		t_id INTEGER,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

CREATE TABLE
	waldflaeche_grundstueck (
    	egrid TEXT,
   		geometrie GEOMETRY
);

CREATE TABLE
	waldflaeche_grundstueck_bereinigt (
    	egrid TEXT,
   		geometrie GEOMETRY
);

CREATE TABLE
	waldflaeche_grundstueck_final (
    	egrid TEXT,
   		geometrie GEOMETRY
);

-- =========================================================
-- 2) Erstellung Flächenberechnungstabellen
-- =========================================================
CREATE TABLE
	waldflaechen_berechnet (
		egrid TEXT,
		flaechenmass_grundstueck INTEGER,
		waldflaeche INTEGER,
		flaeche_differenz INTEGER
);

CREATE TABLE
	waldflaechen_berechnet_plausibilisiert (
		egrid TEXT,
		flaeche INTEGER,
		angepasst BOOLEAN
);

CREATE TABLE
	waldfunktion_flaechen_berechnet (
		egrid TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		biodiversitaet_id TEXT,
		biodiversitaet_objekt TEXT,
		biodiversitaet_objekt_txt TEXT,
		wytweide BOOLEAN,
		wytweide_txt TEXT,
		flaeche INTEGER
);

-- Für den Vergleich der Waldfunktionsflächen mit dem Flächenmass des Grundstücks --
CREATE TABLE
	waldfunktion_flaechen_summen (
		egrid TEXT,
		flaechenmass_grundstueck INTEGER,
		flaeche_waldfunktion_summe INTEGER,
		flaeche_differenz INTEGER
);

-- Angpeasste Flächenwerte für die Waldfunktion, sofern Differenzen auftauchen (siehe waldfunktion_flaechen_summen) --
CREATE TABLE
	waldfunktion_flaechen_berechnet_plausibilisiert (
		egrid TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		biodiversitaet_id TEXT,
		biodiversitaet_objekt TEXT,
		biodiversitaet_objekt_txt TEXT,
		wytweide BOOLEAN,
		wytweide_txt TEXT,
		flaeche INTEGER,
		angepasst BOOLEAN
);

-- Für die Aggregation nach Funktion --
CREATE TABLE
	waldfunktion_funktion_flaechen_berechnet (
		egrid TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		flaeche INTEGER
);

-- Für die Aggregation nach Nutzungskategorie --
CREATE TABLE
	waldnutzung_flaechen_berechnet (
		egrid TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		flaeche INTEGER
);

CREATE TABLE
	waldnutzung_flaechen_summen (
		egrid TEXT,
		flaechenmass_grundstueck INTEGER,
		flaeche_waldnutzung_summe INTEGER,
		flaeche_differenz INTEGER
);

CREATE TABLE
	waldnutzung_flaechen_berechnet_plausibilisiert (
		egrid TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		flaeche INTEGER,
		angepasst BOOLEAN
);

-- Für die Aggregation nach Wytweide --
CREATE TABLE
	wytweideflaechen_berechnet (
		egrid TEXT,
		flaeche INTEGER
);

-- Für die Aggregation nach Biodiversität und Biodiversitätsobjekt --
CREATE TABLE
	biodiversitaet_objekt_flaechen_berechnet (
		egrid TEXT,
		funktion_txt TEXT,
		flaeche INTEGER
);

-- =========================================================
-- 3) Grundtabellen befüllen
-- =========================================================
INSERT INTO grundstuecke
	SELECT
		basket.t_id AS t_basket,
		ww.t_datasetname,
		ww.egrid,
		mop.gemeinde AS gemeinde,
		wkfb.aname AS forstbetrieb,
		ww.forstkreis,
		fk.dispname AS forstkreis_txt,
		wfr.aname AS forstrevier,
		ww.wirtschaftszone,
		wz.dispname AS wirtschaftszone_txt,
		mop.nummer AS grundstuecknummer,
		mop.flaechenmass::INTEGER,
		CONCAT_WS(' ', wet.dispname, ww.zusatzinformation) AS eigentuemerinformation,
		ww.eigentuemer,
		wet.dispname AS eigentuemer_txt,
		mop.grundbuch AS grundbuch,
		ww.ausserkantonal,
		CASE
			WHEN ausserkantonal IS TRUE 
				THEN 'Ja'
			ELSE 'Nein'
		END AS ausserkantonal_txt,
		mop.geometrie,
		ww.bemerkung
	FROM
		awjf_waldplan_v2.waldplan_waldeigentum AS ww
	LEFT JOIN agi_mopublic_pub.mopublic_grundstueck AS mop
		ON ww.egrid = mop.egrid
	LEFT JOIN awjf_waldplan_v2.waldeigentuemer AS wet
		ON ww.eigentuemer = wet.ilicode
	LEFT JOIN awjf_waldplan_v2.wirtschaftszonen AS wz 
		ON ww.wirtschaftszone = wz.ilicode
	LEFT JOIN awjf_waldplan_v2.waldplankatalog_forstrevier AS wfr
		ON ww.forstrevier = wfr.t_id
	LEFT JOIN awjf_waldplan_v2.forstkreise AS fk 
		ON ww.forstkreis = fk.ilicode
	LEFT JOIN awjf_waldplan_v2.waldplankatalog_forstbetrieb AS wkfb 
		ON ww.forstbetrieb = wkfb.t_id
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
		ON ww.t_datasetname = dataset.datasetname
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_basket AS basket
		ON dataset.t_id = basket.dataset
	WHERE
		ww.t_datasetname::int4 = ${bfsnr_param}
;

CREATE INDEX 
	ON grundstuecke
	USING gist (geometrie)
;

INSERT INTO waldfunktion
	SELECT
		wf.t_datasetname,
		wf.funktion,
		wf.funktion_txt,
		wf.biodiversitaet_id,
		wf.biodiversitaet_objekt,
		wf.biodiversitaet_objekt_txt,
		wf.wytweide,
		wytweide_txt,
		wf.geometrie,
		wf.bemerkung
	FROM 
		awjf_waldplan_pub_v2.waldplan_waldfunktion AS wf
	WHERE
		wf.t_datasetname::int4 = ${bfsnr_param}
;

CREATE INDEX 
	ON waldfunktion
	USING gist (geometrie)
;

INSERT INTO waldnutzung
	SELECT
		wnz.t_datasetname,
		wnz.t_id,
		wnz.nutzungskategorie,
		wnz.nutzungskategorie_txt,
		wnz.geometrie
	FROM 
		awjf_waldplan_pub_v2.waldplan_waldnutzung AS wnz
	WHERE
		wnz.t_datasetname::int4 = ${bfsnr_param}
;

CREATE INDEX 
	ON waldnutzung
	USING gist (geometrie)
;

INSERT INTO waldflaeche_grundstueck
SELECT
    gs.egrid,
    (ST_Dump(
        ST_Intersection(
            ST_Snap(wf.geometrie, gs.geometrie, 0.01), --snap auf Grundstueck-Geometrie
            gs.geometrie
        )
    )).geom AS geometrie
FROM
	waldfunktion AS wf
JOIN grundstuecke AS gs
	ON ST_Intersects(wf.geometrie, gs.geometrie)
    AND wf.t_datasetname = gs.t_datasetname
WHERE
	ST_Area(ST_Intersection(
        ST_Snap(wf.geometrie, gs.geometrie, 0.01),
        gs.geometrie
    )) > 0.5;

;

CREATE INDEX 
	ON waldflaeche_grundstueck
	USING gist (geometrie)
;

-- Bereinigung der Geometrien
INSERT INTO waldflaeche_grundstueck_bereinigt
SELECT
	egrid,
    (ST_Dump(
        ST_ReducePrecision(
            (ST_Dump(
                ST_CollectionExtract(
                    ST_MakeValid(geometrie),
                    3
                )
            )).geom,
            0.001  -- 1 mm Präzision
        )
    )).geom AS geometrie
FROM
	waldflaeche_grundstueck
WHERE
	ST_Area(geometrie) > 0.5;

CREATE INDEX 
	ON waldflaeche_grundstueck_bereinigt
	USING gist (geometrie)
;

INSERT INTO waldflaeche_grundstueck_final
SELECT
    egrid,
    ST_Multi(
        ST_Union(geometrie)
    ) AS geometrie
FROM
	waldflaeche_grundstueck_bereinigt
GROUP BY
	egrid;

CREATE INDEX
	ON waldflaeche_grundstueck_final
	USING gist (geometrie)
;

-- =========================================================
-- 4) Flächenberechnungstabellen für Waldfunktion und Waldnutzung befüllen
-- =========================================================
INSERT INTO waldflaechen_berechnet
	SELECT
		gs.egrid,
		gs.flaechenmass AS flaechenmass_grundstueck,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::INTEGER) AS waldflaeche,
		gs.flaechenmass -ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche_differenz
	FROM
		grundstuecke AS gs
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.t_datasetname = wf.t_datasetname
	GROUP BY 
		gs.egrid,
		gs.flaechenmass
;

CREATE INDEX 
	ON waldflaechen_berechnet(egrid)
;

INSERT INTO waldfunktion_flaechen_berechnet
	SELECT 
		gs.egrid,
		wf.funktion,
		wf.funktion_txt,
		wf.biodiversitaet_id,
		wf.biodiversitaet_objekt,
		wf.biodiversitaet_objekt_txt,
		wf.wytweide,
		wf.wytweide_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS gs
	INNER JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.t_datasetname = wf.t_datasetname
	GROUP BY 
		gs.egrid,
		wf.funktion,
		wf.funktion_txt,
		biodiversitaet_id,
		biodiversitaet_objekt,
		biodiversitaet_objekt_txt,
		wytweide,
		wytweide_txt
	HAVING 
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) > 0
;

CREATE INDEX 
	ON waldfunktion_flaechen_berechnet(egrid)
;

INSERT INTO waldnutzung_flaechen_berechnet
	SELECT 
		gs.egrid,
		wnz.nutzungskategorie,
		wnz.nutzungskategorie_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wnz.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS gs
	INNER JOIN waldnutzung AS wnz 
		ON ST_INTERSECTS(gs.geometrie, wnz.geometrie)
		AND gs.t_datasetname = wnz.t_datasetname
	GROUP BY 
		gs.egrid,
		wnz.nutzungskategorie,
		wnz.nutzungskategorie_txt
	HAVING 
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wnz.geometrie)))::NUMERIC) > 0
;

CREATE INDEX 
	ON waldnutzung_flaechen_berechnet(egrid)
;

-- =========================================================
-- 5) Plausibilsierung berechnete Waldfunktions- und Waldnutzungsflächen
-- =========================================================
INSERT INTO	waldflaechen_berechnet_plausibilisiert
	SELECT
		egrid,
		CASE
			WHEN flaeche_differenz BETWEEN -1 AND 1 
				THEN flaechenmass_grundstueck 
			ELSE waldflaeche
		END AS flaeche,
		CASE
			WHEN flaeche_differenz BETWEEN -1 AND 1 
				THEN TRUE
			ELSE FALSE
		END AS angepasst
	FROM 
		waldflaechen_berechnet
;

CREATE INDEX 
	ON waldflaechen_berechnet_plausibilisiert (egrid)
;

INSERT INTO waldfunktion_flaechen_summen
	SELECT
		wfbp.egrid,
		wfbp.flaeche AS waldflaeche,
		SUM(wfb.flaeche) AS flaeche_summe_waldfunktion,
		wfbp.flaeche - SUM(wfb.flaeche) AS flaeche_differenz
	FROM
		waldflaechen_berechnet_plausibilisiert AS wfbp
	LEFT JOIN waldfunktion_flaechen_berechnet AS wfb 
		ON wfbp.egrid = wfb.egrid
	GROUP BY
		wfbp.egrid,
		wfbp.flaeche
;

CREATE INDEX 
	ON waldfunktion_flaechen_summen (egrid)
;

WITH

groesste_waldfunktion AS (
    SELECT DISTINCT ON (egrid)
        egrid,
        flaeche,
        funktion,
        funktion_txt
    FROM
        waldfunktion_flaechen_berechnet
    ORDER BY
        egrid,
        flaeche DESC
)

INSERT INTO waldfunktion_flaechen_berechnet_plausibilisiert 
	SELECT
		wfb.egrid,
		wfb.funktion,
		wfb.funktion_txt,
		biodiversitaet_id,
		biodiversitaet_objekt,
		biodiversitaet_objekt_txt,
		wytweide,
		wytweide_txt,
		CASE
			WHEN wfb.funktion = gw.funktion
				THEN wfb.flaeche + wfs.flaeche_differenz
			ELSE wfb.flaeche
		END AS flaeche,
		CASE
			WHEN wfb.funktion = gw.funktion AND wfs.flaeche_differenz <> 0
				THEN TRUE
			ELSE FALSE
		END AS angepasst
	FROM
		waldfunktion_flaechen_berechnet AS wfb
	LEFT JOIN groesste_waldfunktion AS gw
		ON wfb.egrid = gw.egrid
	LEFT JOIN waldfunktion_flaechen_summen AS wfs 
		ON wfb.egrid = wfs.egrid
;

INSERT INTO waldnutzung_flaechen_summen
	SELECT
		wfbp.egrid,
		wfbp.flaeche AS flaechenmass_grundstueck,
		SUM(wfb.flaeche) AS flaeche_summe_waldnutzung,
		wfbp.flaeche - SUM(wfb.flaeche) AS flaeche_differenz
	FROM
		waldflaechen_berechnet_plausibilisiert AS wfbp
	LEFT JOIN waldnutzung_flaechen_berechnet AS wfb 
		ON wfbp.egrid = wfb.egrid
	GROUP BY
		wfbp.egrid,
		wfbp.flaeche
;

WITH
groesste_waldnutzung AS (
    SELECT DISTINCT ON (egrid)
        egrid,
        flaeche,
        nutzungskategorie,
        nutzungskategorie_txt
    FROM
        waldnutzung_flaechen_berechnet
    ORDER BY
        egrid,
        flaeche DESC
)

INSERT INTO waldnutzung_flaechen_berechnet_plausibilisiert 
	SELECT
		wfb.egrid,
		wfb.nutzungskategorie,
		wfb.nutzungskategorie_txt,
		CASE
			WHEN wfb.nutzungskategorie_txt = gw.nutzungskategorie_txt
				THEN wfb.flaeche + wfs.flaeche_differenz
			ELSE wfb.flaeche
		END AS flaeche,
		CASE
			WHEN wfb.nutzungskategorie_txt = gw.nutzungskategorie_txt AND wfs.flaeche_differenz <> 0
				THEN TRUE
			ELSE FALSE
		END AS angepasst
	FROM
		waldnutzung_flaechen_berechnet AS wfb
	LEFT JOIN groesste_waldnutzung AS gw
		ON wfb.egrid = gw.egrid
	LEFT JOIN waldnutzung_flaechen_summen AS wfs 
		ON wfb.egrid = wfs.egrid
;

-- =========================================================
-- 6) Flächenberechnungstabellen für Waldfunktion, Wytweide und Biodiversität befüllen
-- =========================================================
INSERT INTO waldfunktion_funktion_flaechen_berechnet
	SELECT 
		egrid,
		funktion,
		funktion_txt,
		SUM(flaeche) AS flaeche
	FROM 
		waldfunktion_flaechen_berechnet_plausibilisiert
	GROUP BY
		egrid,
		funktion,
		funktion_txt
;

INSERT INTO wytweideflaechen_berechnet
	SELECT
		egrid,
		SUM(flaeche) AS flaeche
	FROM
		waldfunktion_flaechen_berechnet_plausibilisiert
	WHERE
		wytweide IS TRUE
	GROUP BY 
		egrid
;

INSERT INTO biodiversitaet_objekt_flaechen_berechnet
	SELECT 
		egrid,
		funktion_txt AS funktion,
		SUM(flaeche) AS flaeche
	FROM
		waldfunktion_flaechen_berechnet_plausibilisiert
	WHERE
		funktion IN ('Biodiversitaet', 'Schutzwald_Biodiversitaet')
	GROUP BY 
		egrid,
		funktion_txt
;

-- =========================================================
-- 7) Erstellung JSON-Attribute für berechnete Waldflächen
-- =========================================================
WITH

waldfunktion_flaechen_berechnet_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'Funktion', funktion_txt,
                'Flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Waldfunktion' 
            )
        ) AS waldfunktion_flaechen
    FROM 
        waldfunktion_funktion_flaechen_berechnet
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
),

waldnutzung_flaechen_berechnet_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'Nutzungskategorie', nutzungskategorie_txt,
                'Flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Waldnutzung'
            )
        ) AS waldnutzung_flaechen
    FROM 
        waldnutzung_flaechen_berechnet_plausibilisiert
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
),

biodiversitaet_objekt_flaechen_berechnet_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'Biodiversitaet_Objekt', funktion_txt,
                'Flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Biodiversitaet_Objekt'
            )
        ) AS biodiversitaet_objekt_flaechen
    FROM 
        biodiversitaet_objekt_flaechen_berechnet
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
)

-- =========================================================
-- 8) Insert in Waldplan-Grundstückstabelle
-- =========================================================
INSERT INTO awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck(
	t_basket,
	t_datasetname,
	egrid,
	gemeinde,
	forstbetrieb,
	forstkreis,
	forstkreis_txt,
	forstrevier,
	wirtschaftszone,
	wirtschaftszone_txt,
	grundstuecknummer,
	flaechenmass,
	eigentuemer,
	eigentuemer_txt,
	eigentuemerinformation,
	waldfunktion_flaechen,
	waldnutzung_flaechen,
	biodiversitaetsobjekt_flaeche,
	wytweide_flaeche,
	--produktive_flaeche,
	--hiebsatzrelevante_flaeche,
	waldflaeche,
	grundbuch,
	ausserkantonal,
	ausserkantonal_txt,
	geometrie,
	bemerkung
)

SELECT
	gs.t_basket,
	gs.t_datasetname,
	gs.egrid,
	gs.gemeinde,
	gs.forstbetrieb,
	gs.forstkreis,
	gs.forstkreis_txt,
	gs.forstrevier,
	gs.wirtschaftszone,
	gs.wirtschaftszone_txt,
	gs.grundstuecknummer,
	gs.flaechenmass,
	gs.eigentuemer,
	gs.eigentuemer_txt,
	gs.eigentuemerinformation,
	wffj.waldfunktion_flaechen::JSON AS waldfunktion_flaechen,
	wnfj.waldnutzung_flaechen::JSON AS waldnutzung_flaechen,
	bofj.biodiversitaet_objekt_flaechen::JSON AS biodiversitaetsobjekt_flaeche,
	wytb.flaeche AS wytweide_flaeche,
	--produktive_flaeche,
	--hiebsatzrelevante_flaeche,
	wfbp.flaeche AS waldflaeche,
	gs.grundbuch,
	gs.ausserkantonal,
	gs.ausserkantonal_txt,
	wfg.geometrie,
	gs.bemerkung
FROM 
	grundstuecke AS gs
LEFT JOIN waldfunktion_flaechen_berechnet_json AS wffj 
	ON gs.egrid = wffj.egrid
LEFT JOIN waldnutzung_flaechen_berechnet_json AS wnfj 
	ON gs.egrid = wnfj.egrid
LEFT JOIN biodiversitaet_objekt_flaechen_berechnet_json AS bofj
	ON gs.egrid = bofj.egrid
LEFT JOIN waldflaechen_berechnet_plausibilisiert AS wfbp 
	ON gs.egrid = wfbp.egrid
LEFT JOIN wytweideflaechen_berechnet AS wytb 
	ON gs.egrid = wytb.egrid
LEFT JOIN waldflaeche_grundstueck_final AS wfg 
	ON gs.egrid = wfg.egrid
WHERE 
	wfg.geometrie IS NOT NULL