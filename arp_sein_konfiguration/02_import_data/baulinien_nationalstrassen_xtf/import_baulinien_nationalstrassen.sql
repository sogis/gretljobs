--- Delete existing objects ---
DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Baulinien Nationalstrassen V2.0 ÖREB'
;

--- Insert intersecting objects ---
INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT 
	'Baulinien Nationalstrassen V2.0 ÖREB' AS thema_sql,
	planningapprovalname AS information,
	weblink AS link,
	ageometry AS geometrie
FROM 
	importschema_xtf.buildingline
;