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

waldfunktion_flaechen_berechnet AS (
	SELECT 
		g.egrid,
		wf.funktion,
		ROUND(ST_Area(ST_Intersection(g.geometrie, wf.geometrie))::NUMERIC) AS flaeche
	FROM
		grundstuecke AS g
	LEFT JOIN awjf_waldplan_v2.waldplan_waldfunktion AS wf 
		ON ST_INTERSECTS(g.geometrie, wf.geometrie)
),

waldfunktion_flaechen_berechnet_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'funktion', funktion,
                'flaeche', flaeche
            )
        ) AS waldfunktion_flaechen
    FROM 
        waldfunktion_flaechen_berechnet
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
)

SELECT * FROM waldfunktion_flaechen_berechnet_json