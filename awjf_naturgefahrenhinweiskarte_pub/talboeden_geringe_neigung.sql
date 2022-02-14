SELECT 
    talboden.geometrie, 
    talboden.acode,
    CASE
        WHEN acode = 5
            THEN 'sehr flache Talböden ausserhalb der modellierten Überflutungsbereiche: Überflutung kann nicht ausgeschlossen werden'
    END AS code_text
FROM 
    awjf_naturgefahrenhinweiskarte_v1.talboeden_geringe_neigung AS talboden
;
