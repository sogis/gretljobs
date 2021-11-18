drop table if exists alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten;

with altlasten as (
    select 
        st_union(geometrie) as geometrie
    from 
        afu_altlasten_pub.belastete_standorte_altlast4web 
    where 
        c_bere_res_abwbewe in ('02','03','04','05','06')
)
select 
    st_difference(fff_bodenbedeckung.geometrie,altlasten.geometrie) as geometrie, 
    fff_bodenbedeckung .bfs_nr, 
    fff_bodenbedeckung.anrechenbar
into 
    alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten 
from 
    alw_fruchtfolgeflaechen.fff_maske_bodenbedeckung fff_bodenbedeckung,
    altlasten
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_altlasten_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten
using GIST(geometrie)
;
