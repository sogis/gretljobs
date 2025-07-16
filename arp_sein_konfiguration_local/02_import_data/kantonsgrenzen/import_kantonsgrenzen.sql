DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Kantonsgrenzen'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Kantonsgrenzen' AS thema_sql,
	'Kantonsgrenze Solothurn' AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.agi.kantonsgrenzen' AS link,
	geometrie
FROM
	pubdb.agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze 