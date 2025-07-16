DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Kataster der belasteten Standorte (KBS)'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Kataster der belasteten Standorte (KBS)' AS thema_sql,
	'Nr. ' || standortnummer || ' / ' || standorttyp AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.altlasten.standorte' AS link,
	geometrie
FROM
	pubdb.afu_altlasten_pub_v2.belasteter_standort 