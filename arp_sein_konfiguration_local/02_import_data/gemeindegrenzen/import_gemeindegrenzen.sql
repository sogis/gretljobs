DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Gemeindegrenzen'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Gemeindegrenzen' AS thema_sql,
	'Gemeinde ' || gemeindename AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.agi.gemeindegrenzen&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_PointOnSurface(ST_GeomFromWKB(geometrie)))) || '%2C' || 
    ROUND(ST_Y(ST_PointOnSurface(ST_GeomFromWKB(geometrie)))) || '&s=50000' AS link,
	geometrie
FROM
	pubdb.agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze