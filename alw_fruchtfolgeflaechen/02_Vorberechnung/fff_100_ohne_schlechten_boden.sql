drop table if exists alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden;

with schlechter_boden as (
    select 
        st_union(geometrie) as geometrie
    from 
        afu_isboden_pub.bodeneinheit 
    where 
       (objnr > 0
        AND
        (pflngr < 50
         OR 
         (pflngr IS NULL AND bodpktzahl < 70))
        )
        or 
       (gelform IN ('k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'))
)

select 
    st_difference(maske.geometrie,schlechter_boden.geometrie,0.001) as geometrie, 
    maske.anrechenbar, 
    maske.bfs_nr
into 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
from 
    alw_fruchtfolgeflaechen.fff_maske_where_bodenkartierung maske,
    schlechter_boden
;

-- GeometryCollections werden aufgelöst. Nur die Polygons werden herausgenommen.
update 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
    set 
    geometrie = ST_CollectionExtract(geometrie, 3)
WHERE 
    st_geometrytype(geometrie) = 'ST_GeometryCollection'
;

delete from 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
where 
    ST_IsEmpty(geometrie)
;

delete from 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
where 
    st_geometrytype(geometrie) in ('ST_MultiLineString', 'ST_LineString')
;

CREATE INDEX IF NOT EXISTS
    fff_maske_100_ohne_schlechten_boden_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_100_ohne_schlechten_boden
    using GIST(geometrie)
;
