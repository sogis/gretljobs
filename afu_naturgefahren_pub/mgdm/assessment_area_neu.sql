with 
lines as (
  select 
    st_union(st_boundary(geometrie)) as geometrie
  from
    afu_naturgefahren_staging_v1.erhebungsgebiet 
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
        case 
        	when erhebungsstand = 'beurteilt'
        	then 'assessed'
        	when erhebungsstand = 'beurteilung_nicht_noetig'
        	then 'assessment_not_necessary'
        end as erhebungsstand,
        teilprozess
    from 
        afu_naturgefahren_staging_v1.erhebungsgebiet
)
        

,attribute_agg as (
    select 
        id, 
        point,
        poly,
        string_agg(distinct absenkung.erhebungsstand,', ') as su_state_subsidence, 
        string_agg(distinct einsturz.erhebungsstand,', ') as sh_state_sinkhole,
        string_agg(distinct perm_rutschung.erhebungsstand,', ') as pl_state_permanent_landslide,
        string_agg(distinct hangmure.erhebungsstand,', ') as hd_state_hillslope_debris_flow,
        string_agg(distinct spont_rutschung.erhebungsstand,', ') as sl_state_spontaneous_landslide,
        string_agg(distinct fels_bergsturz.erhebungsstand,', ') as rs_state_rock_slide_rock_aval,
        string_agg(distinct stein_blockschlag.erhebungsstand,', ') as rf_state_rock_fall,
        string_agg(distinct murgang.erhebungsstand,', ') as df_state_debris_flow,
        string_agg(distinct ueberschwemmung.erhebungsstand,', ') as fl_state_flooding
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
    group by 
        id, point,poly
)

select 
    id, 
    poly,
    coalesce(su_state_subsidence,'not_assessed') as su_state_subsidence,
    coalesce(sh_state_sinkhole, 'not_assessed') as sh_state_sinkhole,
    coalesce(pl_state_permanent_landslide, 'not_assessed') as pl_state_permanent_landslide,
    coalesce(hd_state_hillslope_debris_flow, 'not_assessed') as hd_state_hillslope_debris_flow,
    coalesce(sl_state_spontaneous_landslide, 'not_assessed') as sl_state_spontaneous_landslide,
    coalesce(rs_state_rock_slide_rock_aval, 'not_assessed') as rs_state_rock_slide_rock_aval,
    coalesce(rf_state_rock_fall, 'not_assessed') as rf_state_rock_fall,
    coalesce(df_state_debris_flow, 'not_assessed') as df_state_debris_flow,
    coalesce(fl_state_flooding, 'not_assessed') as fl_state_flooding
from 
    attribute_agg 
