DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
;

SELECT 
    st_intersection(maske.geometrie,alte_fff.geometrie,0.001) AS geometrie, 
    alte_fff.anrechenbar,
    alte_fff.spezialfall,
    alte_fff.bezeichnung, 
    alte_fff.datenstand
INTO 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
FROM 
    alw_fruchtfolgeflaechen.fff_maske_where_not_bodenkartierung maske, 
    alw_fruchtfolgeflaechen_alt.inventarflaechen_fruchtfolgeflaeche alte_fff
WHERE 
    st_intersects(maske.geometrie,alte_fff.geometrie)
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
UPDATE 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
    SET 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
WHERE 
    ST_IsEmpty(geometrie)
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
WHERE 
    st_geometrytype(geometrie) IN ('ST_MultiLineString','ST_LineString','ST_Point')
;

CREATE INDEX IF NOT EXISTS
    fff_ohne_bodenkartierung_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_ohne_bodenkartierung
USING GIST(geometrie)
;
