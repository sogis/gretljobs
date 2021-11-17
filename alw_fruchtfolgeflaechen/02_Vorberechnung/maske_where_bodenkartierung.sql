drop table if exists alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung;

with bodenbedeckung as (
    select 
        st_snaptogrid(st_buffer(st_buffer(st_buffer(st_buffer(st_union(geometrie),-0.2),0.2),0.2),-0.2),0.001) as geometrie
    from 
        afu_isboden_pub.bodeneinheit
)

select 
    st_intersection(maske.geometrie, bodenbedeckung.geometrie) as geometrie, 
    anrechenbar, 
    bfs_nr 
into 
    alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung
from 
    alw_fruchtfolgeflaechen.fff_maske_fertig maske, 
    bodenbedeckung 
where 
    st_intersects(maske.geometrie,bodenbedeckung.geometrie)
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung
where 
    ST_IsEmpty(geometrie)
;

CREATE INDEX IF NOT EXISTS
    fff_maske_where_bodenkartierung_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung
    using GIST(geometrie)
;
