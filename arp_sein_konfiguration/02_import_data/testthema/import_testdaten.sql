DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Testthema'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Testthema' AS thema_sql,
	'Test: ' || bezirksname AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.agi.bezirksgrenzen' AS link,
	geometrie
FROM
	pubdb.agi_hoheitsgrenzen_pub.hoheitsgrenzen_bezirksgrenze 