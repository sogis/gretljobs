SELECT 
    rutschung_tief.geometrie, 
    rutschung_tief.acode,
    CASE
        WHEN acode = 8
            THEN 'geringe Festigkeit / höhere Rutschneigung'
        WHEN acode = 9
            THEN 'mässige Festigkeit / geringere Rutschneigung'
    END AS code_text
FROM 
    awjf_naturgefahrenhinweiskarte_v1.rutschung_tief
;
