drop table if exists alw_fruchtfolgeflaechen.fff_maske_fertig;

with grundwasserschutz as 
( 
    select 
        st_union(apolygon) as geometrie
    from 
        afu_gewaesserschutz_pub.gewaesserschutz_zone_areal
    where 
        typ in ('S1')
)

select 
    st_difference(ohne_naturreservate.geometrie,grundwasserschutz.geometrie) as geometrie, 
    ohne_naturreservate.bfs_nr, 
    ohne_naturreservate.anrechenbar
into 
    alw_fruchtfolgeflaechen.fff_maske_fertig 
from 
    alw_fruchtfolgeflaechen.fff_maske_ohne_naturreservate ohne_naturreservate,
    grundwasserschutz
;

CREATE INDEX IF NOT EXISTS
    fff_maske_fertig_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_fertig
    using GIST(geometrie)
;