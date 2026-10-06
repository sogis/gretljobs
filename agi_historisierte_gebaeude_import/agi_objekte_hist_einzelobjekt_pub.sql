SELECT 
	art_txt,
	bfs_nr,
	egid,
	datenexport,
	nachfuehrung,
	geometrie_wkt AS geometrie
FROM
	temp_db.schema_objekte_historisch.einzelobjekt_flaeche
;