DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Archäologische Fundstellen Punktfundstelle'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Archäologische Fundstellen Punktfundstelle' AS thema_sql,
	'Nr. ' || fundstellen_nummer || ' ' || fundstellen_art  AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.ada.archaeologie.punktfundstellen_geschuetzt%2Cch.so.ada.archaeologie.punktfundstellen_nr_geschuetzt&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(punkt)))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(punkt)))) || '&s=10000' AS link,
	punkt AS geometrie
FROM
	pubdb.ada_archaeologie_pub_v1.restricted_punktfundstelle