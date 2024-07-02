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
        case 
            when erhebungsstand = 'beurteilt' AND teilprozess NOT IN ('einsturz','absenkung')
            then 'assessed_and_complete'
            when erhebungsstand = 'beurteilt' AND teilprozess IN ('einsturz','absenkung')
            then 'assessed'
            when erhebungsstand = 'beurteilung_nicht_noetig'
            then 'assessment_not_necessary'
        end as erhebungsstand,
        teilprozess
    from 
        afu_naturgefahren_staging_v1.abklaerungsperimeter
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
        string_agg(distinct ueberschwemmung.erhebungsstand,', ') as fl_state_flooding,
        string_agg(distinct ufererosion.erhebungsstand,', ') as be_state_bank_erosion
    from 
        withpoint point
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'absenkung') absenkung 
        on 
        st_dwithin(absenkung.geometrie, point.point, 0)
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'einsturz') einsturz 
        on 
        st_dwithin(einsturz.geometrie, point.point, 0)     
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'permanente_rutschung') perm_rutschung 
        on 
        st_dwithin(perm_rutschung.geometrie, point.point, 0)  
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'hangmure') hangmure 
        on 
        st_dwithin(hangmure.geometrie, point.point, 0)  
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'spontane_rutschung') spont_rutschung 
        on 
        st_dwithin(spont_rutschung.geometrie, point.point, 0)   
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'fels_bergsturz') fels_bergsturz 
        on 
        st_dwithin(fels_bergsturz.geometrie, point.point, 0) 
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'stein_blockschlag') stein_blockschlag 
        on 
        st_dwithin(stein_blockschlag.geometrie, point.point, 0) 
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'uebermurung') murgang 
        on 
        st_dwithin(murgang.geometrie, point.point, 0) 
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'ueberschwemmung') ueberschwemmung 
        on 
        st_dwithin(ueberschwemmung.geometrie, point.point, 0) 
    left join
        (select geometrie, erhebungsstand from erhebungsgebiet_mapped where teilprozess = 'ufererosion') ufererosion 
        on 
        st_dwithin(ufererosion.geometrie, point.point, 0) 
    group by 
        id, point,poly
)

INSERT INTO 
    afu_naturgefahren_mgdm_v1.hazard_mapping_assessment_area (
        t_ili_tid,
        area, 
        data_responsibility, 
        fl_state_flooding, 
        df_state_debris_flow, 
        be_state_bank_erosion, 
        pl_state_permanent_landslide, 
        sl_state_spontaneous_landslide, 
        hd_state_hillslope_debris_flow, 
        rf_state_rock_fall, 
        rs_state_rock_slide_rock_aval, 
        if_state_ice_fall, 
        sh_state_sinkhole, 
        su_state_subsidence, 
        fa_state_flowing_avalanche, 
        pa_state_powder_avalanche, 
        gs_state_gliding_snow, 
        "comments"
)

select 
    concat('_',uuid_generate_v4(),'.so.ch')::text AS t_ili_tid,
    poly AS area,
    'SO' AS data_responsibility,
    coalesce(fl_state_flooding, 'not_assessed') as fl_state_flooding,
    coalesce(df_state_debris_flow, 'not_assessed') as df_state_debris_flow,
    coalesce(be_state_bank_erosion, 'not_assessed') AS be_state_bank_erosion,
    coalesce(pl_state_permanent_landslide, 'not_assessed') as pl_state_permanent_landslide,
    coalesce(sl_state_spontaneous_landslide, 'not_assessed') as sl_state_spontaneous_landslide,
    coalesce(hd_state_hillslope_debris_flow, 'not_assessed') as hd_state_hillslope_debris_flow,
    coalesce(rf_state_rock_fall, 'not_assessed') as rf_state_rock_fall,
    coalesce(rs_state_rock_slide_rock_aval, 'not_assessed') as rs_state_rock_slide_rock_aval,
    'not_assessed' AS if_stat_ice_fall,
    coalesce(sh_state_sinkhole, 'not_assessed') as sh_state_sinkhole,
    coalesce(su_state_subsidence,'not_assessed') as su_state_subsidence,
    'not_assessed' AS fa_state_flowing_avalanche,
    'not_assessed' AS pa_state_powder_avalanche,
    'not_assessed' AS gs_state_gliding_snow, 
    NULL AS comments

from 
    attribute_agg 
;

update afu_naturgefahren_mgdm_v1.hazard_mapping_assessment_area 
set area = st_reducePrecision(area,0.001)
;

delete from afu_naturgefahren_mgdm_v1.hazard_mapping_assessment_area 
where st_isempty(area) = true
; 



