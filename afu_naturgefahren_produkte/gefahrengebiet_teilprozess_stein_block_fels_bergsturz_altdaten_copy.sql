with
basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
), 

attribute_mapping as (
    SELECT 
        case 
        	when prozessa = 'Stein_Blockschlag'
        	then 's_stein_block_schlag'
        	when prozessa = 'Felssturz'
        	then 's_fels_berg_sturz'
        	else null 
        end as teilprozess, 
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
        afu_gefahrenkartierung.gefahrenkartirung_gk_sturz
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
    attribute_mapping,
    basket basket
where 
    teilprozess is not null 
;
