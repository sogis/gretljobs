SELECT 
    hauptprozess, 
    gefahrenstufe, 
    charakterisierung, 
    teilprozess,
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v1.gefahrengebiet_hauptprozess_rutschung
;