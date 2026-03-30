WITH

-- =========================================================
-- 1) Berechnung Flächen der verschnittenen Waldfunktions- und Waldnutzungsflächen
-- =========================================================
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

-- =========================================================
-- 2) Plausibilisierung der berechneten Flächen
-- =========================================================
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

INSERT INTO waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert (
	egrid,
	t_datasetname,
	funktion,
	funktion_txt,
	biodiversitaet_objekt,
	biodiversitaet_objekt_txt,
	wytweide,
	nutzungskategorie,
	nutzungskategorie_txt,
	flaeche,
	angepasst
)
	SELECT
		egrid,
		t_datasetname,
		funktion,
		funktion_txt,
		biodiversitaet_objekt,
		biodiversitaet_objekt_txt,
		wytweide,
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

-- =========================================================
-- 3) Waldfunktionsfläche pro Grundstück
-- =========================================================
INSERT INTO waldfunktionsflaechen_grundstueck (
	egrid,
	wirtschaftswald,
	schutzwald,
	erholungswald,
	biodiversitaet,
	schutzwald_biodiversitaet,
	waldfunktion_total
)
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
			COALESCE(SUM(flaeche) FILTER (WHERE funktion = 'Wirtschaftswald'),0) AS wirtschaftswald,
			COALESCE(SUM(flaeche) FILTER (WHERE funktion = 'Schutzwald'),0) AS schutzwald,
			COALESCE(SUM(flaeche) FILTER (WHERE funktion = 'Erholungswald'),0) AS erholungswald,
			COALESCE(SUM(flaeche) FILTER (WHERE funktion = 'Biodiversitaet'),0) AS biodiversitaet,
			COALESCE(SUM(flaeche) FILTER (WHERE funktion = 'Schutzwald_Biodiversitaet'),0) AS schutzwald_biodiversitaet
		FROM
			waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
		GROUP BY
			egrid
	) t
;

-- =========================================================
-- 4) Waldnutzungsfläche pro Grundstück
-- =========================================================
INSERT INTO waldnutzungsflaechen_grundstueck (
	egrid,
	wald_bestockt,
	nachteilige_nutzung,
	waldstrasse,
	maschinenweg,
	bauten_anlagen,
	rodung_temporaer,
	gewaesser,
	waldnutzung_total
)
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
				COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Wald_bestockt'),0) AS wald_bestockt,
				COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Nachteilige_Nutzung'),0) AS nachteilige_nutzung,
				COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Waldstrasse'),0) AS waldstrasse,
				COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Maschinenweg'),0) AS maschinenweg,
				COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Bauten_Anlagen'),0) AS bauten_anlagen,
				COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Rodungsflaechen_temporaer'),0) AS rodung_temporaer,
				COALESCE(SUM(flaeche) FILTER (WHERE nutzungskategorie = 'Gewaesser'),0) AS gewaesser
		FROM
			waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
		GROUP BY
			egrid
	) t
;

-- =========================================================
-- 5) Biodiversitätsobjektfläche pro Grundstück
-- =========================================================
INSERT INTO biodiversitaetsobjekte_grundstueck (
	egrid,
	waldreservat,
	altholzinsel,
	waldrand,
	lichter_wald,
	lebensraum_prioritaer,
	andere_foerderflaeche,
	biodiversitaetsobjekte_total
)
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
				COALESCE(SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Waldreservat'),0) AS waldreservat,
				COALESCE(SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Altholzinsel'),0) AS altholzinsel,
				COALESCE(SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Waldrand'),0) AS waldrand,
				COALESCE(SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Lichter_Wald'),0) AS lichter_wald,
				COALESCE(SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Lebensraum_prioritaer'),0) AS lebensraum_prioritaer,
				COALESCE(SUM(flaeche) FILTER (WHERE biodiversitaet_objekt = 'Andere_Foerderflaeche'),0) AS andere_foerderflaeche
		FROM
			waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
		GROUP BY
			egrid
	) t
;

-- =========================================================
-- 6) Produktive Waldfläche pro Grundstück
--    Die produktive Fläche setzt sich aus der Waldnutzungskategorie 'Wald_bestockt' und 'Nachteilige_Nutzung' zusammen
-- =========================================================
INSERT INTO waldflaeche_produktiv (
	egrid,
	waldflaeche,
	waldflaeche_produktiv,
	waldflaeche_unproduktiv,
	wirtschaftswald_produktiv,
	wirtschaftswald_unproduktiv,
	schutzwald_produktiv,
	schutzwald_unproduktiv,
	erholungswald_produktiv,
	erholungswald_unproduktiv,
	biodiversitaet_produktiv,
	biodiversitaet_unproduktiv,
	schutzwald_bio_produktiv,
	schutzwald_bio_unproduktiv
)
	SELECT
		wfnp.egrid,
		wald.flaeche AS waldflaeche,
		-- Waldfläche total --
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')),0) AS waldflaeche_produktiv,
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')),0) AS waldflaeche_unproduktiv,
		-- Wirtschaftswald --
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Wirtschaftswald'),0) AS wirtschaftswald_produktiv,
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Wirtschaftswald'),0) AS wirtschaftswald_unproduktiv,
		-- Schutzwald --
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Schutzwald'),0) AS schutzwald_produktiv,
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Schutzwald'),0) AS schutzwald_unproduktiv,
		-- Erholungswald --
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Erholungswald'),0) AS erholungswald_produktiv,
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Erholungswald'),0) AS erholungswald_unproduktiv,
		-- Biodiversität --
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Biodiversitaet'),0) AS biodiversitaet_produktiv,
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Biodiversitaet'),0) AS biodiversitaet_unproduktiv,
		-- Schutzwald / Biodiversität --
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Schutzwald_Biodiversitaet'),0) AS schutzwald_bio_produktiv,
		COALESCE(SUM(wfnp.flaeche) FILTER (WHERE wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung') AND wfnp.funktion = 'Schutzwald_Biodiversitaet'),0) AS schutzwald_bio_unproduktiv
	FROM 
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert AS wfnp
	LEFT JOIN waldflaeche_berechnet_plausibilisiert AS wald
		ON wfnp.egrid = wald.egrid
	GROUP BY 
		wfnp.egrid,
		wald.flaeche
;

-- =========================================================
-- 7) Hiebsatzrelevante Waldfunktionsfläche pro Grundstück
--    Die hiebsatzrelevante Fläche setzt aus der produktiven Waldfläche zusammen, mit Ausnahme dort,
--    wo die Waldfunktion = Biodiversitaet und Biodiversitaet_Objekt = 'Waldreservat' oder 'Altholzinsel' ist
-- =========================================================
INSERT INTO waldfunktion_hiebsatzrelevant (
	egrid,
	waldflaeche,
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
	schutzwald_bio_n_hiebrel
)
	SELECT
		wfnp.egrid,
		wald.flaeche AS waldflaeche,
		
		-- Waldfläche total --
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				AND NOT (
					wfnp.funktion = 'Biodiversitaet'
					AND wfnp.biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
					AND wfnp.biodiversitaet_objekt IS NOT NULL
				)
			),0
		) AS waldflaeche_hiebrel,
			
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE (
					wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
					OR (
						wfnp.funktion = 'Biodiversitaet'
						AND wfnp.biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
					)
				)
			),0
		) AS waldflaeche_n_hiebrel,
			
		-- Wirtschaftswald --
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.funktion = 'Wirtschaftswald'
				AND
					wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			),0
		) AS wirtschaftswald_hiebrel,

		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE 
					wfnp.funktion = 'Wirtschaftswald'
				AND
					wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			),0
		) AS wirtschaftswald_n_hiebrel,
		
				-- Schutzwald --
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.funktion = 'Schutzwald'
				AND
					wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			),0
		) AS schutzwald_hiebrel,

		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE 
					wfnp.funktion = 'Schutzwald'
				AND
					wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			),0
		) AS schutzwald_n_hiebrel,
						
		-- Erholungswald --
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.funktion = 'Erholungswald'
				AND
					wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			),0
		) AS erholungswald_hiebrel,

		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE 
					wfnp.funktion = 'Erholungswald'
				AND 
					wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			),0
		) AS erholungswald_n_hiebrel,
						
		-- Biodiversität --
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.funktion = 'Biodiversitaet'
				AND
					wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				AND NOT (
					wfnp.biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
					AND wfnp.biodiversitaet_objekt IS NOT NULL
				)		
			),0
		) AS biodiversitaet_hiebrel,

		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE 
					wfnp.funktion = 'Biodiversitaet'
				AND 
					wfnp.biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
			),0
		) AS biodiversitaet_n_hiebrel,
						
		-- Schutzwald / Biodiversität --
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.funktion = 'Schutzwald_Biodiversitaet'
				AND
					wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			),0
		) AS schutzwald_bio_hiebrel,

		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE 
					wfnp.funktion = 'Schutzwald_Biodiversitaet'
				AND 
					wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			),0
		) AS schutzwald_bio_n_hiebrel
	FROM 
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert AS wfnp
	LEFT JOIN waldflaeche_berechnet_plausibilisiert AS wald
		ON wfnp.egrid = wald.egrid
	GROUP BY 
		wfnp.egrid,
		wald.flaeche
;


-- =========================================================
-- 8) Hiebsatzrelevante Waldnutzungsfläche pro Grundstück
--    Die hiebsatzrelevante Fläche setzt aus der produktiven Waldfläche zusammen, mit Ausnahme dort,
--    wo die Waldfunktion = Biodiversitaet und Biodiversitaet_Objekt = 'Waldreservat' oder 'Altholzinsel' ist
-- =========================================================
INSERT INTO waldnutzung_hiebsatzrelevant (
	egrid,
	waldflaeche,
	waldflaeche_hiebrel,
	waldflaeche_n_hiebrel,
	wald_bestockt_hiebrel,
	wald_bestockt_n_hiebrel,
	nachteilige_nutzung_hiebrel,
	nachteilige_nutzung_n_hiebrel
)
	SELECT
		wfnp.egrid,
		wald.flaeche AS waldflaeche,
		
		-- Waldfläche total --
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				AND NOT (
					wfnp.funktion = 'Biodiversitaet'
					AND wfnp.biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
					AND wfnp.biodiversitaet_objekt IS NOT NULL
				)
			),0
		) AS waldflaeche_hiebrel,
			
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE (
					wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
					OR (
						wfnp.funktion = 'Biodiversitaet'
						AND wfnp.biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
					)
				)
			),0
		) AS waldflaeche_n_hiebrel,
			
		-- Wald bestockt --
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.nutzungskategorie = 'Wald_bestockt'
				AND NOT (
					wfnp.funktion = 'Biodiversitaet'
					AND wfnp.biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
					AND wfnp.biodiversitaet_objekt IS NOT NULL
				)
			),0
		) AS wald_bestockt_hiebrel,
			
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.nutzungskategorie = 'Wald_bestockt'
				AND (
					wfnp.funktion = 'Biodiversitaet'
					AND wfnp.biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			),0
		) AS wald_bestockt_n_hiebrel,
				
		-- Nachteilige Nutzung --
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.nutzungskategorie = 'Nachteilige_Nutzung'
				AND NOT (
					wfnp.funktion = 'Biodiversitaet'
					AND wfnp.biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
					AND wfnp.biodiversitaet_objekt IS NOT NULL
				)
			),0
		) AS nachteilige_nutzung_hiebrel,
			
		COALESCE(
			SUM(wfnp.flaeche) FILTER (
				WHERE
					wfnp.nutzungskategorie = 'Nachteilige_Nutzung'
				AND (
					wfnp.funktion = 'Biodiversitaet'
					AND wfnp.biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			),0
		) AS nachteilige_nutzung_n_hiebrel
	FROM 
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert AS wfnp
	LEFT JOIN waldflaeche_berechnet_plausibilisiert AS wald
		ON wfnp.egrid = wald.egrid
	GROUP BY 
		wfnp.egrid,
		wald.flaeche
;

-- =========================================================
-- 9) Waldfunktionsflächen nach Waldnutzung
-- =========================================================
INSERT INTO waldfunktion_nach_waldnutzung (
	egrid,
	wirtschaftswald_wald_bestockt,
	wirtschaftswald_nt_nutzung,
	wirtschaftswald_waldstrasse,
	wirtschaftswald_maschinenweg,
	wirtschaftswald_bauanl,
	wirtschaftswald_gewaesser,
	wirtschaftswald_rodung_temp,
	erholungswald_wald_bestockt,
	erholungswald_nt_nutzung,
	erholungswald_waldstrasse,
	erholungswald_maschinenweg,
	erholungswald_bauanl,
	erholungswald_gewaesser,
	erholungswald_rodung_temp,
	schutzwald_wald_bestockt,
	schutzwald_nt_nutzung,
	schutzwald_waldstrasse,
	schutzwald_maschinenweg,
	schutzwald_bauanl,
	schutzwald_gewaesser,
	schutzwald_rodung_temp,
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
	schutzwald_bio_rodung_temp
)
	SELECT
		egrid,
		
		-- Wirtschaftswald --
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Wald_bestockt'),0) AS wirtschaftswald_wald_bestockt,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Nachteilige_Nutzung'),0) AS wirtschaftswald_nt_nutzung,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Waldstrasse'),0) AS wirtschaftswald_waldstrasse,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Maschinenweg'),0) AS wirtschaftswald_maschinenweg,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Bauten_Anlagen'),0) AS wirtschaftswald_bauanl,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Gewaesser'),0) AS wirtschaftswald_gewaesser,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Rodung_temporaer'),0) AS wirtschaftswald_rodung_temp,
		
		-- Erholungswald --
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Wald_bestockt'),0) AS erholungswald_wald_bestockt,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Nachteilige_Nutzung'),0) AS erholungswald_nt_nutzung,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Waldstrasse'),0) AS erholungswald_waldstrasse,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Maschinenweg'),0) AS erholungswald_maschinenweg,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Bauten_Anlagen'),0) AS erholungswald_bauanl,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Gewaesser'),0) AS erholungswald_gewaesser,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Rodung_temporaer'),0) AS erholungswald_rodung_temp,
		
		-- Schutzwald --
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Wald_bestockt'),0) AS schutzwald_wald_bestockt,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Nachteilige_Nutzung'),0) AS schutzwald_nt_nutzung,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Waldstrasse'),0) AS schutzwald_waldstrasse,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Maschinenweg'),0) AS schutzwaldmaschinenweg,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Bauten_Anlagen'),0) AS schutzwald_bauanl,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Gewaesser'),0) AS schutzwald_gewaesser,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Rodung_temporaer'),0) AS schutzwald_rodung_temp,
		
		-- Biodiversität --
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Wald_bestockt'),0) AS biodiversitaet_wald_bestockt,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Nachteilige_Nutzung'),0) AS biodiversitaet_nt_nutzung,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Waldstrasse'),0) AS biodiversitaet_waldstrasse,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Maschinenweg'),0) AS biodiversitaet_maschinenweg,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Bauten_Anlagen'),0) AS biodiversitaet_bauanl,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Gewaesser'),0) AS biodiversitaet_gewaesser,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Rodung_temporaer'),0) AS biodiversitaet_rodung_temp,
		
		-- Schutzwald / Biodiversität --
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Wald_bestockt'),0) AS schutzwald_bio_wald_bestockt,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Nachteilige_Nutzung'),0) AS schutzwald_bio_nt_nutzung,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Waldstrasse'),0) AS schutzwald_bio_waldstrasse,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Maschinenweg'),0) AS schutzwald_bio_maschinenweg,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Bauten_Anlagen'),0) AS schutzwald_bio_bauanl,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Gewaesser'),0) AS schutzwald_bio_gewaesser,
		COALESCE(SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Rodung_temporaer'),0) AS schutzwald_bio_rodung_temp
	FROM 
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
	GROUP BY 
		egrid
;

-- =========================================================
-- 9) Wytweidefläche pro Grundstück
-- =========================================================
INSERT INTO wytweide_grundstueck (
	egrid,
	flaeche
)
	SELECT 
		egrid,
		SUM(flaeche) FILTER(WHERE wytweide IS TRUE) AS wytweide_flaeche
	FROM 
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
	GROUP BY 
		egrid