SELECT 
    jaehrlichkeit, 
    uebermurungshoehe, 
    hoehe_typ.dispname as uebermurungshoehe_txt,
    prozessquelle, 
    bemerkung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v1.kennwert_uebermurung_hoehe kennwert
left join 
    afu_naturgefahren_staging_v1.m_hoehe_typ hoehe_typ 
    on 
    kennwert.uebermurungshoehe = hoehe_typ.ilicode 
;
