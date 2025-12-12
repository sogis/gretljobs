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
		CAST(column0 Stammnummer AS VARCHAR),
		TRY_CAST(column1 Schild AS INTEGER),
		CAST(column2 Schilderart AS VARCHAR),
		CAST(column3 Standort AS VARCHAR),
		CAST(column4 Schiffstyp AS VARCHAR),
		CAST(column5 Motorisierung AS VARCHAR),
		TRY_CAST(column6 "Anzahl eingelöster Motoren" AS INTEGER),
		TRY_CAST(column7 "Motorenstärke Hauptantrieb [kw]" AS DOUBLE),
		TRY_CAST(column8 "Länge [cm]" AS INTEGER),
		TRY_CAST(column9 "Breite [cm]" AS INTEGER),
		CAST(column10 "Name" AS VARCHAR),
		CAST(column11 Vorname AS VARCHAR),
		CAST(column12 Adresse AS VARCHAR),
		TRY_CAST(column13 PLZ AS INTEGER),
		CAST(column14 Ort AS VARCHAR),
		CAST(column15 Land AS VARCHAR)
	FROM
		ST_READ(${mfkPath})
;