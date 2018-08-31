SELECT 
    bodenbelastungsgebiet.flaecheid AS t_id, 
    bodenbelastungsgebiet.bodenbelastungsgebiet, 
    bodenbelastungsgebiet.verursacher, 
    bodenbelastungsgebiet.belastungsstufe, 
    bodenbelastungsgebiet.probenanzahl, 
    bodenbelastungsgebiet.bemerkung, 
    flaeche.bezeichnung, 
    flaeche.wkb_geometry AS geometrie, 
    flaeche.statustyp, 
    code_status.bezeichnung AS statustyp_text,
    flaeche.erfassungsdatum, 
    flaeche.belastungstyp,
    code_belastung.bezeichnung AS belastungstyp_text,
    flaeche.datenerfasser, 
    flaeche.aktiv
FROM 
    vsb.flaeche flaeche
    JOIN vsb.bodenbelastungsgebiet 
        ON bodenbelastungsgebiet.flaecheid = flaeche.flaecheid
    LEFT JOIN vsb.codenumzeichen code_status
        ON code_status.numcode = flaeche.statustyp
    LEFT JOIN vsb.codenumzeichen code_belastung
        ON code_belastung.numcode = flaeche.belastungstyp
WHERE
    flaeche.belastungstyp = 1
    AND
    archive = 0
;