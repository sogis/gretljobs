DROP TABLE IF EXISTS abgleich_mfk;

--- Create Table for intersecting objects --- 
CREATE TABLE abgleich_mfk (
	Bootsanbindeplatz_ID INTEGER,
	Bootskennzeichen INTEGER,
	Vorname_MFK VARCHAR,
	Nachname_MFK VARCHAR,
	Adresse_MFK VARCHAR,
	PLZ_MFK INTEGER,
	Ort_MFK VARCHAR,
	MFK_Bootslaenge DOUBLE,
	MFK_Bootsbreite DOUBLE,
	MFK_Motorenstaerke_Boot DOUBLE,
	Personendaten_gleich BOOLEAN,
	Kein_Match_MFK BOOLEAN,
	Vorname_gleich BOOLEAN,
	Nachname_gleich BOOLEAN,
	Adresse_gleich BOOLEAN,
	PLZ_gleich BOOLEAN,
	Ort_gleich BOOLEAN,
	Bootslaenge_gleich BOOLEAN
)
;