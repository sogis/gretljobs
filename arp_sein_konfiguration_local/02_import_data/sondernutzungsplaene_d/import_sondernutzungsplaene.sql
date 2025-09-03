DELETE FROM
	sein_sammeltabelle_filtered
WHERE
	thema_sql = 'Sondernutzungspläne (Nutzungsplanung)'
;

INSERT INTO sein_sammeltabelle_filtered (
	gemeindename,
	bfsnr,
	thema_sql,
	information,
	link
)

SELECT DISTINCT
	aname AS gemeindename,
	bfsnr,
	'Sondernutzungspläne (Nutzungsplanung)' AS thema_sql,
	'Sondernutzungspläne' AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.sondernutzungsplaene&bl=hintergrundkarte_sw&c=' ||  
    ROUND(ST_X(ST_Centroid(geometrie))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(geometrie))) || '&s=20000' AS link
FROM
	arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde 