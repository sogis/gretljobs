DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Gemeindegrenzen'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Gemeindegrenzen' AS thema_sql,
	'Gemeindegrenze ' || gemeindename AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.agi.gemeindegrenzen' AS link,
	geometrie
FROM
	pubdb.agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze