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

INSERT INTO waldflaeche_produktiv
	SELECT
		wfnp.egrid,
		wald.flaeche AS waldflaeche,
		-- Waldfläche total --
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
;

INSERT INTO waldfunktion_hiebsatzrelevant
	SELECT
		wfnp.egrid,
		wald.flaeche AS waldflaeche,
		
		-- Waldfläche total --
		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			) AS waldflaeche_hiebrel,
			
		wald.flaeche - SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			) AS waldflaeche_n_hiebrel,
			
		-- Wirtschaftswald --
		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Wirtschaftswald'
			AND
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			) AS wirtschaftswald_hiebrel,

		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Wirtschaftswald'
			AND (
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			) AS wirtschaftswald_n_hiebrel,
						
		-- Erholungswald --
		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Erholungswald'
			AND
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			) AS erholungswald_hiebrel,

		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Erholungswald'
			AND (
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			) AS erholungswald_n_hiebrel,
						
		-- Biodiversität --
		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Biodiversitaet'
			AND
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			) AS biodiversitaet_hiebrel,

		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Biodiversitaet'
			AND (
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			) AS biodiversitaet_n_hiebrel,
						
		-- Schutzwald --
		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Schutzwald'
			AND
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			) AS schutzwald_hiebrel,

		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Schutzwald'
			AND (
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			) AS schutzwald_n_hiebrel,
						
		-- Schutzwald / Biodiversität --
		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Schutzwald_Biodiversitaet'
			AND
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			) AS schutzwald_bio_hiebrel,

		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.funktion = 'Schutzwald_Biodiversitaet'
			AND (
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
				OR biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
				)
			) AS schutzwald_bio_n_hiebrel
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
		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			) AS waldflaeche_hiebrel,
			
		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie NOT IN ('Wald_bestockt', 'Nachteilige_Nutzung')
			OR 
				biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
			) AS waldflaeche_n_hiebrel,
			
		-- Wald bestockt --
		SUM(wfnp.flaeche) FILTER (
			WHERE 
				wfnp.nutzungskategorie = 'Wald_bestockt'
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			) AS wald_bestockt_hiebrel,

			SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie = 'Wald_bestockt'
			AND
				biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
			) AS wald_bestockt_n_hiebrel,
			
					-- Nachteilige Nutzung --
		SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie = 'Nachteilige_Nutzung'
			AND (
				biodiversitaet_objekt IS NULL
				OR biodiversitaet_objekt NOT IN ('Waldreservat', 'Altholzinsel'))
			) AS nachteilige_nutzung_hiebrel,

			SUM(wfnp.flaeche) FILTER (
			WHERE
				wfnp.nutzungskategorie = 'Nachteilige_Nutzung'
			AND
				biodiversitaet_objekt IN ('Waldreservat', 'Altholzinsel')
			) AS nachteilige_nutzung_n_hiebrel
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
		SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Wald_bestockt') AS wirtschaftswald_wald_bestockt,
		SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Nachteilige_Nutzung') AS wirtschaftswald_nt_nutzung,
		SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Waldstrasse') AS wirtschaftswald_waldstrasse,
		SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Maschinenweg') AS wirtschaftswald_maschinenweg,
		SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Bauten_Anlagen') AS wirtschaftswald_bauanl,
		SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Gewaesser') AS wirtschaftswald_gewaesser,
		SUM(flaeche) FILTER(WHERE funktion = 'Wirtschaftswald' AND nutzungskategorie = 'Rodung_temporaer') AS wirtschaftswald_rodung_temp,
		
		-- Erholungswald --
		SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Wald_bestockt') AS erholungswald_wald_bestockt,
		SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Nachteilige_Nutzung') AS erholungswald_nt_nutzung,
		SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Waldstrasse') AS erholungswald_waldstrasse,
		SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Maschinenweg') AS erholungswald_maschinenweg,
		SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Bauten_Anlagen') AS erholungswald_bauanl,
		SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Gewaesser') AS erholungswald_gewaesser,
		SUM(flaeche) FILTER(WHERE funktion = 'Erholungswald' AND nutzungskategorie = 'Rodung_temporaer') AS erholungswald_rodung_temp,
		
		-- Schutzwald --
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Wald_bestockt') AS schutzwald_wald_bestockt,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Nachteilige_Nutzung') AS schutzwald_nt_nutzung,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Waldstrasse') AS schutzwald_waldstrasse,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Maschinenweg') AS schutzwaldmaschinenweg,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Bauten_Anlagen') AS schutzwald_bauanl,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Gewaesser') AS schutzwald_gewaesser,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald' AND nutzungskategorie = 'Rodung_temporaer') AS schutzwald_rodung_temp,
		
		-- Biodiversität --
		SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Wald_bestockt') AS biodiversitaet_wald_bestockt,
		SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Nachteilige_Nutzung') AS biodiversitaet_nt_nutzung,
		SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Waldstrasse') AS biodiversitaet_waldstrasse,
		SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Maschinenweg') AS biodiversitaet_maschinenweg,
		SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Bauten_Anlagen') AS biodiversitaet_bauanl,
		SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Gewaesser') AS biodiversitaet_gewaesser,
		SUM(flaeche) FILTER(WHERE funktion = 'Biodiversitaet' AND nutzungskategorie = 'Rodung_temporaer') AS biodiversitaet_rodung_temp,
		
		-- Schutzwald / Biodiversität --
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Wald_bestockt') AS schutzwald_bio_wald_bestockt,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Nachteilige_Nutzung') AS schutzwald_bio_nt_nutzung,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Waldstrasse') AS schutzwald_bio_waldstrasse,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Maschinenweg') AS schutzwald_bio_maschinenweg,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Bauten_Anlagen') AS schutzwald_bio_bauanl,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Gewaesser') AS schutzwald_bio_gewaesser,
		SUM(flaeche) FILTER(WHERE funktion = 'Schutzwald_Biodiversitaet' AND nutzungskategorie = 'Rodung_temporaer') AS schutzwald_bio_rodung_temp
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