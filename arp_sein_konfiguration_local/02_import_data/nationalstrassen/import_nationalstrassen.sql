DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Nationalstrassen'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Nationalstrassen' AS thema_sql,
	base_id AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.nationalstrassen' AS link,
	geometrie
FROM
	pubdb.afu_stoerfallverordnung_pub_v1.nationalstrasse 