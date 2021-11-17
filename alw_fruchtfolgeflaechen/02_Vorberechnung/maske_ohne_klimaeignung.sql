drop table if exists alw_fruchtfolgeflaechen.fff_maske_ohne_klimaeignung;

WITH klimaeignung as (
    select 
        st_union(geometrie) as geometrie
    from 
        klimaeignung.klimaeignung_klima_area klima_area
    left join 
        klimaeignung.kategorien_eignung eignung
        on 
        klima_area.eignung = eignung .t_id 
    where 
        eignung.klimeigid >41
)

select 
    st_difference(ohne_altlasten.geometrie,klimaeignung.geometrie) as geometrie, 
    ohne_altlasten .bfs_nr, 
    ohne_altlasten.anrechenbar
into 
    alw_fruchtfolgeflaechen.fff_maske_ohne_klimaeignung 
from 
    alw_fruchtfolgeflaechen.fff_maske_ohne_altlasten ohne_altlasten,
    klimaeignung
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_klimaeignung_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_klimaeignung
    using GIST(geometrie)
;
