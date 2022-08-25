SELECT 
    vorkommnis.vorkommnis_id, 
    vorkommnis.bohrprofil_id, 
    vorkommnis.typ, 
    code_typ.kurztext as typ_text,
    vorkommnis.tiefe, 
    vorkommnis.bemerkung, 
    vorkommnis.quali as qualitaet,
    code_qualitaet.kurztext as qualitaet_text,
    vorkommnis.qualibem as qualitaet_bemerkung, 
    vorkommnis.new_date, 
    vorkommnis.mut_date, 
    vorkommnis.new_usr as new_user, 
    vorkommnis.mut_usr as mut_user
FROM 
    bohrung.vorkommnis vorkommnis
left join 
    bohrung.code code_typ 
    on 
    code_typ.code_id = vorkommnis.typ 
    and 
    code_typ.codetyp_id = vorkommnis.h_typ 
left join 
    bohrung.code code_qualitaet 
    on 
    code_qualitaet.code_id = vorkommnis.quali 
    and 
    code_qualitaet.codetyp_id = vorkommnis.h_quali 
;
