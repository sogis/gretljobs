with 
basket as (
    select 
        t_id 
    from 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

select 
    basket.t_id as t_basket,
    case 
	        when gef_stufe = 'keine' then 'nicht_gefaehrdet'
        	when gef_stufe = 'vorhanden' then 'restgefaehrdung'
        	when gef_stufe = 'gering' then 'gering'
        	when gef_stufe = 'mittel' then 'mittel' 
        	when gef_stufe = 'erheblich' then 'erheblich'
    end as gefahrenstufe, 
    replace(replace(synoptisch.aindex, '_', ''),',',' ') as charakterisierung,
    st_multi(geometrie) as geometrie,
    'Altdaten' as datenherkunft,
    null as auftrag_neudaten   
from 
    basket,
    afu_gefahrenkartierung.gefahrenkartirung_gk_synoptisch_generiert synoptisch
where 
    synoptisch.aindex is not null 