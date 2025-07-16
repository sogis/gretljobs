DROP TABLE IF EXISTS sein_sammeltabelle;

--- Create Table for intersecting objects --- 
CREATE TABLE sein_sammeltabelle (
	gemeindename VARCHAR,
	bfsnr INTEGER,
	thema_sql VARCHAR,
	thema VARCHAR,
	gruppe VARCHAR,
	information VARCHAR,
	link VARCHAR,
	geometrie GEOMETRY
)
;