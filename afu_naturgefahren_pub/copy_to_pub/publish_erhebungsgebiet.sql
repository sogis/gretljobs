SELECT 
    teilprozess, 
    quelle.dispname as teilprozess_txt,
    erhebungsstand, 
    beurteilung.dispname as erhebungsstand_txt,
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v1.erhebungsgebiet erhebungsgebiet
left join 
    afu_naturgefahren_staging_v1.teilprozess_quellen quelle
    on 
    erhebungsgebiet.teilprozess = quelle.ilicode 
left join 
    afu_naturgefahren_staging_v1.beurteilung_einfach_typ beurteilung 
    on 
    erhebungsgebiet.erhebungsstand = beurteilung.ilicode
