WITH vsb_flaeche AS (
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
        END AS bemerkung,
        round(ST_Area(wkb_geometry)) AS flaeche,
        round(ST_Perimeter(wkb_geometry)) AS umfang
    FROM
        vsb.flaeche
        LEFT JOIN vsb.eisenbahn
            ON eisenbahn.flaecheid = flaeche.flaecheid
        LEFT JOIN vsb.strasse
            ON strasse.flaecheid = flaeche.flaecheid
    WHERE
        archive = 0
)

SELECT
    vsb_flaeche.t_id,
    vsb_flaeche.bezeichnung,
    vsb_flaeche.geometrie,
    vsb_flaeche.statustyp,
    code_status.bezeichnung AS statustyp_text,
    vsb_flaeche.aktiv,
    vsb_flaeche.erfassungsdatum,
    vsb_flaeche.datenerfasser,
    vsb_flaeche.belastungstyp,
    code_belastung.bezeichnung AS belastungstyp_text,
    vsb_flaeche.begruendung_inaktiv,
    vsb_flaeche.inaktiv_date,
    vsb_flaeche.flaechentyp,
    vsb_flaeche.verkehrsfrequenz,
    vsb_flaeche.verdachtsstreifenbreite,
    vsb_flaeche.pufferdistanz,
    vsb_flaeche.gleisanzahl,
    vsb_flaeche.transportunternehmen,
    vsb_flaeche.strecke_von,
    vsb_flaeche.strecke_bis,
    vsb_flaeche.steigung, 
    vsb_flaeche.strassentyp,
    vsb_flaeche.bemerkung,
    codenumzeichen.bezeichnung AS code_bezeichnung,
    vsb_flaeche.flaeche,
    vsb_flaeche.umfang
FROM
    vsb_flaeche
    LEFT JOIN vsb.codenumzeichen
        ON verdachtsstreifenbreite = codenumzeichen.numcode
    LEFT JOIN vsb.codenumzeichen code_status
        ON code_status.numcode = vsb_flaeche.statustyp
    LEFT JOIN vsb.codenumzeichen code_belastung
        ON code_belastung.numcode = vsb_flaeche.belastungstyp
;