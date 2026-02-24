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

INSERT INTO waldflaeche_produktiv
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

INSERT INTO waldfunktion_hiebsatzrelevant
	SELECT
		wfnp.egrid,
		wald.flaeche AS waldflaeche,
		
		-- Waldfläche total --
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			),0) AS waldflaeche_hiebrel,
			
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NOT NULL
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel'))
			),0) AS waldflaeche_n_hiebrel,
			
		-- Wirtschaftswald --
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Wirtschaftswald'
			AND
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			),0) AS wirtschaftswald_hiebrel,

		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Wirtschaftswald'
			AND (
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			),0) AS wirtschaftswald_n_hiebrel,
						
		-- Erholungswald --
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Erholungswald'
			AND
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			),0) AS erholungswald_hiebrel,

		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Erholungswald'
			AND (
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			),0) AS erholungswald_n_hiebrel,
						
		-- Biodiversität --
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Biodiversitaet'
			AND
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			),0) AS biodiversitaet_hiebrel,

		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Biodiversitaet'
			AND (
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			),0) AS biodiversitaet_n_hiebrel,
						
		-- Schutzwald --
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Schutzwald'
			AND
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			),0) AS schutzwald_hiebrel,

		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Schutzwald'
			AND (
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			),0) AS schutzwald_n_hiebrel,
						
		-- Schutzwald / Biodiversität --
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Schutzwald_Biodiversitaet'
			AND
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			),0) AS schutzwald_bio_hiebrel,

		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Schutzwald_Biodiversitaet'
			AND (
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			),0) AS schutzwald_bio_n_hiebrel
	FROM 
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert AS wfnp
	LEFT JOIN waldflaeche_berechnet_plausibilisiert AS wald
		ON wfnp.egrid = wald.egrid
	GROUP BY 
		wfnp.egrid,
		wald.flaeche
;

INSERT INTO waldnutzung_hiebsatzrelevant
	SELECT
		wfnp.egrid,
		wald.flaeche AS waldflaeche,
		
		-- Waldfläche total --
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			),0) AS waldflaeche_hiebrel,
			
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			OR 
				biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
			),0) AS waldflaeche_n_hiebrel,
			
		-- Wald bestockt --
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE 
				wfnp.nutzungskategorie = 'Wald_bestockt'
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			),0) AS wald_bestockt_hiebrel,

		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie = 'Wald_bestockt'
			AND
				biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
			),0) AS wald_bestockt_n_hiebrel,
			
					-- Nachteilige Nutzung --
		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie = 'Nachteilige_Nutzung'
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			),0) AS nachteilige_nutzung_hiebrel,

		COALESCE(SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie = 'Nachteilige_Nutzung'
			AND
				biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
			),0) AS nachteilige_nutzung_n_hiebrel
	FROM 
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert AS wfnp
	LEFT JOIN waldflaeche_berechnet_plausibilisiert AS wald
		ON wfnp.egrid = wald.egrid
	GROUP BY 
		wfnp.egrid,
		wald.flaeche
;

INSERT INTO waldfunktion_nach_waldnutzung
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

INSERT INTO wytweide_grundstueck
	SELECT 
		egrid,
		SUM(flaeche) FILTER(WHERE wytweide IS TRUE) AS wytweide_flaeche
	FROM 
		waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert
	GROUP BY 
		egrid