SELECT 
    standort_id AS t_id, 
    bezeichnung, 
    bemerkung, 
    gemeinde, 
    gbnummer, 
    new_date, 
    mut_date, 
    freigabe_afu, 
    afu_date
FROM 
    bohrung."GIS_standort" standort
;
