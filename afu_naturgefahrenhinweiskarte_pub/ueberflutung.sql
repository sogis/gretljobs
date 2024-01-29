SELECT
    ueberflutung.geometrie, 
    ueberflutung.acode,
    CASE
        WHEN acode = 4
            THEN 'Überflutungsgebiete'
    END AS code_text
FROM 
    afu_naturgefahrenhinweiskarte_v1.ueberflutung
;
