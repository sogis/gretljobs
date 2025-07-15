DROP TABLE IF EXISTS objektinfos_sein_sammeltabelle;

--- Create Table for intersecting objects --- 
CREATE TABLE objektinfos_sein_sammeltabelle (
	gemeindename VARCHAR,
	bfsnr INTEGER,
	thema_sql VARCHAR,
	thema VARCHAR,
	gruppe VARCHAR,
	information VARCHAR,
	link VARCHAR
)
;