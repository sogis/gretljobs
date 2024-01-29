SELECT
    blockschlag.geometrie AS geometrie, 
    99 AS acode,
    'bekannte Ereignisse ausserhalb des modellierten Steinschlaggebietes' AS code_text
FROM 
    afu_naturgefahrenhinweiskarte_v1.blockschlag
;
