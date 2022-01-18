DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
;

WITH gewaesserraum AS (
    SELECT 
        (st_dump(st_intersection(gewaesserraum.geometrie,fff.geometrie))).geom AS geometrie, 
        'Gewaesserraum' AS spezialfall,
        fff.bezeichnung,
        fff.beschreibung,
        fff.datenstand, 
        fff.anrechenbar
    FROM 
        alw_gewaesserraum.gewaesserraum, 
        alw_fruchtfolgeflaechen.fff_mit_uebersteuerung fff
    WHERE 
        st_intersects(gewaesserraum.geometrie,fff.geometrie)
        AND 
        gewaesserraum.fff_massgebend IS true
), 

gewaesserraum_geometrie AS (
    SELECT 
        st_union(geometrie) AS geometrie
    FROM 
        alw_gewaesserraum.gewaesserraum
    WHERE 
        gewaesserraum.fff_massgebend IS true
),

union_gewaesserraum AS (
    SELECT 
        st_difference(fff.geometrie,gewaesserraum_geometrie.geometrie,0.001) AS geometrie, 
        fff.spezialfall, 
        fff.bezeichnung, 
        fff.beschreibung, 
        fff.datenstand, 
        fff.anrechenbar
    FROM 
        alw_fruchtfolgeflaechen.fff_mit_uebersteuerung fff, 
        gewaesserraum_geometrie

        UNION ALL 
-- die "geeigneten Übersteuerungsflächen" werden wieder eingefügt.    
    SELECT 
        st_snaptogrid(geometrie,0.001) AS geometrie,
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand, 
        anrechenbar 
    FROM 
        gewaesserraum
)

SELECT 
    (st_dump(geometrie)).geom AS geometrie,
    spezialfall,
    bezeichnung,
    beschreibung,
    datenstand, 
    anrechenbar 
INTO 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
FROM 
    union_gewaesserraum
;


-- Self-Intersections werden valide gemacht
update 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
    SET 
    geometrie = ST_makevalid(geometrie)
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
UPDATE 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
    SET 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
WHERE 
    ST_IsEmpty(geometrie)
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
WHERE 
    ST_geometrytype(geometrie) NOT IN ('ST_Polygon','ST_MultiPolygon')
;

CREATE INDEX IF NOT EXISTS
    fff_mit_gewaesserraum_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_mit_gewaesserraum
    USING GIST(geometrie)
;
