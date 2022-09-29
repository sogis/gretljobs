SELECT 
    bohrung.bohrung_id AS t_id, 
    bohrung.bezeichnung, 
    bohrung.bemerkung, 
    bohrung.datum, 
    bohrung.durchmesserbohrloch, 
    bohrung.ablenkung,
    code_ablenkung.kurztext as ablenkung_text,
    bohrung.quali as qualitaet_code, 
    code_qualitaet.kurztext as qualitaet_text,
    bohrung.qualibem as qualitaet_bemerkung, 
    bohrung.quelleref as quelle_referenz, 
    bohrung.new_date, 
    bohrung.mut_date, 
    st_setsrid(bohrung.wkb_geometry,2056) as geometrie, 
    bohrung.standort_id AS standort_bohrung
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
