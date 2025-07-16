DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Durchgangsstrassen'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Durchgangsstrassen' AS thema_sql,
	achsenname AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.durchgangsstrassen' AS link,
	geometrie
FROM
	pubdb.afu_stoerfallverordnung_pub_v1.durchgangsstrasse