-- =========================================================
-- 1) Bestehende Tabellen in Processing-DB löschen
-- =========================================================
DROP TABLE IF EXISTS
	grundstueck,
	waldgeometrie_grundstueck,
	waldgeometrie_grundstueck_bereinigt,
	waldgeometrie_grundstueck_final,
	waldflaeche_berechnet,
	waldflaeche_berechnet_plausibilisiert,
	waldfunktion,
	waldnutzung,
	waldfunktion_waldnutzung,
	waldfunktion_waldnutzung_grundstueck_berechnet,
	waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert,
	waldfunktionsflaechen_grundstueck,
	waldnutzungsflaechen_grundstueck,
	biodiversitaetsobjekte_grundstueck,
	waldflaeche_produktiv,
	waldfunktion_hiebsatzrelevant,
	waldnutzung_hiebsatzrelevant,
	waldfunktion_nach_waldnutzung,
	wytweide_grundstueck
;

-- =========================================================
-- 2) Grundstück
-- =========================================================
CREATE TABLE 
	grundstueck (
		t_basket_waldplan INTEGER,
		t_basket_auswertung INTEGER,
		t_datasetname TEXT,
		egrid TEXT,
		gemeinde TEXT,
		forstbetrieb TEXT,
		forstkreis TEXT,
		forstkreis_txt TEXT,
		forstrevier TEXT,
		wirtschaftszone TEXT,
		wirtschaftszone_txt TEXT,
		grundstuecknummer TEXT,
		flaechenmass INTEGER,
		eigentuemerinformation TEXT,
		eigentuemer TEXT,
		eigentuemer_txt TEXT,
		grundbuch TEXT,
		ausserkantonal BOOLEAN,
		ausserkantonal_txt TEXT,
		geometrie GEOMETRY,
		bemerkung TEXT
);

-- =========================================================
-- 3) Waldflächengeometrie pro Grundstück
-- =========================================================
CREATE TABLE
	waldgeometrie_grundstueck (
    	egrid TEXT,
		flaechenmass INTEGER,
   		geometrie GEOMETRY
);

-- Waldfläche pro Grundstück mit bereinigten Daten --
CREATE TABLE
	waldgeometrie_grundstueck_bereinigt (
    	egrid TEXT,
		flaechenmass INTEGER,
   		geometrie GEOMETRY
);

-- Waldfläche pro Grundstück mit final bereinigten Daten --
CREATE TABLE
	waldgeometrie_grundstueck_final (
    	egrid TEXT,
		flaechenmass INTEGER,
   		geometrie GEOMETRY
);

-- =========================================================
-- 4) Waldflächenberechnung pro Grundstück
-- =========================================================
CREATE TABLE
	waldflaeche_berechnet (
		egrid TEXT,
		flaechenmass_grundstueck INTEGER,
		waldflaeche INTEGER,
		flaeche_differenz INTEGER
);

CREATE TABLE
	waldflaeche_berechnet_plausibilisiert (
		egrid TEXT,
		flaechenmass_grundstueck INTEGER,
		flaeche INTEGER,
		angepasst BOOLEAN
);

-- =========================================================
-- 5) Waldfunktions- und Waldnutzungsgeometrie
-- =========================================================
-- Waldfunktion Geometrie --
CREATE TABLE
	waldfunktion (
		t_datasetname TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		biodiversitaet_id TEXT,
		biodiversitaet_objekt TEXT,
		biodiversitaet_objekt_txt TEXT,
		wytweide BOOLEAN,
		wytweide_txt TEXT,
		geometrie GEOMETRY,
		bemerkung TEXT
);

-- Waldnutzung Geometrie --
CREATE TABLE
	waldnutzung (
		t_datasetname TEXT,
		t_id INTEGER,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

-- Verschnitt von Waldfunktion und Waldnutzung (Geometrie)--
CREATE TABLE
	waldfunktion_waldnutzung (
		t_datasetname TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		biodiversitaet_objekt TEXT,
		biodiversitaet_objekt_txt TEXT,
		wytweide BOOLEAN,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

-- Flächenwerte der verschnittenen Waldfunktions und Waldnutzungsflächen nach Grundstück --
CREATE TABLE
	waldfunktion_waldnutzung_grundstueck_berechnet (
		egrid TEXT,
		t_datasetname TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		biodiversitaet_objekt TEXT,
		biodiversitaet_objekt_txt TEXT,
		wytweide BOOLEAN,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		flaeche INTEGER
);

-- Plausibilisierte Flächenwerte der verschnittenen Waldfunktions und Waldnutzungsflächen nach Grundstück --
CREATE TABLE
	waldfunktion_waldnutzung_grundstueck_berechnet_plausibilisiert (
		egrid TEXT,
		t_datasetname TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		biodiversitaet_objekt TEXT,
		biodiversitaet_objekt_txt TEXT,
		wytweide BOOLEAN,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		flaeche INTEGER,
		angepasst BOOLEAN
);

-- =========================================================
-- 6) Detaillierte Flächenberechnungen
-- =========================================================
CREATE TABLE 
	waldfunktionsflaechen_grundstueck (
		egrid TEXT,
		wirtschaftswald INTEGER,
		schutzwald INTEGER,
    	erholungswald INTEGER,
    	biodiversitaet INTEGER,
    	schutzwald_biodiversitaet INTEGER,
		waldfunktion_total INTEGER
);

CREATE TABLE 
	waldnutzungsflaechen_grundstueck (
		egrid TEXT,
		wald_bestockt INTEGER,
		nachteilige_nutzung INTEGER,
    	waldstrasse INTEGER,
    	maschinenweg INTEGER,
    	bauten_anlagen INTEGER,
		rodung_temporaer INTEGER,
		gewaesser INTEGER,
		waldnutzung_total INTEGER
);

CREATE TABLE
	biodiversitaetsobjekte_grundstueck (
    	egrid TEXT,
    	waldreservat INTEGER,
    	altholzinsel INTEGER,
    	waldrand INTEGER,
    	lichter_wald INTEGER,
    	lebensraum_prioritaer INTEGER,
    	andere_foerderflaeche INTEGER,
		biodiversitaetsobjekte_total INTEGER
);

CREATE TABLE 
	waldflaeche_produktiv (
		egrid TEXT,
		waldflaeche INTEGER,
		waldflaeche_produktiv INTEGER,
		waldflaeche_unproduktiv INTEGER,
		wirtschaftswald_produktiv INTEGER,
		wirtschaftswald_unproduktiv INTEGER,
		schutzwald_produktiv INTEGER,
		schutzwald_unproduktiv INTEGER,
		erholungswald_produktiv INTEGER,
		erholungswald_unproduktiv INTEGER,
		biodiversitaet_produktiv INTEGER,
		biodiversitaet_unproduktiv INTEGER,
		schutzwald_bio_produktiv INTEGER,
		schutzwald_bio_unproduktiv INTEGER
);

CREATE TABLE 
	waldfunktion_hiebsatzrelevant (
		egrid TEXT,
		waldflaeche INTEGER,
		waldflaeche_hiebrel INTEGER,
		waldflaeche_n_hiebrel INTEGER,
		wirtschaftswald_hiebrel INTEGER,
		wirtschaftswald_n_hiebrel INTEGER,
		schutzwald_hiebrel INTEGER,
		schutzwald_n_hiebrel INTEGER,
		erholungswald_hiebrel INTEGER,
		erholungswald_n_hiebrel INTEGER,
		biodiversitaet_hiebrel INTEGER,
		biodiversitaet_n_hiebrel INTEGER,
		schutzwald_bio_hiebrel INTEGER,
		schutzwald_bio_n_hiebrel INTEGER
);

CREATE TABLE 
	waldnutzung_hiebsatzrelevant (
		egrid TEXT,
		waldflaeche INTEGER,
		waldflaeche_hiebrel INTEGER,
		waldflaeche_n_hiebrel INTEGER,
		wald_bestockt_hiebrel INTEGER,
		wald_bestockt_n_hiebrel INTEGER,
		nachteilige_nutzung_hiebrel INTEGER,
		nachteilige_nutzung_n_hiebrel INTEGER
);

CREATE TABLE 
	waldfunktion_nach_waldnutzung (
		egrid TEXT,
		wirtschaftswald_wald_bestockt INTEGER,
		wirtschaftswald_nt_nutzung INTEGER,
		wirtschaftswald_waldstrasse INTEGER,
		wirtschaftswald_maschinenweg INTEGER,
		wirtschaftswald_bauanl INTEGER,
		wirtschaftswald_gewaesser INTEGER,
		wirtschaftswald_rodung_temp INTEGER,
		erholungswald_wald_bestockt INTEGER,
		erholungswald_nt_nutzung INTEGER,
		erholungswald_waldstrasse INTEGER,
		erholungswald_maschinenweg INTEGER,
		erholungswald_bauanl INTEGER,
		erholungswald_gewaesser INTEGER,
		erholungswald_rodung_temp INTEGER,
		schutzwald_wald_bestockt INTEGER,
		schutzwald_nt_nutzung INTEGER,
		schutzwald_waldstrasse INTEGER,
		schutzwald_maschinenweg INTEGER,
		schutzwald_bauanl INTEGER,
		schutzwald_gewaesser INTEGER,
		schutzwald_rodung_temp INTEGER,
		biodiversitaet_wald_bestockt INTEGER,
		biodiversitaet_nt_nutzung INTEGER,
		biodiversitaet_waldstrasse INTEGER,
		biodiversitaet_maschinenweg INTEGER,
		biodiversitaet_bauanl INTEGER,
		biodiversitaet_gewaesser INTEGER,
		biodiversitaet_rodung_temp INTEGER,
		schutzwald_bio_wald_bestockt INTEGER,
		schutzwald_bio_nt_nutzung INTEGER,
		schutzwald_bio_waldstrasse INTEGER,
		schutzwald_bio_maschinenweg INTEGER,
		schutzwald_bio_bauanl INTEGER,
		schutzwald_bio_gewaesser INTEGER,
		schutzwald_bio_rodung_temp INTEGER
);

CREATE TABLE 
	wytweide_grundstueck (
		egrid TEXT,
		flaeche INTEGER
);