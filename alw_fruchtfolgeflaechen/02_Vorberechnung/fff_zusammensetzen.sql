--Dieser Job vereinigt die verschieden bewerteten FFF. 
DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_zusammengesetzt
;

WITH alle_zusammen AS (
SELECT 
    st_makevalid(st_snaptogrid(geometrie,0.001)) AS geometrie, 
    anrechenbar,
    bezeichnung, 
    null AS spezialfall 
FROM 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_50
WHERE 
    st_geometrytype(geometrie) IN ('ST_Polygon', 'ST_MultiPolygon')
    
UNION ALL 

SELECT 
    st_makevalid(st_snaptogrid(geometrie,0.001)) AS geometrie, 
    anrechenbar,
    bezeichnung, 
    null AS spezialfall 
FROM
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
WHERE 
    st_geometrytype(geometrie) IN ('ST_Polygon', 'ST_MultiPolygon')

UNION ALL

SELECT 
    st_makevalid(st_snaptogrid(geometrie,0.001)) AS geometrie, 
    anrechenbar,
    bezeichnung, 
    spezialfall 
FROM
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
WHERE 
    st_geometrytype(geometrie) IN ('ST_Polygon', 'ST_MultiPolygon')
)

--Das Union hier bezweckt das verbinden gleicher Flächen (gleiche wertigkeit und bfs_nr etc.)
select 
    st_makevalid(st_union((geometrie))) AS geometrie, 
    anrechenbar,
    bezeichnung, 
    spezialfall 
INTO
    alw_fruchtfolgeflaechen.fff_zusammengesetzt 
FROM 
    alle_zusammen 
GROUP BY 
    anrechenbar,
    bezeichnung,
    spezialfall 
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
UPDATE
    alw_fruchtfolgeflaechen.fff_zusammengesetzt 
    SET 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_zusammengesetzt 
WHERE 
    ST_IsEmpty(geometrie)
;

CREATE INDEX IF NOT EXISTS
    fff_zusammengesetzt_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_zusammengesetzt 
USING GIST(geometrie)
;
