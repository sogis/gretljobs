-- =========================================================
-- 1) Erstellung JSON-Attribute für berechnete Waldflächen
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
                'Biodiversitaet_Objekt', biodiversitaet_objekt_txt,
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
-- 2) Insert in Waldplan-Grundstückstabelle
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