drop table if exists alw_fruchtfolgeflaechen.fff_mit_uebersteuerung;

--Alle Übersteuerungsflächen werden ausgeschnitten 
with reserveflaechen as (
    select  
        ST_CollectionExtract(
            st_makevalid(
                st_snaptogrid(
                    st_union(geometrie),
                0.001)
            ),3
        ) as geometrie
    from 
        arp_npl_pub.nutzungsplanung_grundnutzung
    where 
        typ_kt IN ('N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone',
                   'N431_Reservezone_Arbeiten',
                   'N432_Reservezone_OeBA',
                   'N439_Reservezone')
), 

grundwasserschutz_S2 as (
    select 
        st_snaptogrid(st_union(apolygon),0.001) as geometrie
    from 
        afu_gewaesserschutz_pub.gewaesserschutz_zone_areal
    where 
        typ = 'S2'
),

zusammengesetzt_reserveflaechen_intersection AS (
    select 
        st_snaptogrid(
                st_intersection(zusammen.geometrie,reserveflaechen.geometrie),
        0.001) as geometrie, 
        zusammen.bfs_nr, 
        0 as anrechenbar,
        zusammen.bezeichnung as bezeichnung, 
        'Reservezone' as spezialfall,
        NULL AS beschreibung, 
        now() AS datenstand
    from 
        alw_fruchtfolgeflaechen.fff_zusammengesetzt zusammen,
        reserveflaechen reserveflaechen
    where 
        st_intersects(zusammen.geometrie,reserveflaechen.geometrie)
), 

zusammengesetzt_grundwasserschutz_intersection AS (
    select 
        st_snaptogrid(
                st_intersection(zusammen.geometrie,grundwasserschutz_s2.geometrie),
        0.001) as geometrie, 
        zusammen.bfs_nr, 
        0 as anrechenbar,
        zusammen.bezeichnung as bezeichnung, 
        'GSZ2' as spezialfall, 
        NULL AS beschreibung, 
        now() AS datenstand 
    from 
        alw_fruchtfolgeflaechen.fff_zusammengesetzt zusammen,
        grundwasserschutz_s2 grundwasserschutz_s2
    where 
        st_intersects(zusammen.geometrie,grundwasserschutz_s2.geometrie)
),

uebersteuerung as (
    select 
        st_snaptogrid(
            ST_CollectionExtract(
                st_union(geometrie),
            3),
        0.001) as geometrie
    from 
        (SELECT 
             st_buffer(ST_CollectionExtract(geometrie,3),0) as geometrie 
         FROM 
             alw_fff_uebersteuerung.uebersteuerung
         UNION ALL 
         SELECT 
             st_buffer(ST_CollectionExtract(geometrie,3),0) as geometrie
         FROM 
             zusammengesetzt_reserveflaechen_intersection
         UNION ALL 
         SELECT 
             st_buffer(ST_CollectionExtract(geometrie,3),0) as geometrie 
         FROM 
             zusammengesetzt_grundwasserschutz_intersection
        ) union_all_intersections
),

union_uebersteuerung as (
    select 
        st_difference(fff_zusammengesetzt.geometrie,uebersteuerung.geometrie,0.001) as geometrie, 
        fff_zusammengesetzt.spezialfall, 
        fff_zusammengesetzt.bezeichnung, 
        null as beschreibung, 
        now() as datenstand, 
        fff_zusammengesetzt.anrechenbar
    from 
        alw_fruchtfolgeflaechen.fff_zusammengesetzt  fff_zusammengesetzt, 
        uebersteuerung

        union all 
-- die "geeigneten Übersteuerungsflächen" werden wieder eingefügt.    
    select 
        st_snaptogrid(geometrie,0.001),
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
    from 
        alw_fff_uebersteuerung.uebersteuerung
    where 
        fall = 'ersetzen'
        
        union all 
-- die reservezonen-Flächen, welche die fff_zusammen überlagerten werden wieder eingesetzt.
    select 
        st_snaptogrid(geometrie,0.001),
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand, 
        anrechenbar 
    from 
        zusammengesetzt_reserveflaechen_intersection

        UNION ALL 
-- die Grundwasserschutzzonen 2-Flächen, welche die fff_zusammen überlagerten werden wieder eingesetzt.
    select 
        st_snaptogrid(geometrie,0.001),
        spezialfall,
        bezeichnung,
        beschreibung,
        datenstand, 
        anrechenbar 
    from 
        zusammengesetzt_grundwasserschutz_intersection
)

select 
    (st_dump(geometrie)).geom as geometrie,
    spezialfall,
    bezeichnung,
    beschreibung,
    datenstand, 
    anrechenbar 
into 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
from 
    union_uebersteuerung
;

-- Geometrien werden valide gemacht
update 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
    set 
    geometrie = st_makevalid(geometrie)
;
-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
where 
    ST_IsEmpty(geometrie)
;

delete from 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
where 
    st_geometrytype(geometrie) = 'ST_LineString'
    or 
    st_geometrytype(geometrie) = 'ST_Point'
;

CREATE INDEX IF NOT EXISTS
    fff_mit_uebersteuerung_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_mit_uebersteuerung
    using GIST(geometrie)
;
