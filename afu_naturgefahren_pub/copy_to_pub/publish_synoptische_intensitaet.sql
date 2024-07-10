SELECT 
    teilprozess,
    syn_typ.dispname as teilprozess_txt,
    jaehrlichkeit, 
    intensitaet, 
    int_typ.dispname as intensitaet_txt,
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v1.synoptische_intensitaet syn_intens 
LEFT JOIN
    afu_naturgefahren_staging_v1.teilprozess_synoptisch syn_typ 
    ON 
    syn_intens.teilprozess = syn_typ.ilicode 
LEFT JOIN
    afu_naturgefahren_staging_v1.intensitaet_typ int_typ
    ON
    syn_intens.intensitaet = int_typ.ilicode 
;