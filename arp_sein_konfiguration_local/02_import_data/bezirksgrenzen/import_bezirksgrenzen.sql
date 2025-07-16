DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Bezirksgrenzen'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Bezirksgrenzen' AS thema_sql,
	'Bezirksgrenze ' || bezirksname AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.agi.bezirksgrenzen' AS link,
	geometrie
FROM
	pubdb.agi_hoheitsgrenzen_pub.hoheitsgrenzen_bezirksgrenze 