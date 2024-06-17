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
    afu_naturgefahren_staging_v1.kennwert_uebermurung_geschwindigkeit kennwert
left join 
    afu_naturgefahren_staging_v1.m_geschwindigkeit_typ gesch_typ 
    on 
    kennwert.fliessgeschwindigkeit = gesch_typ.ilicode 
;
