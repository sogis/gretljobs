drop table if exists alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_0;

-- Reserveflächen und Grundwasserschutz S2 werden beide als 0 angerechnet, sofern sie überhaupt geeignet sind. 
with reserveflaechen as (
    select 
        st_union(st_snaptogrid(geometrie,0.001)) as geometrie
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
) 

select 
    geometrie, 
    bfs_nr,
    anrechenbar,
    bezeichnung,
    spezialfall 
into 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_0
from (
    select 
        st_intersection(maske.geometrie,reserveflaechen.geometrie) as geometrie, 
        maske.bfs_nr, 
        0 as anrechenbar,
        'bedingt_geeignet' as bezeichnung, 
        'Reservezone' as spezialfall
    from 
        alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung maske,
        reserveflaechen reserveflaechen
    where 
        st_intersects(maske.geometrie,reserveflaechen.geometrie)
    union all 
    select 
        st_intersection(maske.geometrie,grundwasserschutz_s2.geometrie) as geometrie, 
        maske.bfs_nr, 
        0 as anrechenbar,
        'bedingt_geeignet' as bezeichnung, 
        'GSZ2' as spezialfall
    from 
        alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung maske,
        grundwasserschutz_s2 grundwasserschutz_s2
    where 
        st_intersects(maske.geometrie,grundwasserschutz_s2.geometrie)
    ) union_reserve_und_gewaesserschutz
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_0
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_0
where 
    ST_IsEmpty(geometrie)
;

CREATE INDEX IF NOT EXISTS
    fff_mit_bodenkartierung_0_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_0
    using GIST(geometrie)
;
