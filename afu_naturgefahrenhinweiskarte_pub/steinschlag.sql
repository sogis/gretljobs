SELECT
    steinschlag.geometrie, 
    steinschlag.acode,
    CASE
        WHEN acode = 6
            THEN 'übrige Steinschlaggebiete'
        WHEN acode = 7
            THEN 'Schutzgüter betroffen'
    END AS code_text
FROM 
    afu_naturgefahrenhinweiskarte_v1.steinschlag
;
