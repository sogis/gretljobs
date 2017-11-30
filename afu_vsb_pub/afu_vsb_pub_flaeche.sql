SELECT
    flaeche.flaecheid AS t_id,
    bezeichnung,
    wkb_geometry AS geometrie,
    statustyp,
    aktiv,
    erfassungsdatum,
    datenerfasser,
    belastungstyp,
    begruendung_inaktiv,
    inaktiv_date,
    flaechentyp,
    CASE 
        WHEN eisenbahn.verkehrsfrequenz IS NOT NULL
            THEN eisenbahn.verkehrsfrequenz
        WHEN strasse.verkehrsfrequenz IS NOT NULL
            THEN strasse.verkehrsfrequenz
        ELSE NULL
    END AS verkehrsfrequenz,
    CASE 
        WHEN eisenbahn.verdachtsstreifenbreite IS NOT NULL
            THEN eisenbahn.verdachtsstreifenbreite
        WHEN strasse.verdachtsstreifenbreite IS NOT NULL
            THEN strasse.verdachtsstreifenbreite
        ELSE NULL
    END AS verdachtsstreifenbreite,
    CASE 
        WHEN eisenbahn.pufferdistanz IS NOT NULL
            THEN eisenbahn.pufferdistanz
        WHEN strasse.pufferdistanz IS NOT NULL
            THEN strasse.pufferdistanz
        ELSE NULL
    END AS pufferdistanz,
    gleisanzahl,
    transportunternehmen,
    strecke_von,
    strecke_bis,
    steigung, 
    strassentyp,
    CASE 
        WHEN eisenbahn.bemerkung IS NOT NULL
            THEN eisenbahn.bemerkung
        WHEN strasse.bemerkung IS NOT NULL
            THEN strasse.bemerkung
        ELSE NULL
    END AS bemerkung
    
FROM
    vsb.flaeche
    LEFT JOIN vsb.eisenbahn
        ON eisenbahn.flaecheid = flaeche.flaecheid
    LEFT JOIN vsb.strasse
        ON strasse.flaecheid = flaeche.flaecheid
WHERE
    archive = 0
;