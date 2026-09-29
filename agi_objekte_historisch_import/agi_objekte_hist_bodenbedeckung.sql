SELECT 
	art_txt,
	bfs_nr,
	egid,
	'2024' AS datenexport,
	nachfuehrung,
	geometrie
FROM
	temp_db.importschema_xtf.bodenbedeckung
WHERE
	art_txt IN ('Bahn','Gebaeude','Gebaeudeerschliessung','Strasse_Weg','Trottoir','Verkehrsinsel')
;