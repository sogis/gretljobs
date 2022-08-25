SELECT 
    standort_id, 
    bezeichnung, 
    bemerkung, 
    gemeinde, 
    gbnummer, 
    new_date, 
    mut_date, 
    new_usr as new_user, 
    mut_usr as mut_user, 
    freigabe_afu, 
    afu_usr as afu_user, 
    afu_date
FROM 
    bohrung.standort standort
;
