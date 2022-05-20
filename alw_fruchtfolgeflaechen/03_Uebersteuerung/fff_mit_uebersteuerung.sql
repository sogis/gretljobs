DROP TABLE IF EXISTS 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
;

--Alle Übersteuerungsflächen werden ausgeschnitten 
WITH reserveflaechen AS (
    SELECT  
        ST_CollectionExtract(
            ST_makevalid(
                ST_snaptogrid(
                    ST_union(geometrie),
                0.001)
            ),3
        ) AS geometrie
    FROM 
        arp_nutzungsplanung_pub_v1.nutzungsplanung_grundnutzung
    WHERE 
        typ_kt IN ('N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone',
                   'N431_Reservezone_Arbeiten',
                   'N432_Reservezone_OeBA',
                   'N439_Reservezone')
), 

grundwasserschutz_S2 AS (
    SELECT 
        ST_snaptogrid(ST_union(apolygon),0.001) AS geometrie
    FROM 
        afu_gewaesserschutz_pub.gewaesserschutz_zone_areal
    WHERE 
        typ = 'S2'
),

zusammengesetzt_reserveflaechen_intersection AS (
    SELECT 
        ST_snaptogrid(
                ST_intersection(zusammen.geometrie,reserveflaechen.geometrie),
        0.001) AS geometrie, 
        0 AS anrechenbar,
        zusammen.bezeichnung AS bezeichnung, 
        'Reservezone' AS spezialfall,
        NULL AS beschreibung, 
        now() AS datenstand
    FROM 
        alw_fruchtfolgeflaechen.fff_zusammengesetzt zusammen,
        reserveflaechen reserveflaechen
    WHERE 
        ST_intersects(zusammen.geometrie,reserveflaechen.geometrie)
), 

zusammengesetzt_grundwasserschutz_intersection AS (
    SELECT 
        ST_snaptogrid(
                ST_intersection(zusammen.geometrie,grundwasserschutz_s2.geometrie),
        0.001) AS geometrie, 
        0 AS anrechenbar,
        zusammen.bezeichnung AS bezeichnung, 
        'GSZ2' AS spezialfall, 
        NULL AS beschreibung, 
        now() AS datenstand 
    FROM 
        alw_fruchtfolgeflaechen.fff_zusammengesetzt zusammen,
        grundwasserschutz_s2 grundwasserschutz_s2
    WHERE 
        ST_intersects(zusammen.geometrie,grundwasserschutz_s2.geometrie)
),

uebersteuerung AS (
    SELECT 
        ST_snaptogrid(
            ST_CollectionExtract(
                ST_union(geometrie),
            3),
        0.001) AS geometrie
    FROM (
             SELECT 
                 ST_buffer(ST_CollectionExtract(geometrie,3),0) AS geometrie 
             FROM 
                 alw_fff_uebersteuerung.uebersteuerung

             UNION ALL 

             SELECT 
                 ST_buffer(ST_CollectionExtract(geometrie,3),0) AS geometrie
             FROM 
                 zusammengesetzt_reserveflaechen_intersection

             UNION ALL 

             SELECT 
                 ST_buffer(ST_CollectionExtract(geometrie,3),0) AS geometrie 
             FROM 
                 zusammengesetzt_grundwasserschutz_intersection
         ) union_all_intersections
),

union_uebersteuerung AS (
    SELECT 
        ST_difference(fff_zusammengesetzt.geometrie,uebersteuerung.geometrie,0.001) AS geometrie, 
        fff_zusammengesetzt.spezialfall, 
        fff_zusammengesetzt.bezeichnung, 
        null AS beschreibung, 
        now() AS datenstand, 
        fff_zusammengesetzt.anrechenbar
    FROM 
        alw_fruchtfolgeflaechen.fff_zusammengesetzt  fff_zusammengesetzt, 
        uebersteuerung

    UNION ALL 
-- die "geeigneten Übersteuerungsflächen" werden wieder eingefügt.    
    SELECT 
        ST_snaptogrid(geometrie,0.001),
        spezialfall,
        CASE 
            WHEN (bezeichnung = 'bedingt_geeignete_FFF' OR bezeichnung = 'bedingt geeignet')
            THEN 'bedingt_geeignet' 
            WHEN bezeichnung = 'geeignete_FFF'
            THEN 'geeignet'
            ELSE bezeichnung
        END AS bezeichnung,
        beschreibung,
        datenstand, 
        anrechenbar 
    FROM 
        alw_fff_uebersteuerung.uebersteuerung
    WHERE 
        fall = 'ersetzen'
        
    UNION ALL 
-- die reservezonen-Flächen, welche die fff_zusammen überlagerten werden wieder eingesetzt.
    SELECT 
        ST_snaptogrid(geometrie,0.001),
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand, 
        anrechenbar 
    FROM 
        zusammengesetzt_reserveflaechen_intersection

    UNION ALL 
-- die Grundwasserschutzzonen 2-Flächen, welche die fff_zusammen überlagerten werden wieder eingesetzt.
    SELECT 
        ST_snaptogrid(geometrie,0.001),
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand, 
        anrechenbar 
    FROM 
        zusammengesetzt_grundwasserschutz_intersection
)

SELECT 
    (ST_dump(geometrie)).geom as geometrie,
    spezialfall,
    bezeichnung,
    beschreibung,
    datenstand, 
    anrechenbar 
INTO 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
FROM 
    union_uebersteuerung
;

-- Geometrien werden valide gemacht
UPDATE 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
    SET 
    geometrie = ST_makevalid(geometrie)
;
-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
UPDATE 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
    SET 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    ST_geometrytype(geometrie) = 'ST_GeometryCollection'
;

DELETE FROM 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
WHERE 
    ST_IsEmpty(geometrie)
;

DELETE FROM  
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
WHERE  
    ST_geometrytype(geometrie) IN ('ST_LineString', 'ST_Point')
;

CREATE INDEX IF NOT EXISTS
    fff_mit_uebersteuerung_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
USING GIST(geometrie)
;
