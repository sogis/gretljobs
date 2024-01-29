SELECT
    uebersarung.geometrie,
    uebersarung.acode,
    CASE
        WHEN acode = 3
            THEN 'Übersarung /Schwemmkegel'
    END AS code_text
FROM 
    afu_naturgefahrenhinweiskarte_v1.uebersarung
;
