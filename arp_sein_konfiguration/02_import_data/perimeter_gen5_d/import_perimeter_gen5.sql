DELETE FROM
	sein_sammeltabelle_filtered
WHERE
	thema_sql = 'Perimeter 5. Generation'
;

INSERT INTO sein_sammeltabelle_filtered (
	gemeindename,
	bfsnr,
	thema_sql,
	information,
	link
)

SELECT DISTINCT
	gemeinde AS gemeindename,
	bfs_nr AS bfsnr,
	'Perimeter 5. Generation' AS thema_sql,
	aggloprogramm || ' (Nr. ' || agglomerationsprogramm_nummer || ')' AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.arp.agglomerationsprogramme.uebersicht&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '&s=20000' AS link
FROM
	pubdb.arp_agglomerationsprogramme_pub.agglomrtnsprgrmme_uebersicht_gemeinde
WHERE 
	kanton = 'SO'