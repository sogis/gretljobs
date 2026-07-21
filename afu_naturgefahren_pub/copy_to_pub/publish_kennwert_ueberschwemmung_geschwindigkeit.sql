SELECT 
    jaehrlichkeit, 
    fliessgeschwindigkeit, 
    fliessgesch_typ.dispname as fliessgeschwindigkeit_txt,
    prozessquelle, 
    bemerkung, 
    st_makevalid(geometrie) AS geometrie, --workaround weil immer wieder komische Shell-Fehler auftraten
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v2.kennwert_ueberschwemmung_geschwindigkeit kennwert
LEFT JOIN
    afu_naturgefahren_staging_v2.ue_fliessgeschwindigkeit_typ fliessgesch_typ 
    ON
    kennwert.fliessgeschwindigkeit = fliessgesch_typ.ilicode 
;