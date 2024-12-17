SELECT 
    teilprozess,
    proz_quelle.dispname as teilprozess_txt,
    gefahrenstufe, 
    gef_typ.dispname as gefahrenstufe_txt,
    charakterisierung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v2.gefahrengebiet_teilprozess_stein_blockschlag prozess
LEFT JOIN
    afu_naturgefahren_staging_v2.gefahrenstufe_typ gef_typ 
    ON 
    prozess.gefahrenstufe = gef_typ.ilicode 
LEFT JOIN
    afu_naturgefahren_staging_v2.teilprozess_quellen proz_quelle 
    ON 
    prozess.teilprozess = proz_quelle.ilicode 
;