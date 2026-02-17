WITH

waldfunktionsflaechen AS (
	SELECT 
		egrid,
		SUM(flaeche) FILTER (WHERE funktion = 'Wirtschaftswald') AS wirtschaftswald,
		SUM(flaeche) FILTER (WHERE funktion = 'Schutzwald') AS schutzwald,
		SUM(flaeche) FILTER (WHERE funktion = 'Erholungswald') AS erholungswald,
		SUM(flaeche) FILTER (WHERE funktion = 'Biodiversitaet') AS biodiversitaet,
		SUM(flaeche) FILTER (WHERE funktion = 'Schutzwald_Biodiversitaet') AS schutzwald_biodiversitaet
	FROM 
		waldfunktion_waldnutzung_flaechen_berechnet
	GROUP BY
		egrid
)

waldfunktionsflaechenv1 AS (
SELECT 
	egrid,
	COALESCE(SUM(flaeche) FILTER (WHERE funktion = 'Wirtschaftswald'), 0) AS wirtschaftswald,
    COALESCE(SUM(flaeche) FILTER (WHERE funktion = 'Schutzwald'), 0)      AS schutzwald,
    COALESCE(SUM(flaeche) FILTER (WHERE funktion = 'Erholungswald'), 0) AS erholungswald,
    COALESCE(SUM(flaeche) FILTER (WHERE funktion = 'Biodiversitaet'), 0) AS biodiversitaet,
    COALESCE(SUM(flaeche) FILTER (WHERE funktion = 'Schutzwald_biodiversitaet'), 0) AS schutzwald_biodiversitaet
FROM
	waldfunktion_flaechen_berechnet_plausibilisiert
GROUP BY
		egrid
),

waldnutzungsflaechen AS (
SELECT
	egrid,
	COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Wald_bestockt'), 0) AS wald_bestockt,
    COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Nachteilige_Nutzung'), 0) AS nachteilige_nutzung,
    COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Waldstrasse'), 0) AS waldstrasse,
    COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Maschinenweg'), 0) AS maschinenweg,
    COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Bauten_Anlagen'), 0) AS bauten_anlagen,
    COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Rodungsflaechen_temporaer'), 0) AS rodung_temporaer,
    COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Gewaesser'), 0) AS gewaesser
FROM
		waldnutzung_flaechen_berechnet_plausibilisiert
GROUP BY
		egrid
),

biodiversitaetsobjekte AS (
	SELECT
		egrid,
		SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Waldreservat') AS waldreservat,
		SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Altholzinsel') AS altholzinsel,
		SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Waldrand') AS waldrand,
		SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Lichter_Wald') AS lichter_wald,
		SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Lebensraum_prioritaer') AS lebensraum_prioritaer,
		SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Andere_Foerderflaeche') AS andere_foerderflaeche
	FROM 
		waldfunktion_waldnutzung_flaechen_berechnet
	GROUP BY 
		egrid
),

produktive_flaechen AS (
	SELECT
		wfnb.egrid,
		prod.waldflaeche,
		prod.produktiv AS waldflaeche_produktiv,
		prod.unproduktiv AS waldflaeche_unproduktiv,
		SUM(wfnb.flaeche) FILTER (WHERE wfnb.funktion = 'Wirtschaftswald' AND wfnb.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')) AS wirtschaftswald_produktiv,
		wfun.wirtschaftswald - SUM(wfnb.flaeche) FILTER (WHERE wfnb.funktion = 'Wirtschaftswald' AND wfnb.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')) AS wirtschaftswald_unproduktiv
	FROM 
		waldfunktion_waldnutzung_flaechen_berechnet AS wfnb
	LEFT JOIN produktive_waldflaechen_grundstueck_plausibilisiert AS prod 
		ON wfnb.egrid = prod.egrid
	LEFT JOIN waldfunktionsflaechen AS wfun
		ON wfnb.egrid = wfun.egrid
	GROUP BY 
		wfnb.egrid,
		prod.waldflaeche,
		prod.produktiv,
		prod.unproduktiv,
		wfun.wirtschaftswald
)

SELECT * FROM produktive_flaechen



/*
berechnete_flaechen AS (
	SELECT
		wfnb.egrid,
		waldf.flaeche AS waldflaeche,
		
		--- Waldfunktionsflächen ---
		wirtschaftswald,
		schutzwald,
		erholungswald,
		biodiversitaet,
		schutzwald_biodiversitaet,
		
		--- Waldnutzungsflächen ---
		wald_bestockt,
		nachteilige_nutzung,
		waldstrasse,
		maschinenweg,
		bauten_anlagen,
		rodung_temporaer,
		gewaesser,
		
		
		--- Produktive Waldfunktionsflächen ---
		waldflaeche_produktiv,
		waldflaeche_unproduktiv,
		wirtschaftswald_produktiv
		

		wirtschaftswald_produktiv,
		wirtschaftswald_unproduktiv,
		schutzwald_produktiv,
		schutzwald_unproduktiv,
		erholungswald_produktiv,
		erholungswald_unproduktiv,
		biodiversitaet_produktiv,
		biodiversitaet_unproduktiv,
		schutzwald_bio_produktiv,
		schutzwald_bio_unproduktiv,
		waldflaeche_hiebrel,
		waldflaeche_n_hiebrel,
		wirtschaftswald_hiebrel,
		wirtschaftswald_n_hiebrel,
		schutzwald_hiebrel,
		schutzwald_n_hiebrel,
		erholungswald_hiebrel,
		erholungswald_n_hiebrel,
		biodiversitaet_hiebrel,
		biodiversitaet_n_hiebrel,
		schutzwald_bio_hiebrel,
		schutzwald_bio_n_hiebrel,
		wald_bestockt_hiebrel,
		wald_bestockt_n_hiebrel,
		nachteilige_nutzung_hiebrel,
		nachteilige_nutzung_n_hiebrel,
		wirtschaftswald_wald_bestockt,
		wirtschaftswald_nt_nutzung,
		wirtschaftswald_waldstrasse,
		wirtschaftswald_maschinenweg,
		wirtschaftswald_bauanl,
		wirtschaftswald_gewaesser,
		wirtschaftswald_rodung_temp,
		schutzwald_wald_bestockt,
		schutzwald_nt_nutzung,
		schutzwald_waldstrasse,
		schutzwald_maschinenweg,
		schutzwald_bauanl,
		schutzwald_gewaesser,
		schutzwald_rodung_temp,
		erholungswald_wald_bestockt,
		erholungswald_nt_nutzung,
		erholungswald_waldstrasse,
		erholungswald_maschinenweg,
		erholungswald_bauanl,
		erholungswald_gewaesser,
		erholungswald_rodung_temp,
		biodiversitaet_wald_bestockt,
		biodiversitaet_nt_nutzung,
		biodiversitaet_waldstrasse,
		biodiversitaet_maschinenweg,
		biodiversitaet_bauanl,
		biodiversitaet_gewaesser,
		biodiversitaet_rodung_temp,
		schutzwald_bio_wald_bestockt,
		schutzwald_bio_nt_nutzung,
		schutzwald_bio_waldstrasse,
		schutzwald_bio_maschinenweg,
		schutzwald_bio_bauanl,
		schutzwald_bio_gewaesser,
		schutzwald_bio_rodung_temp,
		gemeinde,
		grundbuch,
		forstkreis,
		forstkreis_txt,
		forstrevier,
		forstbetrieb,
		wirtschaftszone,
		wirtschaftszone_txt,
		grundstuecknummer,
		flaechenmass,
		eigentuemer,
		eigentuemer_txt,
		eigentuemerinformation,
		wytweide_flaeche,
		waldflaeche,
		geometrie,
		bemerkung
		*/