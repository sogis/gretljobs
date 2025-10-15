DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Erdgasröhrenspeicher'
;

WITH

unified_geometry AS (
    SELECT DISTINCT
        'Erdgasröhrenspeicher' AS thema_sql,
        aname AS information,
        ST_Union_Agg(ST_GeomFromWKB(geometrie)) AS geometrie
    FROM
        pubdb.afu_stoerfallverordnung_pub_v1.erdgasroehrenspeicher
    GROUP BY
        aname
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
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.erdgasroehrenspeicher%5B40%5D&bl=hintergrundkarte_sw&c=' || 
    ST_X(ST_Centroid(geometrie)) || '%2C' ||
    ST_Y(ST_Centroid(geometrie)) || '&s=10000' AS link,
    geometrie
FROM
    unified_geometry