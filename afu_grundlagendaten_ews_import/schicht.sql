SELECT 
    schicht.schicht_id AS t_id,
    code_schicht.kurztext as schicht_kurztext,
    code_schicht."text" as schicht_text,
    schicht.tiefe, 
    schicht.quali as qualitaet_code, 
    code_qualitaet.kurztext as qualitaet_text,
    schicht.qualibem as qualitaet_bemerkung, 
    schicht.bemerkung, 
    schicht.new_date, 
    schicht.mut_date, 
    schicht.bohrprofil_id AS bohrprofil_schicht
FROM 
    bohrung."GIS_schicht" schicht
left join 
    bohrung.code code_qualitaet 
    on 
    code_qualitaet.code_id = schicht.quali 
    and 
    code_qualitaet.codetyp_id = schicht.h_quali 
left join 
    bohrung."GIS_codeschicht" code_schicht 
    on 
    code_schicht.codeschicht_id = schicht.schicht_id 
;
