SELECT 
    jaehrlichkeit, 
    ueberschwemmung_tiefe, 
    ueberflutungshoehe.dispname as ueberschwemmung_tiefe_txt,
    prozessquelle_neudaten, 
    geometrie, 
    datenherkunft, 
    auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v1.fliesstiefen fliesstiefen
left join 
    afu_naturgefahren_staging_v1.ueberflutungshoehe_wasser ueberflutungshoehe
    on 
    fliesstiefen.ueberschwemmung_tiefe = ueberflutungshoehe.ilicode 
