SELECT 
    teilprozess, 
    quelle.dispname as teilprozess_txt,
    erhebungsstand, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v2.abklaerungsperimeter abklaerungsperimeter
LEFT JOIN
    afu_naturgefahren_staging_v2.teilprozess_quellen quelle
    ON 
    abklaerungsperimeter.teilprozess = quelle.ilicode 
;