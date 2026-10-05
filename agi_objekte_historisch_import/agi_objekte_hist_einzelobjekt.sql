DELETE FROM 
	temp_db.schema_objekte_historisch.einzelobjekt_flaeche
;

INSERT INTO temp_db.schema_objekte_historisch.einzelobjekt_flaeche (
	art_txt,
	bfs_nr,
	egid,
	datenexport,
	nachfuehrung,
	geometrie
)

SELECT 
	art_txt,
	bfs_nr,
	egid,
	'2024-01-01' AS datenexport,
	nachfuehrung,
	geometrie
FROM
	temp_db.importschema_xtf.einzelobjekt_flaeche
WHERE
	"art_txt" in ('Laermschutzwand','Mauer','uebriger_Gebaeudeteil','Unterstand')
;