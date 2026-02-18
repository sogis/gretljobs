INSERT INTO waldfunktionsflaechen_grundstueck
	SELECT
    	egrid,
    	wirtschaftswald,
    	schutzwald,
    	erholungswald,
    	biodiversitaet,
    	schutzwald_biodiversitaet,
    
		COALESCE(wirtschaftswald,0)
		+ COALESCE(schutzwald,0)
		+ COALESCE(erholungswald,0)
		+ COALESCE(biodiversitaet,0)
		+ COALESCE(schutzwald_biodiversitaet,0) AS waldfunktion_total
	FROM (
		SELECT 
			egrid,
			SUM(flaeche) FILTER (WHERE funktion = 'Wirtschaftswald') AS wirtschaftswald,
			SUM(flaeche) FILTER (WHERE funktion = 'Schutzwald') AS schutzwald,
			SUM(flaeche) FILTER (WHERE funktion = 'Erholungswald') AS erholungswald,
			SUM(flaeche) FILTER (WHERE funktion = 'Biodiversitaet') AS biodiversitaet,
			SUM(flaeche) FILTER (WHERE funktion = 'Schutzwald_Biodiversitaet') AS schutzwald_biodiversitaet
		FROM
			waldfunktion_waldnutzung_grundstueck_berechnet
		GROUP BY
			egrid
	) t
;

INSERT INTO waldnutzungsflaechen_grundstueck
	SELECT
    	egrid,
    	wald_bestockt,
    	nachteilige_nutzung,
    	waldstrasse,
    	maschinenweg,
    	bauten_anlagen,
    	rodung_temporaer,
    	gewaesser,
    
		COALESCE(wald_bestockt,0)
		+ COALESCE(nachteilige_nutzung,0)
		+ COALESCE(waldstrasse,0)
		+ COALESCE(maschinenweg,0)
		+ COALESCE(bauten_anlagen,0)
		+ COALESCE(rodung_temporaer,0)
		+ COALESCE(gewaesser,0) AS waldnutzung_total
	FROM (
		SELECT 
			egrid,
				SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Wald_bestockt') AS wald_bestockt,
				SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Nachteilige_Nutzung') AS nachteilige_nutzung,
				SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Waldstrasse') AS waldstrasse,
				SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Maschinenweg') AS maschinenweg,
				SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Bauten_Anlagen') AS bauten_anlagen,
				SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Rodungsflaechen_temporaer') AS rodung_temporaer,
				SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Gewaesser') AS gewaesser
		FROM
			waldfunktion_waldnutzung_grundstueck_berechnet
		GROUP BY
			egrid
	) t
;

INSERT INTO biodiversitaetsobjekte_grundstueck
	SELECT
    	egrid,
    	waldreservat,
    	altholzinsel,
    	waldrand,
    	lichter_wald,
    	lebensraum_prioritaer,
    	andere_foerderflaeche,
    
		COALESCE(waldreservat,0)
		+ COALESCE(waldreservat,0)
		+ COALESCE(altholzinsel,0)
		+ COALESCE(waldrand,0)
		+ COALESCE(lichter_wald,0)
		+ COALESCE(lebensraum_prioritaer,0)
		+ COALESCE(andere_foerderflaeche,0) AS biodiversitaetsobjekte_total
	FROM (
		SELECT 
			egrid,
				SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Waldreservat') AS waldreservat,
				SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Altholzinsel') AS altholzinsel,
				SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Waldrand') AS waldrand,
				SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Lichter_Wald') AS lichter_wald,
				SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Lebensraum_prioritaer') AS lebensraum_prioritaer,
				SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Andere_Foerderflaeche') AS andere_foerderflaeche
		FROM
			waldfunktion_waldnutzung_grundstueck_berechnet
		GROUP BY
			egrid
	) t
;




Differenzen AS (
	SELECT
		wbp.egrid,
		wbp.flaeche AS waldflaeche,
		COALESCE(wfg.wirtschaftswald,0) + COALESCE(wfg.schutzwald,0) + COALESCE(wfg.erholungswald,0) + COALESCE(wfg.biodiversitaet,0) + COALESCE(wfg.schutzwald_biodiversitaet,0) AS waldfunktion_summe
	FROM 
		waldflaeche_berechnet_plausibilisiert AS wbp
	LEFT JOIN waldfunktionsflaechen_grundstueck AS wfg 
		ON wbp.egrid = wfg.egrid
)

SELECT * FROM Differenzen



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