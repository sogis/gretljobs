SELECT
    blockschlag.geometrie AS geometrie, 
    99 AS acode,
    'bekannte Ereignisse ausserhalb des modellierten Steinschlaggebietes' AS code_text
FROM 
    awjf_naturgefahrenhinweiskarte_v1.blockschlag
;
