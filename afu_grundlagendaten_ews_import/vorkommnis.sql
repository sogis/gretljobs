SELECT 
    vorkommnis.vorkommnis_id AS t_id,
    vorkommnis.typ AS vorkommnis_code, 
    code_typ.kurztext as vorkommnis_text,
    CASE 
        WHEN vorkommnis.tiefe = '-9999'
        THEN NULL 
        ELSE vorkommnis.tiefe 
    END AS tiefe, 
    vorkommnis.bemerkung, 
    vorkommnis.quali as qualitaet_code,
    code_qualitaet.kurztext as qualitaet_text,
    vorkommnis.qualibem as qualitaet_bemerkung, 
    vorkommnis.new_date, 
    vorkommnis.mut_date, 
    vorkommnis.bohrprofil_id AS profil
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
