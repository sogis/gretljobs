DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Perimeter 5. Generation'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Perimeter 5. Generation' AS thema_sql,
	aggloprogramm || ' (Nr. ' || agglomerationsprogramm_nummer || ')' AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.arp.agglomerationsprogramme.uebersicht&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '&s=20000' AS link,
	geometrie
FROM
	pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_uebersicht_gemeinde