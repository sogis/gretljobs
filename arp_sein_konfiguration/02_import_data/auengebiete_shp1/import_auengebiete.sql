DROP TABLE IF EXISTS ${table_name};

--- Import Data from Shapefile into DuckDB---
CREATE TABLE
	${table_name} AS 
		SELECT
    		*
		FROM
    		ST_Read('https://data.geo.admin.ch/ch.bafu.bundesinventare-auen/bundesinventare-auen/bundesinventare-auen_2056.shp.zip')
;

SELECT
    COUNT(*)
FROM
	${table_name}
;

DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'Auengebiete von nationaler Bedeutung'
;

--- Insert into Sammeltabelle ---
INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'Auengebiete von nationaler Bedeutung' AS thema_sql,
	"Name" AS information,
	RefObjBlat AS link,
	geom AS geometrie
FROM 
	${table_name}
;