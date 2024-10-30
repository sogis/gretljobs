SELECT 
    hauptprozess, 
    haupt_typ.dispname as hauptprozess_txt,
    teilprozess,
    proz_quelle.dispname as teilprozess_txt, 
    gefahrenstufe, 
    gef_typ.dispname as gefahrenstufe_txt,
    charakterisierung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v2.gefahrengebiet_hauptprozess_sturz prozess
LEFT JOIN 
    afu_naturgefahren_staging_v2.hauptprozess haupt_typ
    ON 
    prozess.hauptprozess = haupt_typ.ilicode 
LEFT JOIN
    afu_naturgefahren_staging_v2.gefahrenstufe_typ gef_typ 
    ON 
    prozess.gefahrenstufe = gef_typ.ilicode 
LEFT JOIN
    afu_naturgefahren_staging_v2.teilprozess_quellen proz_quelle 
    ON 
    prozess.teilprozess = proz_quelle.ilicode 
;