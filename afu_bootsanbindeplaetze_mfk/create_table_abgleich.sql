DROP TABLE IF EXISTS abgleich_mfk;

--- Create Table for intersecting objects --- 
CREATE TABLE abgleich_mfk (
	Bootsanbindeplatz_ID INTEGER,
	Bootskennzeichen INTEGER,
	Daten_gleich BOOLEAN,
	nur_Vorname BOOLEAN,
	nur_Nachname BOOLEAN,
	nur_Name_ganz BOOLEAN,
	Bootslaenge BOOLEAN,
	keine_Daten_MFK BOOLEAN,
	Geometrie GEOMETRY
)
;