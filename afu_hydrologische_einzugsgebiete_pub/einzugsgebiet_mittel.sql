SELECT 
    geometrie, 
    aobjectid, 
    einzugsgebietsnummer, 
    teileinzugsgebietsnummer, 
    flaeche,
    replace(color, ' ', ',')||',50' AS color
FROM 
    afu_hydrologische_einzugsgebiete_v1.einzugsgebiet_mittel
;
