SELECT 
    bohrprofil.bohrprofil_id, 
    bohrprofil.bohrung_id, 
    bohrprofil.datum, 
    bohrprofil.bemerkung, 
    bohrprofil.kote, 
    bohrprofil.endteufe, 
    bohrprofil.tektonik, 
    code_tektonik.kurztext as tektonik_text,
    bohrprofil.fmfelso as felsoberflaechenformation, 
    code_fmfelso.kurztext as felsoberflaechenformation_text,
    bohrprofil.fmeto as endtiefenformation, 
    code_fmeto.kurztext as endtiefenformation_text,
    bohrprofil.quali as qualitaet,
    code_qualitaet.kurztext as qualitaet_text,
    bohrprofil.qualibem AS qualitaet_bemerkungen, 
    bohrprofil.new_date, 
    bohrprofil.mut_date, 
    bohrprofil.new_usr AS new_user, 
    bohrprofil.mut_usr AS mut_user
FROM 
    bohrung."GIS_bohrprofil" bohrprofil
left join 
    bohrung.code code_tektonik
    on
    code_tektonik.code_id = bohrprofil.tektonik
left join 
    bohrung.code code_fmfelso
    on
    code_fmfelso.code_id = bohrprofil.fmfelso 
    and 
    code_fmfelso.codetyp_id = bohrprofil.h_fmfelso 
left join 
    bohrung.code code_fmeto
    on
    code_fmeto.code_id = bohrprofil.fmeto
    and 
    code_fmeto.codetyp_id = bohrprofil.h_fmeto 
left join 
    bohrung.code code_qualitaet
    on
    code_qualitaet.code_id = bohrprofil.quali
    and 
    code_qualitaet.codetyp_id = bohrprofil.h_quali 
;
