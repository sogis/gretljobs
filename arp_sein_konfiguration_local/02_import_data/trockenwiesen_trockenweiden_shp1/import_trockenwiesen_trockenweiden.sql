DROP TABLE IF EXISTS ${table_name};

--- Import Data from Shapefile into DuckDB---
CREATE TABLE
	${table_name} AS 
		SELECT
    		*
		FROM
    		ST_Read('https://data.geo.admin.ch/ch.bafu.bundesinventare-trockenwiesen_trockenweiden/bundesinventare-trockenwiesen_trockenweiden/bundesinventare-trockenwiesen_trockenweiden_2056.shp.zip')
;

SELECT
    COUNT(*)
FROM
	${table_name}
;

DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Trockenwiesen und -weiden von nationaler Bedeutung (TWW)'
;

--- Insert into Sammeltabelle ---
INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Trockenwiesen und -weiden von nationaler Bedeutung (TWW)' AS thema_sql,
	"Name" AS information,
	RefObjBlat AS link,
	geom AS geometrie
FROM 
	${table_name}
;