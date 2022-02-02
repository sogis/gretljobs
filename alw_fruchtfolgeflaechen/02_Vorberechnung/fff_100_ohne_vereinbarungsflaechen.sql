DROP TABLE IF EXISTS alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100 ;

WITH vereinbarungsflaechen AS (
    SELECT 
        ST_union(ST_CollectionExtract(ST_makevalid(ST_snaptogrid(geometrie,0.001)),3)) AS geometrie
    FROM 
        arp_mjpnatur_pub.vereinbrngsflchen_flaechen
)

SELECT
    (ST_dump(ST_union(ST_makevalid(ST_difference(maske.geometrie,vereinbarungsflaechen.geometrie,0.001))))).geom AS geometrie,
    1 AS anrechenbar, 
    'geeignet'AS bezeichnung
INTO 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
FROM 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden maske, 
    vereinbarungsflaechen
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
UPDATE 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
    SET 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    ST_geometrytype(geometrie) = 'ST_GeometryCollection'
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
WHERE 
    ST_IsEmpty(geometrie)
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
WHERE 
    ST_geometrytype(geometrie) IN ('ST_LineString')
;

CREATE INDEX IF NOT EXISTS
    fff_mit_bodenkartierung_100_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
USING GIST(geometrie)
;
