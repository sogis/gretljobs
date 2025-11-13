WITH 

-------------------------------------------------------------------------
---------------------- Erstellung Grundtabellen -------------------------
-------------------------------------------------------------------------
grundstuecke AS (
SELECT
	ww.t_datasetname AS bfsnr,
	ww.egrid,
	hg.gemeindename AS gemeinde,
	ww.forstbetrieb,
	ww.forstkreis,
	fk.dispname AS forstkreis_txt,
	wfr.aname AS forstrevier,
	ww.wirtschaftszone,
	wz.dispname AS wirtschaftszone_txt,
	lg.nummer AS grundstuecknummer,
	ll.flaechenmass,
	CONCAT_WS(' ', ww.eigentuemer, ww.zusatzinformation) AS eigentuemerinformation,
	ww.eigentuemer,
	wet.dispname AS eigentuemer_txt,
	--waldfunktion_flaechen,
	--waldnutzung_flaechen,
	--wytweide_flaeche,
	--waldflaeche,
	gg.aname AS grundbuch,
	ww.ausserkantonal,
	CASE
		WHEN ausserkantonal IS TRUE 
			THEN 'Ausserkantonales Eigentum'
		ELSE 'Kantonales Eigentum'
	END AS ausserkantonal_txt,
	ll.geometrie,
	ww.bemerkung
FROM
	awjf_waldplan_v2.waldplan_waldeigentum AS ww
LEFT JOIN agi_dm01avso24.liegenschaften_grundstueck AS lg
	ON ww.egrid = lg.egris_egrid
LEFT JOIN agi_dm01avso24.liegenschaften_liegenschaft AS ll
	ON lg.t_id = ll.liegenschaft_von
LEFT JOIN agi_av_gb_administrative_einteilungen_v2.grundbuchkreise_grundbuchkreis AS gg 
	ON lg.nbident = gg.nbident
LEFT JOIN agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze AS hg 
	ON gg.bfsnr = hg.bfs_gemeindenummer
LEFT JOIN awjf_waldplan_v2.waldeigentuemer AS wet
	ON ww.eigentuemer = wet.ilicode
LEFT JOIN awjf_waldplan_v2.wirtschaftszonen AS wz 
	ON ww.wirtschaftszone = wz.ilicode
LEFT JOIN awjf_waldplan_v2.waldplankatalog_forstrevier AS wfr
	ON ww.forstrevier = wfr.t_id
LEFT JOIN awjf_waldplan_v2.forstkreise AS fk 
	ON ww.forstkreis = fk.ilicode 
),

waldfunktion AS (
SELECT
	t_datasetname AS bfsnr,
	funktion,
	wfk.dispname AS funktion_txt,
	biodiversitaet_id,
	biodiversitaet_objekt,
	biotyp.dispname AS biodiversitaet_objekt_txt,
	--schutzwald_nr, --Zuteilung Schutzwald-Nr. vorher notwendig
	wytweide,
	CASE 
		WHEN wytweide IS TRUE
			THEN 'Wytweidefläche vorhanden'
		ELSE 'keine Wytweidefläche vorhanden'
	END AS wytweide_txt,
	geometrie,
	bemerkung
FROM 
	awjf_waldplan_v2.waldplan_waldfunktion AS wf
LEFT JOIN awjf_waldplan_v2.waldfunktionskategorie AS wfk 
	ON wf.funktion = wfk.ilicode
LEFT JOIN awjf_waldplan_v2.biodiversitaetstyp AS biotyp 
	ON wf.biodiversitaet_objekt = biotyp.ilicode
),

waldnutzung AS (
	SELECT
		wnz.t_id,
		wnz.t_datasetname AS bfsnr,
		wnz.nutzungskategorie,
		wnk.dispName AS nutzungskategorie_txt,
		wnz.geometrie
	FROM 
		awjf_waldplan_v2.waldplan_waldnutzung AS wnz
	LEFT JOIN awjf_waldplan_v2.waldnutzungskategorie AS wnk 
		ON wnz.nutzungskategorie = wnk.ilicode
),

-------------------------------------------------------------------------
--------------------- Waldflächen pro Grundstück ------------------------
-------------------------------------------------------------------------
waldflaeche_grundstueck AS (
SELECT
    egrid,
    ST_Union(geometrie) AS geometrie
FROM (
    SELECT
        gs.egrid,
        (ST_Dump(ST_Intersection(wf.geometrie, gs.geometrie))).geom AS geometrie
    FROM
        waldfunktion AS wf
    JOIN grundstuecke AS gs
        ON ST_Intersects(wf.geometrie, gs.geometrie)
        AND wf.bfsnr = gs.bfsnr
) sub
WHERE
    ST_GeometryType(geometrie) = 'ST_Polygon'
AND
    ST_Area(geometrie) > 0.5
GROUP BY
    egrid
),

-------------------------------------------------------------------------
----------------------- Berechnung Waldflächen --------------------------
-------------------------------------------------------------------------
waldflaechen_berechnet AS (
	SELECT
		gs.egrid,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS gs
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.bfsnr = wf.bfsnr
	GROUP BY 
		gs.egrid
),

wytweideflaechen_berechnet AS (
	SELECT
		gs.egrid,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS gs
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.bfsnr = wf.bfsnr
	WHERE
		wf.wytweide IS TRUE
	GROUP BY 
		gs.egrid
),

waldfunktion_flaechen_berechnet AS (
	SELECT 
		gs.egrid,
		wf.funktion_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS gs
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.bfsnr = wf.bfsnr
	GROUP BY 
		gs.egrid,
		wf.funktion_txt
),

waldnutzung_flaechen_berechnet AS (
	SELECT 
		gs.egrid,
		wnz.nutzungskategorie_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wnz.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS gs
	LEFT JOIN waldnutzung AS wnz 
		ON ST_INTERSECTS(gs.geometrie, wnz.geometrie)
		AND gs.bfsnr = wnz.bfsnr
	GROUP BY 
		gs.egrid,
		wnz.nutzungskategorie_txt
),

biodiversitaet_objekt_flaechen_berechnet AS (
	SELECT 
		gs.egrid,
		wf.funktion_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS gs
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.bfsnr = wf.bfsnr
	WHERE
		wf.funktion IN ('Biodiversitaet', 'Schutzwald_Biodiversitaet')
	GROUP BY 
		gs.egrid,
		wf.funktion_txt
),

biodiversitaet_id_flaechen_berechnet AS (
	SELECT 
		gs.egrid,
		wf.biodiversitaet_id,
		wf.funktion_txt,
		ROUND(SUM(ST_Area(ST_Intersection(gs.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS gs
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(gs.geometrie, wf.geometrie)
		AND gs.bfsnr = wf.bfsnr
	WHERE
		wf.funktion IN ('Biodiversitaet', 'Schutzwald_Biodiversitaet')
	GROUP BY 
		gs.egrid,
		wf.biodiversitaet_id,
		wf.funktion_txt
),

-------------------------------------------------------------------------
---------- Erstellung JSON-Attribute für berechnete Waldflächen ---------
-------------------------------------------------------------------------
waldfunktion_flaechen_berechnet_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'funktion', funktion_txt,
                'flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Waldplan.Flaechen_Waldfunktion'
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
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Waldplan.Flaechen_Waldnutzung'
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
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Waldplan.Flaechen_Biodiversitaet_Objekt'
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
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Waldplan.Flaechen_Biodiversitaet_ID'
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
SELECT 
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