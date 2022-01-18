DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_komplett
;

DROP SEQUENCE IF EXISTS 
    fff_komplett_seq
;

CREATE SEQUENCE 
    fff_komplett_seq
;

--Grenzbereinigung bei Flächen < 15m2
WITH buffered_polygons AS (
    SELECT 
        st_buffer(geometrie,1) AS geometrie, 
        spezialfall, 
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
    FROM 
        alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
    WHERE 
        st_Area(geometrie) > 15
), 
 
small_polygons AS (
    SELECT 
        geometrie, 
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
    FROM 
        alw_fruchtfolgeflaechen.fff_mit_gewaesserraum 
    WHERE 
        st_Area(geometrie) <= 15
),
 
smallpolygons_attribute_big AS (
    SELECT DISTINCT ON (small.geometrie)
        small.geometrie, 
        big.spezialfall,
        big.bezeichnung,
        big.beschreibung,
        big.datenstand,
        big.anrechenbar
    FROM 
        small_polygons small, 
        buffered_polygons big 
    WHERE 
        st_dwithin(small.geometrie,big.geometrie,0)
), 

small_and_big_union AS (
    SELECT 
        geometrie AS geometrie, 
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
    FROM 
        alw_fruchtfolgeflaechen.fff_mit_gewaesserraum 
    WHERE 
        st_Area(geometrie) > 15
    
    UNION ALL 
    
    SELECT 
        geometrie AS geometrie, 
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
    FROM 
        smallpolygons_attribute_big
),

st_union_all_polygons AS (
    SELECT 
        st_union(geometrie) AS geometrie, 
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
    FROM 
        small_and_big_union
    GROUP BY 
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand,
        anrechenbar
)

SELECT 
    NEXTVAL('fff_komplett_seq') AS id,
    (st_dump(geometrie)).geom AS geometrie,
    spezialfall,
    bezeichnung,
    beschreibung,
    datenstand,
    anrechenbar
INTO 
    alw_fruchtfolgeflaechen.fff_komplett
FROM 
    st_union_all_polygons
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_komplett
WHERE 
    st_area(geometrie) <= 15
;

CREATE INDEX IF NOT EXISTS
    fff_komplett_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_komplett
    USING GIST(geometrie)
;

--Hier werden freistehende Flächen kleiner als 0,25ha entfernt

WITH geom_union AS (
    SELECT 
        (st_dump(st_union(st_buffer(geometrie,0.5)))).geom AS geometrie
    FROM 
        alw_fruchtfolgeflaechen.fff_komplett
), 

micro_areas AS (
    SELECT 
        geometrie
    FROM 
        geom_union
    WHERE 
        st_area(geometrie) < 2500
)

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_komplett fff
USING 
    micro_areas
WHERE
    st_contains(micro_areas.geometrie,fff.geometrie)
;

--ALLGEMEINE BEREINIGUNGS FUNKTIONEN

UPDATE 
    alw_fruchtfolgeflaechen.fff_komplett
    SET 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_komplett
WHERE 
    ST_IsEmpty(geometrie)
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_komplett
WHERE 
    ST_geometrytype(geometrie) NOT IN ('ST_Polygon','ST_MultiPolygon')
;

UPDATE 
    alw_fruchtfolgeflaechen.fff_komplett
    SET 
    geometrie = ST_RemoveRepeatedPoints(geometrie) 
;
