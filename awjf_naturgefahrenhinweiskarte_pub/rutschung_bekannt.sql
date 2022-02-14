SELECT
    bekannte_rutschung.geometrie, 
    bekannte_rutschung.acode,
    CASE
        WHEN acode = 10
            THEN 'aus diversen Quellen bekannte aktive oder nichtaktive Rutschgebiete'
    END AS code_text
FROM 
    awjf_naturgefahrenhinweiskarte_v1.rutschung_bekannt AS bekannte_rutschung
;
