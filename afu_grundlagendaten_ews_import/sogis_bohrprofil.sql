SELECT 
    profil.bohrprofil_id, 
    profil.bohrung_id, 
    profil.datum, 
    profil.bemerkung, 
    profil.kote, 
    profil.endteufe, 
    profil.tektonik, 
    profil.fmfelso, 
    profil.fmeto, 
    profil.quali, 
    profil.qualibem, 
    bohrung.wkb_geometry as wkb_geometry, 
    bohrung.wkb_geometry as wkb_geometry95,
    profil.new_date, 
    profil.mut_date, 
    profil.new_usr, 
    profil.mut_usr, 
    profil.h_quali, 
    profil.h_tektonik, 
    profil.h_fmeto, 
    profil.h_fmfelso
FROM 
    bohrung."GIS_bohrprofil" profil
left join 
    bohrung."GIS_bohrung" bohrung 
    on 
    profil.bohrung_id = bohrung.bohrung_id 
;
