DROP TABLE IF EXISTS kontokorrent_structure;

--- Create Table for intersecting objects --- 
CREATE TABLE kontokorrent_structure (
	AuftrArt VARCHAR,
	VerkOrg VARCHAR,
	VertrWeg VARCHAR,
	Sparte VARCHAR,
	Verkaufsbüro VARCHAR,
	KundenNr INTEGER,
	"Bestellnummer des Kunden" VARCHAR,
	BestellDatum VARCHAR,
	Wunschlieferdatum VARCHAR,
	Preisdatum VARCHAR,
	"MaterialNr." VARCHAR,
	Materialtext VARCHAR,
	"Betrag 2Komma" DOUBLE,
	"Menge Ganzahlg" INTEGER,
	Auftragsnummer VARCHAR,
	Profitcenter VARCHAR,
	"MaterialVerkaufstext Zeile 1 Position" VARCHAR,
	"MaterialVerkaufstext Zeile 2 Position" VARCHAR,
	"MaterialVerkaufstext Zeile 3 Position" VARCHAR,
	"MaterialVerkaufstext Zeile 4 Position" VARCHAR,
	"MaterialVerkaufstext Zeile 5 Position" VARCHAR,
	"PositionsNotiz Zeile 1" VARCHAR,
	"PositionsNotiz Zeile 2" VARCHAR,
	"PositionsNotiz Zeile 3" VARCHAR,
	"PositionsNotiz Zeile 4" VARCHAR,
	"PositionsNotiz Zeile 5" VARCHAR,
	"Email Kunde" VARCHAR,
	"Name1 Debitor(Info)" VARCHAR,
	"Name2 Debitor(Info)" VARCHAR,
	"Strasse Debitor(Info)" VARCHAR,
	"PostLz(Info)" VARCHAR,
	"Ortschaft(Info)" VARCHAR
)
;