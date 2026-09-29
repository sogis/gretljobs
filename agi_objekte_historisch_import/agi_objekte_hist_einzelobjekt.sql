SELECT 
	art_txt,
	bfs_nr,
	egid,
	'2024' AS datenexport,
	nachfuehrung,
	geometrie
FROM
	temp_db.importschema_xtf.einzelobjekt_flaeche
WHERE
	"art_txt" in ('Laermschutzwand','Mauer','uebriger_Gebaeudeteil','Unterstand')
;