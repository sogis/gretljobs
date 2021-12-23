DROP TABLE IF EXISTS alw_fruchtfolgeflaechen.fruchtfolgeflaechen_buffer_mm;
CREATE TABLE alw_fruchtfolgeflaechen.fruchtfolgeflaechen_buffer_mm
AS
SELECT   
    id,
	bezeichnung,
    spezialfall, 
    9999 as bfs_nr,
	to_char(datenstand, 'DD.MM.YYYY') as datenstand, 
	anrechenbar,
	ST_Area(geometrie) / 100.0 AS area_aren,
	(ST_Area(geometrie) / 100.0)*anrechenbar AS area_anrech,
	(ST_Dump(ST_ReducePrecision(ST_Buffer(geometrie, 0.02), 0.01))).geom AS geom
FROM 
	alw_fruchtfolgeflaechen.fff_komplett
;	
CREATE INDEX ON "alw_fruchtfolgeflaechen"."fruchtfolgeflaechen_buffer_mm" USING GIST ("geom")
;


DROP TABLE IF EXISTS alw_fruchtfolgeflaechen.fruchtfolgeflaechen_exteriorring;
CREATE TABLE alw_fruchtfolgeflaechen.fruchtfolgeflaechen_exteriorring
AS 
SELECT 
	ST_ExteriorRing(geom) AS geom
FROM 
(
	SELECT 
		(ST_DumpRings(geom)).geom AS geom
	FROM 
		alw_fruchtfolgeflaechen.fruchtfolgeflaechen_buffer_mm
) AS foo
;
CREATE INDEX ON "alw_fruchtfolgeflaechen"."fruchtfolgeflaechen_exteriorring" USING GIST ("geom")
;

DROP TABLE IF EXISTS alw_fruchtfolgeflaechen.fruchtfolgeflaechen_union;
CREATE TABLE alw_fruchtfolgeflaechen.fruchtfolgeflaechen_union
AS
SELECT 
	ST_Union(geom, 0.01) AS geom
FROM 
	alw_fruchtfolgeflaechen.fruchtfolgeflaechen_exteriorring
;
CREATE INDEX ON "alw_fruchtfolgeflaechen"."fruchtfolgeflaechen_union" USING GIST ("geom")
;

DROP SEQUENCE IF EXISTS polyseq;
CREATE SEQUENCE polyseq;
DROP TABLE IF EXISTS alw_fruchtfolgeflaechen.polys;
CREATE TABLE alw_fruchtfolgeflaechen.polys 
AS
SELECT 
	nextval('polyseq') AS id, 
	(ST_Dump(ST_Polygonize(geom))).geom AS geom
FROM 
	alw_fruchtfolgeflaechen.fruchtfolgeflaechen_union
;
CREATE INDEX ON "alw_fruchtfolgeflaechen"."polys" USING GIST ("geom")
;

DROP TABLE IF EXISTS alw_fruchtfolgeflaechen.polys_point;
CREATE TABLE alw_fruchtfolgeflaechen.polys_point 
AS
SELECT 
	geom,
	ST_PointOnSurface(geom) AS point
FROM 
	alw_fruchtfolgeflaechen.polys
;
CREATE INDEX ON "alw_fruchtfolgeflaechen"."polys_point" USING GIST ("geom")
;

DROP TABLE IF EXISTS alw_fruchtfolgeflaechen.polys_attr;
CREATE TABLE alw_fruchtfolgeflaechen.polys_attr
AS
SELECT 
	DISTINCT ON (polys.point) 
	id,
	bezeichnung,
	spezialfall,
    9999 as bfs_nr,
	to_char(datenstand, 'DD.MM.YYYY') as datenstand, 
	anrechenbar,
	ST_Area(geometrie) / 100.0 AS area_aren,
	(ST_Area(geometrie) / 100.0)*anrechenbar AS area_anrech,
	polys.geom AS geometrie
FROM 
	alw_fruchtfolgeflaechen.fff_komplett AS fff
	INNER JOIN alw_fruchtfolgeflaechen.polys_point AS polys 
	ON ST_Intersects(polys.point, fff.geometrie)
;
CREATE INDEX ON "alw_fruchtfolgeflaechen"."polys_attr" USING GIST ("geometrie")
;

DROP TABLE IF EXISTS alw_fruchtfolgeflaechen.polys_join;
CREATE TABLE alw_fruchtfolgeflaechen.polys_join
AS
SELECT 
	(ST_Dump(foo.geometrie)).geom AS geometrie,
	fff.id,
	bezeichnung,
	spezialfall,
	9999 as bfs_nr,
	to_char(datenstand, 'DD.MM.YYYY') as datenstand,
	anrechenbar AS anrechenbar,
	ST_Area(foo.geometrie) / 100.0 AS area_aren,
	(ST_Area(foo.geometrie) / 100.0)*anrechenbar AS area_anrech
FROM 
(
	SELECT 
		id, ST_RemoveRepeatedPoints(ST_Union(geometrie)) AS geometrie
	FROM 
		alw_fruchtfolgeflaechen.polys_attr
	GROUP BY (id)
) AS foo
LEFT JOIN alw_fruchtfolgeflaechen.fff_komplett AS fff
ON fff.id = foo.id
;
CREATE INDEX ON "alw_fruchtfolgeflaechen"."polys_join" USING GIST ("geometrie")
;


DROP TABLE IF EXISTS alw_fruchtfolgeflaechen.fruchtfolgeflaeche_clean;
CREATE TABLE alw_fruchtfolgeflaechen.fruchtfolgeflaeche_clean as 
(
    SELECT 
	    geometrie,
	    bezeichnung,
	    spezialfall,
	    bfs_nr,
	    datenstand,
	    anrechenbar,
	    area_aren,
	    area_anrech
    FROM 	
	    alw_fruchtfolgeflaechen.polys_join AS polys 
    WHERE 
	    ST_Area(geometrie) > 1
)
;