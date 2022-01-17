DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_maske_fertig
;

WITH grundwasserschutz AS ( 
    SELECT
        st_union(apolygon) AS geometrie
    FROM 
        afu_gewaesserschutz_pub.gewaesserschutz_zone_areal
    WHERE 
        typ IN ('S1')
)

SELECT 
    st_makevalid(st_snaptogrid(st_difference(ohne_naturreservate.geometrie,grundwasserschutz.geometrie),0.001)) AS geometrie 
INTO
    alw_fruchtfolgeflaechen.fff_maske_fertig 
FROM 
    alw_fruchtfolgeflaechen.fff_maske_ohne_naturreservate ohne_naturreservate,
    grundwasserschutz
;

CREATE INDEX IF NOT EXISTS
    fff_maske_fertig_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_fertig
USING GIST(geometrie)
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
UPDATE 
    alw_fruchtfolgeflaechen.fff_maske_fertig
    SET 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_maske_fertig 
WHERE 
    ST_IsEmpty(geometrie)
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_maske_fertig
WHERE
    st_geometrytype(geometrie) NOT IN ('ST_Polygon', 'ST_MultiPolygon')
;
