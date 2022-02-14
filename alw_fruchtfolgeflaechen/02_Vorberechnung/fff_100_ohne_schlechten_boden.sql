DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
;

WITH schlechter_boden AS (
    SELECT 
        ST_union(geometrie) AS geometrie
    FROM 
        afu_isboden_pub.bodeneinheit 
    WHERE (
              objnr > 0 
              AND (
                  pflngr < 50
                  OR 
                  (
                       pflngr IS NULL 
                       AND 
                       (bodpktzahl < 70 AND wasserhhgr NOT IN ('a','b','c','f','g','k','l','o','s','t','v'))
                  )
              )
          )
          OR 
          (
              gelform IN ('k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z')
          )
)

SELECT 
    ST_difference(maske.geometrie,schlechter_boden.geometrie,0.001) AS geometrie
INTO
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
FROM 
    alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung maske,
    schlechter_boden
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
UPDATE 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
    SET 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    ST_geometrytype(geometrie) = 'ST_GeometryCollection'
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
WHERE 
    ST_IsEmpty(geometrie)
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
WHERE 
    ST_geometrytype(geometrie) IN ('ST_MultiLineString', 'ST_LineString')
;

CREATE INDEX IF NOT EXISTS
    fff_maske_100_ohne_schlechten_boden_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
USING GIST(geometrie)
;
