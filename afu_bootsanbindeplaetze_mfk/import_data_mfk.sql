DROP TABLE IF EXISTS data_mfk;

--- Create Table for intersecting objects --- 
CREATE TABLE data_mfk AS
	SELECT
		*
	FROM 
		ST_READ(${mfkPath})
;

INSERT INTO data_mfk
	SELECT
		Stammnummer AS VARCHAR,
		TRY_CAST(Schild AS INTEGER),
		Schilderart AS VARCHAR,
		Standort AS VARCHAR,
		Schiffstyp AS VARCHAR,
		Motorisierung AS VARCHAR,
		TRY_CAST("Anzahl eingelöster Motoren" AS INTEGER),
		TRY_CAST("Motorenstärke Hauptantrieb [kw]" AS DOUBLE),
		TRY_CAST("Länge [cm]" AS INTEGER),
		TRY_CAST("Breite [cm]" AS INTEGER),
		"Name" AS VARCHAR,
		Vorname AS VARCHAR,
		Adresse AS VARCHAR,
		TRY_CAST(PLZ AS INTEGER),
		Ort AS VARCHAR,
		Land AS VARCHAR
	FROM
		ST_READ(${mfkPath})
;