DROP TABLE IF EXISTS data_mfk;

--- Create Table for intersecting objects --- 
CREATE TABLE data_mfk (
	Stammnummer VARCHAR,
	Schild INTEGER,
	Schilderart VARCHAR,
	Standort VARCHAR,
	Schiffstyp VARCHAR,
	Motorisierung VARCHAR,
	"Anzahl eingelöster Motoren" INTEGER,
	"Motorenstärke Hauptantrieb [kw]" DOUBLE,
	"Länge [cm]" INTEGER,
	"Breite [cm]" INTEGER,
	Name VARCHAR,
	Vorname VARCHAR,
	Adresse VARCHAR,
	PLZ INTEGER,
	Ort VARCHAR,
	Land VARCHAR
)
;

INSERT INTO data_mfk
	SELECT
		Stammnummer,
		Schild,
		Schilderart,
		Standort,
		Schiffstyp,
		Motorisierung,
		"Anzahl eingelöster Motoren",
		"Motorenstärke Hauptantrieb [kw]",
		"Länge [cm]",
		"Breite [cm]",
		Name,
		Vorname,
		Adresse,
		PLZ,
		Ort,
		Land
	FROM
		ST_READ(${mfkPath}, open_options=['HEADERS=FORCE'])
;