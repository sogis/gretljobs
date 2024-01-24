with
basket as (
     select 
         t_id 
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
), 

attribute_mapping_hangmure as (
    SELECT 
        basket.t_id as t_basket,
        'rutschung' as hauptprozess, 
        gef_stufe as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie, --Im neuen Modell sind Multi-Polygone
        'Altdaten' as datenherkunft, 
        null as auftrag_neudaten
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_hangmure, 
        basket
), 

attribute_mapping_plo_rutschung as (
    SELECT 
        basket.t_id as t_basket,
        'rutschung' as hauptprozess,
        gef_stufe as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie, --Im neuen Modell sind Multi-Polygone
        'Altdaten' as datenherkunft, 
        null as auftrag_neudaten
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_spontan,
        basket
),

attribute_mapping_perm_rutschung as (
    SELECT 
        basket.t_id as t_basket,
        'rutschung' as hauptprozess,
        gef_stufe as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie, --Im neuen Modell sind Multi-Polygone
        'Altdaten' as datenherkunft, 
        null as auftrag_neudaten
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_rutsch_kont_sackung,
        basket
),

union_teilprozesse_rutschung as (
    select * from attribute_mapping_hangmure
    union all 
    select * from attribute_mapping_plo_rutschung
    union all 
    select * from attribute_mapping_plo_rutschung
), 

attribute_mapping_sturz as (
    SELECT 
        basket.t_id as t_basket,
        'sturz' as hauptprozess,
        gef_stufe as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie, --Im neuen Modell sind Multi-Polygone
        'Altdaten' as datenherkunft, 
        null as auftrag_neudaten
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_sturz,
        basket
),

attribute_mapping_wasser as (
    SELECT 
        basket.t_id as t_basket,
        'wasser' as hauptprozess,
        gef_stufe as gefahrenstufe, 
        replace(aindex, '_', '') as charakterisierung, 
        st_multi(geometrie) as geometrie, --Im neuen Modell sind Multi-Polygone
        'Altdaten' as datenherkunft, 
        null as auftrag_neudaten
    FROM 
        afu_gefahrenkartierung.gefahrenkartirung_gk_wasser,
        basket
)

select * from union_teilprozesse_rutschung
union all 
select * from attribute_mapping_sturz
union all 
select * from attribute_mapping_wasser

