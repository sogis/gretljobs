DELETE FROM awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck;

DROP TABLE IF EXISTS 
	grundstuecke,
	grundstuecke_berechnung,
	waldfunktion,
	waldnutzung,
	waldflaeche_grundstueck,
	waldflaechen_berechnet,
	wytweideflaechen_berechnet,
	waldfunktion_flaechen_berechnet,
	waldnutzung_flaechen_berechnet,
	biodiversitaet_objekt_flaechen_berechnet,
	biodiversitaet_id_flaechen_berechnet
CASCADE
;

-------------------------------------------------------------------------
---------------------- Erstellung Grundtabellen -------------------------
-------------------------------------------------------------------------
CREATE TABLE 
	grundstuecke (
		t_basket INTEGER,
		t_datasetname TEXT,
		egrid TEXT,
		gemeinde TEXT,
		forstbetrieb INTEGER,
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

-- Die folgende Tabelle kann gelöscht werden, sobald die Rohdaten behoben wurden
CREATE TABLE
	grundstuecke_berechnung (
		t_datasetname TEXT,	
		egrid TEXT,
		flaechenmass INTEGER,
		geometrie GEOMETRY
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

-------------------------------------------------------------------------
---------------- Erstellung Flächenberechnungstabellen ------------------
-------------------------------------------------------------------------
CREATE TABLE
	waldflaechen_berechnet (
		egrid TEXT,
		flaeche INTEGER
);

CREATE TABLE
	wytweideflaechen_berechnet (
		egrid TEXT,
		flaeche INTEGER
);

CREATE TABLE
	waldfunktion_flaechen_berechnet (
		egrid TEXT,
		funktion_txt TEXT,
		flaeche INTEGER
);

CREATE TABLE
	waldnutzung_flaechen_berechnet (
		egrid TEXT,
		nutzungskategorie_txt TEXT,
		flaeche INTEGER
);

CREATE TABLE
	biodiversitaet_objekt_flaechen_berechnet (
		egrid TEXT,
		funktion_txt TEXT,
		flaeche INTEGER
);

CREATE TABLE
	biodiversitaet_id_flaechen_berechnet (
		egrid TEXT,
		biodiversitaet_id TEXT,
		funktion_txt TEXT,
		flaeche INTEGER
);

-------------------------------------------------------------------------
----------------------- Grundtabellen befüllen --------------------------
-------------------------------------------------------------------------
INSERT INTO grundstuecke
	SELECT
		basket.t_id AS t_basket,
		ww.t_datasetname,
		ww.egrid,
		mop.gemeinde AS gemeinde,
		ww.forstbetrieb,
		ww.forstkreis,
		fk.dispname AS forstkreis_txt,
		wfr.aname AS forstrevier,
		ww.wirtschaftszone,
		wz.dispname AS wirtschaftszone_txt,
		mop.nummer AS grundstuecknummer,
		mop.flaechenmass::INTEGER,
		CONCAT_WS(' ', ww.eigentuemer, ww.zusatzinformation) AS eigentuemerinformation,
		ww.eigentuemer,
		wet.dispname AS eigentuemer_txt,
		mop.grundbuch AS grundbuch,
		ww.ausserkantonal,
		CASE
			WHEN ausserkantonal IS TRUE 
				THEN 'Ausserkantonales Eigentum'
			ELSE 'Kantonales Eigentum'
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
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_dataset AS dataset
		ON ww.t_datasetname = dataset.datasetname
	LEFT JOIN awjf_waldplan_pub_v2.t_ili2db_basket AS basket
		ON dataset.t_id = basket.dataset
	WHERE
		ww.t_datasetname =  ${bfsnr_param}
;

CREATE INDEX 
	ON grundstuecke
	USING gist (geometrie)
;

INSERT INTO grundstuecke_berechnung
	SELECT
		ww.t_datasetname,
		ww.egrid,
		mop.flaechenmass,
		ST_UNION(mop.geometrie) AS geometrie
	FROM
		awjf_waldplan_v2.waldplan_waldeigentum AS ww
	LEFT JOIN agi_mopublic_pub.mopublic_grundstueck AS mop
		ON ww.egrid = mop.egrid
	WHERE
		ww.t_datasetname =  ${bfsnr_param}
	GROUP BY
		ww.egrid,
		ww.t_datasetname,
		mop.flaechenmass
;

CREATE INDEX 
	ON grundstuecke_berechnung
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
		wf.t_datasetname =  ${bfsnr_param}
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
		wnz.t_datasetname =  ${bfsnr_param}
;

CREATE INDEX 
	ON waldnutzung
	USING gist (geometrie)
;

INSERT INTO waldflaeche_grundstueck
	SELECT
    	egrid,
    	ST_MakeValid(ST_RemoveRepeatedPoints(ST_MakeValid(ST_Union(geometrie)), 0.001)) AS geometrie
	FROM (
    	SELECT
        	gs.egrid,
        	(ST_Dump(ST_Intersection(wf.geometrie, gs.geometrie))).geom AS geometrie
    	FROM
        	waldfunktion AS wf
    	JOIN grundstuecke_berechnung AS gs
        	ON ST_Intersects(wf.geometrie, gs.geometrie)
        	AND wf.t_datasetname = gs.t_datasetname
	) sub
	WHERE
    	ST_GeometryType(geometrie) = 'ST_Polygon'
	AND
   		ST_Area(geometrie) > 0.5
	GROUP BY
    	egrid
;

CREATE INDEX 
	ON waldflaeche_grundstueck
	USING gist (geometrie)
;

-------------------------------------------------------------------------
---------------- Flächenberechnungstabellen befüllen --------------------
-------------------------------------------------------------------------
INSERT INTO waldflaechen_berechnet
	SELECT
		gs.egrid,
		(
		CASE
			WHEN gs.flaechenmass -ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) < 0 
			AND gs.flaechenmass -ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) > -2
				THEN gs.flaechenmass 
			ELSE ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC)
		END)::INTEGER AS flaeche
	FROM
		grundstuecke_berechnung AS gs
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

INSERT INTO wytweideflaechen_berechnet
	SELECT
		gs.egrid,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke_berechnung AS gs
	INNER JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.t_datasetname = wf.t_datasetname
	WHERE
		wf.wytweide IS TRUE
	GROUP BY 
		gs.egrid
;

CREATE INDEX 
	ON wytweideflaechen_berechnet(egrid)
;

INSERT INTO waldfunktion_flaechen_berechnet
	SELECT 
		gs.egrid,
		wf.funktion_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke_berechnung AS gs
	INNER JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.t_datasetname = wf.t_datasetname
	GROUP BY 
		gs.egrid,
		wf.funktion_txt
	HAVING 
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) > 0
;

CREATE INDEX 
	ON waldfunktion_flaechen_berechnet(egrid)
;

INSERT INTO waldnutzung_flaechen_berechnet
	SELECT 
		gs.egrid,
		wnz.nutzungskategorie_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wnz.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke_berechnung AS gs
	INNER JOIN waldnutzung AS wnz 
		ON ST_INTERSECTS(gs.geometrie, wnz.geometrie)
		AND gs.t_datasetname = wnz.t_datasetname
	GROUP BY 
		gs.egrid,
		wnz.nutzungskategorie_txt
	HAVING 
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wnz.geometrie)))::NUMERIC) > 0
;

CREATE INDEX 
	ON waldnutzung_flaechen_berechnet(egrid)
;

INSERT INTO biodiversitaet_objekt_flaechen_berechnet
	SELECT 
		gs.egrid,
		wf.funktion_txt AS funktion,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke_berechnung AS gs
	INNER JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.t_datasetname = wf.t_datasetname
	WHERE
		wf.funktion IN ('Biodiversitaet', 'Schutzwald_Biodiversitaet')
	GROUP BY 
		gs.egrid,
		wf.funktion_txt
	HAVING
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) > 0
;

CREATE INDEX 
	ON biodiversitaet_objekt_flaechen_berechnet(egrid)
;

INSERT INTO biodiversitaet_id_flaechen_berechnet
	SELECT 
		gs.egrid,
		wf.biodiversitaet_id,
		wf.funktion_txt AS funktion,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke_berechnung AS gs
	INNER JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.t_datasetname = wf.t_datasetname
	WHERE
		wf.funktion IN ('Biodiversitaet', 'Schutzwald_Biodiversitaet')
	GROUP BY 
		gs.egrid,
		wf.biodiversitaet_id,
		wf.funktion_txt
	HAVING 
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) > 0
;

CREATE INDEX 
	ON biodiversitaet_id_flaechen_berechnet(egrid)
;

-------------------------------------------------------------------------
--------------- Plausibilisierung berechneter Waldflächen ---------------
-------------------------------------------------------------------------
/**
SELECT
	gs.egrid,
	gs.flaechenmass,
	wfb.flaeche AS waldflaeche_berechnet,
	gs.flaechenmass - wfb.flaeche AS Differenz,
	wyt.flaeche AS wytweideflaeche_berechnet,
	SUM(funk.flaeche) AS waldfunktionsflaeche_berechnet,
	SUM(wnb.flaeche) AS waldnutzungsflaeche_berechnet,
	SUM(bioob.flaeche) AS biodiversitaetflaeche_objekt_berechnet,
	SUM(bioid.flaeche) AS biodiversitaetflaeche_id_berechnet
FROM
	grundstuecke AS gs
LEFT JOIN waldflaechen_berechnet AS wfb 
	ON gs.egrid = wfb.egrid
LEFT JOIN wytweideflaechen_berechnet AS wyt 
	ON gs.egrid = wyt.egrid
LEFT JOIN waldfunktion_flaechen_berechnet AS funk 
	ON gs.egrid = funk.egrid
LEFT JOIN waldnutzung_flaechen_berechnet AS wnb 
	ON gs.egrid = wnb.egrid
LEFT JOIN biodiversitaet_objekt_flaechen_berechnet AS bioob 
	ON gs.egrid = bioob.egrid
LEFT JOIN biodiversitaet_id_flaechen_berechnet AS bioid
	ON gs.egrid = bioid.egrid
GROUP BY 
	gs.egrid,
	gs.flaechenmass,
	wfb.flaeche,
	wyt.flaeche
*/
-------------------------------------------------------------------------
---------- Erstellung JSON-Attribute für berechnete Waldflächen ---------
-------------------------------------------------------------------------
WITH

waldfunktion_flaechen_berechnet_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'funktion', funktion_txt,
                'flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Waldfunktion' 
            )
        ) AS waldfunktion_flaechen
    FROM 
        waldfunktion_flaechen_berechnet
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
                'nutzungskategorie', nutzungskategorie_txt,
                'flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Waldnutzung'
            )
        ) AS waldnutzung_flaechen
    FROM 
        waldnutzung_flaechen_berechnet
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
                'biodiversitaet_objekt', funktion_txt,
                'flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Biodiversitaet_Objekt'
            )
        ) AS biodiversitaet_objekt_flaechen
    FROM 
        biodiversitaet_objekt_flaechen_berechnet
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
),

biodiversitaet_id_flaechen_berechnet_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
            	'id', biodiversitaet_id,
                'biodiversitaet_objekt', funktion_txt,
                'flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Biodiversitaet_ID'
            )
        ) AS biodiversitaet_id_flaechen
    FROM 
        biodiversitaet_id_flaechen_berechnet
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
)

-------------------------------------------------------------------------
----------------------- Selektierung Attribute --------------------------
-------------------------------------------------------------------------
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
	biodiversitaet_id_flaeche,
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
	bifj.biodiversitaet_id_flaechen::JSON AS biodiversitaet_id_flaeche,
	wytb.flaeche AS wytweide_flaeche,
	--produktive_flaeche,
	--hiebsatzrelevante_flaeche,
	wfb.flaeche AS waldflaeche,
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
LEFT JOIN biodiversitaet_id_flaechen_berechnet_json AS bifj
	ON gs.egrid = bifj.egrid
LEFT JOIN waldflaechen_berechnet AS wfb 
	ON gs.egrid = wfb.egrid
LEFT JOIN wytweideflaechen_berechnet AS wytb 
	ON gs.egrid = wytb.egrid
LEFT JOIN waldflaeche_grundstueck AS wfg 
	ON gs.egrid = wfg.egrid
WHERE 
	wfg.geometrie IS NOT NULL