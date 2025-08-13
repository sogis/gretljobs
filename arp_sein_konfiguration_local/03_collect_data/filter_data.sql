--- Insert intersecting objects into filtered Sammeltabelle ---
INSERT INTO sein_sammeltabelle_filtered (
	gemeindename,
	bfsnr,
	thema_sql,
	information,
	link
)

SELECT DISTINCT
	gemeinde.aname AS gemeindename,
	gemeinde.bfsnr,
	sein.thema_sql,
	sein.information,
	sein.link
FROM 
	main.sein_sammeltabelle AS sein
JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde
	ON ST_Intersects(
		sein.geometrie,
		gemeinde.geometrie)
;