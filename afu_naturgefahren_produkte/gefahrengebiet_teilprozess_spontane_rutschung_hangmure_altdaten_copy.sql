with
basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
), 

attribute_mapping_hangmure as (
    SELECT 
        'r_plo_hangmure' as teilprozess, 
        case 
            when gef_stufe = 'keine' then 'nicht_gefaehrdet'
    	    when gef_stufe = 'vorhanden' then 'restgefaehrdung'
            when gef_stufe = 'gering' then 'gering'
            when gef_stufe = 'mittel' then 'mittel' 
            when gef_stufe = 'erheblich' then 'erheblich'
        end as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_hangmure 
), 

attribute_mapping_plo_rutschung as (
    SELECT 
        'r_plo_spontane_rutschung' as teilprozess, 
        case 
            when gef_stufe = 'keine' then 'nicht_gefaehrdet'
    	    when gef_stufe = 'vorhanden' then 'restgefaehrdung'
            when gef_stufe = 'gering' then 'gering'
            when gef_stufe = 'mittel' then 'mittel' 
            when gef_stufe = 'erheblich' then 'erheblich'
        end as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_spontan 
), 

union_teilprozesse as (
    select * from attribute_mapping_hangmure
    union all 
    select * from attribute_mapping_plo_rutschung
)

 select
    basket.t_id as t_basket, 
    teilprozess,
    gefahrenstufe,
    charakterisierung,
    geometrie, 
    'Altdaten' as datenherkunft,
    null as auftrag_neudaten
from 
    union_teilprozesse,
    basket basket
;
