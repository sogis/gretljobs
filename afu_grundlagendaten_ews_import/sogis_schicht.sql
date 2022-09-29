SELECT 
    schicht.schicht_id, 
    schicht.bohrprofil_id, 
    schicht.schichten_id, 
    schicht.tiefe, 
    CASE 
        WHEN schicht.quali IS NULL 
        THEN 167 -- 161 = noData
        ELSE schicht.quali
    END AS quali, 
    schicht.qualibem, 
    schicht.bemerkung, 
    schicht.new_date, 
    schicht.mut_date, 
    schicht.new_usr, 
    schicht.mut_usr, 
    CASE 
        WHEN schicht.h_quali IS NULL 
        THEN 11 
        ELSE schicht.h_quali
    END AS h_quali
FROM 
    bohrung."GIS_schicht" schicht
left join 
    bohrung."GIS_bohrprofil" profil 
    on 
    schicht.bohrprofil_id = profil.bohrprofil_id 
left join 
    bohrung."GIS_bohrung" gis_bohrung 
    on 
    profil.bohrung_id = gis_bohrung.bohrung_id 
where 
    gis_bohrung.wkb_geometry is not NULL
;
