SELECT 
    hauptprozess, 
    haupt_typ.dispname as hauptprozess_txt,
    gefahrenstufe, 
    gef_typ.dispname as gefahrenstufe_txt,
    charakterisierung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_wasser prozess
LEFT JOIN
    afu_naturgefahren_staging_v1.hauptprozess haupt_typ
    ON 
    prozess.hauptprozess = haupt_typ.ilicode 
LEFT JOIN
    afu_naturgefahren_staging_v1.gefahrenstufe_typ gef_typ 
    ON 
    prozess.gefahrenstufe = gef_typ.ilicode 
;