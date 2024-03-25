-- ACHTUNG: NEUES DATASET UND BASKET MÜSSEN ANGELEGT WORDEN SEIN!!! 

delete from afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_spontane_rutschung
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

teilprozess_spontanrutschung as ( 
    select 
       'r_plo_spontane_rutschung' as teilprozess,
        case when 
             (string_to_array(iwcode, '_'))[1] = 'gelb' then 'gering' 
             when
             (string_to_array(iwcode, '_'))[1] = 'blau' then 'mittel' 
             when
             (string_to_array(iwcode, '_'))[1] = 'rot' then 'erheblich'
        end as gefahrenstufe,
        case when 
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '30' then 3
             when
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '100' then 2
             when
             (string_to_array(iwcode, '_'))[2] = 'schwach' and (string_to_array(iwcode, '_'))[3] = '300' then 1
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '30' then 6
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '100' then 5
             when 
             (string_to_array(iwcode, '_'))[2] = 'mittel' and (string_to_array(iwcode, '_'))[3] = '300' then 4
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '30' then 9
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '100' then 8
             when 
             (string_to_array(iwcode, '_'))[2] = 'stark' and (string_to_array(iwcode, '_'))[3] = '300' then 7  
        end as charakterisierung,
        geometrie, 
        'Neudaten' as datenherkunft,
        basket.attachmentkey as auftrag_neudaten
    from 
        afu_naturgefahren_v1.befundspontanerutschung befund
    left join
        afu_naturgefahren_v1.t_ili2db_basket basket
        on 
        befund.t_basket = basket.t_id 
    where 
        befund.t_basket in (select t_id from orig_basket)
)

,teilprozess_spontanrutschung_priorisiert as (
    select 
        teilprozess,
        gefahrenstufe,
        charakterisierung,
        geometrie,
        datenherkunft,
        auftrag_neudaten,
        CASE 
		    WHEN gefahrenstufe = 'restgefaehrdung' then 0 
		    WHEN gefahrenstufe = 'gering' then 10 
		    WHEN gefahrenstufe = 'mittel' then 20 
		    WHEN gefahrenstufe = 'erheblich' then 30
		end + charakterisierung as prio
    from 
        teilprozess_spontanrutschung
)

,teilprozess_spontanrutschung_prio as (
    SELECT 
        a.teilprozess,
        a.gefahrenstufe,
        a.charakterisierung,
        ST_Multi(COALESCE(
            ST_Difference(a.geometrie, blade.geometrie),
            a.geometrie
        )) AS geometrie, 
        a.datenherkunft,
        a.auftrag_neudaten
    FROM  
        teilprozess_spontanrutschung_priorisiert AS a
    CROSS JOIN LATERAL (
        SELECT 
            ST_Union(geometrie) AS geometrie
        FROM   
            teilprozess_spontanrutschung_priorisiert AS b
        WHERE 
            a.geometrie && b.geometrie 
            and 
            a.prio < b.prio              
    ) AS blade
),

teilprozess_spontanrutschung_union as (
    select 
        teilprozess,
        gefahrenstufe,
        charakterisierung,
        st_union(geometrie) as geometrie,
        datenherkunft,
        auftrag_neudaten
    from 
        teilprozess_spontanrutschung_prio
    group by 
        teilprozess,
        gefahrenstufe,
        charakterisierung,
        datenherkunft,
        auftrag_neudaten
),

teilprozess_spontanrutschung_dump as (
    select 
        teilprozess,
        gefahrenstufe,
        charakterisierung,
        st_multi((st_dump(geometrie)).geom) as geometrie,
        datenherkunft,
        auftrag_neudaten
    from 
        teilprozess_spontanrutschung_union
), 

 basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 )

INSERT INTO afu_naturgefahren_staging_v1.gefahrengebiet_teilprozess_spontane_rutschung (
    t_basket, 
    teilprozess, 
    gefahrenstufe, 
    charakterisierung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

select
    basket.t_id as t_basket, 
    teilprozess,
    gefahrenstufe as gefahrenstufe,
    'H'||charakterisierung as charakterisierung,
    geometrie, 
    datenherkunft,
    auftrag_neudaten
from 
    teilprozess_spontanrutschung_dump, 
    basket
where 
    st_isempty(geometrie) is not true 
;





