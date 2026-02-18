--DELETE FROM awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck;

-- =========================================================
-- 1) Bestehende Tabellen in Processing-DB löschen
-- =========================================================
DROP TABLE IF EXISTS
	grundstueck,
	waldflaeche_grundstueck,
	waldflaeche_grundstueck_bereinigt,
	waldflaeche_grundstueck_final,
	waldflaeche_berechnet,
	waldflaeche_berechnet_plausibilisiert,
	waldfunktion,
	waldnutzung,
	waldfunktion_waldnutzung,
	waldfunktion_waldnutzung_grundstueck_berechnet
;

-- =========================================================
-- 2) Grundstück
-- =========================================================
CREATE TABLE 
	grundstueck (
		t_basket INTEGER,
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
	waldflaeche_grundstueck (
    	egrid TEXT,
   		geometrie GEOMETRY
);

-- Waldfläche pro Grundstück mit bereinigten Daten --
CREATE TABLE
	waldflaeche_grundstueck_bereinigt (
    	egrid TEXT,
   		geometrie GEOMETRY
);

-- Waldfläche pro Grundstück mit final bereinigten Daten --
CREATE TABLE
	waldflaeche_grundstueck_final (
    	egrid TEXT,
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
		biodiversitaet_objekt TEXT,
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
		biodiversitaet_objekt TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		flaeche INTEGER
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

