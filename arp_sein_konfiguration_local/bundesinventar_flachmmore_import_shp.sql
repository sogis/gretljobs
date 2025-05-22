LOAD spatial;
DROP TABLE IF EXISTS bundesinventar_flachmoore;

--- import data from downloaded shapefile into DuckDB---
CREATE TABLE
	bundesinventar_flachmoore AS 
		SELECT
    		*
		FROM
    		ST_Read(${shp_path})
;

SELECT
    COUNT(*)
FROM
	bundesinventar_flachmoore
;

--- Insert intersecting Flachmoore objects ---
INSERT INTO objektinfos_sein_sammeltabelle (
	gemeindename,
	bfsnr,
	thema_sql,
	information,
	link
)

SELECT DISTINCT
	gemeinde.aname AS gemeindename,
	gemeinde.bfsnr,
	'Flachmoore von nationaler Bedeutung' AS thema_sql,
	bund."Name" AS information,
	bund.RefObjBlat AS link
FROM 
	main.bundesinventar_flachmoore AS bund
JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde
	ON ST_Intersects(
		bund.geom,
		gemeinde.geometrie)
;