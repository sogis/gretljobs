DROP TABLE IF EXISTS bundesinventar_trockenwiesen_trockenweiden;

--- Import Data from Shapefile into DuckDB---
CREATE TABLE
	bundesinventar_trockenwiesen_trockenweiden AS 
		SELECT
    		*
		FROM
    		ST_Read('https://data.geo.admin.ch/ch.bafu.bundesinventare-trockenwiesen_trockenweiden/bundesinventare-trockenwiesen_trockenweiden/bundesinventare-trockenwiesen_trockenweiden_2056.shp.zip')
;

SELECT
    COUNT(*)
FROM
	bundesinventar_trockenwiesen_trockenweiden
;

--- Insert intersecting objects ---
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
	'Trockenwiesen und -weiden von nationaler Bedeutung (TWW)' AS thema_sql,
	bund."Name" AS information,
	bund.RefObjBlat AS link
FROM 
	bundesinventar_trockenwiesen_trockenweiden AS bund
JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde
	ON ST_Intersects(
		bund.geom,
		gemeinde.geometrie)
;