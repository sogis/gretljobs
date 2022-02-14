SELECT
    uebersarung.geometrie,
    uebersarung.acode,
    CASE
        WHEN acode = 3
            THEN 'Übersarung /Schwemmkegel'
    END AS code_text
FROM 
    awjf_naturgefahrenhinweiskarte_v1.uebersarung
;
