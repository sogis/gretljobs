SELECT 
    bohrung_id, 
    standort_id, 
    bezeichnung, 
    bemerkung, 
    datum, 
    durchmesserbohrloch, 
    ablenkung, 
    quali, 
    qualibem, 
    new_date, 
    quelleref, 
    mut_date, 
    new_usr, 
    mut_usr, 
    h_quali, 
    h_ablenkung
FROM 
    bohrung."GIS_bohrung"
where 
    wkb_geometry is not NULL
;
