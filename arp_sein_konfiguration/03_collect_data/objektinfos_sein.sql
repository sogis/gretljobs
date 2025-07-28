--- Insert objects ---
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
	thema.aname AS thema_sql,
	objekt.information,
	objekt.link
FROM 
	sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_objektinfo AS objekt
LEFT JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_thema AS thema 
	ON objekt.thema_r = thema.t_id
LEFT JOIN sein.arp_sein_konfiguration_grundlagen_v2.gemeinde_objektinfo AS gemob 
	ON objekt.t_id = gemob.objektinfo_r 
LEFT JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde 
	ON gemob.gemeinde_r = gemeinde.t_id 
;