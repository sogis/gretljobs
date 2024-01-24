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
    'Neudaten' as datenherkunft, 
    basket.attachmentkey as auftrag_neudaten
FROM 
    afu_naturgefahren_v1.befundufererosion ufererosion,
    basket 
;