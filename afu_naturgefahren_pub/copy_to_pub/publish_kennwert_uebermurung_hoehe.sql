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
    afu_naturgefahren_staging_v2.kennwert_uebermurung_hoehe kennwert
LEFT JOIN
    afu_naturgefahren_staging_v2.m_hoehe_typ hoehe_typ 
    ON
    kennwert.uebermurungshoehe = hoehe_typ.ilicode 
;