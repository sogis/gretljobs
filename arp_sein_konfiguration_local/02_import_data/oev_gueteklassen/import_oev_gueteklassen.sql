DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'ÖV-Güteklassen'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'ÖV-Güteklassen' AS thema_sql,
	'Güteklasse ' || oev_gueteklasse AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.avt.oev_gueteklasse&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '&s=20000' AS link,
	geometrie
FROM
	pubdb.avt_oev_gueteklassen_pub_v1.oev_gueteklassen