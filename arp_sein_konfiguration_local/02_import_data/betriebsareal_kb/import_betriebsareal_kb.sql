DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Konsultationsbereich Betriebsareal'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Konsultationsbereich Betriebsareal' AS thema_sql,
	typ AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.konsultationsbereich_betriebsaeral%5B40%5D' AS link,
	geometrie
FROM
	pubdb.afu_stoerfallverordnung_pub_v1.betrieb_kb
;