SELECT
    rutschung_lockergestein.geometrie, 
    rutschung_lockergestein.acode,
    CASE
        WHEN acode = 32
            THEN 'übrige Rutschgebiete'
        WHEN acode = 33
            THEN 'Schutzgüter betroffen'
    END AS code_text
FROM 
   awjf_naturgefahrenhinweiskarte_v1.rutschung_lockergestein
;
