delete from afu_naturgefahren_staging_v1.dokumente_pro_gemeinde 
;

with 
orig_dataset as (
    select
        t_id  as dataset  
    from 
        afu_naturgefahren_v1.t_ili2db_dataset
    where 
        datasetname = ${kennung}
),

orig_basket as (
    select 
        basket.t_id 
    from 
        afu_naturgefahren_v1.t_ili2db_basket basket,
        orig_dataset
    where 
        basket.dataset = orig_dataset.dataset
        and 
        topic like '%Befunde'
),

 basket as (
     select 
         t_id,
         attachmentkey
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 ),
 
gemeinden as (
    select
        gemeindename,
        geometrie, 
        bfs_gemeindenummer
    from 
        agi_hoheitsgrenzen_pub.hoheitsgrenzen_gemeindegrenze
),

berichte as (
    select 
        teilauftrag.t_id as teilauftrag_tid,
        auftrag.kennung as auftragskennung,
        auftrag.deklaration as auftragsdeklaration,
        auftrag.abschlussjahr::text as jahr,
        teilauftrag.hauptprozess as hauptprozess,
        bericht.bericht as titel, 
        bericht.dateiname as dateiname,
        'https://irgendwas.ch/pfad/'||bericht.dateiname as link
    from 
        afu_naturgefahren_v1.auftrag auftrag 
    left join 
        afu_naturgefahren_v1.bericht bericht
        on 
        bericht.auftrag_r = auftrag.t_id 
    left join 
        afu_naturgefahren_v1.teilauftrag teilauftrag 
        on 
        teilauftrag.auftrag_r = auftrag.t_id
),

teilprozesse as (
    select 
        teilprozess_einsturz.geometrie,
        teilprozess_einsturz.prozessquelle_r as prozessquelle_id 
    from 
        afu_naturgefahren_v1.befundeinsturz teilprozess_einsturz 
    where 
        teilprozess_einsturz.t_basket in (select t_id from orig_basket)
    union all 
    select 
        teilprozess_absenkung.geometrie,
        teilprozess_absenkung.prozessquelle_r as prozessquelle_id 
    from 
        afu_naturgefahren_v1.befundabsenkung teilprozess_absenkung
    where 
        teilprozess_absenkung.t_basket in (select t_id from orig_basket)
    union all 
    select 
        teilprozess_bergfelssturz.geometrie,
        teilprozess_bergfelssturz_pq.prozessquelle_r as prozessquelle_id 
    from 
        afu_naturgefahren_v1.befundbergfelssturz teilprozess_bergfelssturz
    left join 
        afu_naturgefahren_v1.pq_jaehrlichkeit_bergfelssturz teilprozess_bergfelssturz_pq 
        on 
        teilprozess_bergfelssturz.pq_jaehrlichkeit_bergfelssturz_r = teilprozess_bergfelssturz_pq.t_id
    where 
        teilprozess_bergfelssturz.t_basket in (select t_id from orig_basket)
    union all 
    select 
        teilprozess_hangmure.geometrie,
        teilprozess_hangmure_pq.prozessquelle_r as prozessquelle_id 
    from 
        afu_naturgefahren_v1.befundhangmure teilprozess_hangmure
    left join 
        afu_naturgefahren_v1.pq_jaehrlichkeit_hangmure teilprozess_hangmure_pq 
        on 
        teilprozess_hangmure.pq_jaehrlichkeit_hangmure_r = teilprozess_hangmure_pq.t_id
    where 
        teilprozess_hangmure.t_basket in (select t_id from orig_basket)
    union all 
    select 
        teilprozess_permanentrutschung.geometrie,
        teilprozess_permanentrutschung.prozessquelle_r as prozessquelle_id 
    from 
        afu_naturgefahren_v1.befundpermanenterutschung teilprozess_permanentrutschung
    where 
        teilprozess_permanentrutschung.t_basket in (select t_id from orig_basket)
    union all 
    select 
        teilprozess_spontanerutschung.geometrie,
        teilprozess_spontanerutschung_pq.prozessquelle_r as prozessquelle_id 
    from 
        afu_naturgefahren_v1.befundspontanerutschung teilprozess_spontanerutschung
    left join 
        afu_naturgefahren_v1.pq_jaehrlichkeit_spontanerutschung teilprozess_spontanerutschung_pq 
        on 
        teilprozess_spontanerutschung.pq_jaehrlichkeit_spontanerutschung_r = teilprozess_spontanerutschung_pq.t_id
    where 
        teilprozess_spontanerutschung.t_basket in (select t_id from orig_basket)
    union all 
    select 
        teilprozess_steinblockschlag.geometrie,
        teilprozess_steinblockschlag_pq.prozessquelle_r as prozessquelle_id 
    from 
        afu_naturgefahren_v1.befundsteinblockschlag teilprozess_steinblockschlag
    left join 
        afu_naturgefahren_v1.pq_jaehrlichkeit_steinblockschlag teilprozess_steinblockschlag_pq 
        on 
        teilprozess_steinblockschlag.pq_jaehrlichkeit_steinblockschlag_r = teilprozess_steinblockschlag_pq.t_id 
    where 
        teilprozess_steinblockschlag.t_basket in (select t_id from orig_basket)
    union all 
    select 
        teilprozess_uebermurung.geometrie,
        teilprozess_uebermurung.prozessquelle_r as prozessquelle_id 
    from 
        afu_naturgefahren_v1.befunduebermurung teilprozess_uebermurung
    where 
        teilprozess_uebermurung.t_basket in (select t_id from orig_basket)
    union all 
    select 
        teilprozess_ueberschwemmungdynamisch.geometrie,
        teilprozess_ueberschwemmungdynamisch.prozessquelle_r as prozessquelle_id 
    from 
        afu_naturgefahren_v1.befundueberschwemmungdynamisch teilprozess_ueberschwemmungdynamisch 
    where 
        teilprozess_ueberschwemmungdynamisch.t_basket in (select t_id from orig_basket)
    union all 
    select 
        teilprozess_ueberschwemmungstatisch.geometrie,
        teilprozess_ueberschwemmungstatisch.prozessquelle_r as prozessquelle_id 
    from 
        afu_naturgefahren_v1.befundueberschwemmungstatisch teilprozess_ueberschwemmungstatisch
    where 
        teilprozess_ueberschwemmungstatisch.t_basket in (select t_id from orig_basket)
),

dokumente_union as (
select distinct 
    basket.t_id as t_basket, 
    gemeinden.bfs_gemeindenummer as gemeinde_bfsnr, 
    gemeinden.gemeindename as gemeinde_name,
    jsonb_build_object('@type', 'SO_AFU_Naturgefahren_Kernmodell_20231016.Naturgefahren.Dokument',
                      'Titel', berichte.titel, 
                      'Dateiname', berichte.dateiname, 
                      'Link', berichte.link, 
                      'Hauptprozesse', berichte.hauptprozess, 
                      'Jahr', berichte.jahr
                      ) as dokumente,
    gemeinden.geometrie,
    berichte.jahr::text as jahr
from 
    basket,
    teilprozesse befund
left join 
    afu_naturgefahren_v1.prozessquelle prozessquelle 
    on 
    befund.prozessquelle_id = prozessquelle.t_id
left join 
    berichte 
    on 
    berichte.teilauftrag_tid = prozessquelle.teilauftrag_r
left join 
    gemeinden 
    on 
    st_dwithin(befund.geometrie,gemeinden.geometrie,0)
    
union all 

select distinct 
    basket.t_id as t_basket,
    alte_dokumente.gemeinde_bfsnr,
    alte_dokumente.gemeinde_name,
    alte_dokumente.dokument as dokumente,
    alte_dokumente.geometrie,
    alte_dokumente.dokument ->> 'Jahr' as jahr
from 
    basket,
    afu_naturgefahren_alte_dokumente_v1.alte_dokumente alte_dokumente
)

INSERT INTO afu_naturgefahren_staging_v1.dokumente_pro_gemeinde (
    t_basket, 
    gemeinde_bfsnr, 
    gemeinde_name, 
    dokumente, 
    geometrie
)

select 
    t_basket,
    gemeinde_bfsnr, 
    gemeinde_name,
    json_agg(dokumente order by jahr) as dokumente,
    geometrie
from 
    dokumente_union
GROUP by 
    t_basket,
    gemeinde_bfsnr,
    gemeinde_name,
    geometrie 



