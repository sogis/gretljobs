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
    st_makevalid(st_snaptogrid(st_difference(ohne_naturreservate.geometrie,grundwasserschutz.geometrie),0.001)) as geometrie, 
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

delete from 
    alw_fruchtfolgeflaechen.fff_maske_fertig 
where 
    ST_IsEmpty(geometrie)
;

CREATE INDEX IF NOT EXISTS
    fff_zusammengesetzt_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_fertig 
    using GIST(geometrie)
;

delete 
from 
    alw_fruchtfolgeflaechen.fff_maske_fertig
where 
    st_geometrytype(geometrie) not IN ('ST_Polygon', 'ST_MultiPolygon')
;