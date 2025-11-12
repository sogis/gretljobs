-- Delete existing objects --
DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Inventar der historischen Verkehrswege der Schweiz IVS: National'
;

--- Insert intersecting objects ---
INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT 
	'Inventar der historischen Verkehrswege der Schweiz IVS: National' AS thema_sql,
	objekte.ivs_slatyp || ' ' || objekte.ivs_nummer || ': ' || nm.ivs_slaname AS information,
	'https://data.geo.admin.ch/ch.astra.ivs-nat/PDF/' || objekte.ivs_sortsla || '.pdf' AS link,
	ivs_geometrie AS geometrie
FROM 
	importschema_xtf.ivs_linienobjekte_lv95 AS bund
LEFT JOIN importschema_xtf.ivs_objekte AS objekte 
	ON bund.role_ivs_objekte = objekte.T_Id
LEFT JOIN importschema_xtf.ivs_slanamen AS nm 
	ON objekte.T_Id = nm.role_ivs_objekte
;