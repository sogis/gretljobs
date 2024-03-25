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
left join 
    afu_naturgefahren_staging_v1.hauptprozess haupt_typ
    on 
    prozess.hauptprozess = haupt_typ.ilicode 
left join 
    afu_naturgefahren_staging_v1.gefahrenstufe_typ gef_typ 
    on 
    prozess.gefahrenstufe = gef_typ.ilicode 
