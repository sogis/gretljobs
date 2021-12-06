drop table if exists alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100 ;

with vereinbarungsflaechen as (
    select 
        st_union(st_makevalid(st_snaptogrid(geometrie,0.001))) as geometrie
    from 
        arp_mjpnatur_pub.vereinbrngsflchen_flaechen
)

select
    st_difference(maske.geometrie,vereinbarungsflaechen.geometrie) as geometrie,
    maske.anrechenbar, 
    maske.bfs_nr
into 
    alw_fruchtfolgeflaechen.fff_mit_bodenkartierung_100
from 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden maske, 
    vereinbarungsflaechen
;

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
