DELETE FROM waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert;

WITH 
-- Berechne die totale Waldfunktion pro Grundstück --
waldfunktion_summe AS (
	SELECT
		egrid,
		SUM(flaeche) AS waldfunktion_total
	FROM
		waldfunktion_waldnutzung_grundstueck_berechnet
	WHERE
		funktion IN (
			'Wirtschaftswald',
			'Schutzwald',
			'Erholungswald',
			'Biodiversitaet',
			'Schutzwald_Biodiversitaet'
		)
	GROUP BY
		egrid
),

-- Vergleich der berechneten Waldfunktionssumme mit der berechneten Waldfläche --
differenz AS (
	SELECT 
		wbp.egrid,
		wbp.flaeche - COALESCE(wfs.waldfunktion_total,0) AS diff
	FROM
		waldflaeche_berechnet_plausibilisiert AS wbp
	LEFT JOIN waldfunktion_summe AS wfs
		ON wbp.egrid = wfs.egrid
),

-- Nummerierung/Rangierung der Teilflächen pro Grundstück --
-- Bei einer Differenz soll später nur die grösste Teilfläche angepasst werden --
rangiert AS (
	SELECT
		w.*,
		d.diff,
		ROW_NUMBER() OVER (
			PARTITION BY
				w.egrid
				ORDER BY
					w.flaeche DESC
		) AS rn
	FROM
		waldfunktion_waldnutzung_grundstueck_berechnet AS w
	LEFT JOIN differenz AS d
		ON w.egrid = d.egrid
)

INSERT INTO waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
	SELECT
		egrid,
		t_datasetname,
		funktion,
		funktion_txt,
		biodiversitaet_objekt,
		biodiversitaet_objekt_txt,
		nutzungskategorie,
		nutzungskategorie_txt,
    	-- Anpassung grösste Teilfläche pro egrid --
		CASE 
			WHEN rn = 1 AND diff IS NOT NULL
				THEN flaeche + diff
			ELSE flaeche
		END AS flaeche,
		CASE 
			WHEN rn = 1 AND diff IS NOT NULL AND diff <> 0
				THEN TRUE
			ELSE FALSE
		END AS korrigiert
	FROM rangiert;

DELETE FROM waldfunktionsflaechen_grundstueck;
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
			waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
		GROUP BY
			egrid
	) t
;

DELETE FROM waldnutzungsflaechen_grundstueck;
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
			waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
		GROUP BY
			egrid
	) t
;

DELETE FROM waldnutzungsflaechen_grundstueck;
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
			waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
		GROUP BY
			egrid
	) t
;

INSERT INTO produktive_waldflaechen
	SELECT
		wfnp.egrid,
		wald.flaeche AS waldflaeche,
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')) AS waldflaeche_produktiv,
		wald.flaeche - SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')) AS waldflaeche_unproduktiv,
		-- Wirtschaftswald --
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Wirtschaftswald') AS wirtschaftswald_produktiv,
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Wirtschaftswald') AS wirtschaftswald_unproduktiv,
		-- Schutzwald --
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Schutzwald') AS schutzwald_produktiv,
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Schutzwald') AS schutzwald_unproduktiv,
		-- Erholungswald --
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Erholungswald') AS erholungswald_produktiv,
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Erholungswald') AS erholungswald_unproduktiv,
		-- Biodiversität --
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Biodiversitaet') AS biodiversitaet_produktiv,
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Biodiversitaet') AS biodiversitaet_unproduktiv,
		-- Schutzwald / Biodiversität --
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Schutzwald_Biodiversitaet') AS schutzwald_bio_produktiv,
		SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Schutzwald_Biodiversitaet') AS schutzwald_bio_unproduktiv
	FROM 
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert AS wfnp
	LEFT JOIN waldflaeche_berechnet_plausibilisiert AS wald
		ON wfnp.egrid = wald.egrid
	GROUP BY 
		wfnp.egrid,
		wald.flaeche




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