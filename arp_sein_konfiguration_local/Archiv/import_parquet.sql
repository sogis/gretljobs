--- Insert into Sammeltabelle ---
INSERT INTO sein.main.sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	thema_sql,
	information,
	link,
	geometrie
FROM 
	themeDB.main.sein_sammeltabelle
;