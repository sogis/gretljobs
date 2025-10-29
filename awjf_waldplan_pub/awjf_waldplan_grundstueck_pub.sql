WITH 

grundstuecke AS (
SELECT 
	ww.egrid,
	hg.gemeindename AS gemeinde,
	ww.forstbetrieb,
	ww.forstkreis,
	fk.dispname AS forstkreis_txt,
	wfr.aname AS forstrevier,
	ww.wirtschaftszone,
	twz.dispname AS wirtschaftszone_txt,
	lg.nummer AS grundstuecknummer,
	ll.flaechenmass,
	ww.typ || ' ' || ww.zusatzinformation AS eigentuemer,
	ww.typ,
	tw.dispname AS typ_txt,
	--waldfunktion_flaechen,
	--waldplantyp_flaechen,
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
LEFT JOIN awjf_waldplan_v2.typ_waldeigentum AS tw
	ON ww.typ = tw.ilicode
LEFT JOIN awjf_waldplan_v2.typ_wirtschaftszone AS twz 
	ON ww.wirtschaftszone = twz.ilicode
LEFT JOIN awjf_waldplan_v2.waldplancatalgues_forstrevier AS wfr
	ON ww.forstrevier = wfr.t_id
LEFT JOIN awjf_waldplan_v2.forstkreise AS fk 
	ON ww.forstkreis = fk.ilicode 
),

waldfunktion AS (
SELECT
	funktion,
	typ_wf.dispname AS funktion_txt,
	biodiversitaet_id,
	biodiversitaet_objekt,
	typ_bio.dispname AS biodiversitaet_objekt_txt,
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
LEFT JOIN awjf_waldplan_v2.typ_waldfunktion AS typ_wf 
	ON wf.funktion = typ_wf.ilicode
LEFT JOIN awjf_waldplan_v2.typ_biodiversitaet typ_bio 
	ON wf.biodiversitaet_objekt = typ_bio.ilicode
),

waldplantyp AS (
	SELECT
		wt.t_id,
		wt.nutzungskategorie,
		typ_nk.dispName AS nutzungskategorie_txt,
		wt.geometrie
	FROM 
		awjf_waldplan_v2.waldplan_waldplantyp AS wt
	LEFT JOIN awjf_waldplan_v2.typ_nutzungskategorie AS typ_nk 
		ON wt.nutzungskategorie = typ_nk.ilicode
),

waldflaechen_berechnet AS (
	SELECT
		g.egrid,
		ROUND(SUM(ST_Area(ST_Intersection(g.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS g
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(g.geometrie, wf.geometrie)
	GROUP BY 
		g.egrid
),

wytweideflaechen_berechnet AS (
	SELECT
		g.egrid,
		ROUND(SUM(ST_Area(ST_Intersection(g.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS g
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(g.geometrie, wf.geometrie)
	WHERE
		wf.wytweide IS TRUE
	GROUP BY 
		g.egrid
),

waldfunktion_flaechen_berechnet AS (
	SELECT 
		g.egrid,
		wf.funktion_txt,
		ROUND(SUM(ST_Area(ST_Intersection(g.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS g
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(g.geometrie, wf.geometrie)
	GROUP BY 
		g.egrid,
		wf.funktion_txt
),

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

waldplantyp_flaechen_berechnet AS (
	SELECT 
		g.egrid,
		wt.nutzungskategorie_txt,
		ROUND(SUM(ST_Area(ST_Intersection(g.geometrie, wt.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS g
	LEFT JOIN waldplantyp AS wt 
		ON ST_INTERSECTS(g.geometrie, wt.geometrie)
	GROUP BY 
		g.egrid,
		wt.nutzungskategorie_txt
),

waldplantyp_flaechen_berechnet_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'nutzungskategorie', nutzungskategorie_txt,
                'flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Waldplan.Flaechen_Waldplantyp'
            )
        ) AS waldplantyp_flaechen
    FROM 
        waldplantyp_flaechen_berechnet
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
),

biodiversitaet_objekt_flaechen_berechnet AS (
	SELECT 
		g.egrid,
		wf.funktion_txt,
		ROUND(SUM(ST_Area(ST_Intersection(g.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS g
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(g.geometrie, wf.geometrie)
	WHERE
		wf.funktion IN ('Biodiversitaet', 'Schutzwald_Biodiversitaet')
	GROUP BY 
		g.egrid,
		wf.funktion_txt
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

biodiversitaet_id_flaechen_berechnet AS (
	SELECT 
		g.egrid,
		wf.biodiversitaet_id,
		wf.funktion_txt,
		ROUND(SUM(ST_Area(ST_Intersection(g.geometrie, wf.geometrie)))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS g
	LEFT JOIN waldfunktion AS wf 
		ON ST_INTERSECTS(g.geometrie, wf.geometrie)
	WHERE
		wf.funktion IN ('Biodiversitaet', 'Schutzwald_Biodiversitaet')
	GROUP BY 
		g.egrid,
		wf.biodiversitaet_id,
		wf.funktion_txt
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

SELECT 
	g.egrid,
	g.gemeinde,
	g.forstbetrieb,
	g.forstkreis,
	g.forstkreis_txt,
	g.forstrevier,
	g.wirtschaftszone,
	g.wirtschaftszone_txt,
	g.grundstuecknummer,
	g.flaechenmass,
	g.eigentuemer,
	g.typ,
	g.typ_txt,
	wffj.waldfunktion_flaechen::JSON AS waldfunktion_flaechen,
	wtfj.waldplantyp_flaechen::JSON AS waldplantyp_flaechen,
	bofj.biodiversitaet_objekt_flaechen::JSON AS biodiversitaetsobjekt_flaeche,
	bifj.biodiversitaet_id_flaechen::JSON AS biodiversitaet_id_flaeche,
	wytb.flaeche AS wytweide_flaeche,
	--produktive_flaeche,
	--hiebsatzrelevante_flaeche,
	wfb.flaeche AS waldflaeche,
	g.grundbuch,
	g.ausserkantonal,
	g.ausserkantonal_txt,
	g.geometrie,
	g.bemerkung
FROM 
	grundstuecke AS g
LEFT JOIN waldfunktion_flaechen_berechnet_json AS wffj 
	ON g.egrid = wffj.egrid
LEFT JOIN waldplantyp_flaechen_berechnet_json AS wtfj 
	ON g.egrid = wtfj.egrid
LEFT JOIN biodiversitaet_objekt_flaechen_berechnet_json AS bofj
	ON g.egrid = bofj.egrid
LEFT JOIN biodiversitaet_id_flaechen_berechnet_json AS bifj
	ON g.egrid = bifj.egrid
LEFT JOIN waldflaechen_berechnet AS wfb 
	ON g.egrid = wfb.egrid
LEFT JOIN wytweideflaechen_berechnet AS wytb 
	ON g.egrid = wytb.egrid