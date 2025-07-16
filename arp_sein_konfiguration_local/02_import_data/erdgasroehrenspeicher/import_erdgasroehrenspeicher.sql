DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Erdgasröhrenspeicher'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Erdgasröhrenspeicher' AS thema_sql,
	aname AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.erdgasroehrenspeicher%5B40%5D' AS link,
	geometrie
FROM
	pubdb.afu_stoerfallverordnung_pub_v1.erdgasroehrenspeicher 