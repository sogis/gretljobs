LOAD spatial;
DROP TABLE IF EXISTS bundesinventar_hochmoore;

--- Import Data from Shapefile into DuckDB---
CREATE TABLE
	bundesinventar_hochmoore AS 
		SELECT
    		*
		FROM
    		ST_Read(${shp_path})
;

SELECT
    COUNT(*)
FROM
	bundesinventar_hochmoore
;

--- Insert intersecting Hochmoore objects ---
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
	'Hoch- und Übergangsmoore von nationaler Bedeutung' AS thema_sql, -- Thema-NAME must be the same AS DEFINED IN grundlagen_thema
	bund."Name" AS information,
	bund.RefObjBlat AS link
FROM 
	main.bundesinventar_hochmoore AS bund
JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde
	ON ST_Intersects(
		bund.geom,
		gemeinde.geometrie)
;