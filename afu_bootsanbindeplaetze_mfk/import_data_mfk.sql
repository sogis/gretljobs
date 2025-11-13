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
	"Name" VARCHAR,
	Vorname VARCHAR,
	Adresse VARCHAR,
	PLZ INTEGER,
	Ort VARCHAR,
	Land VARCHAR
)
;

INSERT INTO data_mfk
	SELECT
		CAST(Stammnummer AS VARCHAR),
		TRY_CAST(Schild AS INTEGER),
		CAST(Schilderart AS VARCHAR),
		CAST(Standort AS VARCHAR),
		CAST(Schiffstyp AS VARCHAR),
		CAST(Motorisierung AS VARCHAR),
		TRY_CAST("Anzahl eingelöster Motoren" AS INTEGER),
		TRY_CAST("Motorenstärke Hauptantrieb [kw]" AS DOUBLE),
		TRY_CAST("Länge [cm]" AS INTEGER),
		TRY_CAST("Breite [cm]" AS INTEGER),
		CAST("Name" AS VARCHAR),
		CAST(Vorname AS VARCHAR),
		CAST(Adresse AS VARCHAR),
		TRY_CAST(PLZ AS INTEGER),
		CAST(Ort AS VARCHAR),
		CAST(Land AS VARCHAR)
	FROM
		ST_READ('./upload/uploadFile.xlsx')
;