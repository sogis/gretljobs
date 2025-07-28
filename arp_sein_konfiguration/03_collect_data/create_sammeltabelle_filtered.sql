DROP TABLE IF EXISTS sein_sammeltabelle_filtered;

--- Create Table for intersecting objects --- 
CREATE TABLE sein_sammeltabelle_filtered (
	gemeindename VARCHAR,
	bfsnr INTEGER,
	thema_sql VARCHAR,
	thema VARCHAR,
	gruppe VARCHAR,
	information VARCHAR,
	link VARCHAR,
)
;