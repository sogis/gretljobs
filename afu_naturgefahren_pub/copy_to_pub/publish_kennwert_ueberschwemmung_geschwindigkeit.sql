SELECT 
    jaehrlichkeit, 
    fliessgeschwindigkeit, 
    fliessgesch_typ.dispname as fliessgeschwindigkeit_txt,
    prozessquelle, 
    bemerkung, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v1.kennwert_ueberschwemmung_geschwindigkeit kennwert
LEFT JOIN
    afu_naturgefahren_staging_v1.ue_fliessgeschwindigkeit_typ fliessgesch_typ 
    ON
    kennwert.fliessgeschwindigkeit = fliessgesch_typ.ilicode 
;