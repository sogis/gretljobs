SELECT 
    teilprozess, 
    teilprozess_quellen.dispname as teilprozess_txt,
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v1.ufererosion ufererosion
left join 
    afu_naturgefahren_staging_v1.teilprozess_quellen teilprozess_quellen 
    on 
    ufererosion.teilprozess = teilprozess_quellen.ilicode 
;
