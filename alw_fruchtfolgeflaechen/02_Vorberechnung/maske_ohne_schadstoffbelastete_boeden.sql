drop table if exists alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden;

with schadstoffbelastete_boeden as (
    select st_union(geometrie) as geometrie 
    from (
        (select 
            geometrie 
        from 
            afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_schrebergarten
        )
        union all 
        (select 
            geometrie 
        from 
            afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_rebbau
        )
        union all 
        (select 
            geometrie 
        from 
            afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_gaertnerei
        )
        union all 
        (select 
            geometrie 
        from 
            afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_stahlmast
        )
        union all 
        (select 
            geometrie 
        from 
            afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_stahlbruecke
        )
        union all 
        (select 
            geometrie 
        from 
            afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_stahlkonstruktion
        )
        union all 
        (select 
            geometrie 
        from 
            afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_flugplatz
        )
        union all 
        (select 
            geometrie 
        from 
            afu_schadstoffbelastete_boeden_pub.schdstfflstt_bden_bodenbelastungsgebiet
        )
    ) standorte
)

select 
    st_difference(ohne_afhv.geometrie,schadstoffbelastete_boeden.geometrie,0.01) as geometrie, 
    ohne_afhv.bfs_nr, 
    ohne_afhv.anrechenbar
into 
    alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden 
from 
    alw_fruchtfolgeflaechen.fff_maske_ohne_auen_flachmoore_hochmoore_vogelreservate ohne_afhv,
    schadstoffbelastete_boeden
;

CREATE INDEX IF NOT EXISTS
    fff_maske_ohne_schadstoffbelastete_boeden_geometrie_idx 
    ON 
    alw_fruchtfolgeflaechen.fff_maske_ohne_schadstoffbelastete_boeden
    using GIST(geometrie)
;
