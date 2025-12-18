DROP TABLE IF EXISTS 
	calculated_values,
	differences
CASCADE
;

-------------------------------------------------------------------------
------------------- Erstellung Berechnungstabellen ----------------------
-------------------------------------------------------------------------

CREATE TABLE 
	calculated_values (
		egrid TEXT,
		grundstueck INTEGER,
		wald INTEGER,
		waldfunktion_biodiversitaet INTEGER,
		waldfunktion_wirtschaftswald INTEGER,
		waldfunktion_erholungswald INTEGER,
		waldfunktion_schutzwald INTEGER,
		waldfunktion_schutzwald_biodiversitaet INTEGER,
		waldnutzung INTEGER,
		wytweide INTEGER,
		biodiveritaet INTEGER,
		produktiv INTEGER,
		unproduktiv INTEGER,
		hiebsatzrelevant INTEGER,
		hiebsatzirrelevant INTEGER
);

CREATE TABLE 
	differences (
		egrid TEXT
		grundstueck_wald INTEGER,
		wald_waldfunktion INTEGER,
		wald_waldnutzung INTEGER,
		wald_produktiv INTEGER,
		wald_unproduktiv INTEGER,
		wald_hiebsatzrelevant INTEGER,
		wald_hiebsatzirrelevant INTEGER
);

-------------------------------------------------------------------------
-------------------- Befüllung Berechnungstabellen ----------------------
-------------------------------------------------------------------------

SELECT 
	egrid,
	flaechenmass AS grundstueck,
	waldflaeche AS wald,
	-- Waldfunktionsflaechen extrahieren --
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldfunktion_flaechen::jsonb) AS f 
	WHERE
		f->>'Funktion' = 'Biodiversität')::numeric AS waldfunktion_biodiversitaet,
		
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldfunktion_flaechen::jsonb) AS f 
	WHERE
		f->>'Funktion' = 'Wirtschaftswald')::numeric AS waldfunktion_wirtschaftswald,
	
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldfunktion_flaechen::jsonb) AS f 
	WHERE
		f->>'Funktion' = 'Erholungswald')::numeric AS waldfunktion_erholungswald,
		
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldfunktion_flaechen::jsonb) AS f 
	WHERE
		f->>'Funktion' = 'Schutzwald')::numeric AS waldfunktion_schutzwald,
		
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldfunktion_flaechen::jsonb) AS f 
	WHERE
		f->>'Funktion' = 'Schutzwald / Biodiversität')::numeric AS waldfunktion_schutzwald_biodiversitaet,
		
	-- Waldnutzungsflaechen extrahieren --
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldnutzung_flaechen::jsonb) AS f 
	WHERE
		f->>'Nutzungskategorie' = 'Waldstrasse')::numeric AS waldnutzung_waldstrasse,
		
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldnutzung_flaechen::jsonb) AS f 
	WHERE
		f->>'Nutzungskategorie' = 'Gewässer')::numeric AS waldnutzung_gewaesser,
		
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldnutzung_flaechen::jsonb) AS f 
	WHERE
		f->>'Nutzungskategorie' = 'Bauten und Anlagen')::numeric AS waldnutzung_bauten_anlagen,
		
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldnutzung_flaechen::jsonb) AS f 
	WHERE
		f->>'Nutzungskategorie' = 'Nachteilige Nutzung')::numeric AS waldnutzung_nachteilige_nutzung,
		
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldnutzung_flaechen::jsonb) AS f 
	WHERE
		f->>'Nutzungskategorie' = 'Rodungsflächen (temporär)')::numeric AS waldnutzung_rodungs_temp,
		
	(SELECT f->>'Flaeche'
	FROM
		jsonb_array_elements(waldnutzung_flaechen::jsonb) AS f 
	WHERE
		f->>'Nutzungskategorie' = 'Mit Wald bestockt')::numeric AS waldnutzung_wald_bestockt,

	waldnutzung_flaechen AS waldnutzung,
	wytweide_flaeche AS wytweide,
	biodiversitaetsobjekt_flaeche AS biodiversitaet,
	(produktive_flaeche->0->>'Produktiv')::INTEGER AS produktiv,
	(produktive_flaeche->0->>'Unproduktiv')::INTEGER AS unproduktiv,
	(hiebsatzrelevante_flaeche->0->>'Relevant')::INTEGER AS hiebsatzrelevant,
	(hiebsatzrelevante_flaeche->0->>'Irrelevant')::INTEGER AS hiebsatzrelevant
FROM 
	awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck
;


	