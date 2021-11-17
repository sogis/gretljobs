drop table if exists alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100 ;

with reserveflaechen as (
    select 
        st_union(geometrie) as geometrie 
    from (
        select 
            st_union(st_snaptogrid(geometrie,0.001)) as geometrie
        from 
            arp_npl_pub.nutzungsplanung_grundnutzung
        where 
            typ_kt = 'N439_Reservezone'
        union all 
        select 
            st_union(apolygon) as geometrie
        from 
            afu_gewaesserschutz_pub.gewaesserschutz_zone_areal
        where 
            typ = 'S2'
        ) unionsgeometrie
)

select
    st_difference(maske.geometrie,reserveflaechen.geometrie,0.001) as geometrie,
    maske.anrechenbar, 
    maske.bfs_nr
into 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100 
from 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_vereinbarungsflaechen maske, 
    reserveflaechen
where 
    st_geometrytype(maske.geometrie) != 'ST_GeometryCollection'; 

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
where 
    ST_IsEmpty(geometrie)
;

CREATE INDEX IF NOT EXISTS
    fff_mit_bodenkartierung_100_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
    using GIST(geometrie)
;
