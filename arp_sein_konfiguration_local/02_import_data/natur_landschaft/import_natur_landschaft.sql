DELETE FROM
	sein_sammeltabelle_filtered
WHERE
	thema_sql = 'Natur und Landschaft (Nutzungsplanung)'
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
	'Natur und Landschaft (Nutzungsplanung)' AS thema_sql,
	'Natur und Landschaft (Nutzungsplanung)' AS information,
	'https://geo.so.ch/map/?t=default&l=ch.so.arp.nutzungsplanung.natur_landschaft_gruppe' AS link
FROM
	arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde 