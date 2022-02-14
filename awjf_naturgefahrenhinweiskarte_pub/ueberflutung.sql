SELECT
    ueberflutung.geometrie, 
    ueberflutung.acode,
    CASE
        WHEN acode = 4
            THEN 'Überflutungsgebiete'
    END AS code_text
FROM 
    awjf_naturgefahrenhinweiskarte_v1.ueberflutung
;
