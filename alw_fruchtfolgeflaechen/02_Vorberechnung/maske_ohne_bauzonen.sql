drop table if exists alw_fruchtfolgeflaechen.fff_maske_ohne_bauzonen;

WITH bauzonen as (
    select 
        st_union(geometrie) as geometrie
    from 
        arp_npl_pub.nutzungsplanung_grundnutzung
    where 
        typ_kt = 'N499_weitere_Bauzonen_nach_Art18_RPG_ausserhalb_Bauzonen'
)

select 
    st_difference(ohne_schafstoffbelastete_boeden.geometrie,bauzonen.geometrie) as geometrie, 
    ohne_schafstoffbelastete_boeden .bfs_nr, 
    ohne_schafstoffbelastete_boeden.anrechenbar
into 
    alw_fruchtfolgeflaechen.fff_maske_ohne_bauzonen 
from 
    alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden ohne_schafstoffbelastete_boeden,
    bauzonen
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_bauzonen_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_bauzonen
    using GIST(geometrie)
;
