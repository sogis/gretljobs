DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Grundwasserschutz'
;

WITH

schutzzonen AS (
	SELECT 
		'Grundwasserschutz' AS thema_sql,
		'Schutzzone ' || typ AS information,
		'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.grundwasserschutz&bl=hintergrundkarte_sw&c=' || 
    	ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(apolygon)))) || '%2C' || 
    	ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(apolygon)))) || '&s=2000' AS link,
		apolygon AS geometrie
	FROM 
		pubdb.afu_gewaesserschutz_pub_v3.gewaesserschutz_schutzzone_v

),

schutzareale AS (
	SELECT 
		'Grundwasserschutz' AS thema_sql,
		typ AS information,
		'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.grundwasserschutz&bl=hintergrundkarte_sw&c=' || 
    	ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(apolygon)))) || '%2C' || 
    	ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(apolygon)))) || '&s=2000' AS link,
		apolygon AS geometrie
	FROM 
		pubdb.afu_gewaesserschutz_pub_v3.gewaesserschutz_schutzareal_v
),

grundwasserschutz AS (
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		schutzzonen
	UNION ALL
	SELECT
		thema_sql,
		information,
		link,
		geometrie
	FROM
		schutzareale
)

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	thema_sql,
	information,
	link,
	geometrie
FROM
	grundwasserschutz