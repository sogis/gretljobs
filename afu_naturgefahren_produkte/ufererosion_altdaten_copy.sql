 with basket as (
     select 
         t_id,
         attachmentkey
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 )

SELECT 
    basket.t_id as t_basket, 
    'w_ufererosion' as teilprozess, 
    st_multi(geometrie) as geometrie, 
    'Altdaten' as datenherkunft, 
    null as auftrag_neudaten
FROM 
    afu_gefahrenkartierung.gefahrenkartirung_gk_wasser wasser,
    basket 
where 
    prozessa = 'Ufererosion'
;