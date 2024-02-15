delete from afu_naturgefahren_staging_v1.erhebungsgebiet 
;
 
with basket as (
     select 
         t_id,
         attachmentkey
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
 )

INSERT INTO afu_naturgefahren_staging_v1.erhebungsgebiet (
    t_basket, 
    teilprozess, 
    erhebungsstand, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id as t_basket, 
    teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    basket.attachmentkey as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_rutschung,
    basket

    union all 
    
SELECT 
    basket.t_id as t_basket, 
    teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    basket.attachmentkey as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_sturz,
    basket
    
    union all 
    
SELECT 
    basket.t_id as t_basket, 
    teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    basket.attachmentkey as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_wasser,
    basket
;
