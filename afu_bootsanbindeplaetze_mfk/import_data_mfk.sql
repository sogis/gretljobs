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
		ST_READ(${mfkPath})
;