DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Archäologische Fundstellen im Siedlungsgebiet'
;

WITH

fundstellen AS (
	SELECT DISTINCT
		'Archäologische Fundstellen im Siedlungsgebiet' AS thema_sql,
		'Nr. ' || fundstellen_nummer || ' ' || fundstellen_art  AS information,
		'https://geo.so.ch/map/?t=default&l=ch.so.ada.schanzenplaene%5B25%5D%21%2Cch.so.ada.archaeologie.schutzbereich_innenstadt%5B60%5D%2Cch.so.ada.archaeologie.fundstellen_siedlungsgebiet&bl=hintergrundkarte_sw&c=' || 
    	ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(punkt)))) || '%2C' || 
    	ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(punkt)))) || '&s=10000' AS link,
		punkt AS geometrie
	FROM
		pubdb.ada_archaeologie_pub_v1.public_punktfundstelle_siedlungsgebiet
	UNION ALL
	SELECT DISTINCT
		'Archäologische Fundstellen im Siedlungsgebiet' AS thema_sql,
		'Nr. ' || fundstellen_nummer || ' ' || fundstellen_art  AS information,
		'https://geo.so.ch/map/?t=default&l=ch.so.ada.schanzenplaene%5B25%5D%21%2Cch.so.ada.archaeologie.schutzbereich_innenstadt%5B60%5D%2Cch.so.ada.archaeologie.fundstellen_siedlungsgebiet&bl=hintergrundkarte_sw&c=' || 
    	ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(amultipolygon)))) || '%2C' || 
    	ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(amultipolygon)))) || '&s=10000' AS link,
		amultipolygon AS geometrie
	FROM
		pubdb.ada_archaeologie_pub_v1.public_flaechenfundstelle_siedlungsgebiet
)

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT
	thema_sql,
	information,
	link,
	geometrie
FROM
	fundstellen