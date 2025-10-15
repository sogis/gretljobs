DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Konsultationsbereich Betriebsareal'
;
WITH

gemeindepolygone AS (
	SELECT 
    	g.aname, 
    	b.typ,
    	ST_Union_Agg(ST_Intersection(CAST(b.geometrie AS GEOMETRY), CAST(g.geometrie AS GEOMETRY))) AS geom_pro_gemeinde
	FROM
    	pubdb.afu_stoerfallverordnung_pub_v1.betrieb_kb AS b
	LEFT JOIN editdb.arp_sein_konfiguration_grundlagen_v2.grundlagen_gemeinde AS g 
    	ON ST_Intersects(CAST(b.geometrie AS GEOMETRY), CAST(g.geometrie AS GEOMETRY))
	GROUP BY
    	g.aname, b.typ
)

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Konsultationsbereich Betriebsareal' AS thema_sql,
	typ AS information,
    'https://geo.so.ch/map/?t=default&l=ch.so.afu.gefahrenhinweiskarte_stfv.konsultationsbereich_betriebsaeral%5B40%5D&&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_Centroid(geom_pro_gemeinde))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(geom_pro_gemeinde))) || '&s=10000' AS link,
    geom_pro_gemeinde AS geometrie
FROM
	gemeindepolygone
;