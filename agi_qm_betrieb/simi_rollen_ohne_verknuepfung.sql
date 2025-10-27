ATTACH ${connectionStringSimi} AS simidb (TYPE POSTGRES, READ_ONLY);

CREATE TEMP TABLE simiRollenOhneVerknuepfung AS
SELECT 
	r.name
FROM 
	simidb.simi.simiiam_role r
WHERE NOT EXISTS (
 	SELECT 
 		*
 	FROM 
 		simidb.simi.simiiam_permission p
 	WHERE 
 		p.role_id = r.id
)
ORDER BY r.name
;

COPY simiRollenOhneVerknuepfung TO '/tmp/qmbetrieb/simi_rollen_ohne_verknuepfung.csv' (HEADER, DELIMITER ';');