delete from afu_naturgefahren_staging_v1.erhebungsgebiet 
;

with 
lines as (
  select 
    st_union(st_boundary(geometrie)) as geometrie
  from
    afu_naturgefahren_staging_v1.abklaerungsperimeter
)

,splited AS (
  SELECT 
    (st_dump(st_polygonize(geometrie))).geom AS geometrie
  FROM
    lines
)

,withpoint as (
    select
        ROW_NUMBER() OVER() as id, 
        geometrie as poly,
        ST_PointOnSurface(geometrie) as point
    from 
        splited
    where 
        st_area(geometrie) > 1
)

,erhebungsgebiet_mapped as (
    select 
        geometrie,
        concat('_',t_ili_tid,'.so.ch')::text AS t_ili_tid,
        erhebungsstand,
        teilprozess
    from 
        afu_naturgefahren_staging_v1.abklaerungsperimeter
)

,attribute_agg as (
    select 
        id, 
        point,
        poly,
        string_agg(distinct absenkung.erhebungsstand,', ') as status_absenkung, 
        string_agg(distinct einsturz.erhebungsstand,', ') as status_einsturz,
        string_agg(distinct perm_rutschung.erhebungsstand,', ') as status_permanente_rutschung,
        string_agg(distinct hangmure.erhebungsstand,', ') as status_hangmure,
        string_agg(distinct spont_rutschung.erhebungsstand,', ') as status_spontane_rutschung,
        string_agg(distinct fels_bergsturz.erhebungsstand,', ') as status_fels_berg_sturz,
        string_agg(distinct stein_blockschlag.erhebungsstand,', ') as status_stein_block_schlag,
        string_agg(distinct murgang.erhebungsstand,', ') as status_uebermurung,
        string_agg(distinct ueberschwemmung.erhebungsstand,', ') as status_ueberschwemmung,
        string_agg(distinct ufererosion.erhebungsstand,', ') as status_ufererosion
    from 
        withpoint point
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'ea_absenkung') absenkung 
        on 
        st_dwithin(absenkung.geometrie, point.point, 0)
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'ea_einsturz') einsturz 
        on 
        st_dwithin(einsturz.geometrie, point.point, 0)     
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'r_permanente_rutschung') perm_rutschung 
        on 
        st_dwithin(perm_rutschung.geometrie, point.point, 0)  
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'r_plo_hangmure') hangmure 
        on 
        st_dwithin(hangmure.geometrie, point.point, 0)  
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'r_plo_spontane_rutschung') spont_rutschung 
        on 
        st_dwithin(spont_rutschung.geometrie, point.point, 0)   
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 's_fels_berg_sturz') fels_bergsturz 
        on 
        st_dwithin(fels_bergsturz.geometrie, point.point, 0) 
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 's_stein_block_schlag') stein_blockschlag 
        on 
        st_dwithin(stein_blockschlag.geometrie, point.point, 0) 
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'w_uebermurung') murgang 
        on 
        st_dwithin(murgang.geometrie, point.point, 0) 
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'w_ueberschwemmung') ueberschwemmung 
        on 
        st_dwithin(ueberschwemmung.geometrie, point.point, 0) 
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'w_ufererosion') ufererosion 
        on 
        st_dwithin(ufererosion.geometrie, point.point, 0) 
    group by 
        id, point,poly
),

basket as (
     select 
         t_id,
         attachmentkey
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
)

INSERT INTO 
    afu_naturgefahren_staging_v1.erhebungsgebiet (
        t_basket,
        flaeche, 
        datenherr, 
        status_ueberschwemmung, 
        status_uebermurung, 
        status_ufererosion, 
        status_permanente_rutschung, 
        status_spontane_rutschung, 
        status_hangmure, 
        status_stein_block_schlag, 
        status_fels_berg_sturz, 
        status_einsturz, 
        status_absenkung, 
        kommentar
)
select 
    basket.t_id as t_basket,
    poly AS flaeche,
    'SO' AS datenherr,
    coalesce(status_ueberschwemmung, 'nicht_beurteilt') as fl_state_flooding,
    coalesce(status_uebermurung, 'nicht_beurteilt') as df_state_debris_flow,
    coalesce(status_ufererosion, 'nicht_beurteilt') AS be_state_bank_erosion,
    coalesce(status_permanente_rutschung, 'nicht_beurteilt') as pl_state_permanent_landslide,
    coalesce(status_spontane_rutschung, 'nicht_beurteilt') as sl_state_spontaneous_landslide,
    coalesce(status_hangmure, 'nicht_beurteilt') as hd_state_hillslope_debris_flow,
    coalesce(status_stein_block_schlag, 'nicht_beurteilt') as rf_state_rock_fall,
    coalesce(status_fels_berg_sturz, 'nicht_beurteilt') as rs_state_rock_slide_rock_aval,
    coalesce(status_einsturz, 'nicht_beurteilt') as sh_state_sinkhole,
    coalesce(status_absenkung,'nicht_beurteilt') as su_state_subsidence,
    NULL AS kommentar
from 
    attribute_agg
    ,basket
;

update afu_naturgefahren_staging_v1.erhebungsgebiet 
set flaeche = st_reducePrecision(flaeche,0.001)
;

delete from afu_naturgefahren_staging_v1.erhebungsgebiet 
where st_isempty(flaeche) = true
; 



