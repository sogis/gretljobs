delete from afu_naturgefahren_staging_v1.abklaerungsperimeter
;

INSERT INTO afu_naturgefahren_staging_v1.abklaerungsperimeter (
    teilprozess, 
    erhebungsstand, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
)

SELECT 
    teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_rutschung

    union all 
    
SELECT 
    teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_sturz
    
    union all 
    
SELECT 
    teilprozess, 
    erhebungsstand,
    geometrie, 
    'Neudaten' as datenherkunft, 
    NULL as auftrag_neudaten
from 
    afu_naturgefahren_beurteilungsgebiet_v1.erhebungsgebiet_wasser
;

