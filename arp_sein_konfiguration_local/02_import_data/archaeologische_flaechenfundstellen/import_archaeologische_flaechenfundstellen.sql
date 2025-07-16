DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Archäologische Fundstellen Flächenfundstelle'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Archäologische Fundstellen Flächenfundstelle' AS thema_sql,
	'Nr. ' || fundstellen_nummer || '; ' || fundstellen_art  AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.ada.archaeologie.flaechenfundstellen_nr_geschuetzt%2Cch.so.ada.archaeologie.flaechenfundstellen_geschuetzt' AS link,
	amultipolygon AS geometrie
FROM
	pubdb.ada_archaeologie_pub_v1.restricted_flaechenfundstelle
;