LOAD spatial;
DROP TABLE IF EXISTS bundesinventar_amphibien_wanderobjekte;

--- Import Data from Shapefile into DuckDB---
CREATE TABLE
	bundesinventar_amphibien_wanderobjekte AS 
		SELECT
    		*
		FROM
    		ST_Read(${shp_path})
;

SELECT
    COUNT(*)
FROM
	bundesinventar_amphibien_wanderobjekte
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
	'Amphibienlaichgebiete von nationaler Bedeutung - Ortsfeste Objekte' AS thema_sql,
	bund."Name" AS information,
	bund.RefObjBlat AS link
FROM 
	main.bundesinventar_amphibien_laichgebiete AS bund
JOIN sein.arp_sein_konfiguration_grundlagen_v2.so_rp_s0250115grundlagen_gemeinde AS gemeinde
	ON ST_Intersects(
		bund.geom,
		gemeinde.geometrie)
;