DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Konsultastionsbereich Durchgangsstrasse'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Konsultastionsbereich Durchgangsstrasse' AS thema_sql,
	typ AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.konsultationsbereich_durchgangsstrassen' AS link,
	geometrie
FROM
	pubdb.afu_stoerfallverordnung_pub_v1.durchgangsstrasse_kb