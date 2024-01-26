with 
basket as (
    select 
        t_id 
    from 
        afu_naturgefahren_staging_v1.t_ili2db_basket
)

select 
    basket.t_id as t_basket,
    synoptisch.gef_stufe as gefahrenstufe,
    replace(replace(synoptisch.aindex, '_', ''),',',' ') as charakterisierung,
    st_multi(geometrie) as geometrie,
    'Altdaten' as datenherkunft,
    null as auftrag_neudaten   
from 
    basket,
    afu_gefahrenkartierung.gefahrenkartirung_gk_synoptisch_generiert synoptisch
where 
    synoptisch.aindex is not null 