--- Insert intersecting objects ---
INSERT INTO objektinfos_sein_sammeltabelle (
	gemeindename,
	bfsnr,
	thema_sql,
	information,
	link
)

SELECT DISTINCT 
	gemeinde.aname AS gemeindename,
	gemeinde.bfsnr,
	'Inventar der historischen Verkehrswege der Schweiz IVS: Regional und Lokal' AS thema_sql,
	signatur.ivs_deutsch AS information,
	'https://data.geo.admin.ch/ch.astra.ivs-nat/PDF/' || objekte.ivs_sortsla || '.pdf' AS link
FROM 
	bundesinventar_ivs_reg_lok.ivs_linienobjekte_lv95 AS bund
LEFT JOIN bundesinventar_ivs_reg_lok.ivs_signatur_linie AS signatur 
	ON bund.role_ivs_signatur_linie = signatur.T_Id 
LEFT JOIN bundesinventar_ivs_reg_lok.ivs_objekte AS objekte 
	ON bund.role_ivs_objekte = objekte.T_Id
JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde
	ON ST_Intersects(
		bund.ivs_geometrie,
		gemeinde.geometrie)
;