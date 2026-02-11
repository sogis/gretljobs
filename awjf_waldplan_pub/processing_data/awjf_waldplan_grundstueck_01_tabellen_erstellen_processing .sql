DELETE FROM awjf_waldplan_pub_v2.waldplan_waldplan_grundstueck;

DROP TABLE IF EXISTS 
	grundstuecke,
	waldfunktion,
	waldnutzung,
	waldflaeche_grundstueck,
	waldflaeche_grundstueck_bereinigt,
	waldflaeche_grundstueck_final,
	wirtschaftswald_waldnutzung_flaechen,
	schutzwald_waldnutzung_flaechen,
	erholungswald_waldnutzung_flaechen,
	biodiversitaet_waldnutzung_flaechen,
	schutzwald_biodiversitaet_waldnutzung_flaechen,
	waldflaechen_berechnet,
	waldflaechen_berechnet_plausibilisiert,
	wytweideflaechen_berechnet,
	waldfunktion_flaechen_berechnet,
	waldfunktion_flaechen_summen,
	waldfunktion_flaechen_berechnet_plausibilisiert,
	waldfunktion_funktion_flaechen_berechnet,
	waldnutzung_flaechen_berechnet,
	waldnutzung_flaechen_summen,
	waldnutzung_flaechen_berechnet_plausibilisiert,
	biodiversitaet_objekt_flaechen_berechnet,
	wirtschaftswald_waldnutzung_flaechen_berechnet,
	schutzwald_waldnutzung_flaechen_berechnet,
	erholungswald_waldnutzung_flaechen_berechnet,
	biodiversitaet_waldnutzung_flaechen_berechnet,
	schutzwald_biodiversitaet_waldnutzung_flaechen_berechnet,
	
CASCADE
;

-- =========================================================
-- 1) Erstellung Grundtabellen
-- =========================================================

-- Grundstücke / Liegenschaften --
CREATE TABLE 
	grundstuecke (
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

-- Waldfunktion --
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

-- Waldnutzung --
CREATE TABLE
	waldnutzung (
		t_datasetname TEXT,
		t_id INTEGER,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

-- Waldfläche pro Grundstück --
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

-- Wirtschaftswaldflächen nach Waldnutzung --
CREATE TABLE
	wirtschaftswald_waldnutzung_flaechen (
		t_datasetname TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

-- Schutzwaldflächen nach Waldnutzung --
CREATE TABLE
	schutzwald_waldnutzung_flaechen (
		t_datasetname TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

-- Erholungswaldflächen nach Waldnutzung --
CREATE TABLE
	erholungswald_waldnutzung_flaechen (
		t_datasetname TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

-- Biodiversitätsflächen nach Waldnutzung --
CREATE TABLE
	biodiversitaet_waldnutzung_flaechen (
		t_datasetname TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

-- Schutzwald-Biodiversitätsflächen nach Waldnutzung --
CREATE TABLE
	schutzwald_biodiversitaet_waldnutzung_flaechen (
		t_datasetname TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);


-- =========================================================
-- 2) Erstellung Flächenberechnungstabellen
-- =========================================================
CREATE TABLE
	waldflaechen_berechnet (
		egrid TEXT,
		flaechenmass_grundstueck INTEGER,
		waldflaeche INTEGER,
		flaeche_differenz INTEGER
);

CREATE TABLE
	waldflaechen_berechnet_plausibilisiert (
		egrid TEXT,
		flaeche INTEGER,
		angepasst BOOLEAN
);

CREATE TABLE
	waldfunktion_flaechen_berechnet (
		egrid TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		biodiversitaet_id TEXT,
		biodiversitaet_objekt TEXT,
		biodiversitaet_objekt_txt TEXT,
		wytweide BOOLEAN,
		wytweide_txt TEXT,
		flaeche INTEGER
);

-- Für den Vergleich der Waldfunktionsflächen mit dem Flächenmass des Grundstücks --
CREATE TABLE
	waldfunktion_flaechen_summen (
		egrid TEXT,
		flaechenmass_grundstueck INTEGER,
		flaeche_waldfunktion_summe INTEGER,
		flaeche_differenz INTEGER
);

-- Angpeasste Flächenwerte für die Waldfunktion, sofern Differenzen auftauchen (siehe waldfunktion_flaechen_summen) --
CREATE TABLE
	waldfunktion_flaechen_berechnet_plausibilisiert (
		egrid TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		biodiversitaet_id TEXT,
		biodiversitaet_objekt TEXT,
		biodiversitaet_objekt_txt TEXT,
		wytweide BOOLEAN,
		wytweide_txt TEXT,
		flaeche INTEGER,
		angepasst BOOLEAN
);

-- Für die Aggregation nach Funktion --
CREATE TABLE
	waldfunktion_funktion_flaechen_berechnet (
		egrid TEXT,
		funktion TEXT,
		funktion_txt TEXT,
		flaeche INTEGER
);

-- Für die Aggregation nach Nutzungskategorie --
CREATE TABLE
	waldnutzung_flaechen_berechnet (
		egrid TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		flaeche INTEGER
);

CREATE TABLE
	waldnutzung_flaechen_summen (
		egrid TEXT,
		flaechenmass_grundstueck INTEGER,
		flaeche_waldnutzung_summe INTEGER,
		flaeche_differenz INTEGER
);

CREATE TABLE
	waldnutzung_flaechen_berechnet_plausibilisiert (
		egrid TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		flaeche INTEGER,
		angepasst BOOLEAN
);

-- Für die Aggregation nach Wytweide --
CREATE TABLE
	wytweideflaechen_berechnet (
		egrid TEXT,
		flaeche INTEGER
);

-- Für die Aggregation nach Biodiversität und Biodiversitätsobjekt --
CREATE TABLE
	biodiversitaet_objekt_flaechen_berechnet (
		egrid TEXT,
		biodiversitaet_objekt_txt TEXT,
		flaeche INTEGER
);

-- Wirtschaftswaldflächen nach Waldnutzung pro Grundstück --
CREATE TABLE
	wirtschaftswald_waldnutzung_flaechen_berechnet (
		egrid TEXT,
		t_datasetname TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT
);

-- Schutzwaldflächen nach Waldnutzung pro Grundstück--
CREATE TABLE
	schutzwald_waldnutzung_flaechen_berechnet (
		t_datasetname TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

-- Erholungswaldflächen nach Waldnutzung pro Grundstück--
CREATE TABLE
	erholungswald_waldnutzung_flaechen_berechnet (
		t_datasetname TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

-- Biodiversitätsflächen nach Waldnutzung pro Grundstück--
CREATE TABLE
	biodiversitaet_waldnutzung_flaechen_berechnet (
		t_datasetname TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);

-- Schutzwald-Biodiversitätsflächen nach Waldnutzung --
CREATE TABLE
	schutzwald_biodiversitaet_waldnutzung_flaechen_berechnet (
		t_datasetname TEXT,
		nutzungskategorie TEXT,
		nutzungskategorie_txt TEXT,
		geometrie GEOMETRY
);
