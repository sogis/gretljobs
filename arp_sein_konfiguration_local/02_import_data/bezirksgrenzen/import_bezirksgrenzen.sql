DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Bezirksgrenzen'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Bezirksgrenzen' AS thema_sql,
	'Bezirk ' || bezirksname AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.agi.bezirksgrenzen&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_PointOnSurface(ST_GeomFromWKB(geometrie)))) || '%2C' || 
    ROUND(ST_Y(ST_PointOnSurface(ST_GeomFromWKB(geometrie)))) || '&s=60000' AS link,
	geometrie
FROM
	pubdb.agi_hoheitsgrenzen_pub.hoheitsgrenzen_bezirksgrenze