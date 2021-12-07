drop table if exists alw_fruchtfolgeflaechen.fff_mit_uebersteuerung;

--Alle Übersteuerungsflächen werden ausgeschnitten 
with reserveflaechen as (
    select 
        st_union(geometrie) as geometrie
    from 
        arp_npl_pub.nutzungsplanung_grundnutzung
    where 
        typ_kt = 'N439_Reservezone'
), 

grundwasserschutz_S2 as (
    select 
        st_union(apolygon) as geometrie
    from 
        afu_gewaesserschutz_pub.gewaesserschutz_zone_areal
    where 
        typ = 'S2'
),

zusammengesetzt_reserveflaechen_intersection AS (
    select 
        st_intersection(zusammen.geometrie,reserveflaechen.geometrie) as geometrie, 
        zusammen.bfs_nr, 
        0 as anrechenbar,
        zusammen.bezeichnung as bezeichnung, 
        'reservezone' as spezialfall,
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
        st_intersection(zusammen.geometrie,grundwasserschutz_s2.geometrie) as geometrie, 
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
        st_buffer(st_buffer(st_buffer(st_buffer(st_union(geometrie),0.01),-0.01),-0.01),0.01) as geometrie
    from 
        (SELECT 
             geometrie 
         FROM 
             alw_fff_uebersteuerung.uebersteuerung
         UNION ALL 
         SELECT 
             geometrie 
         FROM 
             zusammengesetzt_reserveflaechen_intersection
         UNION ALL 
         SELECT 
             geometrie 
         FROM 
             zusammengesetzt_grundwasserschutz_intersection
        ) union_all_intersections
),

union_uebersteuerung as (
    select 
        st_difference(fff_zusammengesetzt.geometrie,uebersteuerung.geometrie,0.01) as geometrie, 
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
        geometrie,
        spezialfall,
        bezeichnung,
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
        geometrie,
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
        geometrie,
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
