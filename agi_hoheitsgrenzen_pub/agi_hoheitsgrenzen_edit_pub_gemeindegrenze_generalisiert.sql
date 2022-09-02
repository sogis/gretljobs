DELETE FROM agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze_generalisiert
;

WITH
    polygons AS (
        SELECT
            bfs_gemeindenummer,
            (ST_Dump(geometrie)).geom
        FROM
            agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
    ),
    rings AS (
        SELECT
            ST_ExteriorRing((ST_DumpRings(geom)).geom) as geom
        FROM 
            polygons
    ),
    simplerings AS (
        SELECT
            ST_SimplifyPreserveTopology(ST_LineMerge(St_Union(geom)),50) as geom
        FROM
            rings
    ),
    simplelines AS (
        SELECT
            (ST_Dump(geom)).geom
        FROM 
            simplerings
    ),
    simplepolys AS (
        SELECT 
            (ST_Dump(ST_Polygonize(DISTINCT geom))).geom as geom
        FROM 
            simplelines
    ),
    simplegemeinde AS (
        SELECT 
            hoheitsgrenzen_gemeindegrenze.gemeindename,
            hoheitsgrenzen_gemeindegrenze.bfs_gemeindenummer,
            hoheitsgrenzen_gemeindegrenze.bezirksname,
            hoheitsgrenzen_gemeindegrenze.kantonsname,
            simplepolys.geom
        FROM
            agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze, 
            simplepolys
        WHERE
            ST_Intersects(hoheitsgrenzen_gemeindegrenze.geometrie, simplepolys.geom)
            AND
            ST_Area(ST_Intersection(simplepolys.geom, hoheitsgrenzen_gemeindegrenze.geometrie))/ST_Area(simplepolys.geom) > 0.5
    )

INSERT INTO agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze_generalisiert(
    gemeindename,
    bfs_gemeindenummer,
    bezirksname,
    kantonsname,
    geometrie
)

SELECT
    gemeindename,
    bfs_gemeindenummer,
    bezirksname,
    kantonsname,
    ST_Collect(geom) AS geometrie
FROM 
    simplegemeinde
GROUP BY
    bfs_gemeindenummer,
    gemeindename, 
    bezirksname,
    kantonsname
;
