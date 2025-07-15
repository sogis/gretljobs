DROP TABLE IF EXISTS bundesinventar_auen;

--- Import Data from Shapefile into DuckDB---
CREATE TABLE
	bundesinventar_auen AS 
		SELECT
    		*
		FROM
    		ST_Read('https://data.geo.admin.ch/ch.bafu.bundesinventare-auen/bundesinventare-auen/bundesinventare-auen_2056.shp.zip')
;

SELECT
    COUNT(*)
FROM
	bundesinventar_auen
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
	'Auengebiete von nationaler Bedeutung' AS thema_sql,
	bund."Name" AS information,
	bund.RefObjBlat AS link
FROM 
	bundesinventar_auen AS bund
JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde
	ON ST_Intersects(
		bund.geom,
		gemeinde.geometrie)
;