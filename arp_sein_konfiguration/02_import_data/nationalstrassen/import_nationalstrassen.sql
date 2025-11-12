DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Nationalstrassen'
;

WITH

unified_geometry AS (
    SELECT DISTINCT
        'Nationalstrassen' AS thema_sql,
        base_id AS information,
        ST_Union_Agg(ST_GeomFromWKB(geometrie)) AS geometrie
    FROM
        pubdb.afu_stoerfallverordnung_pub_v1.nationalstrasse 
    GROUP BY
        base_id
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
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.nationalstrassen&bl=hintergrundkarte_sw&c=' || 
    ST_X(ST_Centroid(geometrie)) || '%2C' ||
    ST_Y(ST_Centroid(geometrie)) || '&s=10000' AS link,
    geometrie
FROM
    unified_geometry