SELECT
    murgang.geometrie, 
    murgang.acode,
    CASE
        WHEN acode = 1
            THEN 'Übrige Murganggebiete'
        WHEN acode = 2
            THEN 'Schutzgüter betroffen'
    END AS code_text
FROM 
    awjf_naturgefahrenhinweiskarte_v1.murgang
;
