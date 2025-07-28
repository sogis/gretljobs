DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Kataster der belasteten Standorte (KBS)'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Kataster der belasteten Standorte (KBS)' AS thema_sql,
	'Nr. ' || standortnummer || ' / ' || standorttyp AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.afu.altlasten.standorte&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '&s=5000' AS link,
	geometrie
FROM
	pubdb.afu_altlasten_pub_v2.belasteter_standort