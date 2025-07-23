DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Konsultationsbereich Erdgasröhrenspeicher'
;

WITH

einzelpolygone AS (
	SELECT DISTINCT 
		typ,
		UNNEST(ST_Dump(CAST(geometrie AS GEOMETRY))) AS einzelgeom
	FROM
		pubdb.afu_stoerfallverordnung_pub_v1.erdgasroehrenspeicher_kb
)

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Konsultationsbereich Erdgasröhrenspeicher' AS thema_sql,
	typ AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.konsultationsbereich_erdgasroehrenspeicher%5B50%5D&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_Centroid(einzelgeom.geom))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(einzelgeom.geom))) || '&s=10000' AS link,
    einzelgeom.geom AS geometrie
FROM
	einzelpolygone
;