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
    flaeche.erfassungsdatum, 
    flaeche.belastungstyp, 
    flaeche.datenerfasser, 
    flaeche.aktiv
FROM 
    vsb.flaeche flaeche
    JOIN vsb.bodenbelastungsgebiet 
        ON bodenbelastungsgebiet.flaecheid = flaeche.flaecheid
WHERE
    flaeche.belastungstyp = 1
    AND
    archive = 0
;