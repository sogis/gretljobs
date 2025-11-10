DROP TABLE IF EXISTS abgleich_mfk;

--- Create Table for intersecting objects --- 
CREATE TABLE abgleich_mfk (
	Bootsanbindeplatz_ID INTEGER,
	Bootskennzeichen INTEGER,
	Personendaten_gleich BOOLEAN,
	Kein_Match_MFK BOOLEAN,
	Vorname_gleich BOOLEAN,
	Nachname_gleich BOOLEAN,
	Adresse_gleich BOOLEAN,
	PLZ_gleich BOOLEAN,
	Bootslaenge_gleich BOOLEAN
)
;