SELECT 
    bohrung.bohrung_id, 
    bohrung.standort_id, 
    bohrung.bezeichnung, 
    bohrung.bemerkung, 
    bohrung.datum, 
    bohrung.durchmesserbohrloch, 
    bohrung.ablenkung,
    code_ablenkung.kurztext as ablenkung_text,
    bohrung.quali as qualitaet, 
    code_qualitaet.kurztext as qualitaet_text,
    bohrung.qualibem as qualitaet_bemerkung, 
    bohrung.new_date, 
    bohrung.quelleref as quelle_referenz, 
    bohrung.mut_date, 
    bohrung.new_usr as new_user, 
    bohrung.mut_usr as mut_user, 
    bohrung.wkb_geometry
FROM 
    bohrung."GIS_bohrung" bohrung
left join 
    bohrung.code code_ablenkung 
    on 
    code_ablenkung.code_id = bohrung.ablenkung 
    and 
    code_ablenkung.codetyp_id = bohrung.h_ablenkung 
left join 
    bohrung.code code_qualitaet 
    on 
    code_qualitaet.code_id = bohrung.quali 
    and 
    code_qualitaet.codetyp_id = bohrung.h_quali 
;
