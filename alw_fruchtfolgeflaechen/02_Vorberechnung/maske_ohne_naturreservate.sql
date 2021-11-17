drop table if exists alw_fruchtfolgeflaechen.fff_maske_ohne_naturreservate;

with naturreservate as 
( 
    select 
        st_union(geometrie) as geometrie
    from 
        arp_naturreservate_pub.naturreservate_reservat
)

select 
    st_difference(ohne_trockenwiesen.geometrie,naturreservate.geometrie) as geometrie, 
    ohne_trockenwiesen.bfs_nr, 
    ohne_trockenwiesen.anrechenbar
into 
    alw_fruchtfolgeflaechen.fff_maske_ohne_naturreservate 
from 
    alw_fruchtfolgeflaechen.fff_maske_ohne_trockenwiesen ohne_trockenwiesen,
    naturreservate
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_naturreservate_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_naturreservate
    using GIST(geometrie)
;
