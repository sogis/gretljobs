SELECT 
    jaehrlichkeit, 
    fliessgeschwindigkeit, 
    gesch_typ.dispname as fliessgeschwindigkeit_txt,
    prozessquelle, 
    bemerkung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v2.kennwert_uebermurung_geschwindigkeit kennwert
LEFT JOIN
    afu_naturgefahren_staging_v2.m_geschwindigkeit_typ gesch_typ 
    ON 
    kennwert.fliessgeschwindigkeit = gesch_typ.ilicode 
;