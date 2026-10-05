DELETE FROM 
	temp_db.schema_objekte_historisch.bodenbedeckung
;

INSERT INTO temp_db.schema_objekte_historisch.bodenbedeckung (
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
	temp_db.importschema_xtf.bodenbedeckung
WHERE
	art_txt IN ('Bahn','Gebaeude','Gebaeudeerschliessung','Strasse_Weg','Trottoir','Verkehrsinsel')
;