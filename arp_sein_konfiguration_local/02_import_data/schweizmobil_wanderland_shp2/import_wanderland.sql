DROP TABLE IF EXISTS ${table_name};

--- Import Data from Shapefile into DuckDB---
CREATE TABLE
	${table_name} AS 
		SELECT
    		*
		FROM
    		ST_Read(${shp_path})
;

SELECT
    COUNT(*)
FROM
	${table_name}
;

DELETE FROM
	sein_sammeltabelle
WHERE
	thema_sql = 'SchweizMobil Wanderland'
;

--- Insert into Sammeltabelle ---
INSERT INTO sein_sammeltabelle (
	thema_sql,
	information,
	link,
	geometrie
)

SELECT DISTINCT
	'SchweizMobil Wanderland' AS thema_sql,
	NameR || ' (' || BeschreibR || ')' AS information,
	'https://map.geo.admin.ch/#/map?lang=de&center=2618765.15,1237458.56&z=4&topic=ech&layers=ch.astra.wanderland&bgLayer=ch.swisstopo.pixelkarte-grau' AS link,
	geom AS geometrie
FROM 
	main.${table_name}
;