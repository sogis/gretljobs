SELECT 
    teilprozess, 
    quelle.dispname as teilprozess_txt,
    erhebungsstand, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v1.abklaerungsperimeter abklaerungsperimeter
left join 
    afu_naturgefahren_staging_v1.teilprozess_quellen quelle
    on 
    abklaerungsperimeter.teilprozess = quelle.ilicode 

