with
basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
), 

attribute_mapping as (
    SELECT 
        'r_permanente_rutschung' as teilprozess, 
        gef_stufe as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie --Im neuen Modell sind Multi-Polygone
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_kont_sackung
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
;
