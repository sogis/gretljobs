DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Sondernutzungspläne (Nutzungsplanung)'
;

INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Sondernutzungspläne (Nutzungsplanung)' AS thema_sql,
	typ_bezeichnung AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.sondernutzungsplaene&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(ST_GeomFromWKB(geometrie)))) || '&s=10000' AS link,
	geometrie
FROM
	pubdb.arp_nutzungsplanung_pub_v1.nutzungsplanung_ueberlagernd_flaeche_v
WHERE 
	typ_code_kt IN (610,611,620)
AND 
	rechtsstatus = 'inKraft'