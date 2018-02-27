SELECT 
    neophyten.ogc_fid AS t_id, 
    neophyten.wkb_geometry AS geometrie, 
    neophyten.datum_meldung, 
    neophyten.pflart, 
    neophyten.anzahlid, 
    neophyten.flaecheid, 
    neophyten.lraum, 
    codes1.code_text AS pflanzenart, 
    codes2.code_text AS anzahl, 
    codes3.code_text AS flaeche,
    CASE
        WHEN codes3.code_text = 'keine Angabe' OR codes3.code_text is NULL
            THEN codes2.code_text
        ELSE codes3.code_text
    END AS  anzahl_flaeche, 
    lebensraum.lraum AS lebensraum
FROM 
    neophyten.neophyten_t neophyten
    LEFT JOIN neophyten.codes codes1 
        ON neophyten.pflart = codes1.codeid
    LEFT JOIN neophyten.codes codes2 
        ON neophyten.anzahlid = codes2.codeid
    LEFT JOIN neophyten.codes codes3 
        ON neophyten.flaecheid = codes3.codeid
    LEFT JOIN neophyten.lebensraum lebensraum 
        ON neophyten.lraum = lebensraum.lraumid
WHERE
    archive = 0
;
