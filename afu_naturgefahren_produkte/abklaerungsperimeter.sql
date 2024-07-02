delete from afu_naturgefahren_staging_v1.abklaerungsperimeter
;

with basket as (
     select 
         t_id,
         attachmentkey
     from 
         afu_naturgefahren_staging_v1.t_ili2db_basket
)
 
INSERT INTO afu_naturgefahren_staging_v1.abklaerungsperimeter (
    t_basket,
    teilprozess, 
    erhebungsstand, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    basket.t_id as t_basket,
    'absenkung' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_absenkung
    ,basket

    union all 
    
SELECT 
    basket.t_id as t_basket,
    'einsturz' as teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_einsturz
    ,basket
    
    union all 
    
SELECT 
    basket.t_id as t_basket,
    'fels_bergsturz' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_fels_berg_sturz
    ,basket
    
    union all 
    
SELECT 
    basket.t_id as t_basket,
    'hangmure' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_hangmure
    ,basket
    
    union all 
    
SELECT 
    basket.t_id as t_basket,
    'permanente_rutschung' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_permanente_rutschung
    ,basket
    
    union all 
    
SELECT 
    basket.t_id as t_basket,
    'spontane_rutschung' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_spontane_rutschung
    ,basket
    
    union all 
    
SELECT 
    basket.t_id as t_basket,
    'stein_blockschlag' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_stein_block_schlag
    ,basket
    
    union all 
    
SELECT 
    basket.t_id as t_basket,
    'uebermurung' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_uebermurung
    ,basket
    
    union all 
    
SELECT 
    basket.t_id as t_basket,
    'ueberschwemmung' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_ueberschwemmung
    ,basket
    
    union all 
    
SELECT 
    basket.t_id as t_basket,
    'ufererosion' AS teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_ufererosion
    ,basket
;



