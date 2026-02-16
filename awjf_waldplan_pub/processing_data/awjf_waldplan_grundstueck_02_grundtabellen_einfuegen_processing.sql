-- =========================================================
-- 1) Grundtabellen befüllen
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

INSERT INTO wirtschaftswald_waldnutzung_flaechen
SELECT
	wnz.t_datasetname,
	wnz.nutzungskategorie,
	wnz.nutzungskategorie_txt,
	ST_Intersection(wnz.geometrie, wf.geometrie) AS geometrie
FROM 
	waldnutzung AS wnz
LEFT JOIN waldfunktion AS wf 
	ON St_Intersects(wnz.geometrie, wf.geometrie)
WHERE 
	wf.funktion = 'Wirtschaftswald'
AND 
	ST_Area(ST_Intersection(wnz.geometrie, wf.geometrie)) > 0.5
;

CREATE INDEX
	ON wirtschaftswald_waldnutzung_flaechen
	USING gist (geometrie)
;

INSERT INTO schutzwald_waldnutzung_flaechen
SELECT
	wnz.t_datasetname,
	wnz.nutzungskategorie,
	wnz.nutzungskategorie_txt,
	ST_Intersection(wnz.geometrie, wf.geometrie) AS geometrie
FROM 
	waldnutzung AS wnz
LEFT JOIN waldfunktion AS wf 
	ON St_Intersects(wnz.geometrie, wf.geometrie)
WHERE 
	wf.funktion = 'Schutzwald'
AND 
	ST_Area(ST_Intersection(wnz.geometrie, wf.geometrie)) > 0.5
;

CREATE INDEX
	ON schutzwald_waldnutzung_flaechen
	USING gist (geometrie)
;

INSERT INTO erholungswald_waldnutzung_flaechen
SELECT
	wf.funktion,
	wnz.t_datasetname,
	wnz.nutzungskategorie,
	wnz.nutzungskategorie_txt,
	ST_Intersection(wnz.geometrie, wf.geometrie) AS geometrie
FROM 
	waldnutzung AS wnz
LEFT JOIN waldfunktion AS wf 
	ON St_Intersects(wnz.geometrie, wf.geometrie)
WHERE 
	wf.funktion = 'Erholungswald'
AND 
	ST_Area(ST_Intersection(wnz.geometrie, wf.geometrie)) > 0.5
;

CREATE INDEX
	ON erholungswald_waldnutzung_flaechen
	USING gist (geometrie)
;

INSERT INTO biodiversitaet_waldnutzung_flaechen
SELECT
	wnz.t_datasetname,
	wnz.nutzungskategorie,
	wnz.nutzungskategorie_txt,
	ST_Intersection(wnz.geometrie, wf.geometrie) AS geometrie
FROM 
	waldnutzung AS wnz
LEFT JOIN waldfunktion AS wf 
	ON St_Intersects(wnz.geometrie, wf.geometrie)
WHERE 
	wf.funktion = 'Biodiversitaet'
AND 
	ST_Area(ST_Intersection(wnz.geometrie, wf.geometrie)) > 0.5
;

CREATE INDEX
	ON biodiversitaet_waldnutzung_flaechen
	USING gist (geometrie)
;

INSERT INTO schutzwald_biodiversitaet_waldnutzung_flaechen
SELECT
	wnz.t_datasetname,
	wnz.nutzungskategorie,
	wnz.nutzungskategorie_txt,
	ST_Intersection(wnz.geometrie, wf.geometrie) AS geometrie
FROM 
	waldnutzung AS wnz
LEFT JOIN waldfunktion AS wf 
	ON St_Intersects(wnz.geometrie, wf.geometrie)
WHERE 
	wf.funktion = 'Schutzwald_Biodiversitaet'
AND 
	ST_Area(ST_Intersection(wnz.geometrie, wf.geometrie)) > 0.5
;

CREATE INDEX
	ON schutzwald_biodiversitaet_waldnutzung_flaechen
	USING gist (geometrie)
;