DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Konsultationsbereich Erdgasröhrenspeicher'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Konsultationsbereich Erdgasröhrenspeicher' AS thema_sql,
	typ AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.konsultationsbereich_erdgasroehrenspeicher%5B50%5D' AS link,
	geometrie
FROM
	pubdb.afu_stoerfallverordnung_pub_v1.erdgasroehrenspeicher_kb