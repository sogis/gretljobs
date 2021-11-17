drop table if exists alw_fruchtfolgeflaechen.fff_maske_ohne_auen_flachmoore_hochmoore_vogelreservate;

with auen_flachmoore_hochmoore_vogelreservate as (
    select st_union(geometrie) as geometrie 
    from (
        (select 
            geometrie 
        from 
            auen.auen_standorte
        where 
            st_intersects(geometrie,(select geometrie from agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze)) )
        union all 
        (select 
            geometrie 
        from 
            flachmoore.flachmoore_standorte
        where 
            st_intersects(geometrie,(select geometrie from agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze)) )
        union all 
        (select 
            geometrie 
        from 
            hochmoore.hochmoore_standorte
        where 
            st_intersects(geometrie,(select geometrie from agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze)) )
        union all 
        (select 
            geometrie 
        from 
            vogelreservate.vogelreservate_standorte
        where 
            st_intersects(geometrie,(select geometrie from agi_hoheitsgrenzen_pub.hoheitsgrenzen_kantonsgrenze)) )
    ) standorte
)

select 
    st_difference(ohne_klimaeignung.geometrie,auen_flachmoore_hochmoore_vogelreservate.geometrie) as geometrie, 
    ohne_klimaeignung .bfs_nr, 
    ohne_klimaeignung.anrechenbar
into 
    alw_fruchtfolgeflaechen.fff_maske_ohne_auen_flachmoore_hochmoore_vogelreservate 
from 
    alw_fruchtfolgeflaechen.fff_maske_ohne_klimaeignung ohne_klimaeignung,
    auen_flachmoore_hochmoore_vogelreservate
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_auen_flachmoore_hochmoore_vogelreservate_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_auen_flachmoore_hochmoore_vogelreservate
    using GIST(geometrie)
;
