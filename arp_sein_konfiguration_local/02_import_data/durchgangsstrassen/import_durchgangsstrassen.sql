DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Durchgangsstrassen'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Durchgangsstrassen' AS thema_sql,
	achsenname AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.durchgangsstrassen&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_LineInterpolatePoint(ST_GeomFromWKB(geometrie),0.5))) || '%2C' || 
    ROUND(ST_Y(ST_LineInterpolatePoint(ST_GeomFromWKB(geometrie),0.5))) || '&s=10000' AS link,
	geometrie
FROM
	pubdb.afu_stoerfallverordnung_pub_v1.durchgangsstrasse