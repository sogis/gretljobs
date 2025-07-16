--- Insert intersecting objects ---
INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT 
	'Inventar der historischen Verkehrswege der Schweiz IVS: Regional und Lokal' AS thema_sql,
	objekte.ivs_slatyp || ' ' || objekte.ivs_nummer AS information,
	'https://data.geo.admin.ch/ch.astra.ivs-nat/PDF/' || objekte.ivs_sortsla || '.pdf' AS link,
	ivs_geometrie AS geometrie
FROM 
	bundesinventar_ivs_reg_lok.ivs_linienobjekte_lv95 AS bund
LEFT JOIN bundesinventar_ivs_reg_lok.ivs_objekte AS objekte 
	ON bund.role_ivs_objekte = objekte.T_Id
;