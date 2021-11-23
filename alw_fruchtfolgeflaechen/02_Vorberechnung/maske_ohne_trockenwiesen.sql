drop table if exists alw_fruchtfolgeflaechen.fff_maske_ohne_trockenwiesen;

with trockenwiese as 
( 
    select 
        st_union(geometrie) as geometrie
    from 
        trockenwiesenweiden.trockenwiesenwden_standorte
    where 
        st_intersects(geometrie,(select geometrie from agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze))
)

select 
    st_difference(ohne_bauzonen.geometrie,trockenwiese.geometrie) as geometrie, 
    ohne_bauzonen.bfs_nr, 
    ohne_bauzonen.anrechenbar
into 
    alw_fruchtfolgeflaechen.fff_maske_ohne_trockenwiesen 
from 
    alw_fruchtfolgeflaechen.fff_maske_ohne_bauzonen ohne_bauzonen,
    trockenwiese
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_trockenwiesen_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_trockenwiesen
    using GIST(geometrie)
;
