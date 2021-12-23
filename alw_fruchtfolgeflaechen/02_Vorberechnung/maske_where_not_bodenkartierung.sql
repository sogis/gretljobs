drop table if exists alw_fruchtfolgeflaechen.fff_maske_where_not_bodenkartierung;

with bodenbedeckung as (
    select 
        ST_CollectionExtract(st_makevalid(st_snaptogrid(st_union(geometrie),0.001)),3) as geometrie
    from 
        afu_isboden_pub.bodeneinheit
)

select 
    st_difference(maske.geometrie, bodenbedeckung.geometrie,0.001) as geometrie, 
    anrechenbar, 
    bfs_nr 
into 
    alw_fruchtfolgeflaechen.fff_maske_where_not_bodenkartierung
from 
    alw_fruchtfolgeflaechen.fff_maske_fertig maske, 
    bodenbedeckung 
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_maske_where_not_bodenkartierung
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_maske_where_not_bodenkartierung
where 
    ST_IsEmpty(geometrie)
;

CREATE INDEX IF NOT EXISTS
    fff_maske_where_not_bodenkartierung_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_where_not_bodenkartierung
    using GIST(geometrie)
;
