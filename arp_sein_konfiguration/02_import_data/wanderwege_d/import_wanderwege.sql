DELETE FROM
	sein_sammeltabelle_filtered
WHERE
	thema_sql = 'Wanderwege'
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
	'Wanderwege' AS thema_sql,
	'Wanderwege' AS information,
	'https://geo.so.ch/map/?t=default&l=ch.astra.wanderland%2Cch.so.arp.wanderwege.routen%21%2Cch.so.arp.wanderwege.signalisation%21%2Cch.so.arp.wanderwege%2Cch.astra.wanderland-sperrungen_umleitungen&bl=hintergrundkarte_sw&c=' || 
    ROUND(ST_X(ST_Centroid(geometrie))) || '%2C' || 
    ROUND(ST_Y(ST_Centroid(geometrie))) || '&s=20000' AS link
FROM
	arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde 