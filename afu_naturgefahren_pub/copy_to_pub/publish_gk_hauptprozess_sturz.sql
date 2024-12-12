SELECT 
    prozess.hauptprozess, 
    haupt_typ.dispname AS hauptprozess_txt,
    teilprozess_txt_agg.beschreibungen AS teilprozess,    
    prozess.gefahrenstufe, 
    gef_typ.dispname AS gefahrenstufe_txt,
    prozess.charakterisierung, 
    prozess.geometrie, 
    prozess.datenherkunft, 
    prozess.auftrag_neudaten
FROM 
    afu_naturgefahren_staging_v2.gefahrengebiet_hauptprozess_sturz AS prozess
LEFT JOIN 
    afu_naturgefahren_staging_v2.hauptprozess AS haupt_typ
    ON prozess.hauptprozess = haupt_typ.ilicode 
LEFT JOIN 
    afu_naturgefahren_staging_v2.gefahrenstufe_typ AS gef_typ 
    ON prozess.gefahrenstufe = gef_typ.ilicode 
LEFT JOIN 
    LATERAL (
        SELECT STRING_AGG(proz_quelle.dispname, ', ') AS beschreibungen
        FROM UNNEST(STRING_TO_ARRAY(prozess.teilprozess, ', ')) AS wert
        LEFT JOIN afu_naturgefahren_staging_v2.teilprozess_quellen AS proz_quelle 
        ON wert = proz_quelle.ilicode
    ) AS teilprozess_txt_agg ON TRUE;