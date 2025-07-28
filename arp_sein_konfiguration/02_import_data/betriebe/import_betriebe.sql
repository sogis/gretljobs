DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Betriebe'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Betriebe' AS thema_sql,
	betriebsname AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.betriebe&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '&s=2000' AS link,
	geometrie
FROM
	pubdb.afu_stoerfallverordnung_pub_v1.betrieb