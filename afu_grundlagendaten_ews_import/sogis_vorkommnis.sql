SELECT 
    vorkommnis.vorkommnis_id, 
    vorkommnis.bohrprofil_id, 
    vorkommnis.typ, 
    vorkommnis.tiefe, 
    vorkommnis.bemerkung, 
    vorkommnis.new_date, 
    vorkommnis.mut_date, 
    vorkommnis.new_usr, 
    vorkommnis.mut_usr, 
    vorkommnis.quali, 
    vorkommnis.qualibem, 
    vorkommnis.h_quali, 
    vorkommnis.h_typ
FROM 
    bohrung."GIS_vorkommnis" vorkommnis 
left join 
    bohrung."GIS_bohrprofil" profil 
    on 
    vorkommnis.bohrprofil_id = profil.bohrprofil_id 
left join 
    bohrung."GIS_bohrung" gis_bohrung 
    on 
    profil.bohrung_id = gis_bohrung.bohrung_id 
where 
    gis_bohrung.wkb_geometry is not NULL
;
