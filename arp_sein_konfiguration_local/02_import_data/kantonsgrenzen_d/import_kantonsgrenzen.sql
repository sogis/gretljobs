DELETE FROM
	sein_sammeltabelle_filtered
WHERE
	thema_sql = 'Kantonsgrenzen'
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
	'Kantonsgrenzen' AS thema_sql,
	'Kanton Solothurn' AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.agi.kantonsgrenzen' AS link
FROM
	arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde