-- =========================================================
-- 1) Vorhandene Daten aus Processing-DB löschen
-- =========================================================
DELETE FROM awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck;

-- =========================================================
-- 2) Erstellung JSON-Attribute für berechnete Waldflächen
-- =========================================================
WITH

-- Waldfunktion --
waldfunktion_json_aufbereitung AS (
	SELECT 
		egrid,
		funktion_txt,
		SUM(flaeche) AS flaeche
	FROM
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
	GROUP BY 
		egrid,
		funktion_txt
),

waldfunktion_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'Funktion', funktion_txt,
                'Flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Waldfunktion' 
            )
        ) AS waldfunktion_flaeche
    FROM 
        waldfunktion_json_aufbereitung
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
),

-- Waldnutzung --
waldnutzung_json_aufbereitung AS (
	SELECT 
		egrid,
		nutzungskategorie_txt,
		SUM(flaeche) AS flaeche
	FROM
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
	GROUP BY 
		egrid,
		nutzungskategorie_txt
),

waldnutzung_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'Nutzungskategorie', nutzungskategorie_txt,
                'Flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Waldnutzung'
            )
        ) AS waldnutzung_flaeche
    FROM 
        waldnutzung_json_aufbereitung
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
),

-- Biodiversitaet Objekt --
biodiversitaet_objekt_json_aufbereitung AS (
	SELECT 
		egrid,
		biodiversitaet_objekt_txt,
		SUM(flaeche) AS flaeche
	FROM
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
	WHERE
		biodiversitaet_objekt IS NOT NULL
	GROUP BY 
		egrid,
		biodiversitaet_objekt_txt
),

biodiversitaet_objekt_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'Biodiversitaet_Objekt', biodiversitaet_objekt_txt,
                'Flaeche', flaeche,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Biodiversitaet_Objekt'
            )
        ) AS biodiversitaet_objekt_flaeche
    FROM 
        biodiversitaet_objekt_json_aufbereitung
    WHERE
    	flaeche > 0
    GROUP BY 
        egrid
),

-- Produktive Waldfläche --
produktive_waldflaeche_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'Produktiv', waldflaeche_produktiv,
                'Unproduktiv', waldflaeche_unproduktiv,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Produktiv'
            )
        ) AS flaeche_produktiv
    FROM 
       waldflaeche_produktiv
    GROUP BY 
        egrid
),

-- Hiebsatzrelevante Waldfläche --
hiebsatzrelevante_waldflaeche_json AS (
    SELECT
    	egrid,
        json_agg(
            json_build_object(
                'Relevant', waldflaeche_hiebrel,
                'Irrelevant', waldflaeche_n_hiebrel,
                '@type', 'SO_AWJF_Waldplan_Publikation_20250312.Flaechen_Hiebsatzrelevant'
            )
        ) AS flaeche_hiebsatzrelevant
    FROM 
        waldfunktion_hiebsatzrelevant
    GROUP BY 
        egrid
)

-- =========================================================
-- 3) Einfügen in Waldplan-Grundstückstabelle
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
	produktive_flaeche,
	hiebsatzrelevante_flaeche,
	waldflaeche,
	grundbuch,
	ausserkantonal,
	ausserkantonal_txt,
	geometrie,
	bemerkung
)

SELECT
	gs.t_basket_waldplan AS t_basket,
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
	wfj.waldfunktion_flaeche::JSON AS waldfunktion_flaechen,
	wnj.waldnutzung_flaeche::JSON AS waldnutzung_flaechen,
	boj.biodiversitaet_objekt_flaeche::JSON AS biodiversitaetsobjekt_flaeche,
	wyt.flaeche AS wytweide_flaeche,
	prodj.flaeche_produktiv::JSON AS produktive_flaeche,
	hiebj.flaeche_hiebsatzrelevant::JSON AS hiebsatzrelevante_flaeche,
	wfbp.flaeche AS waldflaeche,
	gs.grundbuch,
	gs.ausserkantonal,
	gs.ausserkantonal_txt,
	wfg.geometrie,
	gs.bemerkung
FROM 
	grundstueck AS gs
LEFT JOIN waldfunktion_json AS wfj
	ON gs.egrid = wfj.egrid
LEFT JOIN waldnutzung_json AS wnj 
	ON gs.egrid = wnj.egrid
LEFT JOIN biodiversitaet_objekt_json AS boj
	ON gs.egrid = boj.egrid
LEFT JOIN waldflaeche_berechnet_plausibilisiert AS wfbp 
	ON gs.egrid = wfbp.egrid
LEFT JOIN wytweide_grundstueck AS wyt
	ON gs.egrid = wyt.egrid
LEFT JOIN produktive_waldflaeche_json AS prodj 
	ON gs.egrid = prodj.egrid
LEFT JOIN hiebsatzrelevante_waldflaeche_json AS hiebj 
	ON gs.egrid = hiebj.egrid
LEFT JOIN waldflaeche_grundstueck_final AS wfg 
	ON gs.egrid = wfg.egrid
WHERE 
	wfg.geometrie IS NOT NULL