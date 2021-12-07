drop table if exists alw_fruchtfolgeflaechen.fff_maske_ohne_bauzonen;

WITH bauzonen as (
    select 
        st_union(geometrie) as geometrie
    from 
        arp_npl_pub.nutzungsplanung_grundnutzung
    where 
        typ_kt not IN ('N160_Gruen_und_Freihaltezone_innerhalb_Bauzone',
                       'N210_Landwirtschaftszone',
                       'N220_Spezielle_Landwirtschaftszone',
                       'N230_Rebbauzone',
                       'N290_weitere_Landwirtschaftszonen',
                       'N311_Waldrandschutzzone',
                       'N430_Reservezone_Wohnzone_Mischzone_Kernzone_Zentrumszone',
                       'N431_Reservezone_Arbeiten',
                       'N432_Reservezone_OeBA',
                       'N439_Reservezone',
                       'N490_Golfzone',
                       'N491_Abbauzone',
                       'N492_Deponiezone'
                      )
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
